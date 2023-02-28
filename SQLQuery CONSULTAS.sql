---ACTIVAR LA BASE DE DATOS
USE [PROYECTOS FINAL]
GO
---====================================================================
--- Lista de proyectos: Cliente, Proyecto, Region, Provincia, Distrito, Estado del proyecto
---====================================================================


SELECT
	CLI.Nombre_Empresa AS CLIENTE,
	Nombre AS [NOMBRE PROYECTO],
	PRO.Estado AS [ESTADO DEL PROYECTO],
	UBI.REGION,
	UBI.PROVINCIA,
	UBI.DISTRITO  

FROM
	PROYECTO AS PRO
	INNER JOIN CLIENTE AS CLI ON CLI.Id_Cliente=PRO.Id_Cliente
	INNER JOIN UBIGEO AS UBI ON UBI.ID_UBIGEO=PRO.UBIGEO

GO

---====================================================================
--- Borrar contenido de una tabla, reiniciar clave autonumerica desde 1
---====================================================================---

DELETE FROM COMPONENTE
DBCC CHECKIDENT('COMPONENTE', RESEED, 1);


---====================================================================
--- Borrar contenido de una tabla
---====================================================================

DELETE FROM COMPONENTE;


---====================================================================
--- CONSULTAR EL PRESUPUESTO DE UN PROYECTO
---====================================================================

SELECT
	PRO.Nombre AS PROYECTO,
	COMP.Cod_Componente			AS CODIGO,
	COMP.Descripcion_Componente AS COMPONENTE,
	COMP.Monto_Componente		AS COSTO
FROM PROYECTO AS PRO
	INNER JOIN COMPONENTE AS COMP ON COMP.Id_Proyecto=PRO.Id_Proyecto

GO

---====================================================================
--- Borrar contenido de una tabla
---====================================================================

DELETE FROM dbo.Detalle_Parte;
DELETE FROM dbo.PARTE_EQUIPOS;
DELETE FROM dbo.EQUIPO;

GO

---====================================================================
--- CONSULTAR LOS PARTES DIARIOS DE USO DE EQUIPOS
---====================================================================

SELECT 
    PAR.Descripcion_Partida AS PARTIDA,
	EQP.Familia         AS EQUIPO,    
    EQP.Registro_Placa  AS REGISTRO,
    SUM(DET.Cantidad)   AS CANTIDAD,
    DET.Und             AS UNIDAD,
	PARTE.Costo			AS PU,
	SUM(DET.Cantidad*PARTE.Costo) AS COSTO

FROM EQUIPO AS EQP
    INNER JOIN PARTE_EQUIPOS AS PARTE ON EQP.Id_Equipo=PARTE.Id_Equipo
    INNER JOIN Detalle_Parte AS DET   ON PARTE.Id_Parte=DET.Id_Parte
	INNER JOIN PARTIDA		 AS PAR   ON PARTE.Id_Partida=PAR.Id_Partida
GROUP BY 
    PAR.Descripcion_Partida,
	EQP.Familia,
    EQP.Registro_Placa,
    DET.Und,
	PARTE.Costo
GO

---====================================================================
--- CONSULTAR LOS PARTES DIARIOS DE USO DE EQUIPOS
---====================================================================

SELECT 
    PAR.Descripcion_Partida AS PARTIDA,
	SUM(DET.Cantidad*PARTE.Costo) AS COSTO

FROM EQUIPO AS EQP
    INNER JOIN PARTE_EQUIPOS AS PARTE ON EQP.Id_Equipo=PARTE.Id_Equipo
    INNER JOIN Detalle_Parte AS DET   ON PARTE.Id_Parte=DET.Id_Parte
	INNER JOIN PARTIDA		 AS PAR   ON PARTE.Id_Partida=PAR.Id_Partida
GROUP BY 
    PAR.Descripcion_Partida,
	PARTE.Costo
GO













---====================================================================
--- Borrar contenido de una tabla
---====================================================================

DELETE FROM NOTA_ALMACEN;
GO

---====================================================================
--- CONSULTAR MATERIALES UTILIZADOS POR PARTIDA
---====================================================================

SELECT
	NOTA.Id_Partida,
	PAR.Descripcion_Partida,
	ALM.Id_Material,
	MAT.Descripcion,
	MAT.PU						AS [S/. PU],
	SUM(ALM.Cantidad)			AS CANTIDAD,
	ROUND(SUM(MAT.PU*ALM.Cantidad),2)	AS [S/. COSTO]

FROM NOTA_ALMACEN AS NOTA
	INNER JOIN Detalle_Almacen	AS ALM ON NOTA.Id_Nota=ALM.Id_Nota
	INNER JOIN MATERIALES		AS MAT ON ALM.Id_Material=MAT.Id_Material
	INNER JOIN PARTIDA			AS PAR ON PAR.Id_Partida=NOTA.Id_Partida
GROUP BY
	ALM.Id_Material,
	MAT.Descripcion,
	NOTA.Id_Partida,
	PAR.Descripcion_Partida,
	MAT.PU;
GO

---====================================================================
--- CONSULTAR PERSONAL POR PARTIDA
--- NOTA: Corregir bug en calculo de HH, se tuvo que poner "-"
---====================================================================

SELECT
	PAR.Descripcion_Partida		AS PARTIDA,
	MO.Nro_Docummento			AS PLANILLA,
	--TAR.Id_Personal				AS CODIGO,
	PER.Categoria				AS Categoria,
	SUM(-TAR.HH)				AS HORAS,
	ROUND(PER.Salario/30/8,2)			AS [COSTO HORA],
	ROUND(SUM(-TAR.HH*PER.Salario/30/8),2)		AS COSTO

FROM TAREO_MO AS MO
	INNER JOIN PARTIDA	AS PAR ON MO.Id_Partida=PAR.Id_Partida
	INNER JOIN Detalle_Tareo AS TAR ON TAR.Id_Tareo=MO.Id_Tareo
	INNER JOIN	PERSONAL	 AS PER ON PER.Id_Personal=TAR.Id_Personal

GROUP BY
	PER.Categoria				,
	PAR.Descripcion_Partida		,
	MO.Nro_Docummento			,
	--TAR.Id_Personal			,
	PER.Salario	
ORDER BY 
	PAR.Descripcion_Partida

GO