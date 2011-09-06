use BDtp1Grupo1

-- Creacion de las tablas de la base de datos

create table licencia (nroLicencia int not null , fechaObtencion datetime not null, fechaVencimiento datetime not null, observaciones char(30)) 

create table chofer (nroDocumento int not null , fechaNac datetime not null, nomApe char(30) not null, domicilio char(30) not null, telefono int , nroLicencia int not null )

create table viaje (codViaje int not null , fechaHoraPartida datetime , fechaHoraLlegadaEst datetime , nroPatente int , codRecorrido int , realizado bit)

create table conduce (nroDocumento  int not null, codViaje int not null)

create table control (codControl int not null , nroDocumento int not null, codViaje int not null, codTipo int not null, resultadoTest bit not null, fechaControl datetime not null)

create table tipoTest (codTipo int not null, descripcion char(30) not null)

create table contingencia (nroContingencia int not null, codViaje int not null, descripcion char(30) not null)

create table direccion (calle char(30) not null, altura int not null, codCiudad int not null)

create table ciudad ( codCiudad int not null, nombre char(30) not null)

create table recorrido (codRecorrido int not null, nombre char(30) not null, calleOrig char(30) not null, alturaOrig int not null, codCiudadOrig int not null, calleDest char(30) not null, alturaDest int not null, codCiudadDest int not null)

create table ruta (codRuta int not null, cantKm int not null, condicionesCamino char(30) , cantPeajes int , tiempoEstimado int , codRecorrido int not null)
	-- tomamos como que la ruta se puede dar de alta sin tener la cantidad de kilometros, condiciones, cantidad de peajes y tiempo estimado.

create table estado (codEstado int not null, descripcion char(30) not null)

create table vehiculo (nroPatente int not null, modelo char(30) not null, marca char(30) not null, capacidad int not null, fechaAlta datetime not null, codEstado int not null, enUso bit not null, fechaIngresoReparacion datetime)

create table viajeRealizado (codViaje int not null, fechaHoraLlegada datetime not null, codRuta int not null, codRutaRecorrido int not null)

create table participa (codRecorrido int not null, codRuta int not null, nombreEstacion char(30) not null, codClima int not null)

create table estacion (nombreEstacion char(30) not null)

create table clima (codClima int not null, descripcion char(30) not null)


-- Agregado de claves primarias

alter table licencia add primary key (nroLicencia)

alter table chofer add primary key (nroDocumento)

alter table conduce add primary key (nroDocumento , codViaje)
	
alter table control add primary key (codControl)

alter table tipoTest add primary key (codTipo)

alter table contingencia add primary key (nroContingencia , codViaje)

alter table direccion add primary key (calle , altura , codCiudad)

alter table ciudad add primary key (codCiudad)

alter table recorrido add primary key (codRecorrido)

alter table ruta add primary key (codRuta , codRecorrido)

alter table estado add primary key (codEstado)

alter table vehiculo add primary key (nroPatente)

alter table viaje add primary key (codViaje)

alter table viajeRealizado add primary key (codViaje)

alter table participa add primary key (codRecorrido , codRuta , nombreEstacion)

alter table estacion add primary key (nombreEstacion)

alter table clima add primary key (codClima)

-- Agregado de claves foraneas
alter table chofer add foreign key (nroLicencia) references licencia

alter table conduce add foreign key (nroDocumento) references chofer
alter table conduce add foreign key (codViaje) references viaje

alter table control add foreign key (nroDocumento) references chofer
alter table control add foreign key (codViaje) references viaje
alter table control add foreign key (codTipo) references tipoTest

alter table contingencia add foreign key (codViaje) references viaje

alter table direccion add foreign key (codCiudad) references Ciudad

alter table recorrido add foreign key (calleOrig , alturaOrig , codCiudadOrig) references direccion
alter table recorrido add foreign key (calleDest , alturaDest , codCiudadDest) references direccion

alter table ruta add foreign key (codRecorrido) references recorrido

alter table vehiculo add foreign key (codEstado) references estado

alter table viaje add foreign key (nroPatente) references vehiculo
alter table viaje add foreign key (codRecorrido) references recorrido

alter table viajeRealizado add foreign key (codViaje) references viaje
alter table viajeRealizado add foreign key (codRuta , codRutaRecorrido) references ruta

alter table participa add foreign key (codRuta , codRecorrido) references ruta
alter table participa add foreign key (codClima) references clima
alter table participa add foreign key (nombreEstacion) references estacion



