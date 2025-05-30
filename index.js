const http = require('http');
const fs = require('fs');
const path = require('path');
const { pool, closePool } = require('./db');

const PORT = 3000;

const server = http.createServer(async (req, res) => {
  console.log(`Solicitud recibida: ${req.method} ${req.url}`);
  console.log('Cabeceras de solicitud:', req.headers);
  res.setHeader('Content-Type', 'application/json');
  const url = new URL(req.url, `http://${req.headers.host}`);
  const method = req.method;

  // GET /api/ping (Ruta de prueba simple)
  if (method === 'GET' && url.pathname === '/api/ping') {
    res.writeHead(200);
    res.end(JSON.stringify({ message: '¡Pong! Servidor funcionando' }));

  // GET /api/pasajeros
  } else if (method === 'GET' && url.pathname === '/api/pasajeros') {
    try {
      const result = await pool.query('SELECT * FROM pasajeros');
      res.writeHead(200);
      res.end(JSON.stringify(result.rows));
    } catch (err) {
      res.writeHead(500);
      res.end(JSON.stringify({ error: err.message }));
    }

  // GET /api/pasajero-equipaje?documento=xxx
  } else if (method === 'GET' && url.pathname === '/api/pasajero-equipaje') {
    const documento = url.searchParams.get('documento');
    if (!documento) {
      res.writeHead(400);
      return res.end(JSON.stringify({ error: 'El parámetro "documento" es requerido.' }));
    }

    try {
      const result = await pool.query(
        `SELECT 
          e.numero_identificacion AS equipajeid,
          e.descripcion,
          e.peso,
          e.ultimo_punto_rastreo_conocido AS ubicacion,
          rr.timestamp AS fechahora,
          ee.descripcion_estado AS estado,
          rr.observaciones
        FROM pasajeros p
        JOIN equipajes e ON p.id_pasajero = e.id_pasajero
        LEFT JOIN (
          SELECT numero_identificacion_equipaje, timestamp, ubicacion, observaciones, estado_tiempo_real
          FROM registros_rastreo
          WHERE (numero_identificacion_equipaje, timestamp) IN (
            SELECT numero_identificacion_equipaje, MAX(timestamp)
            FROM registros_rastreo
            GROUP BY numero_identificacion_equipaje
          )
        ) rr ON e.numero_identificacion = rr.numero_identificacion_equipaje
        LEFT JOIN estados_equipaje ee ON e.id_estado = ee.id_estado
        WHERE p.numero_documento = $1
        ORDER BY rr.timestamp DESC`,
        [documento]
      );

      if (result.rows.length > 0) {
        res.writeHead(200);
        res.end(JSON.stringify(result.rows));
      } else {
        res.writeHead(404);
        res.end(JSON.stringify({ error: 'No se encontró equipaje asociado a este documento.' }));
      }
    } catch (err) {
      res.writeHead(500);
      res.end(JSON.stringify({ error: err.message }));
    }

  // GET /api/equipaje-todos
} else if (method === 'GET' && url.pathname === '/api/equipaje-todos') {
  try {
    const result = await pool.query(`
      SELECT 
        e.numero_identificacion,
        p.numero_documento,
        e.descripcion,
        e.peso,
        ee.descripcion_estado AS estado,
        v.numero_vuelo
      FROM equipajes e
      JOIN pasajeros p ON p.id_pasajero = e.id_pasajero
      JOIN vuelos v ON v.numero_vuelo = e.numero_vuelo
      JOIN estados_equipaje ee ON ee.id_estado = e.id_estado
    `);
    console.log('Equipajes devueltos antes de conversión:', result.rows); // Depuración
    const responseData = result.rows.map(row => {
      return {
        ...row,
        peso: Number(row.peso) // Convertir peso a número
      };
    });
    console.log('Equipajes devueltos después de conversión:', responseData); // Depuración
    res.writeHead(200);
    res.end(JSON.stringify(responseData));
  } catch (err) {
    console.error('Error en /api/equipaje-todos:', err.message);
    res.writeHead(500);
    res.end(JSON.stringify({ error: err.message }));
  }

  // GET /api/test-db (Ruta de prueba temporal)
  } else if (method === 'GET' && url.pathname === '/api/test-db') {
    try {
      const result = await pool.query('SELECT * FROM equipajes LIMIT 5');
      console.log('Resultado de test-db:', result.rows); // Depuración
      res.writeHead(200);
      res.end(JSON.stringify(result.rows));
    } catch (err) {
      res.writeHead(500);
      res.end(JSON.stringify({ error: err.message }));
    }

  // POST /api/equipaje
  } else if (method === 'POST' && url.pathname === '/api/equipaje') {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', async () => {
      try {
        const data = JSON.parse(body);
        const pasajero = await pool.query(
          `SELECT id_pasajero FROM pasajeros WHERE numero_documento = $1`,
          [data.numero_documento]
        );
        if (pasajero.rowCount === 0) {
          res.writeHead(404);
          return res.end(JSON.stringify({ error: 'Pasajero no encontrado' }));
        }
        const idPasajero = pasajero.rows[0].id_pasajero;

        const result = await pool.query(
          `INSERT INTO equipajes (numero_identificacion, id_pasajero, numero_vuelo, descripcion, ultimo_punto_rastreo_conocido, id_estado, peso, fecha_registro)
           VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
           RETURNING *,
           (SELECT numero_documento FROM pasajeros WHERE id_pasajero = $2) AS numero_documento,
           (SELECT descripcion_estado FROM estados_equipaje WHERE id_estado = $6) AS estado`,
          [
            `BAG${Math.random().toString(36).substr(2, 9).toUpperCase()}`,
            idPasajero,
            data.numero_vuelo,
            data.descripcion,
            'Check-in',
            data.id_estado || 1,
            data.peso
          ]
        );
        // Convertir peso a número explícitamente en la respuesta
        const responseData = result.rows[0];
        responseData.peso = Number(responseData.peso);
        console.log('Datos devueltos en /api/equipaje:', responseData); // Depuración
        res.writeHead(201);
        res.end(JSON.stringify(responseData));
      } catch (err) {
        console.error('Error en /api/equipaje:', err.message);
        res.writeHead(500);
        res.end(JSON.stringify({ error: err.message }));
      }
    });

  // PUT /api/equipaje/:id/estado
  } else if (method === 'PUT' && url.pathname.startsWith('/api/equipaje/') && url.pathname.endsWith('/estado')) {
    const id = url.pathname.split('/')[3];
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', async () => {
      try {
        const data = JSON.parse(body);
        const idEstado = parseInt(data.id_estado);
        if (!idEstado || idEstado < 1 || idEstado > 5) {
          res.writeHead(400);
          return res.end(JSON.stringify({ error: 'El id_estado debe estar entre 1 y 5' }));
        }

        const client = await pool.connect();
        try {
          await client.query('BEGIN');

          const updateEquipaje = await client.query(
            `UPDATE equipajes SET id_estado = $1 WHERE numero_identificacion = $2 RETURNING *`,
            [idEstado, id]
          );

          if (updateEquipaje.rowCount === 0) {
            throw new Error('Equipaje no encontrado.');
          }

          await client.query(
            `INSERT INTO registros_rastreo (numero_identificacion_equipaje, id_escaner, ubicacion, estado_tiempo_real, observaciones)
             VALUES ($1, $2, $3, $4, $5)`,
            [id, 1, 'Actualización de estado - Operario', (await pool.query('SELECT descripcion_estado FROM estados_equipaje WHERE id_estado = $1', [idEstado])).rows[0].descripcion_estado, 'Estado actualizado por operario']
          );

          await client.query('COMMIT');
          res.writeHead(200);
          res.end(JSON.stringify(updateEquipaje.rows[0]));
        } catch (err) {
          await client.query('ROLLBACK');
          throw err;
        } finally {
          client.release();
        }
      } catch (err) {
        res.writeHead(err.message.includes('no encontrado') ? 404 : 500);
        res.end(JSON.stringify({ error: err.message }));
      }
    });

  // DELETE /api/equipaje/:id
} else if (method === 'DELETE' && url.pathname.startsWith('/api/equipaje/')) {
  const id = url.pathname.split('/')[3];
  console.log('Eliminando equipaje con ID:', id); // Depuración
  try {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Eliminar registros dependientes en registros_rastreo
      await client.query(
        `DELETE FROM registros_rastreo WHERE numero_identificacion_equipaje = $1`,
        [id]
      );

      // Eliminar el equipaje
      const result = await client.query(
        `DELETE FROM equipajes WHERE numero_identificacion = $1 RETURNING *`,
        [id]
      );

      if (result.rowCount > 0) {
        await client.query('COMMIT');
        res.writeHead(200);
        res.end(JSON.stringify({ message: 'Equipaje eliminado' }));
      } else {
        await client.query('ROLLBACK');
        res.writeHead(404);
        res.end(JSON.stringify({ error: 'Equipaje no encontrado.' }));
      }
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('Error al eliminar equipaje:', err.message); // Depuración
    res.writeHead(500);
    res.end(JSON.stringify({ error: err.message }));
  }

  // PUT /api/equipaje/:id/entregar → estado 5 (Entregado)
  } else if (method === 'PUT' && url.pathname.startsWith('/api/equipaje/') && url.pathname.endsWith('/entregar')) {
    const id = url.pathname.split('/')[3];
    try {
      const result = await pool.query(
        `UPDATE equipajes SET id_estado = 5 WHERE numero_identificacion = $1 RETURNING *`,
        [id]
      );
      if (result.rowCount > 0) {
        res.writeHead(200);
        res.end(JSON.stringify(result.rows[0]));
      } else {
        res.writeHead(404);
        res.end(JSON.stringify({ error: 'Equipaje no encontrado.' }));
      }
    } catch (err) {
      res.writeHead(500);
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
          `INSERT INTO pasajeros (nombre_pasajero, numero_documento, tipo_documento, telefono, email, id_pais_nacionalidad)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
          [data.nombre_pasajero || 'Desconocido', data.numero_documento, data.tipo_documento, data.telefono, data.email, data.id_pais_nacionalidad]
        );
        res.writeHead(201);
        res.end(JSON.stringify(result.rows[0]));
      } catch (err) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: err.message }));
      }
    });

  // ARCHIVOS ESTÁTICOS (html, css, js)
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

// Manejar cierre del servidor
process.on('SIGINT', async () => {
  console.log('Cerrando servidor...');
  await closePool();
  process.exit(0);
});

server.listen(PORT, () => {
  console.log(`✅ Servidor corriendo en http://localhost:${PORT}`);
});