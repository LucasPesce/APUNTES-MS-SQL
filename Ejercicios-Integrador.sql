/*

1. RECUPERACI�N DE DATOS SIMPLE

Listar todos los art�culos que cumplan con las siguientes condiciones:
- su preciomenor tenga un valor entre 5.00 y 30.00
- su c�digo (articulo) comience con la letra K
- contanga en su nombre la palabra REMERA

Presentar las columnas ARTICULO, NOMBRE, PRECIOMENOR y ESTADO. Ordenar por la columna NOMBRE.

TABLAS: articulos (EL RESULTADO DEBE ARROJAR 31 FILAS)

*/

SELECT
	articulo,
	nombre,
	preciomenor,
	estado
FROM
	articulos
WHERE
	preciomenor BETWEEN 5 AND 30
	AND articulo LIKE 'K%'
	AND nombre LIKE '%REMERA%'

/*

2. RECUPERACI�N DE DATOS CON AGRUPAMIENTO

Mostrar por MES la cantidad de facturas emitidas y el importe total de ventas MAYORISTAS correspondientes al a�o 2007.

Excluir las ventas anuladas. Mostrar las columnas MES, FACTURAS, IMPORTE. Ordenar por mes.

TABLAS: mayorcab (EL RESULTADO DEBE ARROJAR 12 FILAS)

*/

SELECT
	MONTH(fecha) AS "MES",
	COUNT(factura) AS "FACTURAS",
	SUM(total) AS "IMPORTE"
FROM
	mayorcab
WHERE
	anulada = 0
	AND YEAR(fecha) = 2007
GROUP BY
	MONTH(fecha)
ORDER BY
	MES

/*

3. RECUPERACI�N DE DATOS CON SUBCONSULTA

Listar los vendedores ACTIVOS que NO realizaron ventas minoristas en el periodo que va del 01/04/2006 al 30/06/2006.

Mostrar las columnas VENDEDOR (c�digo), NOMBRE, ENCARGADO y ACTIVO. Ordenar por nombre del vendedor.

TABLAS: vencab (suconsulta), vendedores (consulta principal) (EL RESULTADO DEBE RETORNAR 68 FILAS)

*/

--Prueba subconsulta (vendedores que SI hicieron ventas en el periodo especificado)

SELECT 
	DISTINCT vendedor 
FROM 
	vencab 
WHERE 
	fecha BETWEEN '2006-04-01' AND '2006-06-30'

--Consulta completa, incluyendo subconsulta

SELECT
	vendedor AS "VENDEDOR",
	nombre AS "NOMBRE",
	encargado AS "ENCARGADO"
FROM
	vendedores
WHERE
	activo = 'S'
	AND vendedor NOT IN (SELECT 
						DISTINCT vendedor 
					FROM 
						vencab 
					WHERE 
						fecha BETWEEN '2006-04-01' AND '2006-06-30')
ORDER BY
	nombre

/*

4. RECUPERACI�N DE DATOS CON UNION

Listar en una sola columna denominada "Factura" la LETRA + FACTURA (concatenadas) de las facturas realizadas por ventas minoristas
(vencab) en el mes de mayo del 2006, excluyendo las ventas anuladas. 

Luego listar el conjunto equivalente pero para ventas mayoristas (mayorcab), para el mismo periodo y excluyendo tambi�n
ventas anuladas.

Unir los dos conjuntos, agregando una columna "Tipo Venta" que indique si la factura es de venta mayorista o minorista.

Ordenar por la primer columna "Factura".

TABLAS: vencab (consulta 1), mayorcab (consulta 2) (EL RESULTADO DEBE RETORNAR 10738 FILAS)

*/

SELECT
	letra + TRIM(STR(factura)) AS "Factura", -- FACTURA ES NUM�RICA, DEBE CONVERTIRSE CON STR() PARA QUE PUEDA CONCATENARSE
	'Minorista' AS "Tipo Venta"
FROM
	vencab
WHERE
	anulada = 0
	AND fecha BETWEEN '2006-05-01' AND '2006-05-31'
--
UNION
--
SELECT
	letra + TRIM(STR(factura)) AS "Factura", -- FACTURA ES NUM�RICA, DEBE CONVERTIRSE CON STR() PARA QUE PUEDA CONCATENARSE
	'Mayorista' AS "Tipo Venta"
FROM
	mayorcab
WHERE
	anulada = 0
	AND fecha BETWEEN '2006-05-01' AND '2006-05-31'
--
ORDER BY 1

