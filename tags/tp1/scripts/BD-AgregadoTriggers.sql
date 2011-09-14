use BDtp1Grupo1
-- Triggers
/*
	Impide asociar un vehiculo en reparacion a un nuevo viaje planificado.
*/

exec ('CREATE TRIGGER nuevoViaje
ON viajePlanificado
FOR INSERT
AS
/* Chequeamos que enUso del vehiculo asociado al viaje sea distinto a 0, para que sea una insercion valida. */
DECLARE @enUso bit
SELECT @enUso = v.enUso
FROM vehiculo v INNER JOIN inserted vp ON v.nroPatente = vp.nroPatente
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
/* Chequeamos si existe un viaje realizado para el viaje planificado. Si es así, no permitimos la actualización.*/

if exists (select * from viajeRealizado vr inner join inserted vp on vr.codViaje = vp.codViaje)
BEGIN
   RAISERROR (''No se puede modificar el viaje realizado.'', 16, 1)
   ROLLBACK TRANSACTION
END')

/*
	Impide poner un auto en reparacion si tiene asociado un viaje planificado que todavía no se realizó
*/
exec ('CREATE TRIGGER actualizarVehiculo
ON vehiculo
FOR update
AS
/* Chequeamos si el vehiculo tiene un viaje planificado asociado y no un viaje realizado. Si es así, no permitimos la actualizacion.*/
if	exists (select * from inserted v where enUso=0 and
		exists(	select * from viajePlanificado vp 
				where vp.nroPatente = v.nroPatente and 
				not
					exists(select * from viajeRealizado vr where vr.codViaje=vp.codViaje)
				)
	)
BEGIN
   RAISERROR (''No se puede configurar un vehiculo como en reparacion que está asignado a un viaje planificado.'', 16, 1)
   ROLLBACK TRANSACTION
END')
