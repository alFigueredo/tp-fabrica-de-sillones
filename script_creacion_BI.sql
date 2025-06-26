DROP TABLE IF EXISTS GDDIENTOS.BI_Compra;
DROP TABLE IF EXISTS GDDIENTOS.BI_Envio;
DROP TABLE IF EXISTS GDDIENTOS.BI_Venta_Modelo;
DROP TABLE IF EXISTS GDDIENTOS.BI_Facturacion;
DROP TABLE IF EXISTS GDDIENTOS.BI_Pedido;
DROP TABLE IF EXISTS GDDIENTOS.BI_Tiempo;
DROP TABLE IF EXISTS GDDIENTOS.BI_Sucursal;
DROP TABLE IF EXISTS GDDIENTOS.BI_Ubicacion;
DROP TABLE IF EXISTS GDDIENTOS.BI_Rango_Etario;
DROP TABLE IF EXISTS GDDIENTOS.BI_Turno_Ventas;
DROP TABLE IF EXISTS GDDIENTOS.BI_Tipo_Material;
DROP TABLE IF EXISTS GDDIENTOS.BI_Modelo_Sillon;
DROP TABLE IF EXISTS GDDIENTOS.BI_Estado_Pedido;
DROP TABLE IF EXISTS GDDIENTOS.BI_Envio_Cumplido;
GO

