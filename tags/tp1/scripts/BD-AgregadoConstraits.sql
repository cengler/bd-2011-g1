use BDtp1Grupo1
-- Agregado de constraints

-- Evita tener licencias con fecha de vencimiento menor a la fecha de obtencion
alter table licencia add constraint fechaVencimientoMayorAFechaObtencion check (fechaVencimiento > fechaObtencion)

-- Restringe que si un vehiculo esta en reparacion no tenga dato en la fecha de ingreso a reparacion y lo contrario para uno que esta en uso.
alter table vehiculo add constraint verificacionEnUso check ((enUso = 1 and fechaIngresoReparacion is null) or (enUso = 0 and fechaIngresoReparacion is not null and fechaIngresoReparacion >= fechaAlta))

-- Restringe que un recorrido tenga igual direccion de origen y destino
alter table recorrido add constraint direccionesDistintas check (not (codDirOrigen = codDirDestino))

