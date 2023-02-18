
---===============================================
---GENERAR LA BASE DE DATOS
---===============================================
USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='PROYECTOS' ) )
BEGIN
	CREATE DATABASE PROYECTOS;
END;
GO

USE PROYECTOS;
GO

-- ======================================================
-- ELIMINACIÓN DE TABLAS SI EXISTEN
-- ======================================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='CLIENTE' and xtype = 'u') )

	DROP TABLE dbo.CLIENTE;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[UBICACION]' and xtype = 'u') )

	DROP TABLE dbo.[UBICACION];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[PROYECTO]' and xtype = 'u') )

	DROP TABLE dbo.[PROYECTO];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[COMPONENTE]' and xtype = 'u') )

	DROP TABLE dbo.[COMPONENTE];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[ENTREGABLE]' and xtype = 'u') )

	DROP TABLE dbo.[ENTREGABLE];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[PARTIDA]' and xtype = 'u') )

	DROP TABLE dbo.[PARTIDA];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[EQUIPO]' and xtype = 'u') )

	DROP TABLE dbo.[EQUIPO];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[PARTE_EQUIPOS]' and xtype = 'u') )

	DROP TABLE dbo.[PARTE_EQUIPOS];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[Detalle_Parte]' and xtype = 'u') )

	DROP TABLE dbo.[Detalle_Parte];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[MATERIALES]' and xtype = 'u') )

	DROP TABLE dbo.[MATERIALES];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[NOTA_ALMACEN]' and xtype = 'u') )

	DROP TABLE dbo.[NOTA_ALMACEN];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[Detalle_Almacen]' and xtype = 'u') )

	DROP TABLE dbo.[Detalle_Almacen];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[PERSONAL]' and xtype = 'u') )

	DROP TABLE dbo.[PERSONAL];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[TAREO_MO]' and xtype = 'u') )

	DROP TABLE dbo.[TAREO_MO];
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='[Detalle_Tareo]' and xtype = 'u') )

	DROP TABLE dbo.[Detalle_Tareo];
GO

---===============================================
---GENERAR TABLAS GRUPO PROYECTO
--- Se corrige int por bigint en RUC
--- Se reordeno ubicacion de algunas columnas
---===============================================

CREATE TABLE [CLIENTE]
( 
	[Id_Cliente]         integer  NOT NULL ,

	[Nombre_Empresa]     varchar(200)  NULL ,
	[N_Contacto]         varchar(50)  NULL ,
	[Tel_Contacto]       varchar(20)  NULL ,
	[RUC]                bigint  NULL
)
go

CREATE TABLE [UBICACION]
( 
	[UBIGEO]             integer  NOT NULL,

	[DIRECCION]          varchar(200)  NULL ,
	[REGION]             varchar(120)  NULL ,
	[PROVINCIA]          varchar(120)  NULL ,
	[DISTRITO]           varchar(120)  NULL
)
go

CREATE TABLE [PROYECTO]
( 
	[Id_Proyecto]        varchar(120)  NOT NULL ,
	[Id_Cliente]         integer  NOT NULL ,
	[UBIGEO]             integer  NOT NULL ,
	
	[Nombre]             varchar(200)  NULL ,
	[Monto_Obra]         varchar(20)  NULL 
)
go

---===============================================
---GENERAR TABLAS GRUPO PRESUPUESTO
--- Se eliman FK que no necesito
--- [Monto_Componente] debe llenarse con una consulta
--- de actualizacion de [Monto] 
--- [Monto] debe llenarse con una consulta de actualizacion
--- de [Costo_Parcial]
---===============================================

CREATE TABLE [COMPONENTE]
( 
	[Id_Componente]      varchar(20)  NOT NULL ,
	[Id_Proyecto]        varchar(120)  NOT NULL ,
	
	[Descripcion_Componente] varchar(120)  NULL ,
	[Monto_Componente]   float  NULL 
)
go

CREATE TABLE [ENTREGABLE]
( 
	[Id_Entregable]      varchar(20)  NOT NULL ,
	[Id_Componente]      varchar(20)  NOT NULL ,
	
	[Descripcion_Entregable] varchar(160)  NULL ,
	[Monto]              float  NULL 
)
go

