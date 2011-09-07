use BDtp1Grupo1

create view cantRutasVR as (select count(*) as cantRutasVR  , codRecorrido as RecorridoRT  from 
(select distinct r.codRuta, codRecorrido from viajeRealizado vr,ruta r where (year(GETDATE())-1)= year(fechaHoraLlegada) and 
(vr.codRuta = r.codRuta)) as rutasTransitadasXRec
group by codRecorrido)


create view cantRutasXRecorrido as 
(select count(*) as cantRutasRec,rec.codRecorrido as RecorridoRutas,rec.nombre from recorrido rec join ruta on rec.codRecorrido = ruta.codRecorrido 
group by rec.codRecorrido,rec.nombre having count(*) > 1)