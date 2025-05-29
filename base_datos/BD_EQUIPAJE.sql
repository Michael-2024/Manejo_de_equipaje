CREATE TABLE pais (
    paisid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    codigoiso2 CHAR(2) NOT NULL UNIQUE,
    codigoiso3 CHAR(3) NOT NULL UNIQUE
);

CREATE TABLE ciudad (
    ciudadid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    paisid BIGINT NOT NULL,
    FOREIGN KEY (paisid) REFERENCES pais(paisid),
    UNIQUE(nombre, paisid)
);

CREATE TABLE tipodocumento (
    tipodocumentoid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    longitudminima INTEGER,
    longitudmaxima INTEGER,
    esidentificacion BOOLEAN DEFAULT TRUE
);

CREATE TABLE tipodocumento_pais (
    tipodocumentoid BIGINT NOT NULL,
    paisemisoid BIGINT NOT NULL,
    fechavigencia DATE NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (tipodocumentoid, paisemisoid, fechavigencia),
    FOREIGN KEY (tipodocumentoid) REFERENCES tipodocumento(tipodocumentoid),
    FOREIGN KEY (paisemisoid) REFERENCES pais(paisid)
);

CREATE TABLE dimensiones (
    dimensionid BIGSERIAL PRIMARY KEY,
    alto DECIMAL(8,2) NOT NULL,
    ancho DECIMAL(8,2) NOT NULL,
    profundidad DECIMAL(8,2) NOT NULL,
    UNIQUE(alto, ancho, profundidad)
);

CREATE TABLE nivelgravedad (
    nivelid BIGSERIAL PRIMARY KEY,
    nivel INTEGER NOT NULL UNIQUE,
    descripcion TEXT NOT NULL,
    coloridentificacion CHAR(7),
    tiemporespuestahoras INTEGER
);

CREATE TABLE tipoterminal (
    tipoterminalid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    capacidadpasajeros INTEGER
);

CREATE TABLE tiposistema (
    tiposistemaid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    version TEXT
);

-- ========================================
-- TABLA DE COLORES
-- ========================================

CREATE TABLE color (
    colorid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    codigohex CHAR(7) NOT NULL UNIQUE,
    descripcion TEXT,
    visibilidad TEXT CHECK (visibilidad IN ('alta', 'media', 'baja'))
);

-- ========================================
-- TABLA DE ESTADOS DEL SISTEMA
-- ========================================

CREATE TABLE estadosistema (
    estadoid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    colorhex CHAR(7)
);

-- ========================================
-- TABLAS DE TIPOS ESPECÍFICOS
-- ========================================

CREATE TABLE tipoequipaje (
    tipoequipajeid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    dimensionid BIGINT,
    pesomaxo DECIMAL(8,2),
    permitecabina BOOLEAN DEFAULT FALSE,
    requiereetiquetaespecial BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (dimensionid) REFERENCES dimensiones(dimensionid)
);

CREATE TABLE tipoinspeccion (
    tipoinspeccionid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    requiereoperadorespecializado BOOLEAN DEFAULT FALSE,
    tiempoestimado INTEGER, -- en minutos
    nivelautorizacion INTEGER DEFAULT 1
);

CREATE TABLE resultadoinspeccion (
    resultadoid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    requiereseguimiento BOOLEAN DEFAULT FALSE,
    permiteembarque BOOLEAN DEFAULT TRUE
);

CREATE TABLE tipoincidente (
    tipoincidenteid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    nivelgravedadid BIGINT NOT NULL,
    requierecompensacion BOOLEAN DEFAULT FALSE,
    tiemporespuesta INTEGER, -- horas máximas de respuesta
    autoescalamiento BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (nivelgravedadid) REFERENCES nivelgravedad(nivelid)
);

CREATE TABLE cargo (
    cargoid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    nivelautorizacion INTEGER DEFAULT 1,
    salariobase DECIMAL(12,2)
);

-- ========================================
-- TABLAS PRINCIPALES
-- ========================================

CREATE TABLE pasajero (
    pasajeroid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    numerodocumento TEXT NOT NULL,
    tipodocumentoid BIGINT NOT NULL,
    telefono TEXT,
    email TEXT UNIQUE,
    fechanacimiento DATE,
    paisnacimiento BIGINT,
    FOREIGN KEY (tipodocumentoid) REFERENCES tipodocumento(tipodocumentoid),
    FOREIGN KEY (paisnacimiento) REFERENCES pais(paisid),
    UNIQUE(numerodocumento, tipodocumentoid)
);

