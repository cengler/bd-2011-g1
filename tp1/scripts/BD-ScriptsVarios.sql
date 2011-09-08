use BDtp1Grupo1

--Obtento la antiguedad y todos los datos del vehiculo con antiuedad mayor a XXXX
declare @filtroAntiguedad int
-- Setear aca la antiguedad por la cual se quiere filtrar.
set @filtroAntiguedad = 2
select(DATEDIFF(yyyy, fechaAlta , GETDATE())) as Antigueadad, * from vehiculo  where    (DATEDIFF(yyyy, fechaAlta , GETDATE()))>=@filtroAntiguedad 

/* 
Los recorridos para los cuales se usaron todas las rutas posibles registradas para ese recorrido, 
para viajes realizados el a�o pasado y recorridos asociados a mas de una ruta.
Utiliza las vistas "cantRutasVR" y "cantRutasXRecorrido"

*/
select recorridoRutas,nombre from cantRutasXRecorrido join cantrutasVR on cantRutasXRecorrido.recorridorutas = cantRutasVR.recorridoRT