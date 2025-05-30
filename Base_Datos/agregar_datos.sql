-- ===============================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- SISTEMA DE CONTROL DE EQUIPAJE AEROPORTUARIO
-- ===============================================

-- TABLAS TIPO (CATÁLOGOS)
INSERT INTO paises (codigo_iso, nombre_pais) VALUES
('COL', 'Colombia'),
('USA', 'Estados Unidos'),
('ESP', 'España'),
('MEX', 'México'),
('BRA', 'Brasil'),
('ARG', 'Argentina'),
('CHI', 'Chile'),
('FRA', 'Francia');

INSERT INTO ciudades (nombre_ciudad, codigo_iata, id_pais) VALUES
('Bogotá', 'BOG', 1),
('Medellín', 'MDE', 1),
('Miami', 'MIA', 2),
('Madrid', 'MAD', 3),
('Ciudad de México', 'MEX', 4),
('São Paulo', 'SAO', 5),
('Buenos Aires', 'BUE', 6),
('Santiago', 'SCL', 7),
('París', 'CDG', 8);

INSERT INTO aeropuertos (codigo_iata, nombre_aeropuerto, id_ciudad) VALUES
('BOG', 'Aeropuerto Internacional El Dorado', 1),
('MDE', 'Aeropuerto José María Córdova', 2),
('MIA', 'Aeropuerto Internacional de Miami', 3),
('MAD', 'Aeropuerto Adolfo Suárez Madrid-Barajas', 4),
('MEX', 'Aeropuerto Internacional de la Ciudad de México', 5),
('GRU', 'Aeropuerto Internacional de São Paulo-Guarulhos', 6),
('EZE', 'Aeropuerto Internacional Ezeiza', 7),
('SCL', 'Aeropuerto Arturo Merino Benítez', 8);

INSERT INTO aerolineas (codigo_iata, nombre_aerolinea, id_pais) VALUES
('AV', 'Avianca', 1),
('AM', 'Aeroméxico', 4),
('IB', 'Iberia', 3),
('AA', 'American Airlines', 2),
('LA', 'LATAM Airlines', 7),
('AF', 'Air France', 8),
('G3', 'GOL Líneas Aéreas', 5);

INSERT INTO tipos_aeronave (modelo, fabricante, capacidad_total_carga, numero_compartimentos) VALUES
('A320', 'Airbus', 15000.00, 2),
('B737', 'Boeing', 18000.00, 2),
('A330', 'Airbus', 35000.00, 3),
('B777', 'Boeing', 45000.00, 3),
('A350', 'Airbus', 42000.00, 3),
('B787', 'Boeing', 38000.00, 3),
('E190', 'Embraer', 8000.00, 1);

INSERT INTO estados_equipaje (codigo_estado, descripcion_estado) VALUES
('NORMAL', 'Equipaje en estado normal'),
('PERDIDO', 'Equipaje perdido o extraviado'),
('DAÑADO', 'Equipaje con daños reportados'),
('EN_INSPECCION', 'Equipaje en proceso de inspección'),
('EN_TRANSITO', 'Equipaje en tránsito'),
('ENTREGADO', 'Equipaje entregado al pasajero'),
('RETENIDO', 'Equipaje retenido por autoridades');

INSERT INTO tipos_incidente (codigo_tipo, descripcion_tipo) VALUES
('PERDIDO', 'Equipaje perdido o extraviado'),
('DAÑADO', 'Equipaje con daños físicos'),
('RETRASADO', 'Equipaje con retraso en entrega'),
('MAL_ETIQUETADO', 'Error en etiquetado del equipaje'),
('CONTENIDO_PROHIBIDO', 'Contenido prohibido detectado');

INSERT INTO tipos_escaner (codigo_tipo, descripcion_tipo) VALUES
('OPTICO', 'Escáner óptico de códigos de barras'),
('RFID', 'Lector de etiquetas RFID'),
('AUTOMATIZADO', 'Sistema automatizado de lectura'),
('MANUAL', 'Verificación manual'),
('QR', 'Lector de códigos QR');

INSERT INTO tipos_plataforma (codigo_tipo, descripcion_tipo) VALUES
('MOVIL', 'Aplicación móvil'),
('QUIOSCO', 'Quiosco de autoservicio'),
('WEB', 'Plataforma web'),
('CALL_CENTER', 'Centro de llamadas'),
('COUNTER', 'Mostrador de servicio');

