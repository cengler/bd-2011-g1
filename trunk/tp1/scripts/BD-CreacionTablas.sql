use BDtp1Grupo1

-- Creacion de las tablas de la base de datos

create table licencia (nroLicencia int not null primary key, fechaObtencion datetime not null, fechaVencimiento datetime not null, observaciones char(30)) 

create table chofer (nroDocumento int not null primary key , fechaNac datetime not null, nomApe char(30) not null, domicilio char(30) not null, telefono int , nroLicencia int not null foreign key references licencia)

create table viaje (codViaje int not null primary key, fechaHoraPartida datetime , fechaHoraLlegadaEst datetime , nroPatente int , codRecorrido int , realizado bit)

create table conduce (nroDocumento  int not null, codViaje int not null)

alter table conduce add primary key (nroDocumento,codViaje)
alter table conduce add foreign key (nroDocumento) references chofer
alter table conduce add foreign key (codViaje) references viaje

create table control (codControl int , nroDocumento int ,codViaje int , codTipo int , resultadoTest bit , fechaControl datetime)

create table tipoTest (codTipo int , descripcion char(30))

create table contingencia (codContingencia int , codViaje int , descripcion char(30))

create table direccion (calle char(30) , altura int , codCiudad int)

create table ciudad ( codCiudad int , nombre char(30))

create table recorrido (codRecorrido int , nombre char(30) , calleOrig char(30) , alturaOrig int , codCiudadOrig int , calleDest char(30) , alturaDest int , codCiudadDest int)

create table ruta (codRuta int, cantKm int , condicionesCamino char(30) , cantPeajes int , tiempoEstimado int , codRecorrido int)

create table estado (codEstado int , descripcion char(30))

create table vehiculo (nroPatente int , modelo char(30) , marca char(30) , capacidad int , fechaAlta datetime , codEstado int , enUso bit , fechaIngresoReparacion datetime)

create table viajeRealizado (codViaje int , fechaHoraLlegada datetime , codRuta int , codRutaRecorrido int)

create table participa (codRecorrido int , codRuta int , nombreEstacion char(30), codClima int)

create table estacion (nombreEstacion char(30))

create table clima (codClima int , descripcion char(30))


