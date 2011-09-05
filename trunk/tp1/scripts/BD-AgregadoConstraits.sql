use BDtp1Grupo1
-- Agregado de constraints

-- Evita tener licencias con fecha de vencimiento menor a la fecha de obtencion
alter table licencia add constraint fechaVencimientoMayorAFechaObtencion check (fechaVencimiento > fechaObtencion)

-- Restringe que si un vehiculo esta en reparacion no tenga dato en la fecha de ingreso a reparacion y lo contrario para uno que esta en uso.
alter table vehiculo add constraint verificacionEnUso check ((enUso = 1 and fechaIngresoReparacion is null) or (enUso = 0 and fechaIngresoReparacion is not null))

-- Restringe que un recorrido tenga igual direccion de origen y destino
alter table recorrido add constraint direccionesDistintas check (not (calleOrig = calleDest and alturaOrig = alturaDest and codCiudadOrig = codCiudadDest))

/*
-- Restringe que la fecha del control sea posterior a la fecha de partida del viaje.
-- Ver si se puede y como agregar una constraint que referencia 
-- creo que no se pueden crear constraint que hagan referencias a campos de otras tablas
alter table control add constraint verificacionControlAntesdePartir check (fechaControl < (select top(1) viaje.fechahorapartida from viaje where viaje.codviaje = control.codViaje))

-- Los viajes programados deben estar asociados a vehiculos en uso y no en reparacion
alter table viaje add constraint viajePlanConAutoEnUso check (nroPatente )
*/