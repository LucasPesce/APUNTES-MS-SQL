/*********************************************************|APUNTE Nº 4: PROCEDIMIENTOS & TRANSACCIONES |*********************************************************/

/*-----| COMANDOS UTILIZADOS |-----*/

-- DECLARE: Permite declarar parametros con su tipo de datos y configuracion del mismo (capacidad, cantidad de enteros, decimales, etc)

-- TRIM (String): Quita el pespaciado de ambos lados del String. LTRIM / RTRIM permite quitar el espacio segun el lado que se le indica L/R

-- STR(int/float/decimal) : Convierte un valor en Sring

-- EXISTS (SUB-CONSULTA): Devuelve TRUE o FALSE, segun si la consulta que se le asigna, AFECTA alguna fila.

-- OBJECT_ID([nombre_objeto]): Retorna NULL, si un objeto no existe. Si existe,retorna un número entero que identifica al objeto.

-- @@ERROR: Muestra el CODIGO DE ERROR, de la ultima instruccion mas realizada
-- @@ROWCOUNT: Muestra el numero de filas afectadas
-- @@TRANCOUNT: Muestra el numero de Transacciones activas actualmente.

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| TRANSACCIONES |-----*/

-- BEGIN: Indica que se inicializara un grupo de instrucciones, que se daran por terminado por medio del END
-- BEGIN TRANSACITION: Indica que se inicializa un grupo de instrucciones, en las cuales estaran presente los comandos COMMIT / ROLLBACK

-- COMMIT TRANSACTION: Permite GUARDAR los cambios realizados en la base de datos
-- ROLLBACK TRANSACTION: Permite DESHACER los cambios realizados en las bases de datos

DECLARE  -- Permite declarar parametros, para luego asignarles valor o ser utilizados
	@Error int	--@NombreDelParametro TipoDeDato (Limite) en caso de ser necesario.

BEGIN TRANSACTION	-- Comienza el conjunto de instrucciones. Se empleara los comandos COMMIT / ROLLBACK
	
	/*	1ER BLOQUE DE INTRUCCIONES	*/
	INSERT 
		marcas	
	VALUES
		('Y','YON FUS','N') 
	
	/*	Asignacion de valores a los parametros	*/
	SET @Error = @@ERROR	-- Se le asigna como valor el comando @@ERROR

	/*	VERIFICACIÓN DE ERRORES	*/
	IF @Error <> 0	-- CONDICION: Si hay errores, entonces....
		BEGIN --[I]
			/*	SUB-BLOQUE DE INTRUCCIONES	*/
			PRINT 'Se prujo el error: ' + STR(@Error)	-- Se imprime el mensaje de error utilizando el parametro asignado

			ROLLBACK TRANSACTION						-- ROLLBACK Deshace cualquier cambio realizado
		END

	ELSE		-- Caso contrario...
		BEGIN
			/*	SUB-BLOQUE DE INTRUCCIONES	*/
			PRINT 'La transacción se realizó con éxito <3' -- Se imprime el mensaje de transaccion realizada

			COMMIT TRANSACTION								-- Se guarda los cambios realizados
		END
END



/*_________________________________________________________________________________________________________________________________________________*/

/*-----| PROCEDIMIENTOS ALMACENADOS |-----*/

-- CREATE OR ALTER PROCEDUR: Permite crear o alterar un procedimiento

-- EXEC: Ejecuta el procedimiento o el tirgger al cual este llamando.


CREATE OR ALTER PROCEDURE sp_insertar_marca	--	Nombre del procedimiento
	
	/*	PARAMETROS DEL PROCEDIMIENTO	*/	-- @NombreParametro TipoDato (Configuración)
	@marca char(1),		 
	@nombre char(30),
	@activo char(1)
AS

BEGIN --[I]
	/*	1ER BLOQUE DE INTRUCCIONES	*/
	IF EXISTS (SELECT * FROM marcas WHERE marca = @marca)	-- CONDICION: Si la Marca Parametro, ya se encuentra en los registros.
		PRINT 'La marca ' + TRIM(@marca) + ' ya existe.'

	ELSE													-- CONDICION: Si no se encuentra en los registros, entonces...
		/*	SUB.BLOQUE DE INSTRUCCIONES	*/
		BEGIN --[II]	
			INSERT INTO 
				marcas	(marca, nombre, activo)	-- TABLA (campo 1, campo 2, campo 3)
			VALUES
				(@marca,@nombre,@activo)	-- (parametro 1, parametro 2, parametro 3)

			/*	VERIFICACIÓN DE ERRORES	*/
			IF @@ERROR <> 0					-- Si se produce algun error
				PRINT 'Hubo un problema! No se pudo insertar la marca.'

			ELSE							-- Si no hay errores
				PRINT 'La marca ' + TRIM(@nombre) + ' se insertó correctamente.'

		END --[II]
END --[I]


-- PRUEVAS DE EJECICION DEL PROCEDIMIENTO
EXEC sp_insertar_marca 'W','WRANGLER','S'
EXEC sp_insertar_marca 'X','XTREME','S'
EXEC sp_insertar_marca 'Y','YON FUS','S'

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| TRANSACCIONES TRY - CATCH |-----*/

-- BEGIN TRY: Inicia un bloque de instrucciones, que en caso de suceder algun error, se salteará directamente al BLOQUE CATCH.
--			   Es importante indicar donde termina el bloque por medio de la instruccion END TRY

