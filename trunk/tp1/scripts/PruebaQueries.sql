use BDtp1Grupo1

-- Muestra los recorridos que tuvieron todas las rutas usadas el anio anterior.
Select * from recorridosConTodasRutasUsadasAnioanterior

-- Muestra los choferes que en los ultimos 6 meses condujeron todos los vehiculos de menos de 2 anios de antiguedad.
Select * from chofer6MVehiculo2A

-- Muestra el promedio por anio de antiguedad de cada vehiculo
select * from promedioEstadoXVehiculo

-- Muestra los recorridos para los cuales se hayan usado todas sus rutas asociadas en el último año
    -- Empezamos seleccionando todos los recorridos
    SELECT recorrido.codRecorrido, recorrido.nombre
    FROM recorrido INNER JOIN ruta r ON r.codRecorrido=recorrido.codRecorrido
    WHERE NOT EXISTS
    -- Tal que no exista una ruta asociada al mismo
    (    SELECT ruta.nroRuta
        FROM ruta
        WHERE ruta.codRecorrido=recorrido.codRecorrido
        AND NOT EXISTS
       -- Tal que no exista un viaje realizado el año pasado con esa ruta y recorrido
        (    SELECT nroRuta,codRecorrido,fechaHoraLlegada
            FROM viajeRealizado vR
            WHERE vR.nroRuta=ruta.nroRuta AND vR.codRutaRecorrido=ruta.codRecorrido
            AND (DATEDIFF(yy, fechaHoraLlegada, GETDATE())=1)
        )
    )
    GROUP BY recorrido.codRecorrido, recorrido.nombre
    -- Pero exista más de una ruta asociada al recorrido(como pide el ejercicio)
    HAVING count(*)>1