CREATE TABLE aeropuerto (
    aeropuertoid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    ciudadid BIGINT NOT NULL,
    codigoiata CHAR(3) NOT NULL UNIQUE,
    codigoicao CHAR(4) NOT NULL UNIQUE,
    husohorario TEXT NOT NULL,
    altitud INTEGER,
    latitud DECIMAL(10,8),
    longitud DECIMAL(11,8),
    FOREIGN KEY (ciudadid) REFERENCES ciudad(ciudadid)
);

CREATE TABLE terminal (
    terminalid BIGSERIAL PRIMARY KEY,
    aeropuertoid BIGINT NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    tipoterminalid BIGINT NOT NULL,
    FOREIGN KEY (aeropuertoid) REFERENCES aeropuerto(aeropuertoid),
    FOREIGN KEY (tipoterminalid) REFERENCES tipoterminal(tipoterminalid),
    UNIQUE(aeropuertoid, nombre)
);

CREATE TABLE operador (
    operadorid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    codigoempleado TEXT NOT NULL UNIQUE,
    numerodocumento TEXT NOT NULL,
    tipodocumentoid BIGINT NOT NULL,
    cargoid BIGINT NOT NULL,
    terminalid BIGINT,
    fechaingreso DATE NOT NULL,
    estadoid BIGINT,
    FOREIGN KEY (tipodocumentoid) REFERENCES tipodocumento(tipodocumentoid),
    FOREIGN KEY (cargoid) REFERENCES cargo(cargoid),
    FOREIGN KEY (terminalid) REFERENCES terminal(terminalid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid),
    UNIQUE(numerodocumento, tipodocumentoid)
);

CREATE TABLE aerolinea (
    aerolineaid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    codigoiata CHAR(2) NOT NULL UNIQUE,
    codigoicao CHAR(3),
    paisorigen BIGINT,
    fechafundacion DATE,
    estadoid BIGINT,
    FOREIGN KEY (paisorigen) REFERENCES pais(paisid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid)
);

CREATE TABLE aeronave (
    aeronaveid BIGSERIAL PRIMARY KEY,
    matricula TEXT NOT NULL UNIQUE,
    modelonombre TEXT NOT NULL, -- ej: "Boeing 737-800"
    fabricante TEXT NOT NULL, -- ej: "Boeing"
    capacidadequipaje INTEGER, -- piezas máximas
    pesomaximoequipaje DECIMAL(10,2), -- kg máximos
    aerolineaid BIGINT NOT NULL,
    fechafabricacion DATE,
    fecharegistro DATE NOT NULL,
    estadoid BIGINT,
    FOREIGN KEY (aerolineaid) REFERENCES aerolinea(aerolineaid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid)
);

CREATE TABLE vuelo (
    vueloid BIGSERIAL PRIMARY KEY,
    numerovuelo TEXT NOT NULL,
    aeropuertoorigenid BIGINT NOT NULL,
    aeropuertodestinoid BIGINT NOT NULL,
    terminalsalidaid BIGINT,
    terminalllegadaid BIGINT,
    fechasalida TIMESTAMP NOT NULL,
    fechallegada TIMESTAMP NOT NULL,
    fechasalidaprevista TIMESTAMP NOT NULL,
    fechallegadaprevista TIMESTAMP NOT NULL,
    aerolineaid BIGINT NOT NULL,
    aeronaveid BIGINT,
    estadoid BIGINT,
    FOREIGN KEY (aeropuertoorigenid) REFERENCES aeropuerto(aeropuertoid),
    FOREIGN KEY (aeropuertodestinoid) REFERENCES aeropuerto(aeropuertoid),
    FOREIGN KEY (terminalsalidaid) REFERENCES terminal(terminalid),
    FOREIGN KEY (terminalllegadaid) REFERENCES terminal(terminalid),
    FOREIGN KEY (aerolineaid) REFERENCES aerolinea(aerolineaid),
    FOREIGN KEY (aeronaveid) REFERENCES aeronave(aeronaveid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid),
    UNIQUE(numerovuelo, fechasalida)
);

CREATE TABLE escalavuelo (
    escalaid BIGSERIAL PRIMARY KEY,
    vueloid BIGINT NOT NULL,
    aeropuertoid BIGINT NOT NULL,
    terminalid BIGINT,
    fechallegadaescala TIMESTAMP NOT NULL,
    fechasalidaescala TIMESTAMP NOT NULL,
    fechallegadaprevista TIMESTAMP NOT NULL,
    fechasalidaprevista TIMESTAMP NOT NULL,
    orden INTEGER NOT NULL,
    tiempoescala INTEGER, -- minutos
    FOREIGN KEY (vueloid) REFERENCES vuelo(vueloid),
    FOREIGN KEY (aeropuertoid) REFERENCES aeropuerto(aeropuertoid),
    FOREIGN KEY (terminalid) REFERENCES terminal(terminalid),
    UNIQUE(vueloid, orden)
);