INSERT INTO tipos_equipaje (codigo_tipo, descripcion_tipo) VALUES
('MANO', 'Equipaje de mano'),
('BODEGA', 'Equipaje de bodega'),
('DEPORTIVO', 'Equipaje deportivo especial'),
('FRAGIL', 'Equipaje frágil'),
('ESPECIAL', 'Equipaje especial (instrumentos, etc.)'),
('OVERSIZED', 'Equipaje de gran tamaño'),
('MASCOTA', 'Transporte de mascotas');


INSERT INTO pasajeros (nombre_pasajero, numero_documento, tipo_documento, telefono, email, id_pais_nacionalidad) VALUES
('Juan Carlos Rodríguez', '12345678', 'CC', '+57 310 123 4567', 'juan.rodriguez@email.com', 1),
('María Isabel García', '87654321', 'CC', '+57 320 987 6543', 'maria.garcia@email.com', 1),
('John Smith', 'US123456789', 'PASSPORT', '+1 305 555 0123', 'john.smith@email.com', 2),
('Ana Martínez López', 'ES987654321', 'DNI', '+34 600 123 456', 'ana.martinez@email.com', 3),
('Carlos Alberto Silva', 'BR456789123', 'CPF', '+55 11 9999 8888', 'carlos.silva@email.com', 5),
('Sophie Dubois', 'FR789123456', 'PASSPORT', '+33 1 42 00 00 00', 'sophie.dubois@email.com', 8),
('Miguel Hernández', 'MX321654987', 'PASSPORT', '+52 55 1234 5678', 'miguel.hernandez@email.com', 4);

INSERT INTO aeronaves (matricula, id_tipo_aeronave, id_aerolinea, peso_distribuido, compartimentos_carga, estado_operativo) VALUES
('HK-4001', 1, 1, 12500.50, 2, true),
('N12345', 2, 4, 15800.75, 2, true),
('EC-ABC', 3, 3, 28900.25, 3, true),
('XA-DEF', 4, 2, 38500.00, 3, true),
('PR-GHI', 5, 7, 35200.80, 3, true),
('F-WXYZ', 6, 6, 32100.60, 3, true),
('HK-4002', 7, 1, 6500.30, 1, true);

INSERT INTO vuelos (numero_vuelo, id_aerolinea, id_aeropuerto_origen, id_aeropuerto_destino, matricula_aeronave, fecha_salida, hora_salida, fecha_llegada, hora_llegada, escalas) VALUES
('AV101', 1, 1, 3, 'HK-4001', '2025-05-29', '08:30:00', '2025-05-29', '14:45:00', false),
('AM205', 2, 5, 1, 'XA-DEF', '2025-05-29', '10:15:00', '2025-05-29', '18:30:00', true),
('IB6789', 3, 4, 2, 'EC-ABC', '2025-05-30', '22:00:00', '2025-05-31', '14:20:00', false),
('AA892', 4, 3, 1, 'N12345', '2025-05-30', '16:30:00', '2025-05-31', '06:15:00', false),
('LA450', 5, 8, 1, 'PR-GHI', '2025-05-31', '12:00:00', '2025-05-31', '20:45:00', false),
('AF123', 6, 4, 1, 'F-WXYZ', '2025-06-01', '09:45:00', '2025-06-01', '23:30:00', true),
('AV567', 1, 2, 4, 'HK-4002', '2025-06-01', '06:00:00', '2025-06-01', '18:45:00', false);

INSERT INTO equipajes (numero_identificacion, id_pasajero, numero_vuelo, id_tipo_equipaje, descripcion, ultimo_punto_rastreo_conocido, id_estado, peso) VALUES
('BAG001AV101', 1, 'AV101', 2, 'Maleta rígida color negro', 'Terminal de salida BOG', 1, 23.50),
('BAG002AM205', 2, 'AM205', 2, 'Maleta de tela azul', 'Zona de clasificación MEX', 5, 18.75),
('BAG003IB678', 3, 'IB6789', 1, 'Mochila de viaje', 'Gate B12 MAD', 1, 8.20),
('BAG004AA892', 4, 'AA892', 4, 'Estuche de instrumentos musicales', 'Área de carga MIA', 4, 15.30),
('BAG005LA450', 5, 'LA450', 3, 'Bolsa de equipos deportivos', 'Carrusel 3 SCL', 1, 25.80),
('BAG006AF123', 6, 'AF123', 2, 'Maleta con ruedas plateada', 'Zona de inspección CDG', 4, 22.10),
('BAG007AV567', 7, 'AV567', 5, 'Contenedor especial para arte', 'Terminal MDE', 1, 12.40),
('BAG008AV101', 1, 'AV101', 1, 'Bolso de mano', 'Cabina del avión', 1, 5.20);

