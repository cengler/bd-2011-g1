use BDtp1Grupo1

-- Se insetan 6 licencias
--			     (nroLicencia,fechaObtencion,FechaVencimiento, observaciones)
insert into licencia values (1 , '2007-01-01' , '2012-01-01' , 'Debe usar lentes')
insert into licencia values (2 , '2007-01-01' , '2012-01-01' , '')
insert into licencia values (3 , '2007-01-01' , '2012-01-01' , '')
insert into licencia values (4 , '2007-01-01' , '2012-01-01' , '')
insert into licencia values (5 , '2007-01-01' , '2012-01-01' , '')
insert into licencia values (6 , '2007-01-01' , '2012-01-01' , 'Debe usar lentes')


-- Se insertan 6 choferes asociados uno a cada licencia creada antes
--			   (nroDocumento, fechaNac , NombyAp ,		 direccion, 	telefono , nroLicencia)
insert into chofer values (30450670 , '1985-03-09' , 'Roger Waters' , 'Agustin Alvarez 1234' , 43256781 , 1 )
insert into chofer values (30450671 , '1984-05-30' , 'Armando Estaban Kito' , 'Uruguay 7635' , 41234564 , 2 )
insert into chofer values (30450673 , '1980-09-25' , 'Fredderic Bruselas' , 'Balcarce 765' , 43256787 , 4 )
insert into chofer values (30450674 , '1979-07-15' , 'Brian May' , 'Laprida 4563' , 47875544, 5 )
insert into chofer values (30450675 , '1975-02-10' , 'Roger Taylor' , 'Santa fe 345' , 48384475, 6 )
insert into chofer values (30450672 , '1983-06-12' , 'John Carretera' , 'Cordoba 2345' , 45458875 , 3 )

-- Se insertan datos en la tabla Estado
--			(codEstado, descripcion)
insert into estado values (1 , 'Nuevo')
insert into estado values (2 , 'Excelente')
insert into estado values (3 , 'Muy Bueno')
insert into estado values (4 , 'Bueno')
insert into estado values (5 , 'Regular')
insert into estado values (6 , 'Malo')
insert into estado values (7 , 'Muy Malo')

-- Se insertan datos de Vehiculos
--			(nroPatente, modelo, marca, capacidad, fechaAlta, codEstado , enUso , fechaIngresoReparacion)
insert into vehiculo values (222222 , 'Ka' , 'Ford' ,  4 , '2011-01-15' , 1 , 0 , '2011-09-11')
insert into vehiculo values (333333 , 'MB 1328' , 'Mercedes Benz' ,  80 , '2009-01-15' , 1 , 0 , '2011-06-10')
insert into vehiculo values (555555 , '458' , 'Ferrari' ,  2 , '2011-01-15' , 1 , 1 , null)


-- Se insertan ciudades
--			(codCiudad , nombre)
insert into ciudad values (1, 'Capital Federal')
insert into ciudad values (2, 'Colon - Pcia Entre Rios')
insert into ciudad values (3, 'La Plata')

-- Se insertan direcciones
--			    (codDireccion, calle , altura , codCiudad)
insert into direccion values (1,'Echeverria' , 1234 , 1)
insert into direccion values (2,'Moreno' , 457 , 2)
insert into direccion values (3,'Cabildo' , 600, 1)
insert into direccion values (4,'Juramento' , 750 , 3)


-- Se insertan recorridos
--			(codRecorrido, nombre , direccionOrig, direcctionDest)
insert into recorrido values (1 , 'Capital Federal - Colon ER' , 1, 2 )
insert into recorrido values (2 , 'Colon ER - Capital Federal' , 2, 3 )
insert into recorrido values (3 , 'Buenos Aires - La Plata' , 4, 3 )
insert into recorrido values (4 , 'La Plata - Buenos Aires' , 2, 1 )


-- Se insetan viajes
--			(codViaje , fechaHoraPartida , fechaHoraLlegadaEst, nroPatente , codRecorrido)
insert into viajePlanificado values (1, '2011-10-20 10:00:000' , '2011-10-20 20:00:000' , '555555' , 1 )
insert into viajePlanificado values (2, '2011-05-10 10:00:000' , '2011-05-10 20:00:000' , '555555' , 2 )
insert into viajePlanificado values (3, '2010-05-10 10:00:000' , '2010-05-11 20:00:000' , '555555' , 3 )
insert into viajePlanificado values (4, '2010-05-10 10:00:000' , '2010-05-11 20:00:000' , '555555' , 3 )
insert into viajePlanificado values (5, '2010-05-10 10:00:000' , '2010-05-11 20:00:000' , '555555' , 3 )
insert into viajePlanificado values (6, '2010-05-10 10:00:000' , '2010-05-11 20:00:000' , '555555' , 3 )
insert into viajePlanificado values (7, '2011-09-08 10:00:000' , '2011-09-11 20:00:000' , '222222' , 3 )
insert into viajePlanificado values (8, '2011-09-09 10:00:000' , '2011-09-10 20:00:000' , '222222' , 3 )


