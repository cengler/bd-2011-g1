use BDtp1Grupo1
--Obtento la antiguedad y todos los datos del vehiculo con antiuedad mayor a XXXX
declare @filtroAntiguedad int
-- Setear aca la antiguedad por la cual se quiere filtrar.
set @filtroAntiguedad = 2
select(DATEDIFF(yyyy, fechaAlta , GETDATE())) as Antigueadad, * from vehiculo  where    (DATEDIFF(yyyy, fechaAlta , GETDATE()))>=@filtroAntiguedad 