INSERT INTO etiquetas (codigo_identificacion_unico, numero_identificacion_equipaje, numero_vuelo, destino, nombre_pasajero, codigo_barras, codigo_qr, informacion_rfid, fecha_generacion) VALUES
('TAG001AV101BAG001', 'BAG001AV101', 'AV101', 'MIA', 'Juan Carlos Rodríguez', '1234567890123', 'QR001AV101BAG001DATA', 'RFID001AV101BAG001INFO', '2025-05-29 07:30:00'),
('TAG002AM205BAG002', 'BAG002AM205', 'AM205', 'BOG', 'María Isabel García', '2345678901234', 'QR002AM205BAG002DATA', 'RFID002AM205BAG002INFO', '2025-05-29 09:15:00'),
('TAG003IB678BAG003', 'BAG003IB678', 'IB6789', 'MDE', 'John Smith', '3456789012345', 'QR003IB678BAG003DATA', 'RFID003IB678BAG003INFO', '2025-05-30 21:00:00'),
('TAG004AA892BAG004', 'BAG004AA892', 'AA892', 'BOG', 'Ana Martínez López', '4567890123456', 'QR004AA892BAG004DATA', 'RFID004AA892BAG004INFO', '2025-05-30 15:30:00'),
('TAG005LA450BAG005', 'BAG005LA450', 'LA450', 'BOG', 'Carlos Alberto Silva', '5678901234567', 'QR005LA450BAG005DATA', 'RFID005LA450BAG005INFO', '2025-05-31 11:00:00'),
('TAG006AF123BAG006', 'BAG006AF123', 'AF123', 'BOG', 'Sophie Dubois', '6789012345678', 'QR006AF123BAG006DATA', 'RFID006AF123BAG006INFO', '2025-06-01 08:45:00'),
('TAG007AV567BAG007', 'BAG007AV567', 'AV567', 'MAD', 'Miguel Hernández', '7890123456789', 'QR007AV567BAG007DATA', 'RFID007AV567BAG007INFO', '2025-06-01 05:00:00');

INSERT INTO talones_equipaje (numero_talon, numero_identificacion_equipaje, id_pasajero, fecha_emision, estado_validez) VALUES
('TALON001AV101', 'BAG001AV101', 1, '2025-05-29 07:30:00', true),
('TALON002AM205', 'BAG002AM205', 2, '2025-05-29 09:15:00', true),
('TALON003IB678', 'BAG003IB678', 3, '2025-05-30 21:00:00', true),
('TALON004AA892', 'BAG004AA892', 4, '2025-05-30 15:30:00', true),
('TALON005LA450', 'BAG005LA450', 5, '2025-05-31 11:00:00', true),
('TALON006AF123', 'BAG006AF123', 6, '2025-06-01 08:45:00', true),
('TALON007AV567', 'BAG007AV567', 7, '2025-06-01 05:00:00', true);

INSERT INTO zonas_clasificacion (nombre_zona, agrupacion_por_vuelo, agrupacion_por_destino, capacidad, estado_operativo) VALUES
('Zona A - Vuelos Nacionales', true, true, 500, true),
('Zona B - Vuelos Internacionales', true, true, 800, true),
('Zona C - Equipaje Especial', false, true, 200, true),
('Zona D - Inspección Adicional', false, false, 100, true),
('Zona E - Conexiones', true, true, 600, true),
('Zona F - Carga Prioritaria', true, false, 150, true);

INSERT INTO zonas_reclamo (numero_carrusel, clasificacion_rapida_maletas, disponibilidad_para_pasajeros, capacidad, estado_operativo) VALUES
(1, true, true, 300, true),
(2, true, true, 350, true),
(3, true, true, 400, true),
(4, false, true, 250, true),
(5, true, false, 200, false),
(6, true, true, 450, true);

