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
    EQP.Familia         AS EQUIPO,    
    EQP.Registro_Placa  AS REGISTRO,
    SUM(DET.Cantidad)   AS CANTIDAD,
    DET.Und             AS UNIDAD

FROM EQUIPO AS EQP
    INNER JOIN PARTE_EQUIPOS AS PARTE ON EQP.Id_Equipo=PARTE.Id_Equipo
    INNER JOIN Detalle_Parte AS DET   ON PARTE.Id_Parte=DET.Id_Parte
GROUP BY 
    EQP.Familia,
    EQP.Registro_Placa,
    DET.Und;
GO

---====================================================================
--- Borrar contenido de una tabla
---====================================================================

DELETE FROM NOTA_ALMACEN;

