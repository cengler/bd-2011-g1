use BDtp1Grupo1

-- Muestra los recorridos que tuvieron todas las rutas usadas el anio anterior.
Select * from recorridosConTodasRutasUsadasAnioanterior

-- Muestra los choferes que en los ultimos 6 meses condujeron todos los vehiculos de menos de 2 anios de antiguedad.
Select * from chofer6MVehiculo2A

-- Muestra el promedio por anio de antiguedad de cada vehiculo
select * from promedioEstadoXVehiculo

-- Muestra los recorridos para los cuales se hayan usado todas sus rutas asociadas en el �ltimo a�o
select recorrido.codRecorrido, recorrido.nombre
from recorrido
where not exists
(	select ruta.nroRuta
	from ruta
	where not exists
	(	select nroRuta,codRecorrido,fechaHoraLlegada
		from viajeRealizado vR inner join viajePlanificado vP
		on vR.codViaje=vP.codViaje
		where vR.nroRuta=ruta.nroRuta and vP.codRecorrido=recorrido.codRecorrido
		--and (2010 = year(vR.fechaHoraLlegada))
		--and (year(GETDATE()) - year(fechaHoraLlegada))<=1
		and (DATEDIFF(yy, fechaHoraLlegada, GETDATE())<=1)
	)
)
