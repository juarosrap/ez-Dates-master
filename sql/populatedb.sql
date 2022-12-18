USE `ezdates`;

INSERT INTO Direccion(codigoPostal,municipio,provincia)
VALUES(32007,"Ronda","Malaga"),
(41010,"Sevilla","Sevilla"),
(43689, "Motril","Granada"),
(04001,"Almeria","Almeria"),
(68593,"La Algaba","Sevilla"),
(11140,"Conil","Cadiz"),
(23345,"Lepe","Huelva");

INSERT INTO Usuarios (nombre,fechaNacimiento,numeroTlf,idioma,estatura,peso,genero,email,contrasenya,fechaDeAlta,
fechaDeBaja,colorPelo,colorOjos,biografia,orientacionSexual,
metodoPago,activo,redesSociales,direccionId) 
VALUES ('Julián','1998-08-05',333445566,'español',130,70.00,'Masculino','Julian10@gmail.com','Julian34635','2011-08-12','2012-08-12',
'Rubio','Azules','Soy una persona muy activa e interesada en el mundo del deporte y del cine','Homosexual','Mastercard',TRUE,'Instagram: Jualian32435',1),
('Lucas', '1992-10-17', 321456789, 'español', 170, 65.00, 'Masculino', 'lucasdominguez23@gmail.com', 'vivaelbeti','2015-07-12',NULL,
'Castaño', 'Castaño','Calle Luis Montoto', 'Heterosexual', 'Paypal', TRUE,'Instagram: luuca_dominguez',2),
('Antoine','1999-02-12',648134132,'frances',140,75.00,'Masculino','antonie32@gmail.com','francia','2010-03-04','2010-08-06',
'Rubio','Verdes','Hombre de mediana edad con gran perpectiva politica','Homosexual','Paypal',FALSE,'Twitter:Antoine43',3),
('Federico','2000-05-21',651123444,'español',180,80.00,'Masculino','federodr#gmail.com','fede321','2013-05-01','2013-07-06',
'Rojo','Verdes','Adolescente con grandes dotes para la peluqueria','Bisexual','Paypal',TRUE,'Instagram:fede_32',4),
('Lucía', '1997-09-21', 324354342, 'español', 165, 59.00, 'Femenino', 'lucía56@gmail.com', '237463721312','2015-04-19',NULL,
'Negro', 'Castaño','Calle Marquez', 'Heterosexual', 'Paypal',TRUE, 'Instagram: luciaperez',5),
('Pablo', '1996-05-23', 621356489, 'francés', 175, 75.00, 'Masculino', 'pcarbajo@gmail.com', 'tomares17','2013-04-30',NULL,
'Castaño', 'Verdes','Soy una persona muy organizada y responsable', 'Heterosexual', 'VISA', TRUE,'Instagram: Pcarbaajoo',6),
('Kelly','1996-08-05',333445576,'ingles',160,50.00,'Femenino','kelly7788@gmail.com','micontraseña665','2017-06-12','2018-08-12',
'Rubio','Azules','Me gusta pasar rato con mis amigos y disfrutar de los placeres de la vida','Heterosexual','Mastercard',TRUE,'Instagram: kelly_23',7);

INSERT INTO Relaciones(componentes,fechaInicio,fechaFinalizacion) 
VALUES ('Julián y Lucas','1998-3-4','1999-4-3'),
('Lucas y Sofía','1998-3-4','1999-4-3'),
('Pablo y Maria','2000-7-3','2001-3-2'),
('Julián y Candela','2001-4-4','2001-5-18'),
('Kelly y Pablo', '2003-5-18', '2015-10-6'),
('Kelly y Lucía','1999-04-12','2000-03-1');

INSERT INTO Citas (nombres,fecha,lugar,relacionesId,usuarioId,fechaInicio,fechaFinalizacion) 
VALUES ('Julián,Marcos','1997-06-02','Parque María Luisa',1,1,'1996-3-2','1998-2-2'),
('Lucas, Sofía','1997-09-23','Calle Betis',2,2,'1996-3-2','1998-2-2'),
('Antoine,Eduard','2003-09-14','Arco del triunfo',3,1,'2002-12-23','2004-03-03'),
('Pepe,Marisa','2002-04-03','Benito Villamarin',4,2,'2001-3-2','2003-06-03');

