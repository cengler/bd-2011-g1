use BDtp1Grupo1

/*
Se crea la vista cantRutasVR devuelve el nombre del recorrido, el codigo y la cantidad de rutas asociadas
*/

exec ('create view cantRutasRecorridasAnioAnterior as (select count(*) as rutasRecorridasAnioAnt , codRUtaRecorrido from 
(select distinct r.codRuta , vr.codRutaRecorrido   from ruta r, viajeRealizado vr 
where (year(GETDATE())-1)= year(fechaHoraLlegada) and r.codRecorrido = vr.codRutaRecorrido and r.codRuta = vr.codRuta)
as rutasTransitadasXRec  group by codRUtaRecorrido)')


/*
Se crea la vista cantRutasXRecorrido devuelve el codigo de recorrido y la cantidad de rutas distintas que se utilizaron
en los viajes del año anterior.
*/
exec ('create view cantRutasXRecorrido as 
(select count(*) as cantRutasRec,rec.codRecorrido as RecorridoRutas,rec.nombre from recorrido rec join ruta on rec.codRecorrido = ruta.codRecorrido 
group by rec.codRecorrido,rec.nombre having count(*) > 1)')

/*
Se crea la vista cantViajesXVehiculoXAnio que devuelve para cada vehiculo, la cantidad de viajes ya realizados
por cada año
*/
exec ('
CREATE view cantViajesXVehiculoXAnio as 
(select vehiculo.nroPatente, DATEPART(year, viaje.fechaHoraPartida) as anio, count(vehiculo.nroPatente) as viajesXAnio
	from vehiculo join viaje on viaje.nroPatente = vehiculo.nroPatente
	where viaje.realizado=1
	group by vehiculo.nroPatente, DATEPART(year, viaje.fechaHoraPartida))')