CREATE TABLE [PARTIDA]
( 
	[Id_Partida]         varchar(20)  NOT NULL ,
	[Id_Entregable]      varchar(20)  NOT NULL ,
	
	[Descripcion_Partida] varchar(160)  NULL ,
	[Metrado]            float  NULL ,
	[Und]                char(5)  NULL ,
	[P.U.]               float  NULL ,
	[Costo_Parcial]      AS   [Metrado]*[P.U.]
)
go

---===============================================
---GENERAR TABLAS GRUPO EQUIPOS
---Se corrigio tipo int a float en [Costo]
--- Se define [Cantidad]=[Fin]-[Inicio]
---===============================================

CREATE TABLE [EQUIPO]
( 
	[Id_Equipo]          varchar(20)  NOT NULL ,

	[Familia]            varchar(20)  NULL ,
	[Modelo]             varchar(20)  NULL ,
	[Registro_Placa]     varchar(20)  NULL ,
	[Costo]              float  NULL ,
	[Unidad]             varchar(5)  NULL 
)
go

CREATE TABLE [PARTE_EQUIPOS]
( 
	[Id_Parte]           integer  NOT NULL ,
	[Id_Equipo]          varchar(20)  NOT NULL ,

	[Fecha]              datetime  NULL ,
	[Nro_doc]            varchar(20)  NULL ,
)
go

CREATE TABLE [Detalle_Parte]
( 
	[Id_Parte]           integer  NOT NULL ,
	[Id_Equipo]          varchar(20)  NOT NULL ,

	[Inicio]             int  NULL ,
	[Fin]                int  NULL ,
	[Cantidad]           AS [Fin]-[Inicio],
	[Und]                char(5)  NULL ,
	[Trabajo]            varchar(120)  NULL ,
)
go

---===============================================
---GENERAR TABLAS GRUPO ALMACEN
---Se actualizo tipo de dato [Stock]  float
---[Stock] deberia actualizarse con una consulta de los consumos
---===============================================

CREATE TABLE [MATERIALES]
( 
	[Id_Material]        varchar(20)  NOT NULL ,

	[Descripcion]        varchar(20)  NULL ,
	[Und]                char(5)  NULL ,
	[Stock]              float  NULL ,
	[Almacen]            varchar(20)  NULL ,
	[PU]                 float  NULL 
)
go

CREATE TABLE [NOTA_ALMACEN]
( 
	[Id_Nota]            varchar(20)  NOT NULL ,
	[Id_Partida]         varchar(20)  NOT NULL ,

	[Fecha]              datetime  NULL ,
	[Nro_Doc]            varchar(20)  NULL ,
)
go

CREATE TABLE [Detalle_Almacen]
( 
	[Id_Nota]            varchar(20)  NOT NULL ,
	[Id_Material]        varchar(20)  NOT NULL ,

	[Cantidad]           float  NULL ,

)
go

---===============================================
---GENERAR TABLAS GRUPO PERSONAL
---Se actualizo tamaño del varchar(120)
---[HH] = [Ingreso]-[Salida], ademas solo deberia ser
---horas normales, si HH>8.5 deberia actualizar HE con
---la diferencia  >>> esto falta
---===============================================

CREATE TABLE [PERSONAL]
( 
	[Id_Personal]        varchar(20)  NOT NULL ,

	[Nombre1]            varchar(120)  NULL ,
	[Nombre2]            varchar(120)  NULL ,
	[Apellido_P]         varchar(120)  NULL ,
	[Apeelido_M]         varchar(120)  NULL ,
	[Categoria]          varchar(20)  NULL ,
	[Nro_Orden]          int  NULL ,
	[DNI]                int  NULL ,
	[Salario]            float  NULL 
)
go


CREATE TABLE [TAREO_MO]
( 
	[Id_Tareo]           varchar(20)  NOT NULL ,
	[Id_Entregable]      varchar(20)  NOT NULL ,

	[Fecha]              datetime  NULL ,
	[Nro_Docummento]     varchar(20)  NULL 
)
go

CREATE TABLE [Detalle_Tareo]
( 
	[Id_Tareo]           varchar(20)  NOT NULL ,
	[Id_Personal]        varchar(20)  NOT NULL,

	[Ingreso]            datetime  NULL ,
	[Salida]             datetime  NULL ,
	[HH]                 AS [Ingreso]-[Salida],
	[HE]                 float  NULL ,
 
)
go