/*

5. RECUPERACI�N DE DATOS DE VARIAS TABLAS

Listar las facturas de ventas MAYORISTAS, generadas en el a�o 2007 por clientes de la provincia de C�rdoba.

Los clientes de la provincia de C�rdoba son aquellos cuyo c�digo postal (columna CP de la tabla CLIENTES) 
est� entre '5000' y '5999'. TENGA EN CUENTA QUE ESTA COLUMNA ES DE TIPO CHAR.

Mostrar en el resultado las columnas NOMBRE (cliente), CP, LETRA, FACTURA, FECHA y TOTAL.

Ordene por el nombre del cliente, y luego por el n�mero de factura. Excluya ventas anuladas.

TABLAS: clientes, mayorcab (EL RESULTADO DEBE RETORNAR 5327 FILAS)

*/

SELECT
	c.nombre AS "Cliente",
	c.cp AS "C�digo Postal",
	mc.letra AS "Letra",
	mc.factura AS "Factura",
	mc.fecha AS "Fecha",
	mc.total AS "Total"
FROM
	mayorcab AS mc
	INNER JOIN clientes AS c
	ON mc.cliente = c.cliente
WHERE
	mc.anulada = 0
	AND YEAR(mc.fecha) = 2007
	AND c.cp BETWEEN '5000' AND '5999'
ORDER BY
	"Cliente",
	"Letra",
	"Factura"

/*

6. RECUPERACI�N DE DATOS DE VARIAS TABLAS CON AGRUPAMIENTO

Partiendo de la base de la consulta anterior (con las mismas condiciones), muestre ahora las siguientes columnas: 

NOMBRE (cliente), CP, CANTIDAD DE FACTURAS (count), IMPORTE TOTAL (sum)

Ordene en forma DESCENDENTE por el IMPORTE TOTAL.

TABLAS: clientes, mayorcab (EL RESULTADO DEBE RETORNAR 142 FILAS)

*/

SELECT
	c.nombre AS "Cliente",
	c.cp AS "C�digo Postal",
	COUNT(mc.factura) AS "Cantidad de Facturas",
	SUM(mc.total) AS "Total"
FROM
	mayorcab AS mc
	INNER JOIN clientes AS c
	ON mc.cliente = c.cliente
WHERE
	mc.anulada = 0
	AND YEAR(mc.fecha) = 2007
	AND c.cp BETWEEN '5000' AND '5999'
GROUP BY
	c.nombre,
	c.cp
ORDER BY
	4 DESC

/*

7. RECUPERACI�N DE DATOS DE VARIAS TABLAS CON SUBCONSULTA Y AGRUPAMIENTO

El vendedor SIKORA ARIEL (144) fue quien mas ventas logr� en el a�o 2005 (en importe total). 

Se le solicita determinar qu� vendedores lo superaron (en importe total) en el a�o 2006. Debe excluir ventas anuladas en todas las consultas.

Mostrar VENDEDOR, NOMBRE, ENCARGADO (S o N), IMPORTE TOTAL. Ordene el resultado por importe total en forma decreciente.

TABLAS: vencab y vendedores (consulta principal), vencab (subconsulta). EL RESULTADO DEBE RETORNAR 4 FILAS.

*/

SELECT
	v.vendedor AS "Vendedor",
	v.nombre AS "Nombre",
	v.encargado AS "Encargado",
	SUM(total) AS "Importe Total 2006"
FROM
	vencab AS vc
	INNER JOIN vendedores AS v
	ON vc.vendedor = v.vendedor
WHERE
	vc.anulada = 0
	AND YEAR(vc.fecha) = 2006
GROUP BY
	v.vendedor,
	v.nombre,
	v.encargado
HAVING
	SUM(vc.total) > (SELECT SUM(total) 
					FROM vencab 
					WHERE vendedor = 144 
					AND anulada = 0 
					AND YEAR(fecha) = 2005)
ORDER BY
	4 DESC

/*

8. INSERCI�N SIMPLE

En la empresa ha ingresado un nuevo vendedor: LASPINA MARCELA (dni 30401211). Realice la instrucci�n correspondiente para 
darla de alta en la tabla VENDEDORES, teniendo en cuenta:
	- Determine previamente en una consulta el c�digo (columna VENDEDOR) que le corresponder�a, sum�ndole 1 al m�ximo valor.
	- La sucursal donde ingresa es VILLA CABRERA (determine el c�digo previamente)
	- La fecha de ingreso debe ser tomada en el momento de la inserci�n.
	- El nuevo vendedor deber� estar ACTIVO (activo = 'S'), y ser� ENCARGADO (encargado = 'S').

*/

-- DETERMINO EL C�DIGO DE VENDEDOR (1050 es valor mayor, 1051 el nuevo c�digo disponible)
SELECT MAX(vendedor) + 1 FROM vendedores

