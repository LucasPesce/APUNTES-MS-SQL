/*********************************************************| APUNTE Nº 1: CONSULTAS - COMANDOS PRINCIPALES |*********************************************************/
/*-----| COMANDOS BASICOS |-----*/

-- SELECT: Selecciona los campos (Titulo de Columna) de la tabla indicada, para mostrar sus registros (filas)
-- *: Se utiliza para indicar que se desea seleccionar todos los campos de la tabla
-- AS: Permite cambiar el nombre del campo o asignarle un nombre a una PSEUDO COLUMNA

-- FROM: Selecciona la Tabla de origen, de la cual se ejecutara el select
-- WHERE: Permite definir filtros en la seleccionn, con respecto a los registros que se desea mostrar

-- PSEUDOCOLUMNA: Cuando se realiza una operacion matematica, o se le asigna un String,
--				  se crea virtualmente una nueva columna, con el ALIAS que se le defina

/*-----| OPERADORES LOGICOS |-----*/

-- AND:	Indica que se debe cumplir con el CRITERIO ANTERIOR y tambien con el CRITERIO SIGUIENTE
-- OR: Indica que se debe al menos uno de los dos criterios, con el CRITERIO ANTERIOR o con el CRITERIO SIGUIENTE
-- NOT: Indica la NEGACION del criterio que se le indique
-- <>: Indica que sea todo menos el criterio que se le indique.
-- IS NULL/ IS NOT NULL: Filtra los registros segun contengan el valor NULL (Distinguir de los campos vacíos.)


/*-----| OPERADORES DE FECHA |-----*/

-- DAY (campo fecha):	Filtra una consulta, considerando unicamente el dia de la fecha
-- MONTH (campo fecha): Filtra una consulta, considerando unicamente el mes de la fecha
-- YEAR (campo fecha):  Filtra una consulta, considerando unicamente el año de la fecha
-- GETDATE (): Permite referenciar la fecha actual. Ej: DAY (GETDATE())

/*-----| OTROS OPERADORES |-----*/

-- UPPER (campo/string):  Indica que el valor que se le asigne debe ir todo en MAYUSCULA
-- TRIM (String): Quita el pespaciado de ambos lados del String. LTRIM / RTRIM permite quitar el espacio segun el lado que se le indica L/R
-- STR(int/float/decimal) : Convierte un valor en Sring

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| OPERADOR LIKE |-----*/

-- LIKE: Permite filtrar la consulta, segun el String que se le defina.

SELECT
	articulo,
	nombre,
	preciomenor,
	rubro
FROM
	articulos
WHERE
	rubro <> 10
	AND	nombre LIKE '%REMERA%' -- Indica que contenga dicho STRING			<---------------------
				  --'%REMERA'  -- Indica que termine con dicho STRING
				  --'REMERA%'  -- Indica que comience con dicho STRING

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| OPERADOR BETWEEN |-----*/

-- BETWEEN: Permite utilizar un intervalo de valores en un filtro

-- EJEMPLO 1: Intervalo de valores
SELECT
	*
FROM
	articulos
WHERE
	preciomenor BETWEEN 100 AND 150		--	<--------------------

-- EJEMPLO 2: Intervalo entre dos fechas.
SELECT
	letra,
	factura,
	fecha
FROM
	vencab
WHERE
	fecha BETWEEN '01/08/2006' AND '31/08/2006'		--	<--------------------

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| OPERADOR IN |-----*/

-- IN: Permite definir varios valores para filtrar una consulta

--EJEMPLO 1: Filtra valores
SELECT
	articulo AS "Código de Artículo",
	nombre AS "Descripción del Artículo",
	preciomenor AS "Precio de venta minorista",
	preciomenor * 0.8 AS "Precio promoción 20%", 
	rubro AS "Rubro"
FROM
	articulos
WHERE
	rubro IN (30,36,43,40,94)			--	<--------------------


--EJEMPLO 1: Filtra valores string.
SELECT
	articulo,
	nombre,
	preciomenor,
	-- descuento (35%)
	preciomenor * 0.35 AS "Descuento 35%",
	-- precio c/descuento
	preciomenor * 0.65 AS "Precio c/Dto 35%",
	marca
FROM
	articulos
WHERE
	marca IN ('A','F','J','N','T')		--	<--------------------

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| ORDER BY |-----*/

--ORDER BY: Ordena la consulta, segun el campo que se le indique. Puede utilizarse el numero de columa o el nombre de columna
			-- ASC para ordenar de forma Ascendente 
			-- DESC para ordenar de forma Descendente

SELECT
	letra AS "Letra de Factura",
	fecha AS "Fecha de la venta",
	total AS "Total general",
	vendedor AS "Código de Vendedor"
FROM
	vencab
WHERE
	YEAR(fecha) = 2005
	AND MONTH(fecha) = 5
	AND total > 500
	AND anulada = 0
ORDER BY "Código de Vendedor" ASC, "Total general" DESC		--	<--------------------

