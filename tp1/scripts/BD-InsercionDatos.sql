use BDtp1Grupo1
-- Se insetan 6 licencias
insert into gr1_licencia values (1 , '2007-01-01' , '2012-01-01' , 'Debe usar lentes')
insert into gr1_licencia values (2 , '2007-01-01' , '2012-01-01' , '')
insert into gr1_licencia values (3 , '2007-01-01' , '2012-01-01' , '')
insert into gr1_licencia values (4 , '2007-01-01' , '2012-01-01' , '')
insert into gr1_licencia values (5 , '2007-01-01' , '2012-01-01' , '')
insert into gr1_licencia values (6 , '2007-01-01' , '2012-01-01' , 'Debe usar lentes')


-- Se insertan 6 choferes asociados uno a cada licencia creada antes
insert into gr1_chofer values (30450670 , '1985-03-09' , 'Roger Waters' , 'Agustin Alvarez 1234' , 43256781 , 1 )
insert into gr1_chofer values (30450671 , '1984-05-30' , 'Armando Estaban Kito' , 'Uruguay 7635' , 41234564 , 2 )
insert into gr1_chofer values (30450673 , '1980-09-25' , 'Fredderic Bruselas' , 'Balcarce 765' , 43256787 , 4 )
insert into gr1_chofer values (30450674 , '1979-07-15' , 'Brian May' , 'Laprida 4563' , 47875544, 5 )
insert into gr1_chofer values (30450675 , '1975-02-10' , 'Roger Taylor' , 'Santa fe 345' , 48384475, 6 )
insert into gr1_chofer values (30450672 , '1983-06-12' , 'John Deacon' , 'Cordoba 2345' , 45458875 , 3 )


-- Se insertan datos en la tabla Estado
insert into gr1_estado values (1 , 'Nuevo')
insert into gr1_estado values (2 , 'Excelente')
insert into gr1_estado values (3 , 'Muy Bueno')
insert into gr1_estado values (4 , 'Bueno')
insert into gr1_estado values (5 , 'Regular')
insert into gr1_estado values (6 , 'Malo')
insert into gr1_estado values (7 , 'Muy Malo')

-- Se insertan datos de Vehiculos

insert into gr1_vehiculo values (333333 , 'Mercedes Benz' , 'MB 1328' ,  80 , '2009-01-15' , 1 , 0 , '2011-06-10')
insert into gr1_vehiculo values (555555 , 'Mercedes Benz' , 'MB 1328' ,  80 , '2011-01-15' , 1 , 1 , null)

-- Se insertan ciudades
insert into gr1_ciudad values (1, 'Capital Federal')
insert into gr1_ciudad values (2, 'Colon - Pcia Entre Rios')

-- Se insertan direcciones
insert into gr1_direccion values ('Echeverria' , 1234 , 1)
insert into gr1_direccion values ('Moreno' , 457 , 2)

-- Se insertan recorridos
insert into gr1_recorrido values (1 , 'Capital Federal - Colon ER' , 'Echeverria' , 1234 , 1 , 'Moreno' , 457 , 2)
insert into gr1_recorrido values (2 , 'Colon ER - Capital Federal' , 'Moreno' , 457 , 2 , 'Echeverria' , 1234 , 1 )

-- Se insetan viajes
insert into gr1_viaje values (1, '2011-10-20 10:00:000' , '2011-10-20 20:00:000' , '555555' , 1 , 0)
insert into gr1_viaje values (2, '2011-05-10 10:00:000' , '2011-05-10 20:00:000' , '555555' , 2 , 1)


-- Se insertan datos en la tabla Conduce
insert into gr1_conduce values (30450670 ,1)
insert into gr1_conduce values (30450671 ,2)

-- Se insertan datos en la tabla ruta
insert into gr1_ruta values (1 , 350 , 'Asfaltado muy bueno' , 2 , 7 , 2)
insert into gr1_ruta values (2 , 350 , 'Asfaltado muy bueno' , 2 , 7 , 1)

-- Se insertan los datos de los viajes realizados
insert into gr1_viajeRealizado values (2 , '2011-05-10 22:00:000' , 1 , 2)

-- Se insertan tipos de test
insert into gr1_tipoTest values (1 , 'Alcoholemia')
insert into gr1_tipoTest values (2 , 'Buen descanso')
insert into gr1_tipoTest values (3 , 'Vista')

-- Se insertan contingencias para viajes realizados
insert into gr1_contingencia values (1 , 2 , 'Se pincho una cubierta')
insert into gr1_contingencia values (2 , 2 , 'Un pasajero enloquecio')

-- Se insertan controles
insert into gr1_control values (1 , 30450671 , 2 , 2 , 1 , '2011-05-09')
insert into gr1_control values (2 , 30450671 , 2 , 3 , 1 , '2011-05-05')
insert into gr1_control values (3 , 30450671 , 2 , 1 , 1 , '2011-05-10')

-- Se insertan las estacion
insert into gr1_estacion values ('Primavera')
insert into gr1_estacion values ('Verano')
insert into gr1_estacion values ('Otonio')
insert into gr1_estacion values ('Invierno')

-- Se insertan climas
insert into gr1_clima values (1 , 'Soleado')
insert into gr1_clima values (2 , 'Nieve')
insert into gr1_clima values (3 , 'Lluvioso')
insert into gr1_clima values (4 , 'Nublado')
insert into gr1_clima values (5 , 'Granizo')

-- Se insertan datos en la tabla Participa
insert into gr1_participa values (1 , 2 , 'Primavera' , 1)
insert into gr1_participa values (1 , 2 , 'Verano' , 1)
insert into gr1_participa values (1 , 2 , 'Otonio' , 4)
insert into gr1_participa values (1 , 2 , 'Invierno' , 3)

insert into gr1_participa values (2 , 1 , 'Primavera' , 1)
insert into gr1_participa values (2 , 1 , 'Verano' , 1)
insert into gr1_participa values (2 , 1 , 'Otonio' , 4)
insert into gr1_participa values (2 , 1 , 'Invierno' , 3)













