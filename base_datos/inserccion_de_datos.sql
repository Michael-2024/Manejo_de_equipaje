-- Desactivar temporalmente las restricciones de claves foráneas para permitir el borrado en cualquier orden
SET CONSTRAINTS ALL DEFERRED;

-- Borrar todos los datos de las tablas (en orden inverso para evitar errores de claves foráneas)
DELETE FROM etiqueta;
DELETE FROM seguimientoequipaje;
DELETE FROM entregaequipaje; -- Si existe esta tabla
DELETE FROM equipaje;
DELETE FROM pasajero;
DELETE FROM operador;
DELETE FROM puntocontrol;
DELETE FROM reglasmanejo;
DELETE FROM aeronave;
DELETE FROM vuelo;
DELETE FROM terminal;
DELETE FROM aeropuerto;
DELETE FROM aerolinea;
DELETE FROM ciudad;
DELETE FROM tipoterminal;
DELETE FROM estadosistema;
DELETE FROM clasificacionequipaje;
DELETE FROM tipoequipaje;
DELETE FROM tipodocumento;
DELETE FROM cargo;
DELETE FROM pais;

-- Reactivar las restricciones de claves foráneas
SET CONSTRAINTS ALL IMMEDIATE;

-- Poblar la base de datos desde cero

-- 1. Países
INSERT INTO pais (nombre, codigoiso2, codigoiso3) VALUES
('Venezuela', 'VZ', 'VEZ'),
('Estados Unidos', 'US', 'USA');

-- 2. Ciudades
INSERT INTO ciudad (nombre, paisid) VALUES
('Caracas', 1),
('Miami', 2);

-- 3. Aeropuertos
INSERT INTO aeropuerto (nombre, ciudadid, codigoiata, codigoicao, husohorario) VALUES
('Aeropuerto Simón Bolívar', 1, 'CCS', 'SVMI', 'GMT-4'),
('Miami International', 2, 'MIA', 'KMIA', 'GMT-5');

-- 4. Terminales
INSERT INTO tipoterminal (nombre, descripcion, capacidadpasajeros) VALUES
('Terminal Principal', 'Terminal principal del aeropuerto', 2000);
INSERT INTO terminal (aeropuertoid, nombre, tipoterminalid) VALUES
(1, 'T1', 1),
(2, 'T2', 1);

-- 5. Aerolíneas
INSERT INTO aerolinea (nombre, codigoiata, codigoicao, paisorigen) VALUES
('Avianca', 'AV', 'AVA', 1),
('American Airlines', 'AA', 'AAL', 2);

-- 6. Aeronaves
INSERT INTO aeronave (matricula, modelonombre, fabricante, capacidadequipaje, pesomaximoequipaje, aerolineaid, fecharegistro) VALUES
('HK-1234', 'Airbus A320', 'Airbus', 100, 1500, 1, '2023-01-01'),
('N-5678', 'Boeing 737', 'Boeing', 120, 1800, 2, '2023-01-01');

-- 7. Tipos de Documento
INSERT INTO tipodocumento (nombre, descripcion, longitudminima, longitudmaxima) VALUES
('Cédula', 'Documento de identidad nacional', 6, 10),
('Pasaporte', 'Documento internacional', 6, 15);

-- 8. Cargos
INSERT INTO cargo (nombre, descripcion) VALUES
('Agente', 'Agente de equipaje');

-- 9. Estados del Sistema
INSERT INTO estadosistema (nombre, descripcion, colorhex) VALUES
('Registrado', 'Equipaje registrado', '#cccccc'),
('Cargado', 'Cargado en aeronave', '#ffcc00'),
('En vuelo', 'En tránsito', '#3399ff'),
('Descargado', 'Descargado del avión', '#66cc66'),
('Entregado', 'Ya entregado', '#00cc00');

-- 10. Tipos de Equipaje
INSERT INTO tipoequipaje (nombre, descripcion, pesomaxo) VALUES
('Maleta', 'Equipaje estándar', 23.00),
('Mochila', 'Equipaje ligero', 10.00);

-- 11. Clasificación de Equipaje
INSERT INTO clasificacionequipaje (nombre, descripcion, prioridadcarga) VALUES
('Normal', 'Equipaje sin prioridad', 1),
('Prioritario', 'Equipaje con prioridad alta', 2);

-- 12. Operador
INSERT INTO operador (nombre, apellido, codigoempleado, numerodocumento, tipodocumentoid, cargoid, fechaingreso) VALUES
('Carlos', 'Ruiz', 'OP001', '111222333', 1, 1, '2023-01-01');

-- 13. Pasajeros
INSERT INTO pasajero (nombre, apellido, numerodocumento, tipodocumentoid, telefono, email, fechanacimiento, paisnacimiento) VALUES
('Juan', 'Pérez', '12345678', 1, '3121231234', 'juan@mail.com', '1995-05-10', 1),
('Ana', 'Gómez', '98765432', 2, '3001112233', 'ana@mail.com', '1990-08-15', 2);

-- 14. Vuelos
INSERT INTO vuelo (numerovuelo, aeropuertoorigenid, aeropuertodestinoid, fechasalida, fechallegada, fechasalidaprevista, fechallegadaprevista, aerolineaid, aeronaveid) VALUES
('AV123', 1, 2, '2025-05-29 02:15:00-05', '2025-05-29 06:15:00-05', '2025-05-29 02:15:00-05', '2025-05-29 06:15:00-05', 1, 1);

-- 15. Equipaje
INSERT INTO equipaje (pasajeroid, vueloid, clasificacionid, tipoequipajeid, peso, descripcion, fecharegistro, estadoid) VALUES
(1, 1, 1, 1, 20.0, 'Maleta azul', '2025-05-29 02:00:00-05', 1),
(2, 1, 2, 2, 8.0, 'Mochila roja', '2025-05-29 02:00:00-05', 1);

-- 16. Punto de Control
INSERT INTO puntocontrol (terminalid, nombre, tipoproceso) VALUES
(1, 'Facturación', 'facturacion'),
(2, 'Entrega', 'entrega');

-- 17. Seguimiento de Equipaje
INSERT INTO seguimientoequipaje (equipajeid, puntocontrolid, fechahora, operadorid, observaciones, estadoid) VALUES
(1, 1, '2025-05-29 02:10:00-05', 1, 'Equipaje facturado', 1),
(2, 1, '2025-05-29 02:10:00-05', 1, 'Equipaje facturado', 1);

-- 18. Etiquetas
INSERT INTO etiqueta (equipajeid, codigobarras, talonnumero, fechaemision) VALUES
(1, 'EQ123456', 'TL123456', '2025-05-29 02:00:00-05'),
(2, 'EQ654321', 'TL654321', '2025-05-29 02:00:00-05');

-- 19. Reglas de Manejo
INSERT INTO reglasmanejo (tipoequipajeid, tipoterminalid, pesomaximo, requiereinspeccion, tiempomaxprocesamiento) VALUES
(1, 1, 23.00, false, 30),
(2, 1, 10.00, true, 20);


--SELECT * FROM equipaje WHERE equipajeid IN (1, 2);
--UPDATE equipaje SET estadoid = 1 WHERE equipajeid IN (1, 2, 3);
--UPDATE equipaje SET estadoid = 1 WHERE equipajeid IN (1, 2);