CREATE TABLE clasificacionequipaje (
    clasificacionid BIGSERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    manejoespecial TEXT,
    prioridadcarga INTEGER NOT NULL DEFAULT 1,
    requieredocumentacion BOOLEAN DEFAULT FALSE
);

CREATE TABLE equipaje (
    equipajeid BIGSERIAL PRIMARY KEY,
    pasajeroid BIGINT NOT NULL,
    vueloid BIGINT NOT NULL,
    clasificacionid BIGINT NOT NULL,
    tipoequipajeid BIGINT NOT NULL,
    peso DECIMAL(8,2) NOT NULL,
    dimensionid BIGINT,
    descripcion TEXT,
    fecharegistro TIMESTAMP NOT NULL,
    estadoid BIGINT,
    colorprincipalid BIGINT,
    colorsecundario TEXT, -- descripción libre de colores adicionales
    FOREIGN KEY (pasajeroid) REFERENCES pasajero(pasajeroid),
    FOREIGN KEY (vueloid) REFERENCES vuelo(vueloid),
    FOREIGN KEY (clasificacionid) REFERENCES clasificacionequipaje(clasificacionid),
    FOREIGN KEY (tipoequipajeid) REFERENCES tipoequipaje(tipoequipajeid),
    FOREIGN KEY (dimensionid) REFERENCES dimensiones(dimensionid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid),
    FOREIGN KEY (colorprincipalid) REFERENCES color(colorid)
);

CREATE TABLE etiqueta (
    etiquetaid BIGSERIAL PRIMARY KEY,
    equipajeid BIGINT NOT NULL,
    codigobarras TEXT NOT NULL UNIQUE,
    codigorfid TEXT UNIQUE,
    fechaemision TIMESTAMP NOT NULL,
    talonnumero TEXT NOT NULL UNIQUE,
    operadoremisionid BIGINT,
    fechavencimiento TIMESTAMP,
    estadoid BIGINT,
    FOREIGN KEY (equipajeid) REFERENCES equipaje(equipajeid),
    FOREIGN KEY (operadoremisionid) REFERENCES operador(operadorid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid)
);

CREATE TABLE cargaequipaje (
    cargaid BIGSERIAL PRIMARY KEY,
    equipajeid BIGINT NOT NULL,
    vueloid BIGINT NOT NULL,
    fechacarga TIMESTAMP NOT NULL,
    operadorid BIGINT NOT NULL,
    posicioncarga TEXT,
    pesoverificado DECIMAL(8,2),
    observaciones TEXT,
    FOREIGN KEY (equipajeid) REFERENCES equipaje(equipajeid),
    FOREIGN KEY (vueloid) REFERENCES vuelo(vueloid),
    FOREIGN KEY (operadorid) REFERENCES operador(operadorid)
);

CREATE TABLE puntocontrol (
    puntocontrolid BIGSERIAL PRIMARY KEY,
    terminalid BIGINT NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    tipoproceso TEXT NOT NULL CHECK (tipoproceso IN ('facturacion', 'inspeccion', 'entrega', 'carga', 'descarga')),
    estadoid BIGINT,
    FOREIGN KEY (terminalid) REFERENCES terminal(terminalid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid),
    UNIQUE(terminalid, nombre)
);

CREATE TABLE cintatransportadora (
    cintaid BIGSERIAL PRIMARY KEY,
    puntocontrolid BIGINT NOT NULL,
    nombre TEXT NOT NULL,
    capacidadprocesamiento INTEGER NOT NULL,
    estadoid BIGINT,
    FOREIGN KEY (puntocontrolid) REFERENCES puntocontrol(puntocontrolid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid),
    UNIQUE(puntocontrolid, nombre)
);

CREATE TABLE equipamientocontrol (
    equipamientoid BIGSERIAL PRIMARY KEY,
    puntocontrolid BIGINT NOT NULL,
    nombre TEXT NOT NULL, -- ej: "Escáner de Rayos X modelo XYZ"
    fabricante TEXT, -- ej: "Smiths Detection"
    modelo TEXT, -- ej: "HI-SCAN 6040aTiX"
    numeroseriale TEXT NOT NULL UNIQUE,
    fechainstalacion DATE NOT NULL,
    estadoid BIGINT,
    FOREIGN KEY (puntocontrolid) REFERENCES puntocontrol(puntocontrolid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid)
);

