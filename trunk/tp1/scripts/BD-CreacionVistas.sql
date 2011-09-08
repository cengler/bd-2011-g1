use BDtp1Grupo1

/*
Se crea la vista cantRutasVR devuelve el nombre del recorrido, el codigo y la cantidad de rutas asociadas
*/

exec ('create view cantRutasVR as (select count(*) as cantRutasVR  , codRecorrido as RecorridoRT  from 
(select distinct r.codRuta, codRecorrido from viajeRealizado vr,ruta r where (year(GETDATE())-1)= year(fechaHoraLlegada) and 
(vr.codRuta = r.codRuta)) as rutasTransitadasXRec
group by codRecorrido)')



/*
Se crea la vista cantRutasXRecorrido devuelve el codigo de recorrido y la cantidad de rutas distintas que se utilizaron
en los viajes del año anterior.
*/
exec ('create view cantRutasXRecorrido as 
(select count(*) as cantRutasRec,rec.codRecorrido as RecorridoRutas,rec.nombre from recorrido rec join ruta on rec.codRecorrido = ruta.codRecorrido 
group by rec.codRecorrido,rec.nombre having count(*) > 1)')

