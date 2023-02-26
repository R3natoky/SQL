
---===============================================
---GENERAR LA BASE DE DATOS
---===============================================
USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='PROYECTOS FINAL' ) )
BEGIN
	CREATE DATABASE [PROYECTOS FINAL];
END;
GO

USE [PROYECTOS FINAL];
GO

-- ======================================================
-- ELIMINACIÓN DE TABLAS SI EXISTEN
-- ======================================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='CLIENTE' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.CLIENTE
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='UBICACION' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.UBICACION;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PROYECTO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PROYECTO;
END
GO
---========================================
---BORRAR TABLAS EXISTENTES EN CASCADA
---EMPEZANDO DE ABAJO
---========================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PARTIDA' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PARTIDA;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='ENTREGABLE' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.ENTREGABLE;
END

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='COMPONENTE' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.COMPONENTE;
END
GO

---========================================
---BORRAR TABLAS EXISTENTES EN CASCADA
---EMPEZANDO DE ABAJO
---========================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='Detalle_Parte' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.Detalle_Parte;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='EQUIPO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.EQUIPO;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PARTE_EQUIPOS' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PARTE_EQUIPOS;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='MATERIALES' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.MATERIALES;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='NOTA_ALMACEN' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.NOTA_ALMACEN;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='Detalle_Almacen' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.Detalle_Almacen;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PERSONAL' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PERSONAL;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='TAREO_MO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.TAREO_MO;
END
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='Detalle_Tareo' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.Detalle_Tareo;
END
GO

---===============================================
---GENERAR TABLAS GRUPO PROYECTO
---===============================================

CREATE TABLE [CLIENTE]
( 
	[Id_Cliente]         integer NOT NULL ,

	[RUC]                bigint  NULL,
	[Nombre_Empresa]     varchar(MAX)  NULL ,
	[N_Contacto]         varchar(MAX)  NULL ,
	[Tel_Contacto]       varchar(20)  NULL 

)
go

CREATE TABLE [UBIGEO]
( 
	[ID_UBIGEO]             integer  NOT NULL,

	[REGION]             varchar(MAX)  NULL ,
	[PROVINCIA]          varchar(MAX)  NULL ,
	[DISTRITO]           varchar(MAX)  NULL
)
go

CREATE TABLE [PROYECTO]
( 
	[Id_Proyecto]        varchar(20)	NOT NULL ,
	[Id_Cliente]         integer	NOT NULL ,
	[UBIGEO]             integer		NOT NULL ,
	
	[Nombre]				varchar(MAX)	NULL ,
	[Direccion_Proyecto]	varchar(MAX)	NULL ,
	[Monto_Presupuestado]   float			NULL ,
	[Monto_Costo_Real]		float			NULL ,
	[Estado]				varchar(MAX)	NULL ,
	[Fecha_Estado]			date			NULL ,
	[Fecha_Incio]			date			NULL ,
	[Fecha_Finalizado]		date			NULL 
)
go

---===============================================
---GENERAR TABLAS GRUPO PRESUPUESTO
---===============================================

CREATE TABLE [COMPONENTE]
( 
	[Id_Componente]      varchar(20)		NOT NULL ,
	[Id_Proyecto]        varchar(20)	NOT NULL ,
	
	[Cod_Componente]			varchar(MAX)	NULL,
	[Descripcion_Componente]	varchar(MAX)	NULL ,
	[Monto_Componente]			float		NULL 
)
go

CREATE TABLE [ENTREGABLE]
( 
	[Id_Entregable]      varchar(20)	NOT NULL ,
	[Id_Componente]      varchar(20)	NOT NULL ,
	
	[Cod_Entregable]			varchar(MAX)	NULL,
	[Descripcion_Entregable]	varchar(MAX)  NULL ,
	[Monto_Entregable]          float  NULL 
)
go

CREATE TABLE [PARTIDA]
( 
	[Id_Partida]         varchar(20)		NOT NULL ,
	[Id_Entregable]      varchar(20)		NOT NULL ,
	
	[Cod_Partida]			varchar(MAX)	NULL,
	[Descripcion_Partida]	varchar(MAX)	NULL ,
	[Metrado]				float			NULL ,
	[Und]					char(5)			NULL ,
	[PU]					float			NULL ,
	[Costo_Parcial]			AS   [Metrado]*[PU],
	[Estado_Partida]		varchar(MAX)	NULL,
	[Fecha_Estado_Partida]  date			NULL

)
go

---===============================================
---GENERAR TABLAS GRUPO EQUIPOS

---===============================================

CREATE TABLE [EQUIPO]
( 
	[Id_Equipo]          varchar(20)  NOT NULL ,

	[Familia]            varchar(MAX)  NULL ,
	[Modelo]             varchar(MAX)  NULL ,
	[Registro_Placa]     varchar(MAX)  NULL ,
	[Costo_Base]              money  NULL ,
	[Unidad]             varchar(5)  NULL 
)
go

CREATE TABLE [PARTE_EQUIPOS]
( 
	[Id_Parte]			varchar(200)  NOT NULL ,
	[Id_Equipo]         varchar(20)  NOT NULL ,
	[Id_Partida]        varchar(20)  NOT NULL ,
	[Fecha]             date  NULL ,
	[Costo]				float		NULL,
	[Nro_doc]           varchar(MAX)  NULL ,
)
go

CREATE TABLE [Detalle_Parte]
( 
	[Id_Parte]           varchar(200)  NOT NULL ,
	
	[Inicio]             NUMERIC(10,2) NULL ,
	[Fin]                NUMERIC(10,2)  NULL ,
	[Cantidad]           AS [Fin]-[Inicio],
	[Und]                char(5)  NULL ,
	[Trabajo]            varchar(120)  NULL ,
)
go

---===============================================
---GENERAR TABLAS GRUPO ALMACEN
---===============================================

CREATE TABLE [MATERIALES]
( 
	[Id_Material]        varchar(20)	NOT NULL ,
	[IU]				 varchar(20)	NULL,
	[Descripcion]        varchar(MAX)	NULL ,
	[Und]                char(5)		NULL ,
	[Stock]              NUMERIC(10,2)  NULL ,
	[Almacen]            varchar(MAX)	NULL ,
	[PU]                 money			NULL 
)
go

CREATE TABLE [NOTA_ALMACEN]
( 
	[Id_Nota]            varchar(20)  NOT NULL ,
	[Id_Partida]         varchar(20)  NOT NULL ,

	[Fecha]              date  NULL ,
	[Nro_Doc]            varchar(20)  NULL ,
)
go

CREATE TABLE [Detalle_Almacen]
( 
	[Id_Nota]            varchar(20)	NOT NULL ,
	[Id_Material]        varchar(20)	NULL ,

	[Cantidad]           NUMERIC(10,2)  NULL ,

)
go

---===============================================
---GENERAR TABLAS GRUPO PERSONAL
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
	[Salario]            money  NULL 
)
go


CREATE TABLE [TAREO_MO]
( 
	[Id_Tareo]           varchar(20)  NOT NULL ,
	[Id_Partida]		 varchar(20)  NULL ,

	[Fecha]              date  NULL ,
	[Nro_Docummento]     varchar(20)  NULL 
)
go

CREATE TABLE [Detalle_Tareo]
( 
	[Id_Tareo]           varchar(20)  NOT NULL ,
	[Id_Personal]        varchar(20)  NOT NULL,

	[Ingreso]            float  NULL ,
	[Salida]             float  NULL ,
	[HH]                 AS [Ingreso]-[Salida],
	[HE]                 float  NULL ,
 
)
go
