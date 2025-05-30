-- =====================================================
-- VISTA 1: Equipajes Básicos
-- Información esencial de equipajes con pasajero y vuelo
-- =====================================================
CREATE VIEW vista_equipajes_basicos AS
SELECT 
    e.numero_identificacion,
    p.nombre_pasajero,
    v.numero_vuelo,
    ee.descripcion_estado,
    e.peso,
    e.fecha_registro
FROM equipajes e
JOIN pasajeros p ON e.id_pasajero = p.id_pasajero
JOIN vuelos v ON e.numero_vuelo = v.numero_vuelo
JOIN estados_equipaje ee ON e.id_estado = ee.id_estado;

-- =====================================================
-- VISTA 2: Equipajes Perdidos
-- Solo equipajes con estado perdido
-- =====================================================
CREATE VIEW vista_equipajes_perdidos AS
SELECT 
    e.numero_identificacion,
    p.nombre_pasajero,
    p.telefono,
    v.numero_vuelo,
    e.ultimo_punto_rastreo_conocido,
    e.fecha_registro
FROM equipajes e
JOIN pasajeros p ON e.id_pasajero = p.id_pasajero
JOIN vuelos v ON e.numero_vuelo = v.numero_vuelo
JOIN estados_equipaje ee ON e.id_estado = ee.id_estado
WHERE ee.codigo_estado = 'perdido';

-- =====================================================
-- VISTA 3: Vuelos del Día
-- Vuelos programados para hoy
-- =====================================================
CREATE VIEW vista_vuelos_hoy AS
SELECT 
    v.numero_vuelo,
    al.nombre_aerolinea,
    ao.codigo_iata AS origen,
    ad.codigo_iata AS destino,
    v.hora_salida,
    v.hora_llegada
FROM vuelos v
JOIN aerolineas al ON v.id_aerolinea = al.id_aerolinea
JOIN aeropuertos ao ON v.id_aeropuerto_origen = ao.id_aeropuerto
JOIN aeropuertos ad ON v.id_aeropuerto_destino = ad.id_aeropuerto
WHERE v.fecha_salida = CURRENT_DATE;

-- =====================================================
-- VISTA 4: Incidentes Pendientes
-- Incidentes que aún no se han resuelto
-- =====================================================
CREATE VIEW vista_incidentes_pendientes AS
SELECT 
    ri.numero_reporte,
    e.numero_identificacion,
    p.nombre_pasajero,
    ti.descripcion_tipo,
    ri.fecha_reporte,
    ri.descripcion
FROM reportes_incidentes ri
JOIN equipajes e ON ri.numero_identificacion_equipaje = e.numero_identificacion
JOIN pasajeros p ON e.id_pasajero = p.id_pasajero
JOIN tipos_incidente ti ON ri.id_tipo_incidente = ti.id_tipo_incidente
WHERE ri.estado_resolucion = 'PENDIENTE';

-- =====================================================
-- VISTA 5: Resumen por Aerolínea
-- Conteo simple de equipajes por aerolínea
-- =====================================================
CREATE VIEW vista_resumen_aerolineas AS
SELECT 
    al.nombre_aerolinea,
    COUNT(e.numero_identificacion) AS total_equipajes,
    COUNT(CASE WHEN ee.codigo_estado = 'perdido' THEN 1 END) AS equipajes_perdidos,
    COUNT(CASE WHEN ee.codigo_estado = 'normal' THEN 1 END) AS equipajes_normales
FROM aerolineas al
LEFT JOIN vuelos v ON al.id_aerolinea = v.id_aerolinea
LEFT JOIN equipajes e ON v.numero_vuelo = e.numero_vuelo
LEFT JOIN estados_equipaje ee ON e.id_estado = ee.id_estado
GROUP BY al.id_aerolinea, al.nombre_aerolinea;

-- =====================================================
-- CONSULTAS DE PRUEBA SIMPLES
-- =====================================================

-- Consulta 1: Ver todos los equipajes básicos
SELECT * FROM vista_equipajes_basicos LIMIT 10;

-- Consulta 2: Ver equipajes perdidos
SELECT * FROM vista_equipajes_perdidos;

-- Consulta 3: Ver vuelos de hoy
SELECT * FROM vista_vuelos_hoy;

-- Consulta 4: Ver incidentes pendientes
SELECT * FROM vista_incidentes_pendientes;

-- Consulta 5: Ver resumen por aerolínea
SELECT * FROM vista_resumen_aerolineas ORDER BY total_equipajes DESC;