-- Se insertan datos en la tabla Conduce
--			(nroDocumento, codViaje)
insert into conduce values (30450670 ,1)
insert into conduce values (30450671 ,2)
insert into conduce values (30450670 ,3)
insert into conduce values (30450670 ,4)
insert into conduce values (30450670 ,5)
insert into conduce values (30450670 ,6)
insert into conduce values (30450671 ,8)
insert into conduce values (30450672 ,2)
insert into conduce values (30450672 ,3)
insert into conduce values (30450672 ,7)


-- Se insertan datos en la tabla ruta
--			(codRuta , cantKM, condicionesCamino, cantPeajes, tiempoEst , codRecorrido)
insert into ruta values (1 , 350 , 'Asfaltado muy bueno' , 2 , 7 , 2)
insert into ruta values (3 , 400 , 'Empedrado' , 0 , 2 , 2)
insert into ruta values (2 , 350 , 'Asfaltado muy bueno' , 2 , 7 , 1)
insert into ruta values (1 , 350 , 'Asfaltado muy bueno' , 2 , 7 , 3)
insert into ruta values (2 , 350 , 'Asfaltado muy bueno' , 2 , 7 , 3)

-- Se insertan los datos de los viajes realizados
--				(codViaje, fechaHoraLLegada, codRuta, codRutaRecorrido)
insert into viajeRealizado values (2 , '2011-05-10 22:00:000' , 1 , 2)
insert into viajeRealizado values (3 , '2011-05-10 22:00:000' , 3, 2)
insert into viajeRealizado values (4 , '2011-05-10 22:00:000' , 3, 2)
insert into viajeRealizado values (5 , '2010-05-11 22:00:000' , 1, 3)
insert into viajeRealizado values (6 , '2010-05-11 22:00:000' , 2, 3)
insert into viajeRealizado values (7 , '2011-09-11 22:00:000' , 2, 3)
insert into viajeRealizado values (8 , '2011-09-11 22:00:000' , 2, 3)



-- Se insertan tipos de test
--			(codTipo , descripcion)
insert into tipoTest values (1 , 'Alcoholemia')
insert into tipoTest values (2 , 'Buen descanso')
insert into tipoTest values (3 , 'Vista')

-- Se insertan contingencias para viajes realizados
--				(nroCont , codViaje, descripcion)
insert into contingencia values (1 , 2 , 'Se pincho una cubierta')
insert into contingencia values (2 , 2 , 'Un pasajero enloquecio')

-- Se insertan controles
--			(codControl, nroDoc, codViaje, codTipo, resultadoTest, fechaControl)
insert into control values (1 , 30450671 , 2 , 2 , 1 , '2011-05-09')
insert into control values (2 , 30450671 , 2 , 3 , 1 , '2011-05-05')
insert into control values (3 , 30450671 , 2 , 1 , 1 , '2011-05-10')

-- Se insertan las estacion
-- 			(nombreEstacion)
insert into estacion values ('Primavera')
insert into estacion values ('Verano')
insert into estacion values ('Otonio')
insert into estacion values ('Invierno')

-- Se insertan climas
--			(codClima, descripcion)
insert into clima values (1 , 'Soleado')
insert into clima values (2 , 'Nieve')
insert into clima values (3 , 'Lluvioso')
insert into clima values (4 , 'Nublado')
insert into clima values (5 , 'Granizo')

-- Se insertan datos en la tabla Participa
--			(codRecorrido, codRuta, nombreEstacion, codClima)
insert into participa values (1 , 2 , 'Primavera' , 1)
insert into participa values (1 , 2 , 'Verano' , 1)
insert into participa values (1 , 2 , 'Otonio' , 4)
insert into participa values (1 , 2 , 'Invierno' , 3)

insert into participa values (2 , 1 , 'Primavera' , 1)
insert into participa values (2 , 1 , 'Verano' , 1)
insert into participa values (2 , 1 , 'Otonio' , 4)
insert into participa values (2 , 1 , 'Invierno' , 3)