-- DETERMINO EL C�DIGO DE LA SUCURSAL "VILLA CABRERA"
SELECT sucursal FROM sucursales WHERE denominacion LIKE '%CABRERA%'

-- INSERCI�N
INSERT INTO vendedores
	(vendedor, nombre, sucursal, dni, ingreso, encargado, clave, activo)
VALUES
	(1051,'LASPINA MARCELA',5,30401211,GETDATE(),'S',NULL,'S')

/*

9. INSERCI�N MASIVA CON CREACI�N DE TABLA

Utilizando SELECT..INTO cree la tabla TmpVentasAccesorios. Esta tabla debe mostrar el total de ventas por rubro de
art�culo. Deber� incluir solamente los rubros: 76, 85, 77, 97, 70, 72, 87, 88.

La estructura de la tabla debe ser RUBRO (c�digo), NOMBRE, TOTAL (el total vendido de ese rubro). Tenga en cuenta:
	- Excluya ventas anuladas.
	- La nueva tabla deber� tener UNA FILA POR RUBRO, mostrando el importe total vendido.
	- Calcular el total vendido utilizando CANTIDAD * PRECIO de la tabla VENDET.

TABLAS: rubros, vencab, vendet, articulos (para el SELECT CON AGRUPAMIENTO). 

LA NUEVA TABLA DEBER� TENER 7 FILAS, UNA POR RUBRO (el rubro 72 no tuvo ventas).

*/

SELECT
	a.rubro AS "Rubro",
	r.nombre AS "Nombre",
	SUM(vd.cantidad * vd.precio) "Total Ventas"
INTO
	TmpVentasAccesorios
FROM
	vencab AS vc
	INNER JOIN vendet AS vd
	ON vd.letra = vc.letra AND vd.factura = vc.factura
	INNER JOIN articulos AS a
	ON a.articulo = vd.articulo
	INNER JOIN rubros AS r
	ON r.rubro = a.rubro
WHERE
	vc.anulada = 0
	AND a.rubro IN (76, 85, 77, 97, 70, 72, 87, 88)
GROUP BY
	a.rubro,
	r.nombre
ORDER BY 1

SELECT * FROM TmpVentasAccesorios -- VERIFICACI�N

/*

10. INSERCI�N MASIVA A TABLA EXISTENTE

Utilizando INSERT..SELECT agregue a la tabla TmpVentasAccesorios las ventas de art�culos de los rubros 89 y 99.

Tome como base la consulta del punto anterior.

TABLAS: rubros, vencab, vendet, articulos (para el SELECT). 

SE DEBER�N INSERTAR 2 FILAS EN LA TABLA.

*/

INSERT INTO TmpVentasAccesorios
SELECT
	a.rubro AS "Rubro",
	r.nombre AS "Nombre",
	SUM(vd.cantidad * vd.precio) "Total Ventas"
FROM
	vencab AS vc
	INNER JOIN vendet AS vd
	ON vd.letra = vc.letra AND vd.factura = vc.factura
	INNER JOIN articulos AS a
	ON a.articulo = vd.articulo
	INNER JOIN rubros AS r
	ON r.rubro = a.rubro
WHERE
	vc.anulada = 0
	AND a.rubro IN (89,99)
GROUP BY
	a.rubro,
	r.nombre
ORDER BY 1

SELECT * FROM TmpVentasAccesorios -- VERIFICACI�N

/*

11. ACTUALIZACI�N MASIVA DE FILAS

Reemplazar con valor 0 (cero) las columnas TERMINALPOSNET y CENTROCOSTO de la tabla SUCURSALES, solamente para aquellas
sucursales que NO est�n activas (Activa = 'N').

SE DEBEN ACTUALIZAR 4 FILAS DE LA TABLA SUCURSAL.

*/

UPDATE sucursales
SET terminalposnet = 0, centrocosto = 0
WHERE activa = 'N'

SELECT * FROM sucursales

/*

12. ELIMINACI�N MASIVA DE FILAS

Borre de la tabla TmpVentasAccesorios creada en el punto 9 y actualizada en el punto 10, las filas correspondientes a los
rubros que NO superaron los 20.000 en el total de ventas.

SE DEBEN ELIMINAR 4 FILAS DE LA TABLA.

*/

DELETE FROM TmpVentasAccesorios
WHERE "Total Ventas" <= 20000

SELECT * FROM TmpVentasAccesorios