CREATE TABLE seguimientoequipaje (
    seguimientoid BIGSERIAL PRIMARY KEY,
    equipajeid BIGINT NOT NULL,
    puntocontrolid BIGINT NOT NULL,
    fechahora TIMESTAMP NOT NULL,
    operadorid BIGINT,
    observaciones TEXT,
    temperaturaambiente DECIMAL(4,1),
    humedadambiente DECIMAL(4,1),
    estadoid BIGINT,
    FOREIGN KEY (equipajeid) REFERENCES equipaje(equipajeid),
    FOREIGN KEY (puntocontrolid) REFERENCES puntocontrol(puntocontrolid),
    FOREIGN KEY (operadorid) REFERENCES operador(operadorid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid)
);

CREATE TABLE inspeccionequipaje (
    inspeccionid BIGSERIAL PRIMARY KEY,
    equipajeid BIGINT NOT NULL,
    tipoinspeccionid BIGINT NOT NULL,
    puntocontrolid BIGINT NOT NULL,
    operadorid BIGINT NOT NULL,
    fechainspeccion TIMESTAMP NOT NULL,
    resultadoid BIGINT NOT NULL,
    observaciones TEXT,
    requiereseguimiento BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (equipajeid) REFERENCES equipaje(equipajeid),
    FOREIGN KEY (tipoinspeccionid) REFERENCES tipoinspeccion(tipoinspeccionid),
    FOREIGN KEY (puntocontrolid) REFERENCES puntocontrol(puntocontrolid),
    FOREIGN KEY (operadorid) REFERENCES operador(operadorid),
    FOREIGN KEY (resultadoid) REFERENCES resultadoinspeccion(resultadoid)
);

CREATE TABLE entregaequipaje (
    entregaid BIGSERIAL PRIMARY KEY,
    equipajeid BIGINT NOT NULL,
    puntocontrolid BIGINT NOT NULL,
    fechaentrega TIMESTAMP NOT NULL,
    operadorid BIGINT NOT NULL,
    confirmacionpasajero BOOLEAN,
    documentoentrega TEXT,
    observaciones TEXT,
    metodoconfirmacion TEXT NOT NULL CHECK (metodoconfirmacion IN ('talon', 'biometrico', 'documento')),
    FOREIGN KEY (equipajeid) REFERENCES equipaje(equipajeid),
    FOREIGN KEY (puntocontrolid) REFERENCES puntocontrol(puntocontrolid),
    FOREIGN KEY (operadorid) REFERENCES operador(operadorid)
);

CREATE TABLE incidente (
    incidenteid BIGSERIAL PRIMARY KEY,
    equipajeid BIGINT,
    pasajeroid BIGINT NOT NULL,
    tipoincidenteid BIGINT NOT NULL,
    fechareporte TIMESTAMP NOT NULL,
    descripcion TEXT,
    fecharesolucion TIMESTAMP,
    compensacionaplicada DECIMAL(12,2),
    operadorreporteid BIGINT,
    operadorresolucionid BIGINT,
    estadoid BIGINT,
    FOREIGN KEY (equipajeid) REFERENCES equipaje(equipajeid),
    FOREIGN KEY (pasajeroid) REFERENCES pasajero(pasajeroid),
    FOREIGN KEY (tipoincidenteid) REFERENCES tipoincidente(tipoincidenteid),
    FOREIGN KEY (operadorreporteid) REFERENCES operador(operadorid),
    FOREIGN KEY (operadorresolucionid) REFERENCES operador(operadorid),
    FOREIGN KEY (estadoid) REFERENCES estadosistema(estadoid)
);

CREATE TABLE seguimientoincidente (
    seguimientoid BIGSERIAL PRIMARY KEY,
    incidenteid BIGINT NOT NULL,
    fechaaccion TIMESTAMP NOT NULL,
    accionrealizada TEXT NOT NULL,
    operadorid BIGINT NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (incidenteid) REFERENCES incidente(incidenteid),
    FOREIGN KEY (operadorid) REFERENCES operador(operadorid)
);

-- ========================================
-- CONFIGURACIÓN DE REGLAS DE NEGOCIO
-- ========================================

CREATE TABLE reglasmanejo (
    reglaid BIGSERIAL PRIMARY KEY,
    tipoequipajeid BIGINT NOT NULL,
    tipoterminalid BIGINT NOT NULL,
    pesomaximo DECIMAL(8,2),
    requiereinspeccion BOOLEAN DEFAULT FALSE,
    tiempomaxprocesamiento INTEGER, -- minutos
    FOREIGN KEY (tipoequipajeid) REFERENCES tipoequipaje(tipoequipajeid),
    FOREIGN KEY (tipoterminalid) REFERENCES tipoterminal(tipoterminalid),
    UNIQUE(tipoequipajeid, tipoterminalid)
);