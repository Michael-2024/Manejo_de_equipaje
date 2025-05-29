const { Pool } = require('pg');
require('dotenv').config();

// Validar que DATABASE_URL esté definida
if (!process.env.DATABASE_URL) {
    console.error('Error: DATABASE_URL no está definida en el archivo .env');
    process.exit(1); // Termina el proceso si falta la variable
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
});

// Probar la conexión al iniciar
(async () => {
    try {
        const client = await pool.connect();
        console.log('Conexión a la base de datos establecida correctamente');
        client.release(); // Liberar el cliente después de la prueba
    } catch (err) {
        console.error('Error al conectar a la base de datos:', err.stack);
        process.exit(1); // Termina el proceso si no se puede conectar
    }
})();

module.exports = pool;