/*

13. MODIFICACION DE DATOS CON TRANSACCIONES

Implemente en un bloque BEGIN TRANSACTION el borrado de TODAS las filas de la tabla GASTOS (tiene 3 filas).

Verifique si qued� vac�a (con 0 filas) y en caso afirmativo haga ROLLBACK para volver a la situaci�n inicial (con 3 filas).

*/

-- OPCION 1

BEGIN TRANSACTION

	TRUNCATE TABLE gastos

	IF NOT EXISTS (SELECT * FROM gastos)
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION

SELECT * FROM gastos -- VERIFICACI�N

-- OPCION 2

BEGIN TRANSACTION

	DELETE FROM gastos

	SELECT * FROM gastos

	IF @@ROWCOUNT = 0
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION

SELECT * FROM gastos -- VERIFICACI�N

/*

14. PROCEDIMIENTO ALMACENADO SIMPLE

Cree el procedimiento almacenado "sp_articulos_marca" que retorne solamente la cantidad de art�culos perteneciente
a una determinada marca. La marca debe ser solicitada como par�metro de entrada por el procedimiento.

Debe mostrar el mensaje "Existen [cantidad] art�culos de la marca [c�digo]."

Ejecute el procedimiento con la marca 'B' para probar. DEBE RETORNAR EL MENSAJE: Existen 1510 art�culos de la marca B.

*/

CREATE OR ALTER PROCEDURE sp_articulos_marca
	@m char(1)
AS
DECLARE
	@c int
BEGIN
	SELECT @c = COUNT(*)
	FROM articulos
	WHERE marca = @m
	--
	PRINT 'Existen ' + TRIM(STR(@c)) + ' art�culos de la marca ' + TRIM(@m) + '.'
END

-- EJECUCI�N
EXEC sp_articulos_marca 'B'

/*

15. PROCEDIMIENTO ALMACENADO CON MANEJO DE ERRORES

Implemente un procedimiento almacenado que permita insertar nuevos rubros en la tabla correspondiente.

El procedimiento deber� tener el nombre "sp_inserta_rubro", y debe solicitar como par�metros de entrada 
el CODIGO (rubro) y NOMBRE.

Utilice manejo de transacciones para volver atr�s la inserci�n en caso de error.

Se deber� validar la ocurrencia de errores, mostrando los siguientes mensajes:
	- El rubro [c�digo] ya existe en la tabla. (CUANDO SE QUIERA INGRESAR UN RUBRO EXISTENTE).
	- El rubro [nombre] fue dado de alta correctamente. (EN CASO DE �XITO)
	- Se produjo un error durante la inserci�n. (EN CASO DE QUE FALLE LA INSERCI�N)

Realice dos ejecuciones de prueba, una con un rubro nuevo, y otra con un rubro existente.

*/

CREATE OR ALTER PROCEDURE sp_inserta_rubro
	@r int,
	@n char(30)
AS
DECLARE
	@e int
BEGIN
	BEGIN TRANSACTION
	--
	INSERT INTO rubros (rubro,nombre) VALUES (@r,@n)
	--
	SET @e = @@ERROR
	--
	IF @e=0
		BEGIN
			COMMIT TRANSACTION
			PRINT 'El rubro ' + TRIM(@n) + ' se insert� correctamente.'
		END
	ELSE
		BEGIN
			ROLLBACK TRANSACTION
			IF @e=2627
				PRINT 'El rubro ' + TRIM(STR(@r)) + ' ya existe en la tabla.'
			ELSE
				PRINT 'Se produjo un error durante la inserci�n.'
		END
END

-- EJECUCI�N
EXEC sp_inserta_rubro 1001, 'NUEVO RUBRO'

/*

16. PROCEDIMIENTO ALMACENADO CON USO DE TRY / CATCH

Implemente el mismo procedimiento anterior, con el mismo comportamiento, pero utilizando para el manejo de errores
los bloques TRY y CATCH.

Realice dos ejecuciones de prueba, una con un rubro nuevo, y otra con un rubro existente.

*/

CREATE OR ALTER PROCEDURE sp_inserta_rubro
	@r int,
	@n char(30)
AS

BEGIN TRY
	BEGIN TRANSACTION
	--
	INSERT INTO rubros (rubro,nombre) VALUES (@r,@n)
	--
	COMMIT TRANSACTION
	--
	PRINT 'El rubro ' + TRIM(@n) + ' se insert� correctamente.'
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	--
	IF ERROR_NUMBER() = 2627
		PRINT 'El rubro ' + TRIM(STR(@r)) + ' ya existe en la tabla.'
	ELSE
		PRINT 'Se produjo un error durante la inserci�n.'
END CATCH

-- EJECUCI�N
EXEC sp_inserta_rubro 1002, 'NUEVO RUBRO'