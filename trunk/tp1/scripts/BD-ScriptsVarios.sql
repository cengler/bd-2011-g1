use BDtp1Grupo1

--Obtento la antiguedad y todos los datos del vehiculo con antiuedad mayor a XXXX
declare @filtroAntiguedad int
-- Setear aca la antiguedad por la cual se quiere filtrar.
set @filtroAntiguedad = 2
select(DATEDIFF(yyyy, fechaAlta , GETDATE())) as Antigueadad, * from vehiculo  where    (DATEDIFF(yyyy, fechaAlta , GETDATE()))>=@filtroAntiguedad 

/* 
Los recorridos para los cuales se usaron todas las rutas posibles registradas para ese recorrido, 
para viajes realizados el año pasado y recorridos asociados a mas de una ruta.
Utiliza las vistas "cantRutasVR" y "cantRutasXRecorrido"

*/
select  crraa.codRutaRecorrido as codRecorrido , crxr.nombre as recorrido  from cantRutasXRecorrido crxr join cantRutasRecorridasAnioAnterior crraa
on crxr.recorridoRutas = crraa.codRutaRecorrido where cantRutasRec = rutasRecorridasAnioAnt


/*
El promedio de viajes realizados por vehículo por año y el estado en que este se encuentra. Usa la vista "cantViajesXVehiculoXAnio"
*/

select auxQuery.nroPatente, auxQuery.promedioXAnio, estado.descripcion
from (
	-- Este subquery devuelve el promedio de viajes x anio para cada vehiculo
	select auxView.nroPatente, AVG(auxView.viajesXAnio) as promedioXAnio
	from cantViajesXVehiculoXAnio as auxView
	group by auxView.nroPatente
) as auxQuery
-- Agrego la información del estado actual del vehiculo
join vehiculo on auxQuery.nroPatente = vehiculo.nroPatente
join estado on vehiculo.codEstado = estado.codEstado

