use BDtp1Grupo1


/*
	Viajes planificados y realizados y patente del vehiculo que realizó el viaje
*/

exec ('create view patenteXviajesRealizados as (select vr.codViaje,vr.fechaHoraLlegada, vp.nroPatente as patente 
from viajePlanificado vp inner join viajeRealizado vr on vp.codViaje = vr.codviaje)')

/*
	Todos los vehiculos usados por cada chofer en los ultimos 6 meses.
*/

exec ('create view viajesUltimos6Meses as
select * from patenteXviajesRealizados where dateadd(month, 6, fechaHoraLlegada) > getdate() ')

/*
	Creamos una vista que devuelve el numero de patente y la antiguedad de los vehiculos
*/
exec ('create view antiguedadXVehiculo as select nroPatente , (DATEDIFF(yy, fechaAlta, GETDATE()) -
CASE WHEN MONTH(fechaAlta) > MONTH(GETDATE()) OR (MONTH(fechaAlta) =
MONTH(GETDATE()) AND DAY(fechaAlta) > DAY(GETDATE()))
THEN 1 ELSE 0 END) as antiguedad from vehiculo')

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
Se crea la vista cantViajesXVehiculo que devuelve para cada vehiculo, la cantidad de viajes ya realizados
*/
exec ('
CREATE view cantViajesXVehiculo as 
(select nroPatente, sum(viaje)as cantidad from
	(select vehiculo.nroPatente, (case when( vR.codViaje is null )then 0 else 1 end) as viaje
		from viajeRealizado vR join viajePlanificado vP on vR.codViaje = vP.codViaje
		right join vehiculo on vP.nroPatente = vehiculo.nroPatente
	) as auxQuery
group by nroPatente)')



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
	select auxView.nroPatente, (sum(cast(auxView.cantidad as money))/aV.antiguedad) as promedioXAnio
	from cantViajesXVehiculo as auxView
	inner join antiguedadXVehiculo aV on auxView.nroPatente=aV.nroPatente
	group by auxView.nroPatente, aV.antiguedad
) as auxQuery
-- Agrego la información del estado actual del vehiculo
join vehiculo on auxQuery.nroPatente = vehiculo.nroPatente
join estado on vehiculo.codEstado = estado.codEstado)
')

/*
	Lista los choferes y cantidad de vehiculos distintos que manejó cada chofer en los ultimos 6 meses.
*/
exec ('create view viajesChoferesUltimos6Meses as
select nroDocumento, nomApe, count(*) as cantVehiculos from
	(	select distinct c.nroDocumento, c.nomApe, vp.nroPatente
		from chofer c join conduce co on co.nroDocumento=c.nroDocumento join viajePlanificado vp on vp.codViaje=co.codViaje 
		where exists (select 1 from viajesUltimos6Meses v6m where v6m.codViaje=vp.codViaje)
	) as auxQuery
group by nroDocumento, nomApe')

/*
	Los choferes que han utilizado todos los vehículos de menos de dos años de antigüedad, en viajes del último semestre.
*/

exec ('CREATE view chofer6MVehiculo2A as
select v.nroDocumento, v.nomApe from viajesChoferesUltimos6Meses v where exists
(select 1 from antiguedadXVehiculo where antiguedadXVehiculo.antiguedad<2 having count(*)=v.cantVehiculos)')