-- BEGIN CATCH: Solo se activara este bloque de instrucciones, si sucede algun error en el BLOQUE TRY. 
--				Es importante indicar que el bloque termina con la instruccion END CATCH

CREATE OR ALTER PROCEDURE sp_insertar_marca
	@marca char(1), 
	@nombre char(30),
	@activo char(1)
AS

BEGIN TRY
	BEGIN TRANSACTION 
	/*	1ER BLOQUE DE INTRUCCIONES	*/
		INSERT INTO marcas
			(marca, nombre, activo)
		VALUES
			(UPPER(@marca),UPPER(@nombre),UPPER(@activo))

		COMMIT TRANSACTION	-- Se guarda los cambios realizados con exito

		PRINT 'La marca ' + TRIM(UPPER(@nombre)) + ' se insertó correctamente.'

END TRY

BEGIN CATCH	
	ROLLBACK TRANSACTION	-- Se deshace los cambios realizados
	
	/*	VERIFICACIÓN DE ERRORES	*/
	IF ERROR_NUMBER() = 2627 -- CONDICION:	EL ERROR 2627 ES DE CLAVE DUPLICADA (YA EXISTE LA MARCA)
		PRINT 'La marca ' + TRIM(UPPER(@marca)) + ' ya existe.' 

	ELSE
		PRINT 'Hubo un problema! No se pudo insertar la marca.'
	
END CATCH

EXEC sp_insertar_marca 'X','XTREME','S'
SELECT * FROM marcas -- CONSULTA DE COMPROBACIÓN

SELECT @@TRANCOUNT -- Cuenta si hay transacciones activas.

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| EJERCICIO 1 |-----*/
/*Desarrolle el SP "sp_ventas_anuales", que genera la tabla "tmp_ventas_anuales" que contiene el total de ventas minoristas por
artículo. La tabla debe tener las columnas ARTICULO, CANTIDAD, IMPORTE. Tenga en cuenta los siguientes puntos:

	- Se deben excluir ventas anuladas.
	- Se debe tomar para el cálculo del importe CANTIDAD * PRECIOVENTA de la tabla VENDET.
	- El procedimiento debe recibir como parámetro de entrada el AÑO, y generar la tabla con las ventas de ese año solamente.
	- Se debe evaluar la existencia de la tabla. Si no existe usar SELECT..INTO, y si existe usar TRUNCATE con INSERT..SELECT.
	- Realizar control de errores, mostrando el mensaje "La tabla fue generada con éxito, se insertaron [n] filas." en caso de
	  éxito, o en caso contrario "Se produjo un error durante la inserción. Contacte con el administrador". */



CREATE OR ALTER PROCEDURE sp_ventas_anuales
	@año int									-- PARAMETRO DEL PROCEDIMIENTO
AS
BEGIN
	/*	1ER BLOQUE DE INTRUCCIONES	*/
	DECLARE
		@filasAfectadas int						-- PARAMETRO INTERNO		
	
	/*	VERIFICACION DE ERRORES	*/
	IF OBJECT_ID('tmp_ventas_anuales') IS NULL	-- CONDICIÓN: Si dicha tabla no existe

		SELECT												-- Se selecciona estos campos
			vd.articulo AS "Artículo",
			SUM(vd.cantidad) AS "Cantidad",
			SUM(vd.cantidad * vd.precioventa) AS "Importe"
		INTO												-- Para introducirlos en esta NUEVA TABLA (Se crea)
			tmp_ventas_anuales
		FROM												-- Utilizando de fuente, esta tabla
			vencab AS vc
			INNER JOIN vendet AS vd
			ON vc.letra = vd.letra AND vc.factura = vd.factura
		WHERE												-- Teniendo en cuenta estas condiciones.
			vc.anulada = 0
			AND YEAR(vc.fecha) = @año
		GROUP BY
			vd.articulo

	ELSE										-- CONDICIÓN: Si ya exista dicha tabla
		/*	SUB-BLOQUE DE INSTRUCCIONES	*/
		BEGIN
			TRUNCATE TABLE tmp_ventas_anuales	-- Borrar los registros que contiene.
			
			INSERT INTO tmp_ventas_anuales		-- Insertar en esta tabla
			SELECT								-- La siguiente seleccion
				vd.articulo AS "Artículo",
				SUM(vd.cantidad) AS "Cantidad",
				SUM(vd.cantidad * vd.precioventa) AS "Importe"
			FROM
				vencab AS vc
				INNER JOIN vendet AS vd
				ON vc.letra = vd.letra AND vc.factura = vd.factura
			WHERE
				vc.anulada = 0
				AND YEAR(vc.fecha) = @año
			GROUP BY
				vd.articulo	
		END

	/*	Asignacion de valores a los parametros internos	*/
	SET @filasAfectadas = @@ROWCOUNT						-- Se le asigna lo que el el COMANDO contabilice (filas afectadas)
	
	/*	VERIFICACION DE ERRORES	*/
	IF @@ERROR <> 0								-- CONDICIÓN: Si existe algun ERROR

		PRINT 'Se produjo un error durante la inserción. Contacte con el administrador.'

	ELSE									   -- CONDICIÓN: Si no existe ningun error

		PRINT 'Se insertaron ' + TRIM(STR(@filasAfectadas)) + ' filas.'
END

EXEC sp_ventas_anuales 2006
SELECT * FROM tmp_ventas_anuales

DROP TABLE tmp_ventas_anuales

/*_________________________________________________________________________________________________________________________________________________*/
