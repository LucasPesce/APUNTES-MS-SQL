/****************************************************| APUNTE Nº 2: CONSULTAS AVANZADAS - CONDICIONAL CASE, INNER JOIN, UNION & VIEWS |****************************************************/

/*-----| CONDICIONAL CASE |-----*/

-- CASE: Selecciona un campo concreto, y para cada opcion que contemple, define una accion concreta

SELECT
	nombre AS "Vendedor",

	CASE encargado								
		WHEN 'S' THEN 'encargado'
		WHEN 'N' THEN 'vendedor'
	END AS "Categoría"				--SE ASIGNA A LA COLUMNA CATEGORÍA

FROM
	vendedores

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| INNER JOIN |-----*/

-- INNER JOIN: Permite unir una tabla a otra, para realizar la consulta. Se une una tabla a la vez

SELECT	DISTINCT
	v.nombre
FROM
	vencab AS vc
	INNER JOIN vendedores AS v ON vc.vendedor = v.vendedor				--	<--------------------
WHERE
	vc.anulada = 0
	AND vc.fecha BETWEEN '01/09/2006' AND '15/09/2006'
	AND vc.total > 100
ORDER BY
	1

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| UNION | UNION ALL |-----*/

-- UNION: Permite unir todos los registros, de dos consultas, ignorando los registros duplicados
-- UNION ALL: Permite unir todos los registros, de dos consultas, incluyendo los registros duplicados

/*	1ERA CONSULTA	*/
SELECT
	'Min' AS "Tipo Venta",	-- Crea una nueva columna, en la cual todos los registros de esta consulta, llevara el String indicado
	YEAR(fecha) AS "Año", 
	MONTH(fecha) AS "Mes", 
	SUM(total) AS "Importe" 
FROM
	vencab
WHERE
	anulada = 0
GROUP BY 
	YEAR(fecha),
	MONTH(fecha)
HAVING
	SUM(total) < 1000000

----------------------------------------------
UNION													--	<--------------------
----------------------------------------------

/*	2DA CONSULTA	*/
SELECT
	'May' AS "Tipo Venta",	-- Crea una nueva columna, en la cual todos los registros de esta consulta, llevara el String indicado
	YEAR(fecha) AS "Año", 
	MONTH(fecha) AS "Mes", 
	SUM(total) AS "Importe" 
FROM
	mayorcab
WHERE
	anulada = 0
GROUP BY -- Establece los criterios de agrupamiento
	YEAR(fecha),
	MONTH(fecha)
HAVING
	SUM(total) < 1000000
----------------------------------
ORDER BY		-- Solo tendra efecto si se encuentra al final, posteriormente de haberse unido las consultas
	2,3,1


/*_________________________________________________________________________________________________________________________________________________*/

/*-----| VIEWS |-----*/

-- VIEWS: Es una consulta almacenada. Al llamarla por el nombre que le fue asignado, ejecuta la consulta.
-- DROP VIEW: Borra la vista creada

CREATE OR ALTER VIEW v_resumen_ventas_articulos
AS
SELECT
	md.articulo AS "Código",
	a.nombre AS "Nombre",
	SUM(md.cantidad) AS "Cantidad Vendida",
	'MAY' AS "Tipo Venta"
FROM
	mayordet AS md
	INNER JOIN articulos AS a ON md.articulo = a.articulo
	INNER JOIN mayorcab AS mc ON mc.letra = md.letra AND mc.factura = md.factura
WHERE
	mc.anulada = 0
GROUP BY
	md.articulo,
	a.nombre
HAVING
	SUM(md.cantidad) > 0
---------------------------------------------------------
UNION
---------------------------------------------------------
SELECT
	vd.articulo,
	a.nombre,
	SUM(vd.cantidad),
	'MIN'
FROM
	vendet AS vd
	INNER JOIN articulos AS a ON vd.articulo = a.articulo
	INNER JOIN vencab AS vc ON vc.letra = vd.letra AND vc.factura = vd.factura
WHERE
	vc.anulada = 0
GROUP BY
	vd.articulo,
	a.nombre
HAVING
	SUM(vd.cantidad) > 0


/*	Se puede realiza una consulta convencional con la VISTA creada	*/
--EJEMPLO 1
SELECT
	* 
FROM
	v_resumen_ventas_articulos 

--EJEMPLO 2
SELECT 
	SUM("Cantidad Vendida")
FROM
	v_resumen_ventas_articulos
WHERE 
	"Código" = 'A105210015'

--EJEMPLO 2
SELECT 
	"Tipo Venta",
	"Cantidad Vendida"
FROM 
	v_resumen_ventas_articulos
WHERE 
	"Código" = 'A105210015'

/*	BORRA LA VISTA CREADA	*/
DROP VIEW v_resumen_ventas_articulos -- 

	
EXEC sp_helptext	-- Permite visualizar, el codigo de la visa
	v_resumen_ventas_articulos 

/*_________________________________________________________________________________________________________________________________________________*/