INSERT INTO operadores (nombre, area_asignada, verificacion_numero_vuelo_destino, coordinacion_busqueda_devolucion, turno, activo) VALUES
('Carlos Mendoza', 'Zona de Clasificación A', true, true, 'MAÑANA', true),
('Ana Pérez', 'Zona de Clasificación B', true, true, 'TARDE', true),
('Roberto Silva', 'Área de Carga', true, false, 'NOCHE', true),
('Lucía Ramírez', 'Zona de Reclamo', false, true, 'MAÑANA', true),
('Diego Morales', 'Inspección Adicional', true, true, 'TARDE', true),
('Patricia López', 'Servicio al Cliente', false, true, 'MAÑANA', true),
('Fernando Castro', 'Área de Carga', true, false, 'NOCHE', true);

INSERT INTO escaneres (id_tipo_escaner, ubicacion, estado_operativo) VALUES
(1, 'Terminal 1 - Entrada Principal', true),
(2, 'Zona de Clasificación A', true),
(3, 'Zona de Carga - Puerta 5', true),
(4, 'Carrusel 1 - Zona de Reclamo', true),
(5, 'Área de Inspección', true),
(1, 'Terminal 2 - Check-in', true),
(2, 'Zona de Clasificación B', true);

INSERT INTO cintas_transportadoras (nombre_cinta, zona_origen, zona_destino, velocidad_mts_min, capacidad_kg, estado_operativo) VALUES
('Cinta Principal A', 'Check-in Terminal 1', 'Zona Clasificación A', 25.50, 2000, true),
('Cinta Principal B', 'Check-in Terminal 2', 'Zona Clasificación B', 28.00, 2500, true),
('Cinta Carga 1', 'Zona Clasificación A', 'Área de Carga 1', 20.00, 3000, true),
('Cinta Carga 2', 'Zona Clasificación B', 'Área de Carga 2', 22.50, 3500, true),
('Cinta Reclamo 1', 'Área de Llegadas', 'Carrusel 1', 15.00, 1500, true),
('Cinta Reclamo 2', 'Área de Llegadas', 'Carrusel 2', 18.00, 1800, true);

INSERT INTO compartimentos_aeronave (matricula_aeronave, numero_compartimento, capacidad_peso, capacidad_volumen, tipo_compartimento) VALUES
('HK-4001', 1, 7500.00, 45.50, 'delantero'),
('HK-4001', 2, 7500.00, 45.50, 'trasero'),
('N12345', 1, 9000.00, 55.20, 'delantero'),
('N12345', 2, 9000.00, 55.20, 'trasero'),
('EC-ABC', 1, 12000.00, 75.80, 'delantero'),
('EC-ABC', 2, 11500.00, 70.25, 'central'),
('EC-ABC', 3, 11500.00, 70.25, 'trasero'),
('XA-DEF', 1, 15000.00, 95.50, 'delantero'),
('XA-DEF', 2, 15000.00, 90.80, 'central'),
('XA-DEF', 3, 15000.00, 95.50, 'trasero');

INSERT INTO registros_rastreo (numero_identificacion_equipaje, id_escaner, timestamp, ubicacion, registro_equipaje_a_bordo, trazabilidad_continua, estado_tiempo_real, observaciones) VALUES
('BAG001AV101', 1, '2025-05-29 07:35:00', 'Terminal 1 - Check-in', false, true, 'Equipaje registrado', 'Equipaje en buen estado'),
('BAG001AV101', 2, '2025-05-29 07:45:00', 'Zona Clasificación A', false, true, 'En clasificación', 'Procesamiento normal'),
('BAG001AV101', 3, '2025-05-29 08:15:00', 'Área de Carga', true, true, 'Cargado en aeronave', 'Vuelo AV101 - Compartimento 1'),
('BAG002AM205', 1, '2025-05-29 09:20:00', 'Terminal 2 - Check-in', false, true, 'Equipaje registrado', 'Equipaje deportivo'),
('BAG002AM205', 7, '2025-05-29 09:35:00', 'Zona Clasificación B', false, true, 'En clasificación', 'Requiere manejo especial'),
('BAG003IB678', 6, '2025-05-30 21:05:00', 'Terminal 2 - Check-in', false, true, 'Equipaje registrado', 'Equipaje de mano documentado'),
('BAG004AA892', 5, '2025-05-30 15:35:00', 'Área de Inspección', false, true, 'En inspección', 'Equipaje frágil - instrumentos musicales');

