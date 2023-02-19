
USE PROYECTOS;
GO

-- ======================================================
-- DEFINIR CLAVES PRIMARIAS BLOQUE PROYECTO
-- ======================================================

ALTER TABLE [UBICACION]
	ADD CONSTRAINT [XPKUBICACION] PRIMARY KEY  CLUSTERED ([UBIGEO] ASC)
go

ALTER TABLE [CLIENTE]
	ADD CONSTRAINT [XPKCLIENTE] PRIMARY KEY  CLUSTERED ([Id_Cliente] ASC)
go


ALTER TABLE [PROYECTO]
	ADD CONSTRAINT [XPKPROYECTO] PRIMARY KEY  CLUSTERED ([Id_Proyecto] ASC)
go


EXEC sp_help [PROYECTO];
go



-- ======================================================
-- DEFINIR RELACIONES BLOQUE PROYECTO
-- ======================================================

ALTER TABLE [PROYECTO]
	ADD CONSTRAINT [R_17] FOREIGN KEY ([Id_Cliente]) REFERENCES [CLIENTE]([Id_Cliente])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PROYECTO]
	ADD CONSTRAINT [R_19] FOREIGN KEY ([UBIGEO]) REFERENCES [UBICACION]([UBIGEO])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


-- ======================================================
-- DEFINIR CLAVES BLOQUE PRESUPUESTO
-- ======================================================

--ALTER TABLE [COMPONENTE] DROP CONSTRAINT [XPKCOMPONENTE];
--ALTER TABLE [ENTREGABLE] DROP CONSTRAINT [XPKENTREGABLE];
--ALTER TABLE [PARTIDA]	 DROP CONSTRAINT [XPKPARTIDA];

ALTER TABLE [COMPONENTE]
	ADD CONSTRAINT [XPKCOMPONENTE] PRIMARY KEY  CLUSTERED ([Id_Componente] ASC)
go

ALTER TABLE [ENTREGABLE]
	ADD CONSTRAINT [XPKENTREGABLE] PRIMARY KEY  CLUSTERED ([Id_Entregable] ASC)
go

ALTER TABLE [PARTIDA]
	ADD CONSTRAINT [XPKPARTIDA] PRIMARY KEY  CLUSTERED ([Id_Partida] ASC)
go

-- ======================================================
-- DEFINIR RELACIONES BLOQUE PRESUPUESTO
-- ======================================================

ALTER TABLE [COMPONENTE]
	ADD CONSTRAINT [R_Proyecto_Componente_Presupuesto]
	FOREIGN KEY ([Id_Proyecto]) REFERENCES [PROYECTO]([Id_Proyecto])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ENTREGABLE]
	ADD CONSTRAINT [R_Componente_entregable]
	FOREIGN KEY ([Id_Componente]) REFERENCES [COMPONENTE]([Id_Componente])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PARTIDA]
	ADD CONSTRAINT [R_Entregable_Partida]
	FOREIGN KEY ([Id_Entregable]) REFERENCES [ENTREGABLE]([Id_Entregable])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

-- ======================================================
-- DEFINIR CLAVES BLOQUE EQUIPOS
-- ======================================================

ALTER TABLE [EQUIPO]
	ADD CONSTRAINT [XPKEQUIPO] PRIMARY KEY  CLUSTERED ([Id_Equipo] ASC)
go

ALTER TABLE [PARTE_EQUIPOS]
	ADD CONSTRAINT [XPKPARTE_EQUIPOS] PRIMARY KEY  CLUSTERED ([Id_Parte] ASC)
go

ALTER TABLE [Detalle_Parte]
	ADD CONSTRAINT [XPKDetalle_Parte] PRIMARY KEY  CLUSTERED ([Id_Parte] ASC)
go

-- ======================================================
-- DEFINIR RELACIONES BLOQUE EQUIPOS
-- ======================================================

ALTER TABLE [PARTE_EQUIPOS]
	ADD CONSTRAINT [R_20]
	FOREIGN KEY ([Id_Equipo]) REFERENCES [EQUIPO]([Id_Equipo])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Detalle_Parte]
	ADD CONSTRAINT [R_22]
	FOREIGN KEY ([Id_Parte]) REFERENCES [PARTE_EQUIPOS]([Id_Parte])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PARTE_EQUIPOS]
	ADD CONSTRAINT [R_21]
	FOREIGN KEY ([Id_Partida]) REFERENCES [PARTIDA]([Id_Partida])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

-- ======================================================
-- DEFINIR CLAVES BLOQUE ALMACEN
-- ======================================================

ALTER TABLE [MATERIALES]
	ADD CONSTRAINT [XPKMATERIALES] PRIMARY KEY  CLUSTERED ([Id_Material] ASC)
go

ALTER TABLE [NOTA_ALMACEN]
	ADD CONSTRAINT [XPKNOTA_ALMACEN] PRIMARY KEY  CLUSTERED ([Id_Nota] ASC)
go


-- ======================================================
-- DEFINIR RELACIONES BLOQUE ALMACEN
-- ======================================================

ALTER TABLE [NOTA_ALMACEN]
	ADD CONSTRAINT [R_27] FOREIGN KEY ([Id_Partida]) REFERENCES [PARTIDA]([Id_Partida])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Detalle_Almacen]
	ADD CONSTRAINT [R_15] FOREIGN KEY ([Id_Nota]) REFERENCES [NOTA_ALMACEN]([Id_Nota])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Detalle_Almacen]
	ADD CONSTRAINT [R_16] FOREIGN KEY ([Id_Material]) REFERENCES [MATERIALES]([Id_Material])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

-- ======================================================
-- DEFINIR CLAVES BLOQUE PERSONAL
-- ======================================================


ALTER TABLE [PERSONAL]
	ADD CONSTRAINT [XPKPERSONAL] PRIMARY KEY  CLUSTERED ([Id_Personal] ASC)
go

ALTER TABLE [TAREO_MO]
	ADD CONSTRAINT [XPKTAREO_MO] PRIMARY KEY  CLUSTERED ([Id_Tareo] ASC)
go

-- ======================================================
-- DEFINIR RELACIONES BLOQUE PERSONAL
-- ======================================================

ALTER TABLE [TAREO_MO]
	ADD CONSTRAINT [R_8] FOREIGN KEY ([Id_Partida]) REFERENCES [PARTIDA]([Id_Partida])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Detalle_Tareo]
	ADD CONSTRAINT [R_24] FOREIGN KEY ([Id_Tareo]) REFERENCES [TAREO_MO]([Id_Tareo])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Detalle_Tareo]
	ADD CONSTRAINT [R_25] FOREIGN KEY ([Id_Personal]) REFERENCES [PERSONAL]([Id_Personal])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go