/*	El equivalente utilizando el Nº de Columna.	*/
--	ORDER BY 
--		4, 3 DESC

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| DISTINCT |-----*/

-- DISTINCT: Muestra todos los valores de una columna sin que se repitan. Su fin es facilitar ver cuales son las opciones contenidas dentro de un campo

SELECT DISTINCT		--	<--------------------
	sucursal
FROM
	vencab
WHERE
	total > 1000
	AND anulada = 0
	AND fecha BETWEEN '01/05/2007' AND '31/05/2007'
ORDER BY
	1

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| TOP |-----*/

-- TOP: Permite limitar al numero que se le asigne, la cantidad de registros que devolvera una consulta

SELECT TOP 10		--	<--------------------
	letra,
	factura,
	total
FROM
	vencab
WHERE
	YEAR(fecha) = 2007
	AND anulada = 0
ORDER BY 3 DESC

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| NOT |-----*/

-- NOT: Indica la NEGACION del criterio que se le indique

SELECT
	factura,
	fecha,
	total,
	vendedor
FROM	
	vencab
WHERE
	fecha NOT BETWEEN '01/10/2007' AND '31/10/2007'		--	<--------------------
	AND anulada = 0

/*_________________________________________________________________________________________________________________________________________________*/
/*-----| IS NULL/ IS NOT NULL |-----*/

-- IS NULL/ IS NOT NULL: Filtra los registros segun si contienen o no NULL (No aplica para campo VACÍO)

SELECT 
	*
FROM
	vencab
WHERE
	fechahora IS NOT NULL
--------------------------------------------------------------------------
SELECT 
	*
FROM
	vencab
WHERE
	fechahora IS NULL

/*_________________________________________________________________________________________________________________________________________________*/
/*-----| FUNCIONES DE AGRUPAMIENTO|-----*/

-- Agrupa los registros segun la funcion que se este ejecutando:
	-- SUM (): Suma todos los registros, del campo que se le indique.
	-- AVG (): Realiza un promedio de todos los registros que se le indique
	-- COUNT (): Contabiliza la cantidad de registros (filas), del campo que se le indique
	-- MAX (): Obtiene el MAXIMO valor de todos los registros, del campo que se le indique
	-- MIN (): Obtiene el MINIMO valor de todos los registros, del campo que se le indique

-- GROUP BY: Cuando se utiliza las funciones de agrupamiento en la seleccion,
--			  sera necesario posteriormente agrupar los resultados utilizando los criterior de seleccion

-- HAVING: Permite sobre el agrupamiento hecho, realizar nuevamente otro filtra, con la misma logica que WHERE

--EJEMPLO BASICO:
SELECT
	MAX(total) AS "Importe máximo de una factura",
	MIN(total) AS "Importe mínimo de una factura",
	SUM(total)  AS "Importe total facturado",
	COUNT(factura) AS "Total de facturas",
	AVG(total) AS "Valor de factura promedio"
FROM
	vencab
WHERE 
	YEAR(fecha) = 2007
	AND total > 0
	AND anulada = 0

--EJEMPLO CON GROUP BY & HAVING: 
								-- CONSIGNA: DETERMINAR EL IMPORTE VENDIDO POR CADA VENDEDOR DE FORMA MINORISTA (NO ANULADAS) EN TODO LA HISTORIA DE LA EMPRESA

SELECT
	v.vendedor AS Codigo,				-- CRITERIO 1
	v.nombre AS VENDEDOR,				-- CRITERIO 2
	SUM(vc.total)	AS [VENTA TOTAL],	-- FUNCION 1
	COUNT(*) AS [CANTIDAD DE VENTAS]	-- FUNCION 2
FROM
	vencab AS vc
	INNER JOIN vendedores AS v ON v.vendedor = vc.vendedor
WHERE
	vc.anulada = 0
GROUP BY													--	<-------------------- BLOQUE GROUP BY
	v.vendedor,			-- CRITERIO 1
	v.nombre			-- CRITERIO 2
HAVING														--	<-------------------- BLOQUE HAVING
	COUNT(*) > 1000 
ORDER BY
	2,3

/*_________________________________________________________________________________________________________________________________________________*/
/*-----| SUBCONSULTAS |-----*/

-- Permita dentro de una consulta, utilizar otra consulta, como filtro.

--EJEMPLO 1: Como criterio de comparación 
SELECT 
	COUNT(*)
FROM 
	vencab 
WHERE
	YEAR(fecha) = 2008
	AND anulada = 0
	AND total > (SELECT MAX(total) FROM vencab WHERE YEAR(fecha) = 2007 AND anulada = 0)

--EJEMPLO 2: Se filtra un elemento, dentro de las opciones que da otra consulta.
SELECT
	factura,
	fecha,
	vendedor,
	total
FROM
	vencab
WHERE
 	total > 500
	AND YEAR(fecha) = 2007
	AND sucursal = 2
	AND vendedor IN (SELECT vendedor FROM vendedores WHERE encargado = 'S' and activo = 'S')