INSERT INTO proceso_carga_aeronave (numero_vuelo, numero_identificacion_equipaje, id_compartimento, verificado_peso, verificado_destino, verificado_balance, id_operador_carga, fecha_carga, observaciones) VALUES
('AV101', 'BAG001AV101', 1, true, true, true, 3, '2025-05-29 08:15:00', 'Carga exitosa en compartimento delantero'),
('AM205', 'BAG002AM205', 8, true, true, false, 7, '2025-05-29 10:05:00', 'Pendiente verificación de balance'),
('IB6789', 'BAG003IB678', 5, true, true, true, 3, '2025-05-30 21:45:00', 'Equipaje de mano en cabina'),
('AA892', 'BAG004AA892', 2, true, true, true, 7, '2025-05-30 16:15:00', 'Manejo especial para instrumentos'),
('LA450', 'BAG005LA450', 1, true, true, true, 3, '2025-05-31 11:45:00', 'Equipaje deportivo asegurado');

INSERT INTO inspecciones_adicionales (numero_identificacion_equipaje, motivo_inspeccion, id_operador_inspector, fecha_inicio_inspeccion, fecha_fin_inspeccion, resultado_inspeccion, observaciones) VALUES
('BAG002AM205', 'Equipaje deportivo - verificación de contenido', 5, '2025-05-29 09:40:00', '2025-05-29 09:55:00', 'aprobado', 'Equipos deportivos normales'),
('BAG004AA892', 'Instrumentos musicales - verificación especial', 5, '2025-05-30 15:40:00', '2025-05-30 16:00:00', 'aprobado', 'Instrumentos debidamente protegidos'),
('BAG006AF123', 'Inspección aleatoria de seguridad', 5, '2025-06-01 09:00:00', '2025-06-01 09:20:00', 'aprobado', 'Sin novedades'),
('BAG007AV567', 'Arte y objetos de valor', 5, '2025-06-01 05:15:00', '2025-06-01 05:35:00', 'aprobado', 'Embalaje adecuado para obras de arte'),
('BAG008AV101', 'Verificación de equipaje de mano', 5, '2025-05-29 08:00:00', '2025-05-29 08:10:00', 'aprobado', 'Cumple con regulaciones de cabina');

INSERT INTO reportes_incidentes (numero_reporte, numero_identificacion_equipaje, id_tipo_incidente, descripcion, ultimo_punto_rastreo_conocido, fecha_reporte, hora_reporte, estado_resolucion, id_operador_responsable) VALUES
('INC001-2025', 'BAG002AM205', 3, 'Equipaje no llegó en vuelo programado', 'Zona de clasificación MEX', '2025-05-29', '19:30:00', 'EN_PROCESO', 6),
('INC002-2025', 'BAG006AF123', 1, 'Equipaje extraviado durante conexión', 'Zona de inspección CDG', '2025-06-01', '10:15:00', 'PENDIENTE', 6),
('INC003-2025', 'BAG004AA892', 2, 'Daño menor en estuche de instrumentos', 'Área de carga MIA', '2025-05-30', '17:00:00', 'RESUELTO', 5),
('INC004-2025', 'BAG005LA450', 4, 'Etiqueta dañada durante manipulación', 'Carrusel 3 SCL', '2025-05-31', '21:00:00', 'RESUELTO', 4),
('INC005-2025', 'BAG001AV101', 3, 'Retraso en entrega por congestión en carrusel', 'Terminal de llegada MIA', '2025-05-29', '15:30:00', 'RESUELTO', 4);

INSERT INTO transacciones_entrega (numero_talon, id_operador, fecha_entrega, hora_entrega, confirmacion_correspondencia_maleta_talon, registro_entrega_completada, metodo_verificacion, observaciones) VALUES
('TALON001AV101', 4, '2025-05-29', '16:00:00', true, true, 'Verificación visual y código de barras', 'Entrega exitosa al pasajero'),
('TALON003IB678', 4, '2025-05-31', '15:30:00', true, true, 'Verificación RFID', 'Equipaje de mano entregado'),
('TALON004AA892', 4, '2025-05-31', '07:45:00', true, true, 'Verificación manual especial', 'Instrumentos entregados con precaución'),
('TALON005LA450', 4, '2025-05-31', '22:00:00', true, true, 'Código QR y visual', 'Equipaje deportivo entregado'),
('TALON007AV567', 6, '2025-06-01', '20:15:00', true, true, 'Verificación especializada para arte', 'Entrega con documentación especial');

