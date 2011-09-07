use BDtp1Grupo1

--Obtento la antiguedad y todos los datos del vehiculo con antiuedad mayor a XXXX
declare @filtroAntiguedad int
-- Setear aca la antiguedad por la cual se quiere filtrar.
set @filtroAntiguedad = 2
select(DATEDIFF(yyyy, fechaAlta , GETDATE())) as Antigueadad, * from vehiculo  where    (DATEDIFF(yyyy, fechaAlta , GETDATE()))>=@filtroAntiguedad 

/* 
Los recorridos para los cuales se usaron todas las rutas posibles registradas para ese recorrido, 
para viajes realizados el año pasado y recorridos asociados a mas de una ruta.
*/
-- Cantidad de rutas de cada recorrido y el codigo de recorrido
(select count(*) as cantRutasRec,rec.codRecorrido as RecorridoRutas,rec.nombre from recorrido rec join ruta on rec.codRecorrido = ruta.codRecorrido 
group by rec.codRecorrido,rec.nombre having count(*) > 1)


-- Las rutas y recorridos realizados el años pasado sin repetidos
(select count(*) as cantRutasVR  , codRecorrido as RecorridoRT  from 
(select distinct r.codRuta, codRecorrido from viajeRealizado vr,ruta r where (year(GETDATE())-1)= year(fechaHoraLlegada) and 
(vr.codRuta = r.codRuta)) as rutasTransitadasXRec
group by codRecorrido)