INSERT INTO VinculosAmistades (usuarioId,relacionesId,vinculoActivo) 
VALUES(1,1,TRUE),
(2,1,TRUE),
(6,2,TRUE),
(2,2,FALSE),
(7,3,FALSE),
(2,3,FALSE),
(1,4,TRUE),
(3,4,TRUE),
(2,5,FALSE),
(4,5,FALSE),
(5,6,TRUE),
(7,6,TRUE);

INSERT INTO SolicitudesAmistades (usuarioSolicitado,usuarioSolicitante,vinculosAmistadesId,fechaSolicitud,fechaAceptacion,fechaRevocacion,fechaRevocacionAceptacionCumplimentada,vinculoActivo) 
VALUES (1,2,1,'1992-12-4','1998-5-6','2006-6-6','2007-6-6',TRUE),
 (6,2,2,'1991-11-3','1992-7-2','2006-6-6','2007-6-6',FALSE),
 (7,2,3,'1992-12-3','1993-4-2','2003-6-3','2008-3-2',FALSE),
 (1,3,4,'1993-12-4','1994-8-3','2000-3-6','2001-6-16',TRUE),
 (2,4,5,'1991-12-15','1992-5-6','2001-6-24','2002-3-14',FALSE),
 (5,7,6,'1994-11-4','1998-5-26','2003-6-6','2005-3-6',TRUE);

 
INSERT INTO Fotos(url,nombre,descripcion,meGustas,usuarioId) 
VALUES ('imagen1.jpg,imagen2.jpg','playa','Mis amigos y yo disfrutando de un día en la playa',331,1),
('imagen1','coche','Yo en Londres posando junto a mi coche favorito',22,1),
('imagen2.jpg','playa','Mis amigos y yo disfrutando de un día en la playa',234,7),
('imagen12.jpg','playa','Mis amigos y yo disfrutando de un día en el campo',324,2),
('imagen13.jpg','playa','Mis amigos y yo disfrutando de un día en la uni',377,3),
('imagen14.jpg','playa','Mis amigos y yo disfrutando de un día en la discoteca abril',768,5),
('imagen15.jpg','Arco del Triunfo','Monumento de Francia',342,6),
('imagen16.jpg','Benito Villamarin','Viendo un partido del betis en su estadio',875,4);


INSERT INTO Aficiones(nombre,usuarioId) 
VALUES ('Fútbol,leer libros',1),
 ('Música, pasear y los coches.',2),
 ('Pasar tiempo con mis ammigos',3),
 ('Carreras de caballo',5),
 ('Jugar a videojuegos',7),
 ('Coches , tomar un café y viajar',4);
 
INSERT INTO Preferencias(usuarioId)
VALUES(1),
(2),
(3),
(4),
(5),
(6),
(7);

INSERT INTO prefOjos(preferenciaId,ojos)
VALUES(1,'Verdes'),
(4,'Grises'),
(2,'Azules'),
(5,'Negros'),
(6, 'Verdes'),
(7,'Azules'),
(3, 'Castaños');

INSERT INTO prefpelo(preferenciaId,pelo)
VALUES(1,'Negro'),
(2,'Castaño'),
(3,'Rubio'),
(4,'Blanco'),
(5,'Castaño'),
(6,'Rubio'),
(7,'Rojo');

INSERT INTO prefaficiones(preferenciaId,aficion)
VALUES(1,1),
(2,1),
(3,2),
(3,3),
(3,4),
(4,5);

INSERT INTO prefedad(preferenciaId,MaximaEdad,MinimaEdad)
VALUES(1,20,40),
(3,40,23),
(2,30,20),
(5,50,40),
(4,34,25),
(6,50,20),
(7,80,78);

INSERT INTO prefEstatura(preferenciaId,MaximaEst,MinimaEst)
VALUES(1,1.4,1.5),
(2,2.1,1.76),
(4,2.0,1.75),
(3,1.8,1.3),
(5,1.9,1.7),
(6,2.4,1.6),
(7,1.85,1.44);

INSERT INTO prefPeso(preferenciaId,MaximoPeso,MinimoPeso)
VALUES(1,45,90),
(2,34,89),
(3,34,67),
(4, 105, 75),
(5,40, 55),
(6,30,40);

INSERT INTO preferenciasgeograficas(preferenciaId,prefProv,prefMunicipio)
VALUES(1,'Sevilla','Sevilla'),
(3,'Huelva','Lepe'),
(4,'Cadiz', 'Conil'),
(2, 'Malaga' , ' Ronda'),
(5, 'Granada', 'Motril'),
(6,'Almeria','Almeria'),
(7, 'Huelva', 'Aracena');