INSERT INTO consultas_aplicacion (numero_identificacion_equipaje, id_tipo_plataforma, consulta_estado_maleta, informacion_tiempo_real, timestamp_consulta, ip_origen) VALUES
('BAG001AV101', 1, 'Estado de equipaje vuelo AV101', 'Equipaje entregado exitosamente', '2025-05-29 16:05:00', '192.168.1.100'),
('BAG002AM205', 2, 'Consulta equipaje demorado vuelo AM205', 'Equipaje en proceso de localización', '2025-05-29 20:00:00', '10.0.0.50'),
('BAG003IB678', 3, 'Verificación estado equipaje IB6789', 'Equipaje disponible para recolección', '2025-05-31 14:30:00', '172.16.0.25'),
('BAG004AA892', 1, 'Estado instrumentos musicales AA892', 'Equipaje entregado - verificar estado', '2025-05-31 08:00:00', '192.168.2.75'),
('BAG005LA450', 4, 'Consulta equipaje deportivo LA450', 'Equipaje entregado en carrusel 3', '2025-05-31 22:15:00', '10.1.1.120'),
('BAG006AF123', 1, 'Estado equipaje AF123', 'Equipaje en proceso de inspección', '2025-06-01 11:00:00', '192.168.3.200'),
('BAG007AV567', 2, 'Consulta arte AV567', 'Equipaje disponible - requiere documentación', '2025-06-01 19:45:00', '172.20.0.100');


-- TABLAS DE RELACIONES MUCHOS A MUCHOS
INSERT INTO equipaje_zona_clasificacion (numero_identificacion_equipaje, id_zona, fecha_entrada, fecha_salida, estado_proceso, id_operador_responsable) VALUES
('BAG001AV101', 1, '2025-05-29 07:45:00', '2025-05-29 08:10:00', 'COMPLETADO', 1),
('BAG002AM205', 2, '2025-05-29 09:35:00', NULL, 'EN_PROCESO', 2),
('BAG003IB678', 2, '2025-05-30 21:10:00', '2025-05-30 21:40:00', 'COMPLETADO', 2),
('BAG004AA892', 3, '2025-05-30 15:45:00', '2025-05-30 16:05:00', 'COMPLETADO', 5),
('BAG005LA450', 3, '2025-05-31 11:15:00', '2025-05-31 11:40:00', 'COMPLETADO', 1),
('BAG006AF123', 4, '2025-06-01 09:00:00', NULL, 'EN_PROCESO', 5),
('BAG007AV567', 3, '2025-06-01 05:20:00', '2025-06-01 05:50:00', 'COMPLETADO', 1);

INSERT INTO equipaje_zona_reclamo (numero_identificacion_equipaje, id_zona_reclamo, fecha_asignacion, posicion_carrusel, prioridad) VALUES
('BAG001AV101', 1, '2025-05-29 15:30:00', 1, 1),
('BAG003IB678', 2, '2025-05-31 14:45:00', 3, 1),
('BAG004AA892', 1, '2025-05-31 07:15:00', 2, 2),
('BAG005LA450', 3, '2025-05-31 21:30:00', 1, 1),
('BAG007AV567', 6, '2025-06-01 19:30:00', 2, 3),
('BAG008AV101', 1, '2025-05-29 15:45:00', 4, 1);

INSERT INTO vuelo_escalas (numero_vuelo, id_aeropuerto_escala, orden_escala, fecha_llegada_escala, hora_llegada_escala, fecha_salida_escala, hora_salida_escala, duracion_escala) VALUES
('AM205', 7, 1, '2025-05-29', '14:20:00', '2025-05-29', '16:15:00', '01:55:00'),
('AF123', 4, 1, '2025-06-01', '15:30:00', '2025-06-01', '17:45:00', '02:15:00'),
('AF123', 3, 2, '2025-06-01', '20:00:00', '2025-06-01', '21:30:00', '01:30:00'),
('AM205', 6, 2, '2025-05-29', '16:45:00', '2025-05-29', '17:30:00', '00:45:00'),
('IB6789', 8, 1, '2025-05-31', '10:30:00', '2025-05-31', '12:00:00', '01:30:00');

