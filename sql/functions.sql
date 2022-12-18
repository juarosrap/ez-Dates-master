USE `ezdates`;


-- Número de vínculos de amistad por un usuario dado
DELIMITER //
CREATE OR REPLACE FUNCTION numeroVinculosAmistadPorUsuario(uId INTEGER)
RETURNS INTEGER 
BEGIN
	DECLARE nvinculos INTEGER;
	SET nvinculos=( SELECT COUNT(*) FROM vinculosAmistades 
		GROUP BY usuarioId 
		HAVING usuarioId=uId);
	RETURN nvinculos;
END // 
DELIMITER ;


-- Media edad de usuarios activos
DELIMITER //
CREATE OR REPLACE FUNCTION mediaEdadUsuariosActivos()
RETURNS DOUBLE 
BEGIN
	DECLARE mEdad DOUBLE;
	SET mEdad=( SELECT AVG(DATEDIFF(CURRENT_DATE,fechaNacimiento)/365) FROM usuarios 
		WHERE activo=TRUE);
	RETURN mEdad;
END // 
DELIMITER ;

-- Url de la foto con mayor número de me gustas
DELIMITER //
CREATE OR REPLACE FUNCTION fotoMayorNumeroMeGustas()
RETURNS VARCHAR(128) 
BEGIN
    DECLARE fMayorM INTEGER;
    SET fMayorM=( SELECT MAX(meGustas) FROM Fotos);
    RETURN (SELECT url FROM fotos WHERE meGustas=fMayorM);
END // 
DELIMITER ;

-- Lista de aficiones distintas
DELIMITER //
CREATE OR REPLACE FUNCTION numeroAficionesDistintas()
RETURNS VARCHAR(128) 
BEGIN
    RETURN (SELECT DISTINCT nombre FROM Aficiones);
END // 
DELIMITER ;

-- Aficiones más comunes
DELIMITER //
CREATE OR REPLACE FUNCTION aficionesMasComunes()
RETURNS VARCHAR(255)
BEGIN
    RETURN (SELECT nombre 
    FROM Aficiones
    GROUP BY nombre
    ORDER BY COUNT(*) ASC);
END // 
DELIMITER ;

-- Nombre de las 3 personas con más citad
DELIMITER //
CREATE OR REPLACE FUNCTION top3PersonasConMasCitas()
RETURNS VARCHAR(64)
BEGIN
  RETURN (
    SELECT nombre
    FROM usuarios NATURAL JOIN citas
    GROUP BY usuarioId
    ORDER BY COUNT(*)
    LIMIT 3
  );
END //
DELIMITER ;




