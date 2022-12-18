DROP DATABASE `ezdates`;
CREATE DATABASE `ezdates`;

USE `ezdates`;

CREATE TABLE Direccion(
    direccionId INT NOT NULL AUTO_INCREMENT,
    codigoPostal INT, 
    municipio VARCHAR(32),
    provincia VARCHAR(32),
    PRIMARY KEY(direccionId)
);

CREATE TABLE Usuarios(
    usuarioId INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(128) NOT NULL,
    fechaNacimiento Date NOT NULL,
    numeroTlf INT NOT NULL,
    idioma VARCHAR(128) NOT NULL,
    estatura INT NOT NULL DEFAULT 170,
    peso DECIMAL(4,2) NOT NULL DEFAULT 75.00,
    genero ENUM('Masculino','Femenino','Otro') NOT NULL,
    email  VARCHAR(128) NOT NULL,
    contrasenya VARCHAR(128) NOT NULL,
    fechaDeAlta Date NOT NULL,
    fechaDeBaja Date DEFAULT NULL,
    colorPelo ENUM('Negro','Castaño','Rubio','Rojo','Blanco','Gris') DEFAULT 'Negro',
    colorOjos ENUM('Azules','Negros','Grises','Verdes','Castaño') NOT NULL,
    biografia VARCHAR(256) NOT NULL,
    orientacionSexual VARCHAR(32) NOT NULL,
    metodoPago VARCHAR(128) NOT NULL,
    activo BOOL,
    redesSociales VARCHAR(128) NOT NULL,
    direccionId INT NOT NULL,
    PRIMARY KEY(usuarioId),
    UNIQUE(nombre,numeroTlf,email),
    FOREIGN KEY (direccionId) REFERENCES Direccion (direccionId),
    CONSTRAINT ErrorPeso CHECK (peso>0.00),  -- RN-1-0b Peso debe ser positivo
    CONSTRAINT ErrorEstatura CHECK (estatura>0),  -- RN-1-0b Estatura debe ser positivo
    CONSTRAINT ErrorFecha CHECK(fechaNacimiento<fechaDeAlta AND fechaDeAlta<fechaDeBaja)  -- RN-1-03 Consistencia de fechas de usuario
);


CREATE TABLE Relaciones(
    relacionesId INT NOT NULL AUTO_INCREMENT,
    componentes VARCHAR(128) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFinalizacion DATE NOT NULL,
    PRIMARY KEY(relacionesId),
    UNIQUE(componentes),
    CONSTRAINT Errorfechas CHECK(fechaInicio<fechaFinalizacion) -- RN-4-01 Fechas consistentes de Relación
);


CREATE OR REPLACE TABLE VinculosAmistades(
	vinculoAmistadesId INT NOT NULL AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	relacionesId INT NOT NULL,
	vinculoActivo BOOL,
	PRIMARY KEY(vinculoAmistadesId),
	FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId),
	FOREIGN KEY(relacionesId) REFERENCES Relaciones(relacionesId),
	UNIQUE(usuarioId,relacionesId)
);


CREATE TABLE Citas(
    citasId INT NOT NULL AUTO_INCREMENT,
    nombres VARCHAR(128),
    fecha DATE,
    lugar VARCHAR(128),
    relacionesId INT NOT NULL,
    usuarioId INT NOT NULL,
    fechaInicio DATE,
    fechaFinalizacion DATE,
    PRIMARY KEY(citasId),
    FOREIGN KEY (relacionesId) REFERENCES Relaciones(relacionesId),
    FOREIGN KEY (usuarioId) REFERENCES Usuarios(usuarioId),
    CONSTRAINT Errorfechas CHECK(fechaFinalizacion IS NULL OR fecha BETWEEN fechaInicio AND fechaFinalizacion)  -- RN-4-04 Fechas consistentes de Citas
);


