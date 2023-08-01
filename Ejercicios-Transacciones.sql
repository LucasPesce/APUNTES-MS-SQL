/*

EJERCICIO 1

Cree el procedimiento almacenado "sp_ArticulosSinVentas" que, recibiendo como par�metro un a�o determinado,
cree la tabla TmpArticulosSinVentas. Esta tabla deber� contener los art�culos que no registraron ninguna venta
en el a�o especificado. La estructura de la tabla debe ser: art�culo (c�digo), nombre, marca (nombre), 
rubro (nombre), preciomayor y preciomenor. 

El procedimiento deber� validar la existencia de la tabla y contar con manejo de errores y mensajes con el 
resumen de las filas insertadas.

*/

CREATE OR ALTER PROCEDURE sp_ArticulosSinVentas
	@a�o int
AS
DECLARE
	@filas int
BEGIN TRY
	BEGIN TRANSACTION
	--
	IF OBJECT_ID('TmpArticulosSinVentas') IS NOT NULL DROP TABLE TmpArticulosSinVentas
	--
	SELECT
		a.articulo AS Articulo,
		a.nombre AS Nombre,
		m.nombre AS Marca,
		r.nombre AS Rubro,
		a.preciomayor AS PrecioMayor,
		a.preciomenor AS PrecioMenor
	INTO
		TmpArticulosSinVentas
	FROM
		articulos AS a
		INNER JOIN rubros AS r		ON a.rubro = r.rubro
		INNER JOIN marcas AS m		ON a.marca = m.marca
	WHERE
		a.articulo NOT IN (
			SELECT DISTINCT vd.articulo 
			FROM vencab AS vc 
			INNER JOIN vendet AS vd			ON vc.letra = vd.letra AND vc.factura = vd.factura
			WHERE vc.anulada = 0
			AND YEAR(vc.fecha) = @a�o)
		--
		SET @filas = @@ROWCOUNT
		--
		COMMIT TRANSACTION
		--
		PRINT 'Se insertaron ' + TRIM(STR(@filas)) + ' filas en la tabla.'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	--
	PRINT 'Se produjo un error durante la inserci�n. La tabla no fue actualizada.'
END CATCH

-- SCRIPTS DE PRUEBA

EXEC sp_ArticulosSinVentas 2007

SELECT * FROM TmpArticulosSinVentas

DROP TABLE TmpArticulosSinVentas

/*

EJERCICIO 2

Realizar un Procedimiento Almacenado que permita a partir de la recepci�n como par�metro de un c�digo de vendedor, 
un A�o y un Mes, realice el comparativo de ventas entre el mes y a�o ingresados, y el mismo mes y a�o
correspondiente al a�o anterior. 

El procedimiento deber� llamarse "sp_ComparativoVentas", y deber� retornar una fila con las siguientes columnas:
- Vendedor
- Nombre
- A�o/Mes
- Cantidad (cantidad de facturas realizadas)
- Importe (importe total facturado)
- A�o/Mes Anterior
- Cantidad Anterior
- Importe Anterior

Ejemplo de salida:

Vendedor Nombre              A�o/Mes Cantidad Importe     A�o/Mes Anterior Cantidad Anterior Importe Anterior
-------- ------------------- ------- -------- ----------- ---------------- ----------------- ----------------
10       ROMINA TORRES       2005/7	 161      13309.50	  2004/7           216               13801.75

En el caso de que el vendedor no tenga ventas en el A�o y Mes ingresados, se debe mostrar el mensaje
'No se registraron ventas de ese vendedor en el a�o y mes ingresados.'

*/

CREATE OR ALTER PROCEDURE sp_ComparativoVentas
	@vendedor int,
	@a�o int,
	@mes int
AS

BEGIN
		
	DECLARE
		@cant INT,
		@vant DECIMAL(9,2)

	-- CANTIDADES Y VENTAS DEL A�O/MES ANTERIOR

	SELECT
		@cant = COUNT(*),
		@vant = SUM(vc.total)
	FROM
		vencab AS vc
	WHERE
		vc.anulada = 0
		AND vc.vendedor = @vendedor
		AND YEAR(vc.fecha) = @a�o - 1
		AND MONTH(vc.fecha) = @mes

	-- DATOS ACTUALES

	IF EXISTS (	SELECT * FROM vencab AS vc WHERE vc.anulada = 0 AND vc.vendedor = @vendedor 
				AND YEAR(vc.fecha) = @a�o AND MONTH(vc.fecha) = @mes )

		SELECT
			vc.vendedor AS "Vendedor",
			v.nombre AS "Nombre",
			TRIM(STR(@a�o)) + '/' + TRIM(STR(@mes)) AS "A�o/Mes",
			COUNT(*) AS "Cantidad",
			SUM(vc.total) AS "Importe",
			TRIM(STR(@a�o - 1)) + '/' + TRIM(STR(@mes)) AS "A�o/Mes Anterior",
			@cant AS "Cantidad Anterior",
			@vant AS "Importe Anterior"
		FROM
			vencab AS vc
			INNER JOIN vendedores AS v ON v.vendedor = vc.vendedor
		WHERE
			vc.anulada = 0
			AND vc.vendedor = @vendedor
			AND YEAR(vc.fecha) = @a�o
			AND MONTH(vc.fecha) = @mes
		GROUP BY
			vc.vendedor,
			v.nombre
	ELSE
		PRINT 'No se registraron ventas de ese vendedor en el a�o y mes ingresados.'
END

-- SCRIPTS DE PRUEBA

EXEC sp_ComparativoVentas 21, 2005, 7