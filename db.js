const { Pool } = require('pg');
require('dotenv').config();

// Validar que DATABASE_URL esté definida
if (!process.env.DATABASE_URL) {
    console.error('Error: DATABASE_URL no está definida en el archivo .env');
    process.exit(1);
}

// Configurar el pool con parámetros adicionales
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    max: 10, // Número máximo de conexiones simultáneas
    idleTimeoutMillis: 30000, // Tiempo que una conexión inactiva permanece abierta (30 segundos)
    connectionTimeoutMillis: 2000, // Tiempo máximo para conectar (2 segundos)
});

// Manejar errores del pool
pool.on('error', (err, client) => {
    console.error('Error inesperado en el pool de conexiones:', err.stack);
    // Intentar reconectar después de 5 segundos
    setTimeout(async () => {
        console.log('Intentando reconectar a la base de datos...');
        try {
            const client = await pool.connect();
            console.log('Reconexión exitosa a la base de datos');
            client.release();
        } catch (retryErr) {
            console.error('Error al reconectar a la base de datos:', retryErr.stack);
        }
    }, 5000);
});

// Probar la conexión al iniciar
(async () => {
    try {
        const client = await pool.connect();
        console.log('Conexión a la base de datos establecida correctamente');
        const res = await client.query('SELECT NOW()');
        console.log('Hora actual de la base de datos:', res.rows[0].now);
        client.release();
    } catch (err) {
        console.error('Error al conectar a la base de datos:', err.stack);
        console.error('Detalles del error:', {
            name: err.name,
            message: err.message,
            code: err.code,
            detail: err.detail,
            hint: err.hint
        });
        process.exit(1);
    }
})();

// Función para cerrar el pool (útil para cerrar el servidor correctamente)
const closePool = async () => {
    try {
        await pool.end();
        console.log('Pool de conexiones cerrado correctamente');
    } catch (err) {
        console.error('Error al cerrar el pool de conexiones:', err.stack);
    }
};

module.exports = { pool, closePool };