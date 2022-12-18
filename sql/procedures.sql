USE `ezdates`;


-- RF 1-01
DELIMITER //
CREATE OR REPLACE PROCEDURE fNuevoUsuario(nombre VARCHAR(32), fechaNacimiento DATE, estatura INT, peso DECIMAL(4,2),genero ENUM('Masculino','Femenino','Otro'),correoElectronico VARCHAR(64) ,contraseña VARCHAR(64) 
                    ,colorPelo ENUM('Negro','Castaño','Rubio','Rojo','Blanco','Gris'),colorOjos ENUM ('Azules','Negros','Grises','Verdes','Castaño'),
                    biografia VARCHAR(128) ,direccionId INT)
BEGIN 
    INSERT INTO Usuarios (nombre, fechaNacimiento, estatura, peso, genero, correoElectronico, contraseña, fechaDeBaja, colorPelo, colorOjos, biografia, direccionId)
    VALUES(nombre, fechaNacimiento, estatura, peso, genero, correoElectronico, contraseña, fechaDeBaja, colorPelo, colorOjos, biografia, direccionId);
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE DarsedeBaja(email VARCHAR(32))
BEGIN 
    UPDATE usuarios SET fechaDeBaja = CURRENT_DATE() WHERE correoElectronico = email;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE 
    eliminarusuario(tlfUsuario INT)
BEGIN 
    DECLARE usuario INT;
    SET usuario = (SELECT usuarioId FROM usuarios WHERE numeroTlf = tlfUsuario);



    If (usuario IN (SELECT usuarioId FROM Preferencias) OR
         usuario IN (SELECT usuarioId FROM Aficiones) OR 
         usuario IN (SELECT usuarioId FROM Fotos) OR
         usuario IN (SELECT usuarioSolicitado FROM SolicitudesAmistades) OR
         usuario IN (SELECT usuarioSolicitante FROM SolicitudesAmistades)) THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este usuario no se puede borrar';
    ELSE 
        DELETE FROM usuarios WHERE numeroTlf = tlfUsuario;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE
    aficionModificada(tlfUsuario INT, aficion VARCHAR(32)) 
BEGIN 
    UPDATE usuarios SET aficiones = aficion WHERE numeroTlf = tlfUsuario;
END // 
DELIMITER ;



-- RF-1-02
DELIMITER //
CREATE OR REPLACE PROCEDURE 
    cambiafechaNacimiento(tlfUsuario INT,fechaNacimiento2 DATE)
BEGIN 
    UPDATE usuarios SET fechaNacimiento = fechaNacimiento2 WHERE numeroTlf = tlfUsuario;
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE 
    cambiaEstatura(tlfUsuario INT, estatura2 INT)
BEGIN 
    UPDATE usuarios SET estatura = estatura2 WHERE numeroTlf = tlfUsuario;
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE 
    cambiaPeso(tlfUsuario INT, peso2 INT)
BEGIN 
    UPDATE usuarios SET peso= peso2 WHERE numeroTlf = tlfUsuario;
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE 
    cambiocolorPelo(tlfUsuario INT, colorPelo2 ENUM('Negro','Castaño','Rubio','Rojo','Blanco','Gris'))
BEGIN 
    UPDATE usuarios SET colorPelo = colorPelo2 WHERE numeroTlf = tlfUsuario;
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE 
    cambiocolorOjos(tlfUsuario INT, colorOjos2 ENUM ('Azules','Negros','Grises','Verdes','Castaño'))
BEGIN 
    UPDATE usuarios SET colorOjos = colorOjos2 WHERE numeroTlf = tlfUsuario;
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE 
    cambioBiografia(tlfUsuario INT, biografia2 VARCHAR(128))
BEGIN 
    UPDATE usuarios SET biografia = biografia2 WHERE numeroTlf = tlfUsuario;
END //
DELIMITER ;

-- RF-1-03
DELIMITER //
CREATE OR REPLACE PROCEDURE aficionAñadida(tlfUsuario INT,aficion VARCHAR(32))
BEGIN 
	DECLARE usuario INT;
	DECLARE afAuxiliar INT;
	DECLARE aux INT;
    SET usuario = (SELECT usuarioId FROM usuarios WHERE tlfUsuario = numeroTlf);

    IF (aficion IN (SELECT nombre FROM aficiones)) THEN 
         SET afAuxiliar = (SELECT aficionId FROM aficiones WHERE aficion = nombreAf);
         INSERT INTO usuariosAf(usuarioId,aficionId)
             VALUES(usuario,afAuxiliar);
    ELSE 
        INSERT INTO aficiones(nombreAf)
             VALUES(aficion);
        SET aux = (SELECT aficionId FROM aficiones WHERE aficion = nombreAf);
        INSERT INTO usuariosAf(usuarioId,aficionId)
             VALUES(usuario,aux);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE aficionEliminada(tlfUsuario INT,aficion VARCHAR(32))
