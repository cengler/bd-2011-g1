use BDtp1Grupo1
-- Triggers
/*
	Impide asociar un vehiculo en reparacion a un nuevo viaje planificado.

*/

exec ('CREATE TRIGGER nuevoViaje
ON viajePlanificado
FOR INSERT
AS
/* Chequeo que enUso del vehiculo asociado al viaje sea distinto a 0, para que sea una insercion valida. */
DECLARE @enUso bit
SELECT @enUso = v.enUso
FROM vehiculo v INNER JOIN viajePlanificado vp ON v.nroPatente = vp.nroPatente
IF @enUso = 0 
BEGIN
   RAISERROR (''No se puede insertar un viaje planificado asociado a un vehiculo en reparacion.'', 16, 1)
   ROLLBACK TRANSACTION
END')

/*
	Impide modificar un viaje si el mismo tiene asociado un viaje realizado.

*/

exec ('CREATE TRIGGER actualizarViaje
ON viajePlanificado
FOR update
AS
/* Chequeo que enUso del vehiculo asociado al viaje sea distinto a 0, para que sea una insercion valida. */

if exists (select * from viajeRealizado vr inner join viajePlanificado vp on vr.codViaje = vp.codViaje)
BEGIN
   RAISERROR (''No se puede modificar el viaje realizado.'', 16, 1)
   ROLLBACK TRANSACTION
END')



