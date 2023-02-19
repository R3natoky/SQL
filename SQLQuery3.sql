
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

--ALTER TABLE [Detalle_Tareo] DROP CONSTRAINT [R_24];
--ALTER TABLE [Detalle_Tareo] DROP CONSTRAINT [R_25];
--DROP TABLE [TAREO_MO]




CREATE TRIGGER tD_CLIENTE ON CLIENTE FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on CLIENTE */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* CLIENTE  PROYECTO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00010df8", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Id_Cliente" */
    IF EXISTS (
      SELECT * FROM deleted,PROYECTO
      WHERE
        /*  %JoinFKPK(PROYECTO,deleted," = "," AND") */
        PROYECTO.Id_Cliente = deleted.Id_Cliente
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CLIENTE because PROYECTO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_CLIENTE ON CLIENTE FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on CLIENTE */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Cliente integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* CLIENTE  PROYECTO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00011e79", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Id_Cliente" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Cliente)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PROYECTO
      WHERE
        /*  %JoinFKPK(PROYECTO,deleted," = "," AND") */
        PROYECTO.Id_Cliente = deleted.Id_Cliente
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CLIENTE because PROYECTO exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_COMPONENTE ON COMPONENTE FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on COMPONENTE */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* COMPONENTE  ENTREGABLE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002b891", PARENT_OWNER="", PARENT_TABLE="COMPONENTE"
    CHILD_OWNER="", CHILD_TABLE="ENTREGABLE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Id_Componente""Id_Proyecto" */
    IF EXISTS (
      SELECT * FROM deleted,ENTREGABLE
      WHERE
        /*  %JoinFKPK(ENTREGABLE,deleted," = "," AND") */
        ENTREGABLE.Id_Proyecto = deleted.Id_Proyecto AND
        ENTREGABLE.Id_Componente = deleted.Id_Componente
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete COMPONENTE because ENTREGABLE exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PROYECTO  COMPONENTE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PROYECTO"
    CHILD_OWNER="", CHILD_TABLE="COMPONENTE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Id_Proyecto""Id_Cliente""UBIGEO" */
    IF EXISTS (SELECT * FROM deleted,PROYECTO
      WHERE
        /* %JoinFKPK(deleted,PROYECTO," = "," AND") */
        deleted.Id_Proyecto = PROYECTO.Id_Proyecto AND
        deleted.Id_Cliente = PROYECTO.Id_Cliente AND
        deleted.UBIGEO = PROYECTO.UBIGEO AND
        NOT EXISTS (
          SELECT * FROM COMPONENTE
          WHERE
            /* %JoinFKPK(COMPONENTE,PROYECTO," = "," AND") */
            COMPONENTE.Id_Proyecto = PROYECTO.Id_Proyecto AND
            COMPONENTE.Id_Cliente = PROYECTO.Id_Cliente AND
            COMPONENTE.UBIGEO = PROYECTO.UBIGEO
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last COMPONENTE because PROYECTO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_COMPONENTE ON COMPONENTE FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on COMPONENTE */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Proyecto varchar(120), 
           @insId_Componente varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* COMPONENTE  ENTREGABLE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002d459", PARENT_OWNER="", PARENT_TABLE="COMPONENTE"
    CHILD_OWNER="", CHILD_TABLE="ENTREGABLE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Id_Componente""Id_Proyecto" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Proyecto) OR
    UPDATE(Id_Componente)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ENTREGABLE
      WHERE
        /*  %JoinFKPK(ENTREGABLE,deleted," = "," AND") */
        ENTREGABLE.Id_Proyecto = deleted.Id_Proyecto AND
        ENTREGABLE.Id_Componente = deleted.Id_Componente
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update COMPONENTE because ENTREGABLE exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PROYECTO  COMPONENTE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PROYECTO"
    CHILD_OWNER="", CHILD_TABLE="COMPONENTE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Id_Proyecto""Id_Cliente""UBIGEO" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Proyecto) OR
    UPDATE(Id_Cliente) OR
    UPDATE(UBIGEO)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PROYECTO
        WHERE
          /* %JoinFKPK(inserted,PROYECTO) */
          inserted.Id_Proyecto = PROYECTO.Id_Proyecto and
          inserted.Id_Cliente = PROYECTO.Id_Cliente and
          inserted.UBIGEO = PROYECTO.UBIGEO
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update COMPONENTE because PROYECTO does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Detalle_Almacen ON Detalle_Almacen FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Detalle_Almacen */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* MATERIALES  Detalle_Almacen on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002e481", PARENT_OWNER="", PARENT_TABLE="MATERIALES"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="Id_Material" */
    IF EXISTS (SELECT * FROM deleted,MATERIALES
      WHERE
        /* %JoinFKPK(deleted,MATERIALES," = "," AND") */
        deleted.Id_Material = MATERIALES.Id_Material AND
        NOT EXISTS (
          SELECT * FROM Detalle_Almacen
          WHERE
            /* %JoinFKPK(Detalle_Almacen,MATERIALES," = "," AND") */
            Detalle_Almacen.Id_Material = MATERIALES.Id_Material
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Detalle_Almacen because MATERIALES exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* NOTA_ALMACEN  Detalle_Almacen on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="NOTA_ALMACEN"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Id_Nota""Id_Partida" */
    IF EXISTS (SELECT * FROM deleted,NOTA_ALMACEN
      WHERE
        /* %JoinFKPK(deleted,NOTA_ALMACEN," = "," AND") */
        deleted.Id_Nota = NOTA_ALMACEN.Id_Nota AND
        deleted.Id_Partida = NOTA_ALMACEN.Id_Partida AND
        NOT EXISTS (
          SELECT * FROM Detalle_Almacen
          WHERE
            /* %JoinFKPK(Detalle_Almacen,NOTA_ALMACEN," = "," AND") */
            Detalle_Almacen.Id_Nota = NOTA_ALMACEN.Id_Nota AND
            Detalle_Almacen.Id_Partida = NOTA_ALMACEN.Id_Partida
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Detalle_Almacen because NOTA_ALMACEN exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Detalle_Almacen ON Detalle_Almacen FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Detalle_Almacen */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Nota varchar(20), 
           @insId_Material varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* MATERIALES  Detalle_Almacen on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002dec9", PARENT_OWNER="", PARENT_TABLE="MATERIALES"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="Id_Material" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Material)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,MATERIALES
        WHERE
          /* %JoinFKPK(inserted,MATERIALES) */
          inserted.Id_Material = MATERIALES.Id_Material
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Detalle_Almacen because MATERIALES does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* NOTA_ALMACEN  Detalle_Almacen on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="NOTA_ALMACEN"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Id_Nota""Id_Partida" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Nota) OR
    UPDATE(Id_Partida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,NOTA_ALMACEN
        WHERE
          /* %JoinFKPK(inserted,NOTA_ALMACEN) */
          inserted.Id_Nota = NOTA_ALMACEN.Id_Nota and
          inserted.Id_Partida = NOTA_ALMACEN.Id_Partida
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Detalle_Almacen because NOTA_ALMACEN does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Detalle_Parte ON Detalle_Parte FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Detalle_Parte */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PARTE_EQUIPOS  Detalle_Parte on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001d414", PARENT_OWNER="", PARENT_TABLE="PARTE_EQUIPOS"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Parte"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Id_Parte""Id_Equipo""Id_Partida" */
    IF EXISTS (SELECT * FROM deleted,PARTE_EQUIPOS
      WHERE
        /* %JoinFKPK(deleted,PARTE_EQUIPOS," = "," AND") */
        deleted.Id_Parte = PARTE_EQUIPOS.Id_Parte AND
        deleted.Id_Equipo = PARTE_EQUIPOS.Id_Equipo AND
        deleted.Id_Partida = PARTE_EQUIPOS.Id_Partida AND
        NOT EXISTS (
          SELECT * FROM Detalle_Parte
          WHERE
            /* %JoinFKPK(Detalle_Parte,PARTE_EQUIPOS," = "," AND") */
            Detalle_Parte.Id_Parte = PARTE_EQUIPOS.Id_Parte AND
            Detalle_Parte.Id_Equipo = PARTE_EQUIPOS.Id_Equipo AND
            Detalle_Parte.Id_Partida = PARTE_EQUIPOS.Id_Partida
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Detalle_Parte because PARTE_EQUIPOS exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Detalle_Parte ON Detalle_Parte FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Detalle_Parte */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Parte integer, 
           @insId_Equipo varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PARTE_EQUIPOS  Detalle_Parte on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001cf4d", PARENT_OWNER="", PARENT_TABLE="PARTE_EQUIPOS"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Parte"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Id_Parte""Id_Equipo""Id_Partida" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Parte) OR
    UPDATE(Id_Equipo) OR
    UPDATE(Id_Partida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PARTE_EQUIPOS
        WHERE
          /* %JoinFKPK(inserted,PARTE_EQUIPOS) */
          inserted.Id_Parte = PARTE_EQUIPOS.Id_Parte and
          inserted.Id_Equipo = PARTE_EQUIPOS.Id_Equipo and
          inserted.Id_Partida = PARTE_EQUIPOS.Id_Partida
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Detalle_Parte because PARTE_EQUIPOS does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Detalle_Tareo ON Detalle_Tareo FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Detalle_Tareo */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PERSONAL  Detalle_Tareo on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002f7ac", PARENT_OWNER="", PARENT_TABLE="PERSONAL"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="Id_Personal" */
    IF EXISTS (SELECT * FROM deleted,PERSONAL
      WHERE
        /* %JoinFKPK(deleted,PERSONAL," = "," AND") */
        deleted.Id_Personal = PERSONAL.Id_Personal AND
        NOT EXISTS (
          SELECT * FROM Detalle_Tareo
          WHERE
            /* %JoinFKPK(Detalle_Tareo,PERSONAL," = "," AND") */
            Detalle_Tareo.Id_Personal = PERSONAL.Id_Personal
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Detalle_Tareo because PERSONAL exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* TAREO_MO  Detalle_Tareo on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TAREO_MO"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="Id_Tareo""Id_Entregable""Id_Partida" */
    IF EXISTS (SELECT * FROM deleted,TAREO_MO
      WHERE
        /* %JoinFKPK(deleted,TAREO_MO," = "," AND") */
        deleted.Id_Tareo = TAREO_MO.Id_Tareo AND
        deleted.Id_Entregable = TAREO_MO.Id_Entregable AND
        deleted.Id_Partida = TAREO_MO.Id_Partida AND
        NOT EXISTS (
          SELECT * FROM Detalle_Tareo
          WHERE
            /* %JoinFKPK(Detalle_Tareo,TAREO_MO," = "," AND") */
            Detalle_Tareo.Id_Tareo = TAREO_MO.Id_Tareo AND
            Detalle_Tareo.Id_Entregable = TAREO_MO.Id_Entregable AND
            Detalle_Tareo.Id_Partida = TAREO_MO.Id_Partida
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Detalle_Tareo because TAREO_MO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Detalle_Tareo ON Detalle_Tareo FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Detalle_Tareo */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Tareo varchar(20), 
           @insId_Personal varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PERSONAL  Detalle_Tareo on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00031091", PARENT_OWNER="", PARENT_TABLE="PERSONAL"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="Id_Personal" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Personal)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PERSONAL
        WHERE
          /* %JoinFKPK(inserted,PERSONAL) */
          inserted.Id_Personal = PERSONAL.Id_Personal
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Detalle_Tareo because PERSONAL does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* TAREO_MO  Detalle_Tareo on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TAREO_MO"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="Id_Tareo""Id_Entregable""Id_Partida" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Tareo) OR
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,TAREO_MO
        WHERE
          /* %JoinFKPK(inserted,TAREO_MO) */
          inserted.Id_Tareo = TAREO_MO.Id_Tareo and
          inserted.Id_Entregable = TAREO_MO.Id_Entregable and
          inserted.Id_Partida = TAREO_MO.Id_Partida
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Detalle_Tareo because TAREO_MO does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_ENTREGABLE ON ENTREGABLE FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ENTREGABLE */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ENTREGABLE  PARTIDA on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00029899", PARENT_OWNER="", PARENT_TABLE="ENTREGABLE"
    CHILD_OWNER="", CHILD_TABLE="PARTIDA"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Id_Entregable""Id_Componente" */
    IF EXISTS (
      SELECT * FROM deleted,PARTIDA
      WHERE
        /*  %JoinFKPK(PARTIDA,deleted," = "," AND") */
        PARTIDA.Id_Componente = deleted.Id_Componente AND
        PARTIDA.Id_Entregable = deleted.Id_Entregable
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ENTREGABLE because PARTIDA exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* COMPONENTE  ENTREGABLE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="COMPONENTE"
    CHILD_OWNER="", CHILD_TABLE="ENTREGABLE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Id_Componente""Id_Proyecto" */
    IF EXISTS (SELECT * FROM deleted,COMPONENTE
      WHERE
        /* %JoinFKPK(deleted,COMPONENTE," = "," AND") */
        deleted.Id_Proyecto = COMPONENTE.Id_Proyecto AND
        deleted.Id_Componente = COMPONENTE.Id_Componente AND
        NOT EXISTS (
          SELECT * FROM ENTREGABLE
          WHERE
            /* %JoinFKPK(ENTREGABLE,COMPONENTE," = "," AND") */
            ENTREGABLE.Id_Proyecto = COMPONENTE.Id_Proyecto AND
            ENTREGABLE.Id_Componente = COMPONENTE.Id_Componente
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ENTREGABLE because COMPONENTE exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_ENTREGABLE ON ENTREGABLE FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ENTREGABLE */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Componente varchar(20), 
           @insId_Entregable varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ENTREGABLE  PARTIDA on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002cb72", PARENT_OWNER="", PARENT_TABLE="ENTREGABLE"
    CHILD_OWNER="", CHILD_TABLE="PARTIDA"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Id_Entregable""Id_Componente" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Componente) OR
    UPDATE(Id_Entregable)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PARTIDA
      WHERE
        /*  %JoinFKPK(PARTIDA,deleted," = "," AND") */
        PARTIDA.Id_Componente = deleted.Id_Componente AND
        PARTIDA.Id_Entregable = deleted.Id_Entregable
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ENTREGABLE because PARTIDA exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* COMPONENTE  ENTREGABLE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="COMPONENTE"
    CHILD_OWNER="", CHILD_TABLE="ENTREGABLE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Id_Componente""Id_Proyecto" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Proyecto) OR
    UPDATE(Id_Componente)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,COMPONENTE
        WHERE
          /* %JoinFKPK(inserted,COMPONENTE) */
          inserted.Id_Proyecto = COMPONENTE.Id_Proyecto and
          inserted.Id_Componente = COMPONENTE.Id_Componente
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ENTREGABLE because COMPONENTE does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_EQUIPO ON EQUIPO FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on EQUIPO */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* EQUIPO  PARTE_EQUIPOS on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000113bc", PARENT_OWNER="", PARENT_TABLE="EQUIPO"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Id_Equipo" */
    IF EXISTS (
      SELECT * FROM deleted,PARTE_EQUIPOS
      WHERE
        /*  %JoinFKPK(PARTE_EQUIPOS,deleted," = "," AND") */
        PARTE_EQUIPOS.Id_Equipo = deleted.Id_Equipo
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete EQUIPO because PARTE_EQUIPOS exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_EQUIPO ON EQUIPO FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on EQUIPO */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Equipo varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* EQUIPO  PARTE_EQUIPOS on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012eef", PARENT_OWNER="", PARENT_TABLE="EQUIPO"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Id_Equipo" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Equipo)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PARTE_EQUIPOS
      WHERE
        /*  %JoinFKPK(PARTE_EQUIPOS,deleted," = "," AND") */
        PARTE_EQUIPOS.Id_Equipo = deleted.Id_Equipo
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update EQUIPO because PARTE_EQUIPOS exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_MATERIALES ON MATERIALES FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on MATERIALES */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* MATERIALES  Detalle_Almacen on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00011dc6", PARENT_OWNER="", PARENT_TABLE="MATERIALES"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="Id_Material" */
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Almacen
      WHERE
        /*  %JoinFKPK(Detalle_Almacen,deleted," = "," AND") */
        Detalle_Almacen.Id_Material = deleted.Id_Material
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete MATERIALES because Detalle_Almacen exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_MATERIALES ON MATERIALES FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on MATERIALES */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Material varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* MATERIALES  Detalle_Almacen on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00013c5a", PARENT_OWNER="", PARENT_TABLE="MATERIALES"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="Id_Material" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Material)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Almacen
      WHERE
        /*  %JoinFKPK(Detalle_Almacen,deleted," = "," AND") */
        Detalle_Almacen.Id_Material = deleted.Id_Material
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update MATERIALES because Detalle_Almacen exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_NOTA_ALMACEN ON NOTA_ALMACEN FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on NOTA_ALMACEN */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* NOTA_ALMACEN  Detalle_Almacen on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002ae81", PARENT_OWNER="", PARENT_TABLE="NOTA_ALMACEN"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Id_Nota""Id_Partida" */
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Almacen
      WHERE
        /*  %JoinFKPK(Detalle_Almacen,deleted," = "," AND") */
        Detalle_Almacen.Id_Nota = deleted.Id_Nota AND
        Detalle_Almacen.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete NOTA_ALMACEN because Detalle_Almacen exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PARTIDA  NOTA_ALMACEN on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="NOTA_ALMACEN"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="Id_Partida""Id_Entregable" */
    IF EXISTS (SELECT * FROM deleted,PARTIDA
      WHERE
        /* %JoinFKPK(deleted,PARTIDA," = "," AND") */
        deleted.Id_Entregable = PARTIDA.Id_Entregable AND
        deleted.Id_Partida = PARTIDA.Id_Partida AND
        NOT EXISTS (
          SELECT * FROM NOTA_ALMACEN
          WHERE
            /* %JoinFKPK(NOTA_ALMACEN,PARTIDA," = "," AND") */
            NOTA_ALMACEN.Id_Entregable = PARTIDA.Id_Entregable AND
            NOTA_ALMACEN.Id_Partida = PARTIDA.Id_Partida
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last NOTA_ALMACEN because PARTIDA exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_NOTA_ALMACEN ON NOTA_ALMACEN FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on NOTA_ALMACEN */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Nota varchar(20), 
           @insId_Partida varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* NOTA_ALMACEN  Detalle_Almacen on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002d575", PARENT_OWNER="", PARENT_TABLE="NOTA_ALMACEN"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Almacen"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Id_Nota""Id_Partida" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Nota) OR
    UPDATE(Id_Partida)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Almacen
      WHERE
        /*  %JoinFKPK(Detalle_Almacen,deleted," = "," AND") */
        Detalle_Almacen.Id_Nota = deleted.Id_Nota AND
        Detalle_Almacen.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update NOTA_ALMACEN because Detalle_Almacen exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PARTIDA  NOTA_ALMACEN on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="NOTA_ALMACEN"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="Id_Partida""Id_Entregable" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PARTIDA
        WHERE
          /* %JoinFKPK(inserted,PARTIDA) */
          inserted.Id_Entregable = PARTIDA.Id_Entregable and
          inserted.Id_Partida = PARTIDA.Id_Partida
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update NOTA_ALMACEN because PARTIDA does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PARTE_EQUIPOS ON PARTE_EQUIPOS FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PARTE_EQUIPOS */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PARTE_EQUIPOS  Detalle_Parte on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003e493", PARENT_OWNER="", PARENT_TABLE="PARTE_EQUIPOS"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Parte"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Id_Parte""Id_Equipo""Id_Partida" */
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Parte
      WHERE
        /*  %JoinFKPK(Detalle_Parte,deleted," = "," AND") */
        Detalle_Parte.Id_Parte = deleted.Id_Parte AND
        Detalle_Parte.Id_Equipo = deleted.Id_Equipo AND
        Detalle_Parte.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PARTE_EQUIPOS because Detalle_Parte exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PARTIDA  PARTE_EQUIPOS on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="Id_Partida""Id_Entregable" */
    IF EXISTS (SELECT * FROM deleted,PARTIDA
      WHERE
        /* %JoinFKPK(deleted,PARTIDA," = "," AND") */
        deleted.Id_Entregable = PARTIDA.Id_Entregable AND
        deleted.Id_Partida = PARTIDA.Id_Partida AND
        NOT EXISTS (
          SELECT * FROM PARTE_EQUIPOS
          WHERE
            /* %JoinFKPK(PARTE_EQUIPOS,PARTIDA," = "," AND") */
            PARTE_EQUIPOS.Id_Entregable = PARTIDA.Id_Entregable AND
            PARTE_EQUIPOS.Id_Partida = PARTIDA.Id_Partida
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PARTE_EQUIPOS because PARTIDA exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* EQUIPO  PARTE_EQUIPOS on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EQUIPO"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Id_Equipo" */
    IF EXISTS (SELECT * FROM deleted,EQUIPO
      WHERE
        /* %JoinFKPK(deleted,EQUIPO," = "," AND") */
        deleted.Id_Equipo = EQUIPO.Id_Equipo AND
        NOT EXISTS (
          SELECT * FROM PARTE_EQUIPOS
          WHERE
            /* %JoinFKPK(PARTE_EQUIPOS,EQUIPO," = "," AND") */
            PARTE_EQUIPOS.Id_Equipo = EQUIPO.Id_Equipo
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PARTE_EQUIPOS because EQUIPO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_PARTE_EQUIPOS ON PARTE_EQUIPOS FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PARTE_EQUIPOS */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Parte integer, 
           @insId_Equipo varchar(20), 
           @insId_Partida varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PARTE_EQUIPOS  Detalle_Parte on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00044622", PARENT_OWNER="", PARENT_TABLE="PARTE_EQUIPOS"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Parte"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Id_Parte""Id_Equipo""Id_Partida" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Parte) OR
    UPDATE(Id_Equipo) OR
    UPDATE(Id_Partida)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Parte
      WHERE
        /*  %JoinFKPK(Detalle_Parte,deleted," = "," AND") */
        Detalle_Parte.Id_Parte = deleted.Id_Parte AND
        Detalle_Parte.Id_Equipo = deleted.Id_Equipo AND
        Detalle_Parte.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PARTE_EQUIPOS because Detalle_Parte exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PARTIDA  PARTE_EQUIPOS on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="Id_Partida""Id_Entregable" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PARTIDA
        WHERE
          /* %JoinFKPK(inserted,PARTIDA) */
          inserted.Id_Entregable = PARTIDA.Id_Entregable and
          inserted.Id_Partida = PARTIDA.Id_Partida
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PARTE_EQUIPOS because PARTIDA does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* EQUIPO  PARTE_EQUIPOS on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EQUIPO"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Id_Equipo" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Equipo)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,EQUIPO
        WHERE
          /* %JoinFKPK(inserted,EQUIPO) */
          inserted.Id_Equipo = EQUIPO.Id_Equipo
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PARTE_EQUIPOS because EQUIPO does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PARTIDA ON PARTIDA FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PARTIDA */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PARTIDA  NOTA_ALMACEN on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0004d632", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="NOTA_ALMACEN"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="Id_Partida""Id_Entregable" */
    IF EXISTS (
      SELECT * FROM deleted,NOTA_ALMACEN
      WHERE
        /*  %JoinFKPK(NOTA_ALMACEN,deleted," = "," AND") */
        NOTA_ALMACEN.Id_Entregable = deleted.Id_Entregable AND
        NOTA_ALMACEN.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PARTIDA because NOTA_ALMACEN exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PARTIDA  PARTE_EQUIPOS on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="Id_Partida""Id_Entregable" */
    IF EXISTS (
      SELECT * FROM deleted,PARTE_EQUIPOS
      WHERE
        /*  %JoinFKPK(PARTE_EQUIPOS,deleted," = "," AND") */
        PARTE_EQUIPOS.Id_Entregable = deleted.Id_Entregable AND
        PARTE_EQUIPOS.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PARTIDA because PARTE_EQUIPOS exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PARTIDA  TAREO_MO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="TAREO_MO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Id_Partida""Id_Entregable" */
    IF EXISTS (
      SELECT * FROM deleted,TAREO_MO
      WHERE
        /*  %JoinFKPK(TAREO_MO,deleted," = "," AND") */
        TAREO_MO.Id_Entregable = deleted.Id_Entregable AND
        TAREO_MO.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PARTIDA because TAREO_MO exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* ENTREGABLE  PARTIDA on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ENTREGABLE"
    CHILD_OWNER="", CHILD_TABLE="PARTIDA"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Id_Entregable""Id_Componente" */
    IF EXISTS (SELECT * FROM deleted,ENTREGABLE
      WHERE
        /* %JoinFKPK(deleted,ENTREGABLE," = "," AND") */
        deleted.Id_Componente = ENTREGABLE.Id_Componente AND
        deleted.Id_Entregable = ENTREGABLE.Id_Entregable AND
        NOT EXISTS (
          SELECT * FROM PARTIDA
          WHERE
            /* %JoinFKPK(PARTIDA,ENTREGABLE," = "," AND") */
            PARTIDA.Id_Componente = ENTREGABLE.Id_Componente AND
            PARTIDA.Id_Entregable = ENTREGABLE.Id_Entregable
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PARTIDA because ENTREGABLE exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_PARTIDA ON PARTIDA FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PARTIDA */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Entregable varchar(20), 
           @insId_Partida varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PARTIDA  NOTA_ALMACEN on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000549af", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="NOTA_ALMACEN"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="Id_Partida""Id_Entregable" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,NOTA_ALMACEN
      WHERE
        /*  %JoinFKPK(NOTA_ALMACEN,deleted," = "," AND") */
        NOTA_ALMACEN.Id_Entregable = deleted.Id_Entregable AND
        NOTA_ALMACEN.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PARTIDA because NOTA_ALMACEN exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PARTIDA  PARTE_EQUIPOS on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="PARTE_EQUIPOS"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="Id_Partida""Id_Entregable" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PARTE_EQUIPOS
      WHERE
        /*  %JoinFKPK(PARTE_EQUIPOS,deleted," = "," AND") */
        PARTE_EQUIPOS.Id_Entregable = deleted.Id_Entregable AND
        PARTE_EQUIPOS.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PARTIDA because PARTE_EQUIPOS exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PARTIDA  TAREO_MO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="TAREO_MO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Id_Partida""Id_Entregable" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,TAREO_MO
      WHERE
        /*  %JoinFKPK(TAREO_MO,deleted," = "," AND") */
        TAREO_MO.Id_Entregable = deleted.Id_Entregable AND
        TAREO_MO.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PARTIDA because TAREO_MO exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ENTREGABLE  PARTIDA on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ENTREGABLE"
    CHILD_OWNER="", CHILD_TABLE="PARTIDA"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Id_Entregable""Id_Componente" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Componente) OR
    UPDATE(Id_Entregable)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ENTREGABLE
        WHERE
          /* %JoinFKPK(inserted,ENTREGABLE) */
          inserted.Id_Componente = ENTREGABLE.Id_Componente and
          inserted.Id_Entregable = ENTREGABLE.Id_Entregable
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PARTIDA because ENTREGABLE does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PERSONAL ON PERSONAL FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PERSONAL */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PERSONAL  Detalle_Tareo on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00011227", PARENT_OWNER="", PARENT_TABLE="PERSONAL"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="Id_Personal" */
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Tareo
      WHERE
        /*  %JoinFKPK(Detalle_Tareo,deleted," = "," AND") */
        Detalle_Tareo.Id_Personal = deleted.Id_Personal
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PERSONAL because Detalle_Tareo exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_PERSONAL ON PERSONAL FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PERSONAL */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Personal varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PERSONAL  Detalle_Tareo on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012c2b", PARENT_OWNER="", PARENT_TABLE="PERSONAL"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="Id_Personal" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Personal)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Tareo
      WHERE
        /*  %JoinFKPK(Detalle_Tareo,deleted," = "," AND") */
        Detalle_Tareo.Id_Personal = deleted.Id_Personal
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PERSONAL because Detalle_Tareo exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PROYECTO ON PROYECTO FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PROYECTO */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PROYECTO  COMPONENTE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00038f49", PARENT_OWNER="", PARENT_TABLE="PROYECTO"
    CHILD_OWNER="", CHILD_TABLE="COMPONENTE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Id_Proyecto""Id_Cliente""UBIGEO" */
    IF EXISTS (
      SELECT * FROM deleted,COMPONENTE
      WHERE
        /*  %JoinFKPK(COMPONENTE,deleted," = "," AND") */
        COMPONENTE.Id_Proyecto = deleted.Id_Proyecto AND
        COMPONENTE.Id_Cliente = deleted.Id_Cliente AND
        COMPONENTE.UBIGEO = deleted.UBIGEO
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PROYECTO because COMPONENTE exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* UBICACION  PROYECTO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="UBICACION"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="UBIGEO" */
    IF EXISTS (SELECT * FROM deleted,UBICACION
      WHERE
        /* %JoinFKPK(deleted,UBICACION," = "," AND") */
        deleted.UBIGEO = UBICACION.UBIGEO AND
        NOT EXISTS (
          SELECT * FROM PROYECTO
          WHERE
            /* %JoinFKPK(PROYECTO,UBICACION," = "," AND") */
            PROYECTO.UBIGEO = UBICACION.UBIGEO
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PROYECTO because UBICACION exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CLIENTE  PROYECTO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Id_Cliente" */
    IF EXISTS (SELECT * FROM deleted,CLIENTE
      WHERE
        /* %JoinFKPK(deleted,CLIENTE," = "," AND") */
        deleted.Id_Cliente = CLIENTE.Id_Cliente AND
        NOT EXISTS (
          SELECT * FROM PROYECTO
          WHERE
            /* %JoinFKPK(PROYECTO,CLIENTE," = "," AND") */
            PROYECTO.Id_Cliente = CLIENTE.Id_Cliente
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PROYECTO because CLIENTE exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_PROYECTO ON PROYECTO FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PROYECTO */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Proyecto varchar(120), 
           @insId_Cliente integer, 
           @insUBIGEO integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PROYECTO  COMPONENTE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0003f4ff", PARENT_OWNER="", PARENT_TABLE="PROYECTO"
    CHILD_OWNER="", CHILD_TABLE="COMPONENTE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Id_Proyecto""Id_Cliente""UBIGEO" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Proyecto) OR
    UPDATE(Id_Cliente) OR
    UPDATE(UBIGEO)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,COMPONENTE
      WHERE
        /*  %JoinFKPK(COMPONENTE,deleted," = "," AND") */
        COMPONENTE.Id_Proyecto = deleted.Id_Proyecto AND
        COMPONENTE.Id_Cliente = deleted.Id_Cliente AND
        COMPONENTE.UBIGEO = deleted.UBIGEO
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PROYECTO because COMPONENTE exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* UBICACION  PROYECTO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="UBICACION"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="UBIGEO" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(UBIGEO)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,UBICACION
        WHERE
          /* %JoinFKPK(inserted,UBICACION) */
          inserted.UBIGEO = UBICACION.UBIGEO
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PROYECTO because UBICACION does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CLIENTE  PROYECTO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Id_Cliente" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Cliente)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CLIENTE
        WHERE
          /* %JoinFKPK(inserted,CLIENTE) */
          inserted.Id_Cliente = CLIENTE.Id_Cliente
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PROYECTO because CLIENTE does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_TAREO_MO ON TAREO_MO FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on TAREO_MO */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* TAREO_MO  Detalle_Tareo on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002c261", PARENT_OWNER="", PARENT_TABLE="TAREO_MO"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="Id_Tareo""Id_Entregable""Id_Partida" */
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Tareo
      WHERE
        /*  %JoinFKPK(Detalle_Tareo,deleted," = "," AND") */
        Detalle_Tareo.Id_Tareo = deleted.Id_Tareo AND
        Detalle_Tareo.Id_Entregable = deleted.Id_Entregable AND
        Detalle_Tareo.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete TAREO_MO because Detalle_Tareo exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PARTIDA  TAREO_MO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="TAREO_MO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Id_Partida""Id_Entregable" */
    IF EXISTS (SELECT * FROM deleted,PARTIDA
      WHERE
        /* %JoinFKPK(deleted,PARTIDA," = "," AND") */
        deleted.Id_Entregable = PARTIDA.Id_Entregable AND
        deleted.Id_Partida = PARTIDA.Id_Partida AND
        NOT EXISTS (
          SELECT * FROM TAREO_MO
          WHERE
            /* %JoinFKPK(TAREO_MO,PARTIDA," = "," AND") */
            TAREO_MO.Id_Entregable = PARTIDA.Id_Entregable AND
            TAREO_MO.Id_Partida = PARTIDA.Id_Partida
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last TAREO_MO because PARTIDA exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_TAREO_MO ON TAREO_MO FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on TAREO_MO */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId_Tareo varchar(20), 
           @insId_Entregable varchar(20), 
           @insId_Partida varchar(20),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* TAREO_MO  Detalle_Tareo on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002f871", PARENT_OWNER="", PARENT_TABLE="TAREO_MO"
    CHILD_OWNER="", CHILD_TABLE="Detalle_Tareo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="Id_Tareo""Id_Entregable""Id_Partida" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id_Tareo) OR
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Detalle_Tareo
      WHERE
        /*  %JoinFKPK(Detalle_Tareo,deleted," = "," AND") */
        Detalle_Tareo.Id_Tareo = deleted.Id_Tareo AND
        Detalle_Tareo.Id_Entregable = deleted.Id_Entregable AND
        Detalle_Tareo.Id_Partida = deleted.Id_Partida
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update TAREO_MO because Detalle_Tareo exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PARTIDA  TAREO_MO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PARTIDA"
    CHILD_OWNER="", CHILD_TABLE="TAREO_MO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Id_Partida""Id_Entregable" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id_Entregable) OR
    UPDATE(Id_Partida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PARTIDA
        WHERE
          /* %JoinFKPK(inserted,PARTIDA) */
          inserted.Id_Entregable = PARTIDA.Id_Entregable and
          inserted.Id_Partida = PARTIDA.Id_Partida
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update TAREO_MO because PARTIDA does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_UBICACION ON UBICACION FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on UBICACION */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* UBICACION  PROYECTO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001065c", PARENT_OWNER="", PARENT_TABLE="UBICACION"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="UBIGEO" */
    IF EXISTS (
      SELECT * FROM deleted,PROYECTO
      WHERE
        /*  %JoinFKPK(PROYECTO,deleted," = "," AND") */
        PROYECTO.UBIGEO = deleted.UBIGEO
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete UBICACION because PROYECTO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_UBICACION ON UBICACION FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on UBICACION */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insUBIGEO integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* UBICACION  PROYECTO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00011c02", PARENT_OWNER="", PARENT_TABLE="UBICACION"
    CHILD_OWNER="", CHILD_TABLE="PROYECTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="UBIGEO" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(UBIGEO)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PROYECTO
      WHERE
        /*  %JoinFKPK(PROYECTO,deleted," = "," AND") */
        PROYECTO.UBIGEO = deleted.UBIGEO
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update UBICACION because PROYECTO exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go
