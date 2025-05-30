
CREATE TABLE paises (
    id_pais SERIAL PRIMARY KEY,
    codigo_iso VARCHAR(3) UNIQUE NOT NULL,
    nombre_pais VARCHAR(100) NOT NULL
);

CREATE TABLE ciudades (
    id_ciudad SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    codigo_iata VARCHAR(3) UNIQUE,
    id_pais INTEGER NOT NULL REFERENCES paises(id_pais)
);

CREATE TABLE aeropuertos (
    id_aeropuerto SERIAL PRIMARY KEY,
    codigo_iata VARCHAR(3) UNIQUE NOT NULL,
    nombre_aeropuerto VARCHAR(200) NOT NULL,
    id_ciudad INTEGER NOT NULL REFERENCES ciudades(id_ciudad)
);

CREATE TABLE aerolineas (
    id_aerolinea SERIAL PRIMARY KEY,
    codigo_iata VARCHAR(2) UNIQUE NOT NULL,
    nombre_aerolinea VARCHAR(100) NOT NULL,
    id_pais INTEGER NOT NULL REFERENCES paises(id_pais)
);

CREATE TABLE tipos_aeronave (
    id_tipo_aeronave SERIAL PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    fabricante VARCHAR(50) NOT NULL,
    capacidad_total_carga DECIMAL(10,2) NOT NULL,
    numero_compartimentos INTEGER NOT NULL
);

CREATE TABLE estados_equipaje (
    id_estado SERIAL PRIMARY KEY,
    codigo_estado VARCHAR(20) UNIQUE NOT NULL, -- normal, perdido, dañado, en_inspeccion
    descripcion_estado VARCHAR(100) NOT NULL
);

CREATE TABLE tipos_incidente (
    id_tipo_incidente SERIAL PRIMARY KEY,
    codigo_tipo VARCHAR(20) UNIQUE NOT NULL, -- perdido, dañado
    descripcion_tipo VARCHAR(100) NOT NULL
);

CREATE TABLE tipos_escaner (
    id_tipo_escaner SERIAL PRIMARY KEY,
    codigo_tipo VARCHAR(20) UNIQUE NOT NULL, -- optico, RFID, automatizado
    descripcion_tipo VARCHAR(100) NOT NULL
);

CREATE TABLE tipos_plataforma (
    id_tipo_plataforma SERIAL PRIMARY KEY,
    codigo_tipo VARCHAR(20) UNIQUE NOT NULL, -- movil, quiosco
    descripcion_tipo VARCHAR(100) NOT NULL
);

CREATE TABLE tipos_equipaje (
    id_tipo_equipaje SERIAL PRIMARY KEY,
    codigo_tipo VARCHAR(20) UNIQUE NOT NULL, -- mano, bodega, deportivo, fragil, especial
    descripcion_tipo VARCHAR(100) NOT NULL
);