CREATE TABLE SolicitudesAmistades(
    solicitudesAmistadesId INT NOT NULL AUTO_INCREMENT,
    usuarioSolicitado INT,
    usuarioSolicitante INT,
    vinculosAmistadesId INT NOT NULL,
    fechaSolicitud DATE NOT NULL,
    fechaAceptacion DATE,
    fechaRevocacion DATE,
    fechaRevocacionAceptacionCumplimentada DATE,
    vinculoActivo BOOL,
    PRIMARY KEY(solicitudesAmistadesId),
    FOREIGN KEY(vinculosAmistadesId) REFERENCES VinculosAmistades(vinculoAmistadesId),
    FOREIGN KEY(usuarioSolicitado) REFERENCES Usuarios(usuarioId),
    FOREIGN KEY(usuarioSolicitante) REFERENCES Usuarios(usuarioId),
    CHECK (fechaSolicitud<fechaAceptacion), -- RN-2-01 Consistencia de fechas de vínculos de amistad
    CHECK (fechaSolicitud<fechaRevocacion), -- RN-2-01 Consistencia de fechas de vínculos de amistad
    CHECK (fechaAceptacion<fechaRevocacionAceptacionCumplimentada), -- RN-2-01 Consistencia de fechas de vínculos de amistad
    CONSTRAINT ErrorSolicitudAmistad CHECK(usuarioSolicitado!=usuarioSolicitante) -- RN-3-02B Autoexclusión en vínculos de amistad
);


CREATE TABLE Fotos(
    fotosId INT NOT NULL AUTO_INCREMENT,
    url VARCHAR(128) NOT NULL,
    nombre VARCHAR(128),
    descripcion VARCHAR(128) NOT NULL,
    meGustas INT,
    usuarioId INT NOT NULL,
    PRIMARY KEY(fotosId),
    FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId),
    UNIQUE(url)
);


CREATE TABLE Aficiones(
    aficionesId INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(128),
    usuarioId INT NOT NULL,
    PRIMARY KEY(aficionesId),
    FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId),
    UNIQUE (nombre)
);


CREATE OR REPLACE TABLE Preferencias(
    preferenciaId INT NOT NULL AUTO_INCREMENT,
    usuarioId INT NOT NULL,
    PRIMARY KEY(preferenciaId),
    FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId)
);



CREATE OR REPLACE TABLE PrefOjos(
    prefOjosId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    ojos ENUM ('Azules','Negros','Grises','Verdes','Castaños') NOT NULL,
    PRIMARY KEY(prefOjosId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId),
    UNIQUE(preferenciaId, ojos)
);

CREATE OR REPLACE TABLE PrefPelo(
    prefPeloId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    pelo ENUM('Negro','Castaño','Rubio','Rojo','Blanco','Gris') NOT NULL,
    PRIMARY KEY(prefPeloId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId),
    UNIQUE(preferenciaId,pelo)
);

CREATE OR REPLACE TABLE PrefAficiones(
    preferenciaAficionesId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    aficion INT, 
    PRIMARY KEY(preferenciaAficionesId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId),
    FOREIGN KEY(aficion) REFERENCES aficiones(aficionesId),
    UNIQUE(preferenciaId, aficion)
);

CREATE OR REPLACE TABLE PrefEdad(
    prefEdadId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    MaximaEdad INT,
    MinimaEdad INT, 
    PRIMARY KEY(prefEdadId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId),
    UNIQUE(prefEdadId, preferenciaId)
);
CREATE OR REPLACE TABLE PrefEstatura(
    prefEstaturaId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    MaximaEst DECIMAL(4,2),
    MinimaEst DECIMAL(4,2),
    PRIMARY KEY(prefEstaturaId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId),
    UNIQUE(prefEstaturaId, preferenciaId)
);

CREATE OR REPLACE TABLE PrefPeso(
    prefPesoId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    MaximoPeso INT,
    MinimoPeso INT,
    PRIMARY KEY(prefPesoId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId),
    UNIQUE(prefPesoId,preferenciaId)
);

CREATE OR REPLACE TABLE PreferenciasGeograficas(
    prefGeograficaId INT NOT NULL AUTO_INCREMENT,
    preferenciaId INT NOT NULL,
    prefProv VARCHAR(32),
    prefMunicipio VARCHAR(32),
    PRIMARY KEY(prefGeograficaId),
    FOREIGN KEY(preferenciaId) REFERENCES Preferencias(preferenciaId)
);