BEGIN 
	DECLARE usuario INT;
	DECLARE aux INT;
   
	 SET usuario = (SELECT usuarioId FROM usuarios WHERE tlfUsuario = numeroTlf);
    SET aux = (SELECT aficionId FROM aficiones WHERE aficion = nombreAf);

    IF (aux IN (SELECT aficionId FROM usuariosAf WHERE usuario = usuarioId)) THEN 
        SET aux = (SELECT aficionId FROM aficiones WHERE aficion = nombreAf);
         DELETE FROM usuariosAf WHERE (usuario = usuarioId AND aux= aficionId);
    
	 ELSE 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta afición no la tenías puesta';
    
	 END IF;
END //
DELIMITER ;


-- RF 2-01-B
DELIMITER //
CREATE OR REPLACE PROCEDURE anularSolicitudSolicitante(correousuario VARCHAR(64), correousuario2 VARCHAR(64))
BEGIN 
	DECLARE	u1 INT;
	 DECLARE u2 INT;
    
	 SET u1 = (SELECT usuarioId FROM usuarios WHERE correousuario = correoElectronico);
    SET u2 = (SELECT usuarioId FROM usuarios WHERE correousuario2 = correoElectronico);

    UPDATE solicitudesAmistades SET fechaRevocacionAceptacionCumplimentada = CURRENT_DATE() WHERE usuarioSolicitante = u1 and usuarioSolicitado = u2;
    UPDATE SolicitudesAmistades set vinculoActivo = 0 where usuarioSolicitante = u1 and usuarioSolicitado = u2;

END //
DELIMITER ;

-- RF-2-01-B
DELIMITER //
CREATE OR REPLACE PROCEDURE anularSolicitud(correousuarioSolicitado VARCHAR(64), correousuarioSolicitante VARCHAR(64))
BEGIN
	 DECLARE	usuarioSolicitado INT;
	 DECLARE usuarioSolicitante INT;
    
	 SET usuarioSolicitado = (SELECT usuarioId FROM usuarios WHERE correousuarioSolicitado = correoElectronico);
    SET usuarioSolicitante = (SELECT usuarioId FROM usuarios WHERE correousuarioSolicitante = correoElectronico);

    UPDATE solicitudesAmistades SET fechaRevocacion = CURRENT_DATE() WHERE usuarioSolicitante = userIdSolicitante and usuarioSolicitado = userIdSolicitado;
    UPDATE SolicitudesAmistades set vinculoActivo = 0 where usuarioSolicitante = userIdSolicitante and usuarioSolicitado = userIdSolicitado;

END //
DELIMITER ;


-- RF-4-01
DELIMITER  //
CREATE OR REPLACE PROCEDURE
    nuevaCita(tlfusuario VARCHAR(64), tlfusuario2 VARCHAR(64), fecha Date)
BEGIN
	DECLARE u1 INT;
	DECLARE u2 INT;
	DECLARE fechaF DATE;
	DECLARE relacion INT;
    
	 SET u1 = (SELECT usuarioId FROM usuarios WHERE tlfusuario = tlf);
    SET u2 = (SELECT usuarioId FROM usuarios WHERE tlfusuario2 = tlf);

    SET relacion = (SELECT relacionId FROM usuarios NATURAL JOIN usuariosrelaciones WHERE tlf IN (tlfusuario,tlfusuario2) 
        GROUP BY relacionId HAVING COUNT(DISTINCT tlf)=2);
    SET fechaF = (SELECT fechaFinalizacion FROM relaciones WHERE relacion=relacionesId);

    IF (fechaF IS null) THEN
        INSERT INTO citas(relacionId, fecha)
        VALUES (relacionId, fecha);
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE 
    terminarRelacion(tlfSolicitante VARCHAR(64), tlfSolicitado VARCHAR(64))
BEGIN
	DECLARE u1 INT;
	DECLARE u2 INT;
	DECLARE relacion INT;
    
	 SET u1 = (SELECT usuarioId FROM usuarios WHERE tlfSolicitante = tlf);
    SET u2 = (SELECT usuarioId FROM usuarios WHERE tlfSolicitado = tlf);

    SET relacion = (SELECT relacionesId FROM usuarios NATURAL JOIN vinculoAmistades WHERE tlf IN (tlfSolicitante,tlfSolicitado) 
        GROUP BY relacionesId HAVING COUNT(DISTINCT tlf)=2);
   
	 UPDATE relaciones SET tlfSolicitante = u1 WHERE relacionesId = relacion;
    
	 UPDATE relaciones SET fechaFinalizacion = CURRENT_DATE() WHERE relacionesId = relacion;
END //
DELIMITER ;