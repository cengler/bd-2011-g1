use BDtp1Grupo1

/* 
Los recorridos para los cuales se usaron todas las rutas posibles registradas para ese recorrido, 
para viajes realizados el año pasado y recorridos asociados a mas de una ruta.
Utiliza las vistas "cantRutasVR" y "cantRutasXRecorrido"

*/
exec ('create view recorridosConTodasRutasUsadasAnioAnterior as 
(select  crraa.codRutaRecorrido as codRecorrido , crxr.nombre as recorrido  from cantRutasXRecorrido crxr join cantRutasRecorridasAnioAnterior crraa
on crxr.recorridoRutas = crraa.codRutaRecorrido where cantRutasRec = rutasRecorridasAnioAnt)')


/*
El promedio de viajes realizados por vehículo por año y el estado en que este se encuentra. Usa la vista "cantViajesXVehiculoXAnio"
*/

exec ('create view promedioEstadoXVehiculo as (select auxQuery.nroPatente, auxQuery.promedioXAnio, estado.descripcion
from (
	-- Este subquery devuelve el promedio de viajes x anio para cada vehiculo
	select auxView.nroPatente, AVG(auxView.viajesXAnio) as promedioXAnio
	from cantViajesXVehiculoXAnio as auxView
	group by auxView.nroPatente
) as auxQuery
-- Agrego la información del estado actual del vehiculo
join vehiculo on auxQuery.nroPatente = vehiculo.nroPatente
join estado on vehiculo.codEstado = estado.codEstado)')







/*
Se crea la vista cantRutasVR devuelve el nombre del recorrido, el codigo y la cantidad de rutas asociadas
*/

exec ('create view cantRutasRecorridasAnioAnterior as (select count(*) as rutasRecorridasAnioAnt , codRutaRecorrido from 
(select distinct r.nroRuta , vr.codRutaRecorrido   from ruta r, viajeRealizado vr 
where (year(GETDATE())-1)= year(fechaHoraLlegada) and r.codRecorrido = vr.codRutaRecorrido and r.nroRuta = vr.nroRuta)
as rutasTransitadasXRec  group by codRUtaRecorrido)')


/*
Se crea la vista cantRutasXRecorrido devuelve el codigo de recorrido y la cantidad de rutas distintas que se utilizaron
en los viajes del año anterior.
*/
exec ('create view cantRutasXRecorrido as 
(select count(*) as cantRutasRec,rec.codRecorrido as RecorridoRutas,rec.nombre from 
recorrido rec join ruta on rec.codRecorrido = ruta.codRecorrido 
group by rec.codRecorrido,rec.nombre having count(*) > 1)')

/*
Se crea la vista cantViajesXVehiculoXAnio que devuelve para cada vehiculo, la cantidad de viajes ya realizados
por cada año
*/
exec ('
CREATE view cantViajesXVehiculoXAnio as 
(select vehiculo.nroPatente, DATEPART(year, vP.fechaHoraPartida) as anio, count(vehiculo.nroPatente) as viajesXAnio
	from viajeRealizado vR join viajePlanificado vP on vR.codViaje = vP.codViaje
	join vehiculo on vP.nroPatente = vehiculo.nroPatente
	group by vehiculo.nroPatente, DATEPART(year, vP.fechaHoraPartida))')