CREATE TABLE GDDIENTOS.BI_Envio_Cumplido
(
    bi_envio_cumplido_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    bi_envio_cumplido VARCHAR(2) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Estado_Pedido
(
    bi_estado_pedido_codigo BIGINT PRIMARY KEY,
    bi_estado_pedido VARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Modelo_Sillon
(
    bi_modelo_sillon_codigo BIGINT PRIMARY KEY,
    bi_modelo_sillon VARCHAR(255) NOT NULL,
    bi_modelo_sillon_descripcion VARCHAR(255) NOT NULL,
    bi_modelo_sillon_precio DECIMAL(12,2) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Tipo_Material
(
    bi_tipo_material_codigo BIGINT PRIMARY KEY,
    bi_tipo_material VARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Turno_Ventas
(
    bi_turno_ventas_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    bi_turno_ventas VARCHAR(50) NOT NULL,
    bi_turno_ventas_desde TIME NOT NULL,
    bi_turno_ventas_hasta TIME NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Rango_Etario
(
    bi_rango_etario_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    bi_rango_etario VARCHAR(50) NOT NULL,
    bi_rango_etario_desde INT NOT NULL,
    bi_rango_etario_hasta INT NULL
);

CREATE TABLE GDDIENTOS.BI_Ubicacion
(
    bi_ubicacion_codigo BIGINT PRIMARY KEY,
    bi_ubicacion_provincia VARCHAR(255) NOT NULL,
    bi_ubicacion_localidad VARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Sucursal
(
    bi_sucursal_codigo BIGINT PRIMARY KEY,
    bi_sucursal_ubicacion BIGINT NOT NULL,
    bi_sucursal_direccion NVARCHAR(255) NOT NULL,
    bi_sucursal_telefono NVARCHAR(255) NOT NULL,
    bi_sucursal_mail NVARCHAR(255) NOT NULL,
    FOREIGN KEY (bi_sucursal_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo)
);

CREATE TABLE GDDIENTOS.BI_Tiempo
(
    bi_tiempo_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    bi_tiempo_anio INT NOT NULL,
    bi_tiempo_mes DECIMAL(2,0) NOT NULL,
    bi_tiempo_cuatrimestre DECIMAL(1,0) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Pedido
(
    bi_pedido_codigo DECIMAL(18,0) PRIMARY KEY,
    bi_pedido_tiempo BIGINT NOT NULL,
    bi_pedido_sucursal BIGINT NOT NULL,
    bi_pedido_ubicacion BIGINT NOT NULL,
    bi_pedido_turno_ventas BIGINT NOT NULL,
    bi_pedido_estado BIGINT NOT NULL,
    bi_pedido_total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (bi_pedido_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
    FOREIGN KEY (bi_pedido_sucursal) REFERENCES GDDIENTOS.BI_Sucursal(bi_sucursal_codigo),
    FOREIGN KEY (bi_pedido_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
    FOREIGN KEY (bi_pedido_turno_ventas) REFERENCES GDDIENTOS.BI_Turno_Ventas(bi_turno_ventas_codigo),
    FOREIGN KEY (bi_pedido_estado) REFERENCES GDDIENTOS.BI_Estado_Pedido(bi_estado_pedido_codigo)
);

CREATE TABLE GDDIENTOS.BI_Facturacion
(
    bi_facturacion_codigo BIGINT PRIMARY KEY,
    bi_facturacion_tiempo BIGINT NOT NULL,
    bi_facturacion_sucursal BIGINT NOT NULL,
    bi_facturacion_ubicacion BIGINT NOT NULL,
    bi_facturacion_total DECIMAL(38,2) NOT NULL,
    FOREIGN KEY (bi_facturacion_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
    FOREIGN KEY (bi_facturacion_sucursal) REFERENCES GDDIENTOS.BI_Sucursal(bi_sucursal_codigo),
    FOREIGN KEY (bi_facturacion_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo)
);

CREATE TABLE GDDIENTOS.BI_Venta_Modelo
(
    bi_venta_modelo_codigo BIGINT PRIMARY KEY,
    bi_venta_modelo_tiempo BIGINT NOT NULL,
    bi_venta_modelo_sucursal BIGINT NOT NULL,
    bi_venta_modelo_ubicacion BIGINT NOT NULL,
    bi_venta_modelo_modelo BIGINT NOT NULL,
    bi_venta_modelo_rango_etario BIGINT NOT NULL,
    bi_venta_modelo_total DECIMAL(38,2) NOT NULL,
    FOREIGN KEY (bi_venta_modelo_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
    FOREIGN KEY (bi_venta_modelo_sucursal) REFERENCES GDDIENTOS.BI_Sucursal(bi_sucursal_codigo),
    FOREIGN KEY (bi_venta_modelo_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
    FOREIGN KEY (bi_venta_modelo_modelo) REFERENCES GDDIENTOS.BI_Modelo_Sillon(bi_modelo_sillon_codigo),
    FOREIGN KEY (bi_venta_modelo_rango_etario) REFERENCES GDDIENTOS.BI_Rango_Etario(bi_rango_etario_codigo)
);

CREATE TABLE GDDIENTOS.BI_Envio
(
    bi_envio_codigo DECIMAL(18,0) PRIMARY KEY,
    bi_envio_tiempo_programado BIGINT NOT NULL,
    bi_envio_ubicacion BIGINT NOT NULL,
    bi_envio_cumplido BIGINT NOT NULL,
    bi_envio_total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (bi_envio_tiempo_programado) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
    FOREIGN KEY (bi_envio_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
    FOREIGN KEY (bi_envio_cumplido) REFERENCES GDDIENTOS.BI_Envio_Cumplido(bi_envio_cumplido_codigo)
);

CREATE TABLE GDDIENTOS.BI_Compra
(
    bi_compra_codigo DECIMAL(18,0) PRIMARY KEY,
    bi_compra_tiempo BIGINT NOT NULL,
    bi_compra_sucursal BIGINT NOT NULL,
    bi_compra_ubicacion BIGINT NOT NULL,
    bi_compra_tipo_material BIGINT NOT NULL,
    bi_compra_total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (bi_compra_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
    FOREIGN KEY (bi_compra_sucursal) REFERENCES GDDIENTOS.BI_Sucursal(bi_sucursal_codigo),
    FOREIGN KEY (bi_compra_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
    FOREIGN KEY (bi_compra_tipo_material) REFERENCES GDDIENTOS.BI_Tipo_Material(bi_tipo_material_codigo)
);
GO


CREATE OR ALTER PROCEDURE migrar_bi_envio_cumplido
AS
BEGIN
	SET NOCOUNT ON; -- Al comentar esto, se imprimen las filas afectadas, sirve para comparar

	INSERT INTO GDDIENTOS.BI_Envio_Cumplido
        (bi_envio_cumplido)
    VALUES
        ('SI'),
		('NO')
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_estado_pedido
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Estado_Pedido
        (bi_estado_pedido_codigo, bi_estado_pedido)
	SELECT estado_numero, estado_tipo
		FROM GDDIENTOS.Estado
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_modelo_sillon
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Modelo_Sillon
        (bi_modelo_sillon_codigo, bi_modelo_sillon,
		bi_modelo_sillon_descripcion, bi_modelo_sillon_precio)
	SELECT sillon_modelo_codigo, sillon_modelo,
		sillon_modelo_descripcion, sillon_modelo_precio
	FROM GDDIENTOS.Sillon_Modelo
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_tipo_material
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Tipo_Material
		(bi_tipo_material_codigo, bi_tipo_material)
	SELECT tipo_material_codigo, tipo_material_nombre
	FROM GDDIENTOS.Tipo_Material
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_turno_ventas
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Turno_Ventas
		(bi_turno_ventas, bi_turno_ventas_desde,
		bi_turno_ventas_hasta)
	VALUES
		('08:00 - 14:00', '08:00', '14:00'),
		('14:00 - 20:00', '14:00', '20:00:01')
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_rango_etario
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Rango_Etario
		(bi_rango_etario, bi_rango_etario_desde,
		bi_rango_etario_hasta)
	VALUES
		('< 25', 0, 25),
		('25 - 35', 25, 35),
		('35 - 50', 35, 50),
		('> 50', 50, NULL)
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_ubicacion
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Ubicacion
		(bi_ubicacion_codigo, bi_ubicacion_provincia,
		bi_ubicacion_localidad)
	SELECT localidad_codigo, provincia_nombre,
		localidad_nombre
	FROM GDDIENTOS.Localidad
		JOIN GDDIENTOS.Provincia ON localidad_provincia = provincia_codigo
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_sucursal
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Sucursal
		(bi_sucursal_codigo, bi_sucursal_ubicacion,
		bi_sucursal_direccion, bi_sucursal_telefono,
		bi_sucursal_mail)
	SELECT sucursal_codigo, sucursal_localidad,
		sucursal_direccion, sucursal_telefono,
		sucursal_mail
	FROM GDDIENTOS.Sucursal
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_tiempo
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Tiempo
		(bi_tiempo_anio, bi_tiempo_mes,
		bi_tiempo_cuatrimestre)
	SELECT YEAR(pedido_fecha), MONTH(pedido_fecha),
		(MONTH(pedido_fecha)+2)/3
	FROM GDDIENTOS.Pedido
	GROUP BY YEAR(pedido_fecha), MONTH(pedido_fecha)
	UNION
	SELECT YEAR(factura_fecha), MONTH(factura_fecha),
		(MONTH(factura_fecha)+2)/3
	FROM GDDIENTOS.Factura
	GROUP BY YEAR(factura_fecha), MONTH(factura_fecha)
	UNION
	SELECT YEAR(envio_fecha_programada), MONTH(envio_fecha_programada),
		(MONTH(envio_fecha_programada)+2)/3
	FROM GDDIENTOS.Envio
	GROUP BY YEAR(envio_fecha_programada), MONTH(envio_fecha_programada)
	UNION
	SELECT YEAR(compra_fecha), MONTH(compra_fecha),
		(MONTH(compra_fecha)+2)/3
	FROM GDDIENTOS.Compra
	GROUP BY YEAR(compra_fecha), MONTH(compra_fecha)
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_pedido
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Pedido
		(bi_pedido_codigo, bi_pedido_tiempo, bi_pedido_sucursal,
		bi_pedido_ubicacion, bi_pedido_turno_ventas,
		bi_pedido_estado, bi_pedido_total)
	SELECT pedido_numero, (
			SELECT TOP 1 bi_tiempo_codigo
			FROM GDDIENTOS.BI_Tiempo
			WHERE YEAR(pedido_fecha)=bi_tiempo_anio
				AND MONTH(pedido_fecha)=bi_tiempo_mes
		), pedido_sucursal, sucursal_localidad, (
			SELECT TOP 1 bi_turno_ventas_codigo
			FROM GDDIENTOS.BI_Turno_Ventas
			WHERE CAST(pedido_fecha AS TIME) >= bi_turno_ventas_desde
				AND CAST(pedido_fecha AS TIME) < bi_turno_ventas_hasta
		), pedido_estado, pedido_total
	FROM GDDIENTOS.Pedido
	JOIN GDDIENTOS.Sucursal ON pedido_sucursal=sucursal_codigo
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_bi_facturacion
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Facturacion
		(bi_facturacion_codigo, bi_facturacion_tiempo,
		bi_facturacion_sucursal, bi_facturacion_ubicacion,
		bi_facturacion_total)
	SELECT factura_numero, (
			SELECT TOP 1 bi_tiempo_codigo
			FROM GDDIENTOS.BI_Tiempo
			WHERE YEAR(factura_fecha)=bi_tiempo_anio
				AND MONTH(factura_fecha)=bi_tiempo_mes
		), factura_sucursal, sucursal_localidad,
		factura_total
	FROM GDDIENTOS.Factura
	JOIN GDDIENTOS.Sucursal ON factura_sucursal=sucursal_codigo
	;
END;
GO

CREATE OR ALTER PROCEDURE migrar_todo_bi
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC migrar_bi_envio_cumplido;
        EXEC migrar_bi_estado_pedido;
        EXEC migrar_bi_modelo_sillon;
        EXEC migrar_bi_tipo_material;
        EXEC migrar_bi_turno_ventas;
        EXEC migrar_bi_rango_etario;
        EXEC migrar_bi_ubicacion;
        EXEC migrar_bi_sucursal;
        EXEC migrar_bi_tiempo;
        EXEC migrar_bi_pedido;
        EXEC migrar_bi_facturacion;

        COMMIT TRANSACTION;
        PRINT 'Migracion bi completa.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC migrar_todo_bi;
