use BDtp1Grupo1

-- Creacion de las tablas de la base de datos

create table gr1_licencia (nroLicencia int not null , fechaObtencion datetime not null, fechaVencimiento datetime not null, observaciones char(30)) 

create table gr1_chofer (nroDocumento int not null , fechaNac datetime not null, nomApe char(30) not null, domicilio char(30) not null, telefono int , nroLicencia int not null )

create table gr1_viaje (codViaje int not null , fechaHoraPartida datetime , fechaHoraLlegadaEst datetime , nroPatente int , codRecorrido int , realizado bit)

create table gr1_conduce (nroDocumento  int not null, codViaje int not null)

create table gr1_control (codControl int not null , nroDocumento int not null, codViaje int not null, codTipo int not null, resultadoTest bit not null, fechaControl datetime not null)

create table gr1_tipoTest (codTipo int not null, descripcion char(30) not null)

create table gr1_contingencia (codContingencia int not null, codViaje int not null, descripcion char(30) not null)

create table gr1_direccion (calle char(30) not null, altura int not null, codCiudad int not null)

create table gr1_ciudad ( codCiudad int not null, nombre char(30) not null)

create table gr1_recorrido (codRecorrido int not null, nombre char(30) not null, calleOrig char(30) not null, alturaOrig int not null, codCiudadOrig int not null, calleDest char(30) not null, alturaDest int not null, codCiudadDest int not null)

create table gr1_ruta (codRuta int not null, cantKm int not null, condicionesCamino char(30) , cantPeajes int , tiempoEstimado int , codRecorrido int not null)
	-- tomamos como que la ruta se puede dar de alta sin tener la cantidad de kilometros, condiciones, cantidad de peajes y tiempo estimado.

create table gr1_estado (codEstado int not null, descripcion char(30) not null)

create table gr1_vehiculo (nroPatente int not null, modelo char(30) not null, marca char(30) not null, capacidad int not null, fechaAlta datetime not null, codEstado int not null, enUso bit not null, fechaIngresoReparacion datetime)

create table gr1_viajeRealizado (codViaje int not null, fechaHoraLlegada datetime not null, codRuta int not null, codRutaRecorrido int not null)

create table gr1_participa (codRecorrido int not null, codRuta int not null, nombreEstacion char(30) not null, codClima int not null)

create table gr1_estacion (nombreEstacion char(30) not null)

create table gr1_clima (codClima int not null, descripcion char(30) not null)


-- Agregado de claves primarias

alter table gr1_licencia add primary key (nroLicencia)

alter table gr1_chofer add primary key (nroDocumento)

alter table gr1_conduce add primary key (nroDocumento , codViaje)
	
alter table gr1_control add primary key (codControl)

alter table gr1_tipoTest add primary key (codTipo)

alter table gr1_contingencia add primary key (codContingencia , codViaje)

alter table gr1_direccion add primary key (calle , altura , codCiudad)

alter table gr1_ciudad add primary key (codCiudad)

alter table gr1_recorrido add primary key (codRecorrido)

alter table gr1_ruta add primary key (codRuta , codRecorrido)

alter table gr1_estado add primary key (codEstado)

alter table gr1_vehiculo add primary key (nroPatente)

alter table gr1_viaje add primary key (codViaje)

alter table gr1_viajeRealizado add primary key (codViaje)

alter table gr1_participa add primary key (codRecorrido , codRuta , nombreEstacion)

alter table gr1_estacion add primary key (nombreEstacion)

alter table gr1_clima add primary key (codClima)

-- Agregado de claves foraneas
alter table gr1_chofer add foreign key (nroLicencia) references gr1_licencia

alter table gr1_conduce add foreign key (nroDocumento) references gr1_chofer
alter table gr1_conduce add foreign key (codViaje) references gr1_viaje

alter table gr1_control add foreign key (nroDocumento) references gr1_chofer
alter table gr1_control add foreign key (codViaje) references gr1_viaje
alter table gr1_control add foreign key (codTipo) references gr1_tipoTest

alter table gr1_contingencia add foreign key (codViaje) references gr1_viaje

alter table gr1_direccion add foreign key (codCiudad) references gr1_Ciudad

alter table gr1_recorrido add foreign key (calleOrig , alturaOrig , codCiudadOrig) references gr1_direccion
alter table gr1_recorrido add foreign key (calleDest , alturaDest , codCiudadDest) references gr1_direccion

alter table gr1_ruta add foreign key (codRecorrido) references gr1_recorrido

alter table gr1_vehiculo add foreign key (codEstado) references gr1_estado

alter table gr1_viaje add foreign key (nroPatente) references gr1_vehiculo
alter table gr1_viaje add foreign key (codRecorrido) references gr1_recorrido

alter table gr1_viajeRealizado add foreign key (codViaje) references gr1_viaje
alter table gr1_viajeRealizado add foreign key (codRuta , codRutaRecorrido) references gr1_ruta

alter table gr1_participa add foreign key (codRuta , codRecorrido) references gr1_ruta
alter table gr1_participa add foreign key (codClima) references gr1_clima
alter table gr1_participa add foreign key (nombreEstacion) references gr1_estacion