-- ENTIDADES PRINCIPALES - CON created_at donde es necesario
CREATE TABLE pasajeros (
    id_pasajero SERIAL PRIMARY KEY,
    nombre_pasajero VARCHAR(200) NOT NULL,
    numero_documento VARCHAR(50) UNIQUE NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    id_pais_nacionalidad INTEGER REFERENCES paises(id_pais),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE aeronaves (
    matricula VARCHAR(20) PRIMARY KEY,
    id_tipo_aeronave INTEGER NOT NULL REFERENCES tipos_aeronave(id_tipo_aeronave),
    id_aerolinea INTEGER NOT NULL REFERENCES aerolineas(id_aerolinea),
    peso_distribuido DECIMAL(10,2) NOT NULL DEFAULT 0,
    compartimentos_carga INTEGER NOT NULL,
    estado_operativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE vuelos (
    numero_vuelo VARCHAR(10) PRIMARY KEY,
    id_aerolinea INTEGER NOT NULL REFERENCES aerolineas(id_aerolinea),
    id_aeropuerto_origen INTEGER NOT NULL REFERENCES aeropuertos(id_aeropuerto),
    id_aeropuerto_destino INTEGER NOT NULL REFERENCES aeropuertos(id_aeropuerto),
    matricula_aeronave VARCHAR(20) NOT NULL REFERENCES aeronaves(matricula),
    fecha_salida DATE NOT NULL,
    hora_salida TIME NOT NULL,
    fecha_llegada DATE NOT NULL,
    hora_llegada TIME NOT NULL,
    escalas BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE equipajes (
    numero_identificacion VARCHAR(50) PRIMARY KEY,
    id_pasajero INTEGER NOT NULL REFERENCES pasajeros(id_pasajero),
    numero_vuelo VARCHAR(10) NOT NULL REFERENCES vuelos(numero_vuelo),
    id_tipo_equipaje INTEGER NOT NULL REFERENCES tipos_equipaje(id_tipo_equipaje),
    descripcion TEXT,
    ultimo_punto_rastreo_conocido VARCHAR(200),
    id_estado INTEGER NOT NULL REFERENCES estados_equipaje(id_estado),
    peso DECIMAL(8,2) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE etiquetas (
    codigo_identificacion_unico VARCHAR(100) PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL,
    numero_vuelo VARCHAR(10) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    nombre_pasajero VARCHAR(200) NOT NULL,
    codigo_barras VARCHAR(200) UNIQUE NOT NULL,
    codigo_qr TEXT NOT NULL,
    informacion_rfid VARCHAR(500) NOT NULL,
    fecha_generacion TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (numero_identificacion_equipaje) REFERENCES equipajes(numero_identificacion)
);

CREATE TABLE talones_equipaje (
    numero_talon VARCHAR(50) PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL,
    id_pasajero INTEGER NOT NULL REFERENCES pasajeros(id_pasajero),
    fecha_emision TIMESTAMP NOT NULL DEFAULT NOW(),
    estado_validez BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (numero_identificacion_equipaje) REFERENCES equipajes(numero_identificacion)
);

CREATE TABLE zonas_clasificacion (
    id_zona SERIAL PRIMARY KEY,
    nombre_zona VARCHAR(100) NOT NULL,
    agrupacion_por_vuelo BOOLEAN DEFAULT TRUE,
    agrupacion_por_destino BOOLEAN DEFAULT TRUE,
    capacidad INTEGER NOT NULL,
    estado_operativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE zonas_reclamo (
    id_zona_reclamo SERIAL PRIMARY KEY,
    numero_carrusel INTEGER NOT NULL,
    clasificacion_rapida_maletas BOOLEAN DEFAULT TRUE,
    disponibilidad_para_pasajeros BOOLEAN DEFAULT TRUE,
    capacidad INTEGER NOT NULL,
    estado_operativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE operadores (
    id_operador SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    area_asignada VARCHAR(100) NOT NULL,
    verificacion_numero_vuelo_destino BOOLEAN DEFAULT TRUE,
    coordinacion_busqueda_devolucion BOOLEAN DEFAULT TRUE,
    turno VARCHAR(20) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE escaneres (
    id_escaner SERIAL PRIMARY KEY,
    id_tipo_escaner INTEGER NOT NULL REFERENCES tipos_escaner(id_tipo_escaner),
    ubicacion VARCHAR(200) NOT NULL,
    estado_operativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- NUEVAS ENTIDADES PARA MEJORAS IDENTIFICADAS
CREATE TABLE cintas_transportadoras (
    id_cinta SERIAL PRIMARY KEY,
    nombre_cinta VARCHAR(100) NOT NULL,
    zona_origen VARCHAR(100) NOT NULL,
    zona_destino VARCHAR(100) NOT NULL,
    velocidad_mts_min DECIMAL(5,2) NOT NULL,
    capacidad_kg INTEGER NOT NULL,
    estado_operativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE compartimentos_aeronave (
    id_compartimento SERIAL PRIMARY KEY,
    matricula_aeronave VARCHAR(20) NOT NULL REFERENCES aeronaves(matricula),
    numero_compartimento INTEGER NOT NULL,
    capacidad_peso DECIMAL(8,2) NOT NULL,
    capacidad_volumen DECIMAL(8,2) NOT NULL,
    tipo_compartimento VARCHAR(50) NOT NULL, -- delantero, trasero, central
    UNIQUE(matricula_aeronave, numero_compartimento)
);

-- ENTIDADES DE PROCESO Y AUDITORÍA - CON created_at
CREATE TABLE registros_rastreo (
    id_registro SERIAL PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL,
    id_escaner INTEGER NOT NULL REFERENCES escaneres(id_escaner),
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    ubicacion VARCHAR(200) NOT NULL,
    registro_equipaje_a_bordo BOOLEAN DEFAULT FALSE,
    trazabilidad_continua BOOLEAN DEFAULT TRUE,
    estado_tiempo_real VARCHAR(100) NOT NULL,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (numero_identificacion_equipaje) REFERENCES equipajes(numero_identificacion)
);

CREATE TABLE proceso_carga_aeronave (
    id_proceso SERIAL PRIMARY KEY,
    numero_vuelo VARCHAR(10) NOT NULL REFERENCES vuelos(numero_vuelo),
    numero_identificacion_equipaje VARCHAR(50) NOT NULL,
    id_compartimento INTEGER NOT NULL REFERENCES compartimentos_aeronave(id_compartimento),
    verificado_peso BOOLEAN DEFAULT FALSE,
    verificado_destino BOOLEAN DEFAULT FALSE,
    verificado_balance BOOLEAN DEFAULT FALSE,
    id_operador_carga INTEGER NOT NULL REFERENCES operadores(id_operador),
    fecha_carga TIMESTAMP NOT NULL DEFAULT NOW(),
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (numero_identificacion_equipaje) REFERENCES equipajes(numero_identificacion),
    UNIQUE(numero_identificacion_equipaje, numero_vuelo)
);

CREATE TABLE inspecciones_adicionales (
    id_inspeccion SERIAL PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL REFERENCES equipajes(numero_identificacion),
    motivo_inspeccion VARCHAR(200) NOT NULL,
    id_operador_inspector INTEGER NOT NULL REFERENCES operadores(id_operador),
    fecha_inicio_inspeccion TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_fin_inspeccion TIMESTAMP,
    resultado_inspeccion VARCHAR(100), -- aprobado, rechazado, requiere_seguimiento
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE reportes_incidentes (
    numero_reporte VARCHAR(50) PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL REFERENCES equipajes(numero_identificacion),
    id_tipo_incidente INTEGER NOT NULL REFERENCES tipos_incidente(id_tipo_incidente),
    descripcion TEXT NOT NULL,
    ultimo_punto_rastreo_conocido VARCHAR(200) NOT NULL,
    fecha_reporte DATE NOT NULL,
    hora_reporte TIME NOT NULL,
    estado_resolucion VARCHAR(50) DEFAULT 'PENDIENTE',
    id_operador_responsable INTEGER REFERENCES operadores(id_operador),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE transacciones_entrega (
    id_transaccion SERIAL PRIMARY KEY,
    numero_talon VARCHAR(50) NOT NULL REFERENCES talones_equipaje(numero_talon),
    id_operador INTEGER NOT NULL REFERENCES operadores(id_operador),
    fecha_entrega DATE NOT NULL,
    hora_entrega TIME NOT NULL,
    confirmacion_correspondencia_maleta_talon BOOLEAN NOT NULL,
    registro_entrega_completada BOOLEAN NOT NULL,
    metodo_verificacion VARCHAR(100) NOT NULL,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE consultas_aplicacion (
    id_consulta SERIAL PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL REFERENCES equipajes(numero_identificacion),
    id_tipo_plataforma INTEGER NOT NULL REFERENCES tipos_plataforma(id_tipo_plataforma),
    consulta_estado_maleta TEXT NOT NULL,
    informacion_tiempo_real TEXT NOT NULL,
    timestamp_consulta TIMESTAMP NOT NULL DEFAULT NOW(),
    ip_origen VARCHAR(45),
    created_at TIMESTAMP DEFAULT NOW()
);

-- TABLAS DE RELACIONES MUCHOS A MUCHOS (4NF) - CON created_at
CREATE TABLE equipaje_zona_clasificacion (
    id SERIAL PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL REFERENCES equipajes(numero_identificacion),
    id_zona INTEGER NOT NULL REFERENCES zonas_clasificacion(id_zona),
    fecha_entrada TIMESTAMP NOT NULL,
    fecha_salida TIMESTAMP,
    estado_proceso VARCHAR(50) NOT NULL DEFAULT 'EN_PROCESO',
    id_operador_responsable INTEGER REFERENCES operadores(id_operador),
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(numero_identificacion_equipaje, id_zona, fecha_entrada)
);

CREATE TABLE equipaje_zona_reclamo (
    id SERIAL PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL REFERENCES equipajes(numero_identificacion),
    id_zona_reclamo INTEGER NOT NULL REFERENCES zonas_reclamo(id_zona_reclamo),
    fecha_asignacion TIMESTAMP NOT NULL DEFAULT NOW(),
    posicion_carrusel INTEGER,
    prioridad INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(numero_identificacion_equipaje, id_zona_reclamo)
);

CREATE TABLE vuelo_escalas (
    id SERIAL PRIMARY KEY,
    numero_vuelo VARCHAR(10) NOT NULL REFERENCES vuelos(numero_vuelo),
    id_aeropuerto_escala INTEGER NOT NULL REFERENCES aeropuertos(id_aeropuerto),
    orden_escala INTEGER NOT NULL,
    fecha_llegada_escala DATE NOT NULL,
    hora_llegada_escala TIME NOT NULL,
    fecha_salida_escala DATE NOT NULL,
    hora_salida_escala TIME NOT NULL,
    duracion_escala INTERVAL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(numero_vuelo, orden_escala)
);

CREATE TABLE equipaje_cinta_transportadora (
    id SERIAL PRIMARY KEY,
    numero_identificacion_equipaje VARCHAR(50) NOT NULL REFERENCES equipajes(numero_identificacion),
    id_cinta INTEGER NOT NULL REFERENCES cintas_transportadoras(id_cinta),
    timestamp_inicio TIMESTAMP NOT NULL DEFAULT NOW(),
    timestamp_fin TIMESTAMP,
    estado_transporte VARCHAR(50) NOT NULL DEFAULT 'EN_TRANSITO', -- en_transito, completado, error
    created_at TIMESTAMP DEFAULT NOW()
);

-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
CREATE INDEX idx_equipajes_estado ON equipajes(id_estado);
CREATE INDEX idx_equipajes_vuelo ON equipajes(numero_vuelo);
CREATE INDEX idx_equipajes_pasajero ON equipajes(id_pasajero);
CREATE INDEX idx_equipajes_tipo ON equipajes(id_tipo_equipaje);
CREATE INDEX idx_registros_rastreo_equipaje ON registros_rastreo(numero_identificacion_equipaje);
CREATE INDEX idx_registros_rastreo_timestamp ON registros_rastreo(timestamp);
CREATE INDEX idx_reportes_incidentes_fecha ON reportes_incidentes(fecha_reporte);
CREATE INDEX idx_consultas_aplicacion_timestamp ON consultas_aplicacion(timestamp_consulta);
CREATE INDEX idx_vuelos_fecha_salida ON vuelos(fecha_salida);
CREATE INDEX idx_vuelos_aeropuerto_origen ON vuelos(id_aeropuerto_origen);
CREATE INDEX idx_vuelos_aeropuerto_destino ON vuelos(id_aeropuerto_destino);

-- COMENTARIOS EN TABLAS PRINCIPALES
COMMENT ON TABLE equipajes IS 'Tabla principal de equipajes con información de identificación y estado';
COMMENT ON TABLE tipos_equipaje IS 'Catálogo de tipos de equipaje para evitar redundancia de datos';
COMMENT ON TABLE registros_rastreo IS 'Registro de todos los puntos de rastreo del equipaje en tiempo real';
COMMENT ON TABLE proceso_carga_aeronave IS 'Control del proceso de carga de equipaje en compartimentos de aeronave';
COMMENT ON TABLE reportes_incidentes IS 'Registro de incidentes relacionados con equipajes perdidos o dañados';
COMMENT ON TABLE inventario_tiempo_real IS 'Control de inventario en tiempo real por zonas del aeropuerto';