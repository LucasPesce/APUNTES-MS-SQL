/****************************************************| APUNTE Nº 3: UPDATE - INSERT - INSERT INTO - TRUNCATE - DELETE - DROP - CREATE TABLE |****************************************************/

/*-----| UPDATE SET |-----*/
-- UPDATE SET: Se utiliza para modificar un registro existente de una tabla.

--UPDATE: Selecciona la tabla que se desea modificar.
--SET: Se ingresa el campo, con el nuevo valor que se desea asignar.
--WHERE: Indica el registro que se desea cambiar.

UPDATE 
	marcas
SET
	nombre = 'VANS', activo = 'S' 
WHERE
	marca = 'V'

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| INSERT INTO VALUE |-----*/

--INSERT INTO (campo 1, campo2): Permite seleccionar la tabla a la que se desea insertar nuevos datos
--								 Se puede definir el orden de los campos para el cargado de datos, en caso de no definirlo
--								 Es el orden predeterminado

-- VALUE(registro 1, registro 2): Es el comando que nos permite ingresar los datos que se desean insertar.

INSERT INTO encargados
	(dni,nombre,ingreso,activo)
VALUES
	(99999999,'ENCARGADO NUEVO',GETDATE(),'S')


/*_________________________________________________________________________________________________________________________________________________*/

/*-----| INSERT INTO |-----*/

-- INSERT INTO: Realiza a partir de una consulta (SELECT), la inserción de datos a una tabla ya existente.

INSERT INTO encargados			--	<---------------------

SELECT 
	dni,
	nombre,
	ingreso,
	activo 
FROM 
	vendedores 
WHERE
	encargado = 'S'


/*_________________________________________________________________________________________________________________________________________________*/

/*-----| INTO  |-----*/

--INSERT: Realiza a partir de una consulta (SELECT), la creación de una nueva tabla y la inserción de datos a esta, utilizando los registros de la consulta

SELECT
	dni,
	nombre,
	ingreso,
	activo
INTO								--	<---------------------
	[ENCARGADOS - TABLA NUEVA]
FROM
	vendedores 
WHERE 
	encargado = 'S'

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| TRUNCATE | DELETE | DROP |-----*/

-- DROP: Permite borrar por completo el objeto seleccionado, sea una Base de Datos, Tabla, Procedimientos, Triggers, Views.
-- TRUNCATE: Permite borrar TODOS los registros de la tabla seleccionada. TODOS sin exepcion. No admite WHERE
-- DELETE: Permite borrar los registros selecciondos, de la tabla seleccionada. Es mas flexible de TRUNCATE. Admite los filtros de WHERE

-- Ejemplo de DELETE
DROP TABLE Gastos

-- Ejemplo de TRUNCATE
TRUNCATE TABLE temp_sucursales

-- Ejemplo de DELETE
DELETE FROM 
	marcas
WHERE 
	marca IN('W','V')

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| CREACIÓN DE BASE DE DATOS |-----*/

CREATE DATABASE VentasIntegrada;

/*_________________________________________________________________________________________________________________________________________________*/

/*-----| CREACIÓN DE TABLAS |-----*/

CREATE TABLE T_VENTAS_DETALLE 
(				
	Letra CHAR (1) NOT NULL,
	Factura DECIMAL (12,0) NOT NULL,
	IdArticulo CHAR (10) NOT NULL,
	Talle CHAR (2) NOT NULL,
	Color INT NOT NULL,
	Cantidad INT NOT NULL,
	PrecioLista DECIMAL (8,2) NOT NULL,
	PrecioVenta DECIMAL (8,2) NOT NULL,

	/*	Si tiene llave primaria agregar:	*/
	CONSTRAINT PK_T_VENTAS_DETALLE PRIMARY KEY (		
		Letra,
		Factura,
		IdArticulo,
		Talle,
		Color)
);


