const http = require('http');
const fs = require('fs');
const path = require('path');
const pool = require('./db');

const PORT = 3000;

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const method = req.method;

  // =========================================
  // RUTAS API
  // =========================================

  // GET /api/pasajeros
  if (method === 'GET' && url.pathname === '/api/pasajeros') {
    try {
      const result = await pool.query('SELECT * FROM pasajero');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(result.rows));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }

  // GET /api/pasajero-equipaje?documento=xxx
  } else if (method === 'GET' && url.pathname === '/api/pasajero-equipaje') {
    const documento = url.searchParams.get('documento');
    if (!documento) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ error: 'El parámetro "documento" es requerido.' }));
    }

    try {
      const result = await pool.query(
        `SELECT 
          e.equipajeid,
          e.descripcion,
          e.peso,
          pc.nombre AS ubicacion,
          se.fechahora,
          COALESCE(es_seguimiento.nombre, es_equipaje.nombre) AS estado,
          se.observaciones
        FROM pasajero p
        JOIN equipaje e ON p.pasajeroid = e.pasajeroid
        LEFT JOIN (
          SELECT equipajeid, puntocontrolid, fechahora, observaciones, estadoid
          FROM seguimientoequipaje
          WHERE (equipajeid, fechahora) IN (
            SELECT equipajeid, MAX(fechahora)
            FROM seguimientoequipaje
            GROUP BY equipajeid
          )
        ) se ON e.equipajeid = se.equipajeid
        LEFT JOIN puntocontrol pc ON se.puntocontrolid = pc.puntocontrolid
        LEFT JOIN estadosistema es_seguimiento ON se.estadoid = es_seguimiento.estadoid
        LEFT JOIN estadosistema es_equipaje ON e.estadoid = es_equipaje.estadoid
        WHERE p.numerodocumento = $1
        ORDER BY se.fechahora DESC`,
        [documento]
      );

      if (result.rows.length > 0) {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(result.rows));
      } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'No se encontró equipaje asociado a este documento.' }));
      }
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }

  // GET /api/equipaje-todos
  } else if (method === 'GET' && url.pathname === '/api/equipaje-todos') {
    try {
      const result = await pool.query(`
        SELECT e.equipajeid, e.descripcion, e.peso, es.nombre AS estado,
               p.nombre || ' ' || p.apellido AS nombre_pasajero
        FROM equipaje e
        JOIN pasajero p ON p.pasajeroid = e.pasajeroid
        LEFT JOIN estadosistema es ON e.estadoid = es.estadoid
      `);
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(result.rows));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }

  // ✅ PUT /api/equipaje/:id/estado → actualizar estado dinámicamente
  } else if (method === 'PUT' && url.pathname.startsWith('/api/equipaje/') && url.pathname.endsWith('/estado')) {
    const id = url.pathname.split('/')[3];
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', async () => {
      try {
        const data = JSON.parse(body);
        const estadoid = parseInt(data.estadoid);
        if (!estadoid || estadoid < 1 || estadoid > 5) {
          res.writeHead(400, { 'Content-Type': 'application/json' });
          return res.end(JSON.stringify({ error: 'El estadoid debe estar entre 1 y 5' }));
        }

        const result = await pool.query(
          `UPDATE equipaje SET estadoid = $1 WHERE equipajeid = $2 RETURNING *`,
          [estadoid, id]
        );
        if (result.rowCount > 0) {
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify(result.rows[0]));
        } else {
          res.writeHead(404, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'Equipaje no encontrado.' }));
        }
      } catch (err) {
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: err.message }));
      }
    });

  // PUT /api/equipaje/:id/entregar → estado 5
  } else if (method === 'PUT' && url.pathname.startsWith('/api/equipaje/') && url.pathname.endsWith('/entregar')) {
    const id = url.pathname.split('/')[3];
    try {
      const result = await pool.query(
        `UPDATE equipaje SET estadoid = 5 WHERE equipajeid = $1 RETURNING *`,
        [id]
      );
      if (result.rowCount > 0) {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(result.rows[0]));
      } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Equipaje no encontrado.' }));
      }
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }

  // POST /api/pasajeros
  } else if (method === 'POST' && url.pathname === '/api/pasajeros') {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', async () => {
      try {
        const data = JSON.parse(body);
        const result = await pool.query(
          `INSERT INTO pasajero (nombre, apellido, numerodocumento, tipodocumentoid)
           VALUES ($1, $2, $3, $4) RETURNING *`,
          [data.nombre, data.apellido, data.numerodocumento, data.tipodocumentoid]
        );
        res.writeHead(201, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(result.rows[0]));
      } catch (err) {
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: err.message }));
      }
    });

  // POST /api/equipaje
  } else if (method === 'POST' && url.pathname === '/api/equipaje') {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', async () => {
      try {
        const data = JSON.parse(body);

        const pasajero = await pool.query(
          `SELECT pasajeroid FROM pasajero WHERE numerodocumento = $1`,
          [data.documento]
        );
        if (pasajero.rowCount === 0) {
          res.writeHead(404);
          return res.end(JSON.stringify({ error: 'Pasajero no encontrado' }));
        }

        const pasajeroid = pasajero.rows[0].pasajeroid;

        const result = await pool.query(
          `INSERT INTO equipaje (pasajeroid, vueloid, clasificacionid, tipoequipajeid, peso, descripcion, fecharegistro)
           VALUES ($1, $2, 1, $3, $4, $5, CURRENT_TIMESTAMP)
           RETURNING *`,
          [pasajeroid, data.vueloid, data.tipoequipajeid, data.peso, data.descripcion]
        );
        res.writeHead(201, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(result.rows[0]));
      } catch (err) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: err.message }));
      }
    });

  // =========================================
  // ARCHIVOS ESTÁTICOS (html, css, js)
  // =========================================
  } else {
    const filePath = url.pathname === '/' ? '/index.html' : url.pathname;
    const fullPath = path.join(__dirname, 'public', filePath);

    fs.readFile(fullPath, (err, content) => {
      if (err) {
        res.writeHead(404);
        res.end('404 Not Found');
      } else {
        const ext = path.extname(fullPath);
        const mimeTypes = {
          '.html': 'text/html',
          '.css': 'text/css',
          '.js': 'text/javascript',
        };
        res.writeHead(200, { 'Content-Type': mimeTypes[ext] || 'text/plain' });
        res.end(content);
      }
    });
  }
});

server.listen(PORT, () => {
  console.log(`✅ Servidor corriendo en http://localhost:${PORT}`);
});