INSERT INTO equipaje_cinta_transportadora (numero_identificacion_equipaje, id_cinta, timestamp_inicio, timestamp_fin, estado_transporte) VALUES
('BAG001AV101', 1, '2025-05-29 07:35:00', '2025-05-29 07:43:00', 'completado'),
('BAG001AV101', 3, '2025-05-29 08:10:00', '2025-05-29 08:15:00', 'completado'),
('BAG002AM205', 2, '2025-05-29 09:20:00', '2025-05-29 09:32:00', 'completado'),
('BAG003IB678', 2, '2025-05-30 21:05:00', '2025-05-30 21:08:00', 'completado'),
('BAG004AA892', 2, '2025-05-30 15:35:00', '2025-05-30 15:42:00', 'completado'),
('BAG005LA450', 4, '2025-05-31 11:40:00', '2025-05-31 11:45:00', 'completado'),
('BAG005LA450', 6, '2025-05-31 21:25:00', '2025-05-31 21:30:00', 'completado'),
('BAG006AF123', 2, '2025-06-01 08:50:00', NULL, 'en_transito'),
('BAG007AV567', 1, '2025-06-01 05:05:00', '2025-06-01 05:18:00', 'completado');

-- ===============================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ===============================================

-- Consultas de verificación para confirmar que los datos se insertaron correctamente
SELECT 'Países' as tabla, COUNT(*) as total FROM paises
UNION ALL
SELECT 'Ciudades', COUNT(*) FROM ciudades
UNION ALL  
SELECT 'Aeropuertos', COUNT(*) FROM aeropuertos
UNION ALL
SELECT 'Aerolíneas', COUNT(*) FROM aerolineas
UNION ALL
SELECT 'Tipos de aeronave', COUNT(*) FROM tipos_aeronave
UNION ALL
SELECT 'Estados equipaje', COUNT(*) FROM estados_equipaje
UNION ALL
SELECT 'Tipos incidente', COUNT(*) FROM tipos_incidente
UNION ALL
SELECT 'Tipos escáner', COUNT(*) FROM tipos_escaner
UNION ALL
SELECT 'Tipos plataforma', COUNT(*) FROM tipos_plataforma
UNION ALL
SELECT 'Tipos equipaje', COUNT(*) FROM tipos_equipaje
UNION ALL
SELECT 'Pasajeros', COUNT(*) FROM pasajeros
UNION ALL
SELECT 'Aeronaves', COUNT(*) FROM aeronaves
UNION ALL
SELECT 'Vuelos', COUNT(*) FROM vuelos
UNION ALL
SELECT 'Equipajes', COUNT(*) FROM equipajes
UNION ALL
SELECT 'Etiquetas', COUNT(*) FROM etiquetas
UNION ALL
SELECT 'Talones equipaje', COUNT(*) FROM talones_equipaje
UNION ALL
SELECT 'Zonas clasificación', COUNT(*) FROM zonas_clasificacion
UNION ALL
SELECT 'Zonas reclamo', COUNT(*) FROM zonas_reclamo
UNION ALL
SELECT 'Operadores', COUNT(*) FROM operadores
UNION ALL
SELECT 'Escáneres', COUNT(*) FROM escaneres
UNION ALL
SELECT 'Cintas transportadoras', COUNT(*) FROM cintas_transportadoras
UNION ALL
SELECT 'Compartimentos aeronave', COUNT(*) FROM compartimentos_aeronave
UNION ALL
SELECT 'Registros rastreo', COUNT(*) FROM registros_rastreo
UNION ALL
SELECT 'Proceso carga aeronave', COUNT(*) FROM proceso_carga_aeronave
UNION ALL
SELECT 'Inspecciones adicionales', COUNT(*) FROM inspecciones_adicionales
UNION ALL
SELECT 'Reportes incidentes', COUNT(*) FROM reportes_incidentes
UNION ALL
SELECT 'Transacciones entrega', COUNT(*) FROM transacciones_entrega
UNION ALL
SELECT 'Consultas aplicación', COUNT(*) FROM consultas_aplicacion
UNION ALL
SELECT 'Inventario tiempo real', COUNT(*) FROM inventario_tiempo_real
UNION ALL
SELECT 'Equipaje zona clasificación', COUNT(*) FROM equipaje_zona_clasificacion
UNION ALL
SELECT 'Equipaje zona reclamo', COUNT(*) FROM equipaje_zona_reclamo
UNION ALL
SELECT 'Vuelo escalas', COUNT(*) FROM vuelo_escalas
UNION ALL
SELECT 'Equipaje cinta transportadora', COUNT(*) FROM equipaje_cinta_transportadora
ORDER BY tabla;
