USE `ezdates`;

DELIMITER // 
CREATE OR REPLACE TRIGGER RN_1_01_FechaNacimiento
BEFORE INSERT ON Usuarios FOR EACH ROW 
BEGIN
	IF(DATEDIFF(CURRENT_DATE,NEW.fechaNacimiento)/365)<18 THEN
		SIGNAL /*(45000,mensaje);*/
			SQLSTATE '45000'
			SET MESSAGE_TEXT = 
				'RN_1_01_FechaNacimiento: \n Debes ser mayor de edad';
	END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR
REPLACE TRIGGER RN_1_04_NumeroFoto BEFORE
INSERT ON Fotos FOR EACH ROW BEGIN DECLARE n INT; -- academicYear de la fila del acta
SET n= (
SELECT COUNT(*)
FROM Fotos
WHERE usuarioId = NEW.usuarioId);
 IF n>= 5 THEN SIGNAL /*(45000,mensaje);*/ SQLSTATE '45000' SET MESSAGE_TEXT = 
				'RN_1_04_NumeroFoto: \n Tienes más de 5 fotos'; END IF; END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE TRIGGER RN_2_02_NumeroSolicitudes
BEFORE INSERT ON  SolicitudesAmistades FOR EACH ROW 
BEGIN
    DECLARE n INT; 
	SET n= (SELECT COUNT(*) FROM SolicitudesAmistades WHERE usuarioSolicitante = NEW.usuarioSolicitante AND fechaSolicitud=NEW.fechaSolicitud);
    IF n>= 5 THEN 
		SIGNAL /*(45000,mensaje);*/
			SQLSTATE '45000'
			SET MESSAGE_TEXT = 
				'RN_2_02_NumeroSolicitudes: \n No puedes enviar mas de 5 solicitudes en un mismo dia';
	END IF;
END //
DELIMITER ;



-- RN-2-03
DELIMITER //
CREATE OR REPLACE TRIGGER RN_2_03_DerivacionVinculoActivo BEFORE INSERT ON SolicitudesAmistades FOR EACH ROW
BEGIN 
	IF (NEW.fechaAceptacion IS NOT NULL AND NEW.fechaRevocacion IS NULL AND NEW.fechaRevocacionAceptacionCumplimentada IS NULL) THEN
		SET NEW.vinculoActivo = 1;
	END IF;
END //
DELIMITER;


-- RN-2-04
DELIMITER //
	CREATE OR REPLACE TRIGGER RN_2_04_LimitacionDeVinculosActivosEntreDosU BEFORE INSERT ON SolicitudesAmistades FOR EACH ROW
	BEGIN
		DECLARE usuario1 INT;
		DECLARE usuario2 INT;
		DECLARE VinculosActivos INT;
		DECLARE VinculosActivos2 INT;
		SET usuario1 = NEW.usuarioSolicitado;
		SET usuario2 = NEW.usuarioSolicitante;
		
		IF (new.fechaAceptacion IS NOT NULL AND new.fechaRevocacion IS NULL AND new.fechaRevocacionAceptacionCumplimentada IS NULL) THEN
			SET VinculosActivos = (SELECT COUNT(*) from solicitudesAmistades S
				WHERE (S.usuarioSolicitante = usuario1  AND S.usuarioSolicitado = usuario2 AND S.vinculoActivo = 1));
			SET VinculosActivos2 = (SELECT COUNT(*) from solicitudes S
				WHERE (S.usuarioSolicitante = usuario2  AND S.usuarioSolicitado = usuario1 AND S.vinculoActivo = 1));
		
			IF ((VinculosActivos + VinculosActivos2) >= 1) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' RN-2-04: Dos usuarios solo pueden tener un vinculo activo entre ellos';
		END IF;
		END IF;
	END //
DELIMITER ;
	
-- RN-2-05
DELIMITER //
CREATE OR REPLACE TRIGGER RN_2_05_SolicitudActivos BEFORE INSERT ON SolicitudesAmistades FOR EACH ROW
BEGIN
	DECLARE UsuarioActivo BOOL;
	SET UsuarioActivo = (SELECT activo FROM Usuarios where usuarioId = new.usuarioSolicitante);
	IF (NOT(UsuarioActivo)) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'RN-2-05: Solo un usuario activo puede solicitar un vinculo de amistad';
	END IF;
END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE TRIGGER RN_2_05_AceptacionActivos BEFORE INSERT ON SolicitudesAmistades FOR EACH ROW
BEGIN
	DECLARE UsuarioActivo BOOL;
	SET UsuarioActivo = (SELECT activo FROM Usuarios where usuarioId = new.usuarioSolicitado);
	IF (NOT(UsuarioActivo) AND new.fechaAceptacion IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'RN-2-05: Solo un usuario activo puede aceptar un vinculo de amistad';
	END IF;
END //
DELIMITER ;
	


-- RN-3-01
DELIMITER //
CREATE OR REPLACE TRIGGER RN_3_01_PreferenciaPeso BEFORE UPDATE ON PrefPeso FOR EACH ROW
BEGIN
	IF(( NEW.MinimoPeso IS NOT NULL AND NEW.MinimoPeso<0) OR (NEW.MaximoPeso IS NOT NULL AND NEW.MaximoPeso<0)) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'RN-3-01: El peso mínimo y máximo deben ser positivos o igual a 0 ';
	END IF;
	IF (NEW.MinimoPeso IS NOT NULL AND NEW.MaximoPeso IS NOT NULL AND new.MinimoPeso > NEW.MaximoPeso) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'RN-3-01: El peso mínimo debe ser inferior al peso máximo ';
	END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER RN_3_01_PreferenciaEstatura BEFORE UPDATE ON PrefEstatura FOR EACH ROW
BEGIN
	IF((NEW.MinimaEst IS NOT NULL AND NEW.MinimaEst < 0) OR (NEW.MaximaEst IS NOT NULL AND NEW.MaximaEst < 0)) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'RN-3-01: La altura mínima y máxima deben ser positivos o igual a 0 ';
	END IF;
	IF (NEW.MinimaEst IS NOT NULL AND NEW.MaximaEst IS NOT NULL AND NEW.MinimaEst > NEW.MaximaEst) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'RN-3-01: La altura mínima debe ser inferior a la máxima ';
	END IF;
END //
DELIMITER ;


-- RN-4-02

DELIMITER //
CREATE OR REPLACE TRIGGER RN_4_02_Citas_admitidas_solo_para_vínculos_activos BEFORE INSERT ON Citas FOR EACH ROW
BEGIN
   
   DECLARE u1 INT;
   DECLARE u2 INT;
   DECLARE activo BOOL;
   SET u1 = (SELECT usuarioId FROM VinculosAmistades WHERE relacionesId=NEW.relacionesId ORDER BY usuarioId LIMIT 1);
   SET u2 = (SELECT usuarioId FROM VinculosAmistades WHERE relacionesId=NEW.relacionesId ORDER BY usuarioId LIMIT 1);
   SET activo = (SELECT COUNT(*) FROM SolicitudesAmistades WHERE ((usuarioSolicitante=u1 AND usuarioSolicitado=u2) OR (usuarioSolicitante=u2 AND usuarioSolicitado=u1)) AND vinculoActivo = 1) = 1;

   IF (activo = 0) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 'RN-4-02: Solo pueden tener citas aquellas personas cuyos vínculos estén activos';
   END IF;
END //
DELIMITER ;









