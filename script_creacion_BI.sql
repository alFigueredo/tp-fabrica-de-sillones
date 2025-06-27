--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
USE GD1C2025;
GO

DROP TABLE

IF EXISTS GDDIENTOS.BI_Compra_Materiales;
DROP TABLE

IF EXISTS GDDIENTOS.BI_Compras;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Envios;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Ventas;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Facturacion;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Pedidos;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Tiempo;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Ubicacion;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Rango_Etario;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Turno;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Tipo_Material;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Modelo_Sillon;
	DROP TABLE

IF EXISTS GDDIENTOS.BI_Estado_Pedido;

-- Dimensiones

CREATE TABLE GDDIENTOS.BI_Estado_Pedido (
	bi_estado_pedido_codigo BIGINT PRIMARY KEY,
	bi_estado_pedido VARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Modelo_Sillon (
	bi_modelo_sillon_codigo BIGINT PRIMARY KEY,
	bi_modelo_sillon VARCHAR(255) NOT NULL,
	bi_modelo_sillon_descripcion VARCHAR(255) NOT NULL,
	bi_modelo_sillon_precio DECIMAL(12, 2) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Tipo_Material (
	bi_tipo_material_codigo BIGINT PRIMARY KEY,
	bi_tipo_material VARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Turno (
	bi_turno_codigo BIGINT IDENTITY(1, 1) PRIMARY KEY,
	bi_turno_detalle VARCHAR(50) NOT NULL,
	bi_turno_desde TIME NOT NULL,
	bi_turno_hasta TIME NOT NULL
);

CREATE TABLE GDDIENTOS.BI_Rango_Etario (
	bi_rango_etario_codigo BIGINT IDENTITY(1, 1) PRIMARY KEY,
	bi_rango_etario_detalle VARCHAR(50) NOT NULL,
	bi_rango_etario_desde INT NOT NULL,
	bi_rango_etario_hasta INT NULL
	);

CREATE TABLE GDDIENTOS.BI_Ubicacion (
	bi_ubicacion_codigo BIGINT PRIMARY KEY,
	bi_ubicacion_provincia VARCHAR(255) NOT NULL,
	bi_ubicacion_localidad VARCHAR(255) NOT NULL
	);

CREATE TABLE GDDIENTOS.BI_Tiempo (
	bi_tiempo_codigo BIGINT IDENTITY(1, 1) PRIMARY KEY,
	bi_tiempo_anio INT NOT NULL,
	bi_tiempo_mes DECIMAL(2, 0) NOT NULL,
	bi_tiempo_cuatrimestre DECIMAL(1, 0) NOT NULL
	);

-- Hechos

CREATE TABLE GDDIENTOS.BI_Pedidos (
	bi_pedidos_sucursal BIGINT NOT NULL,
	bi_pedidos_turno BIGINT NOT NULL,
	bi_pedidos_tiempo BIGINT NOT NULL,
	bi_pedidos_estado BIGINT NOT NULL,
	bi_pedidos_cantidad BIGINT NOT NULL,
	bi_pedidos_total DECIMAL(18, 2) NOT NULL,
	FOREIGN KEY (bi_pedidos_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
	FOREIGN KEY (bi_pedidos_turno) REFERENCES GDDIENTOS.BI_Turno(bi_turno_codigo),
	FOREIGN KEY (bi_pedidos_estado) REFERENCES GDDIENTOS.BI_Estado_Pedido(bi_estado_pedido_codigo)
	);

CREATE TABLE GDDIENTOS.BI_Facturacion (
	bi_facturacion_sucursal BIGINT NOT NULL,
	bi_facturacion_tiempo BIGINT NOT NULL,
	bi_facturacion_ubicacion BIGINT NOT NULL,
	bi_facturacion_tiempo_fabricacion INT NOT NULL,
	bi_facturacion_cantidad_facturas INT NOT NULL,
	bi_facturacion_total DECIMAL(38, 2) NOT NULL,
	FOREIGN KEY (bi_facturacion_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
	FOREIGN KEY (bi_facturacion_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
	); 

CREATE TABLE GDDIENTOS.BI_Ventas (
	bi_ventas_sucursal BIGINT NOT NULL,
	bi_ventas_tiempo BIGINT NOT NULL,
	bi_ventas_modelo BIGINT NOT NULL,
	bi_ventas_ubicacion BIGINT NOT NULL,
	bi_ventas_rango_etario BIGINT NOT NULL,
	bi_ventas_cantidad BIGINT NOT NULL,
	bi_ventas_total DECIMAL(38, 2) NOT NULL,
	FOREIGN KEY (bi_ventas_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
	FOREIGN KEY (bi_ventas_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
	FOREIGN KEY (bi_ventas_modelo) REFERENCES GDDIENTOS.BI_Modelo_Sillon(bi_modelo_sillon_codigo),
	FOREIGN KEY (bi_ventas_rango_etario) REFERENCES GDDIENTOS.BI_Rango_Etario(bi_rango_etario_codigo),
	);

CREATE TABLE GDDIENTOS.BI_Envios (
    bi_envios_ubicacion BIGINT NOT NULL,
    bi_envios_ubicacion_cliente BIGINT NOT NULL,
    bi_envios_tiempo BIGINT NOT NULL,
    bi_envios_total DECIMAL(18,0) NOT NULL,
    bi_envios_cumplidos INT NOT NULL,
    bi_envios_no_cumplidos INT NOT NULL,
	FOREIGN KEY (bi_envios_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
    FOREIGN KEY (bi_envios_ubicacion) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
    FOREIGN KEY (bi_envios_ubicacion_cliente) REFERENCES GDDIENTOS.BI_Ubicacion(bi_ubicacion_codigo),
);

CREATE TABLE GDDIENTOS.BI_Compras  (
	bi_compras_sucursal BIGINT NOT NULL,
	bi_compras_tiempo BIGINT NOT NULL,
	bi_compras_cantidad INT NOT NULL,
	bi_compras_total DECIMAL(18, 2) NOT NULL,
	FOREIGN KEY (bi_compras_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
	);

CREATE TABLE GDDIENTOS.BI_Compra_Materiales  (
	bi_compra_materiales_sucursal BIGINT NOT NULL,
	bi_compra_materiales_tiempo BIGINT NOT NULL,
	bi_compra_materiales_tipo_material BIGINT NOT NULL,
	bi_compra_materiales_cantidad INT NOT NULL,
	bi_compra_materiales_total DECIMAL(18, 2) NOT NULL,
	FOREIGN KEY (bi_compra_materiales_tiempo) REFERENCES GDDIENTOS.BI_Tiempo(bi_tiempo_codigo),
	FOREIGN KEY (bi_compra_materiales_tipo_material) REFERENCES GDDIENTOS.BI_Tipo_Material(bi_tipo_material_codigo)
	);
GO

CREATE
	OR
ALTER PROCEDURE migrar_bi_estado_pedido
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Estado_Pedido (
		bi_estado_pedido_codigo
		,bi_estado_pedido
		)
	SELECT estado_numero
		,estado_tipo
	FROM GDDIENTOS.Estado;
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_modelo_sillon
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Modelo_Sillon (
		bi_modelo_sillon_codigo
		,bi_modelo_sillon
		,bi_modelo_sillon_descripcion
		,bi_modelo_sillon_precio
		)
	SELECT sillon_modelo_codigo
		,sillon_modelo
		,sillon_modelo_descripcion
		,sillon_modelo_precio
	FROM GDDIENTOS.Sillon_Modelo;
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_tipo_material
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Tipo_Material (
		bi_tipo_material_codigo
		,bi_tipo_material
		)
	SELECT tipo_material_codigo
		,tipo_material_nombre
	FROM GDDIENTOS.Tipo_Material;
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_turno
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Turno (
		bi_turno_detalle 
		,bi_turno_desde 
		,bi_turno_hasta
		)
	VALUES ('08:00 - 14:00','08:00','14:00'),
		('14:00 - 20:00','14:00','20:00:01');
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_rango_etario
AS
BEGIN
	SET NOCOUNT ON;
	 
	INSERT INTO GDDIENTOS.BI_Rango_Etario (
		bi_rango_etario_detalle
		,bi_rango_etario_desde
		,bi_rango_etario_hasta
		)
	VALUES 
		('0 - 25', 0, 25),
		('25 - 35', 25, 35),
		('35 - 50', 35, 50),
		('50+', 50, NULL);
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_ubicacion
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Ubicacion (
		bi_ubicacion_codigo
		,bi_ubicacion_provincia
		,bi_ubicacion_localidad
		)
	SELECT localidad_codigo
		,provincia_nombre
		,localidad_nombre
	FROM GDDIENTOS.Localidad
	JOIN GDDIENTOS.Provincia ON localidad_provincia = provincia_codigo;
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_tiempo
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Tiempo (
		bi_tiempo_anio
		,bi_tiempo_mes
		,bi_tiempo_cuatrimestre
		)
	SELECT YEAR(pedido_fecha)
		,MONTH(pedido_fecha)
		,(MONTH(pedido_fecha) + 3) / 4
	FROM GDDIENTOS.Pedido
	GROUP BY YEAR(pedido_fecha)
		,MONTH(pedido_fecha)
	
	UNION
	
	SELECT YEAR(factura_fecha)
		,MONTH(factura_fecha)
		,(MONTH(factura_fecha) + 3) / 4
	FROM GDDIENTOS.Factura
	GROUP BY YEAR(factura_fecha)
		,MONTH(factura_fecha)
	
	UNION
	
	SELECT YEAR(envio_fecha_programada)
		,MONTH(envio_fecha_programada)
		,(MONTH(envio_fecha_programada) + 3) / 4
	FROM GDDIENTOS.Envio
	GROUP BY YEAR(envio_fecha_programada)
		,MONTH(envio_fecha_programada)
	
	UNION
	
	SELECT YEAR(compra_fecha)
		,MONTH(compra_fecha)
		,(MONTH(compra_fecha) + 3) / 4
	FROM GDDIENTOS.Compra
	GROUP BY YEAR(compra_fecha)
		,MONTH(compra_fecha);
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_pedidos
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Pedidos (
		bi_pedidos_sucursal,
		bi_pedidos_turno,
		bi_pedidos_tiempo,
		bi_pedidos_estado,
		bi_pedidos_cantidad,
		bi_pedidos_total
		)
	SELECT
		pedido_sucursal,
		bi_turno_codigo,
		bi_tiempo_codigo,
		pedido_estado,
		COUNT(pedido_numero) AS cantidad,
		SUM(pedido_total) AS total
	FROM GDDIENTOS.Pedido
		INNER JOIN GDDIENTOS.BI_Tiempo ON YEAR(pedido_fecha) = bi_tiempo_anio AND MONTH(pedido_fecha) = bi_tiempo_mes
		INNER JOIN GDDIENTOS.BI_Turno ON CAST(pedido_fecha AS TIME) >= bi_turno_desde AND CAST(pedido_fecha AS TIME) < bi_turno_hasta
	GROUP BY
		pedido_sucursal,
		bi_turno_codigo,
		bi_tiempo_codigo,
		pedido_estado
END;
GO


CREATE
	OR
ALTER PROCEDURE migrar_bi_compras
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Compras (
		bi_compras_sucursal
		,bi_compras_tiempo
		,bi_compras_cantidad
		,bi_compras_total
		)
	SELECT 
		compra_sucursal, 
		bi_tiempo_codigo,
		COUNT(compra_numero),
		SUM(compra_total)
	FROM GDDIENTOS.Compra 
		INNER JOIN GDDIENTOS.BI_Tiempo ON YEAR(compra_fecha) = bi_tiempo_anio AND MONTH(compra_fecha) = bi_tiempo_mes
	GROUP BY compra_sucursal, bi_tiempo_codigo
END;
GO

CREATE
	OR
ALTER PROCEDURE migrar_bi_compra_materiales
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Compra_Materiales (
		bi_compra_materiales_sucursal
		,bi_compra_materiales_tiempo
		,bi_compra_materiales_tipo_material
		,bi_compra_materiales_cantidad
		,bi_compra_materiales_total
		)
	SELECT 
		compra_sucursal, 
		bi_tiempo_codigo,
		material_tipo,
		SUM(item_compra_cantidad),
		SUM(item_compra_subtotal)
	FROM GDDIENTOS.Compra 
		INNER JOIN GDDIENTOS.Item_Compra ON compra_numero = item_compra_codigo_compra
		INNER JOIN GDDIENTOS.Material ON item_compra_material = material_codigo
		INNER JOIN GDDIENTOS.BI_Tiempo ON YEAR(compra_fecha) = bi_tiempo_anio AND MONTH(compra_fecha) = bi_tiempo_mes
	GROUP BY compra_sucursal, bi_tiempo_codigo, material_tipo
END;
GO

CREATE 
OR
ALTER FUNCTION GDDIENTOS.fn_ObtenerRangoEtario (
    @FechaNacimiento DATE
)
RETURNS BIGINT
AS
BEGIN
    DECLARE @Edad INT;
    DECLARE @Rango BIGINT;

    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, GETDATE());
    IF DATEADD(YEAR, @Edad, @FechaNacimiento) > GETDATE()
        SET @Edad = @Edad - 1;

    SELECT TOP 1 @Rango = bi_rango_etario_codigo
    FROM GDDIENTOS.BI_Rango_Etario
    WHERE @Edad >= bi_rango_etario_desde
      AND (@Edad < bi_rango_etario_hasta OR bi_rango_etario_hasta IS NULL)
	;

    RETURN @Rango;
END;
GO

CREATE
    OR
ALTER PROCEDURE migrar_bi_ventas
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO GDDIENTOS.BI_Ventas (
        bi_ventas_sucursal
        ,bi_ventas_tiempo
        ,bi_ventas_modelo
        ,bi_ventas_ubicacion 
        ,bi_ventas_rango_etario 
        ,bi_ventas_cantidad 
        ,bi_ventas_total 
        )
    SELECT 
        factura_sucursal,
        bi_tiempo_codigo,
        sillon_modelo,
        sucursal_localidad,
        GDDIENTOS.fn_ObtenerRangoEtario(cliente_fechaNacimiento),
        SUM(item_factura_cantidad),
        SUM(item_factura_subtotal)

    FROM GDDIENTOS.Factura 
    INNER JOIN GDDIENTOS.BI_Tiempo ON YEAR(factura_fecha) = bi_tiempo_anio AND MONTH(factura_fecha) = bi_tiempo_mes
    INNER JOIN GDDIENTOS.Sucursal ON factura_sucursal = sucursal_codigo
    INNER JOIN GDDIENTOS.Cliente ON factura_cliente = cliente_codigo
    INNER JOIN GDDIENTOS.Item_Factura  ON item_factura_codigo_factura = factura_numero
    INNER JOIN GDDIENTOS.Item_Pedido  ON item_pedido_codigo = item_factura_item_pedido_codigo
    INNER JOIN GDDIENTOS.Sillon ON item_pedido_sillon = sillon_codigo

    GROUP BY
        factura_sucursal,
        bi_tiempo_codigo,
        sillon_modelo,
        sucursal_localidad,
        GDDIENTOS.fn_ObtenerRangoEtario(cliente_fechaNacimiento);
END;
GO

CREATE
	OR
ALTER PROCEDURE migrar_bi_envios
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO GDDIENTOS.BI_Envios (
        bi_envios_ubicacion
        ,bi_envios_ubicacion_cliente
		,bi_envios_tiempo
        ,bi_envios_cumplidos
        ,bi_envios_no_cumplidos
		,bi_envios_total
        )
	SELECT 
		sucursal_localidad,
		cliente_localidad,
		bi_tiempo_codigo,
			SUM(CASE WHEN envio_fecha_entrega <= envio_fecha_programada THEN 1 ELSE 0 END),
			SUM(CASE WHEN envio_fecha_entrega > envio_fecha_programada THEN 1 ELSE 0 END),
		SUM(envio_total)
	FROM GDDIENTOS.Envio
		INNER JOIN GDDIENTOS.BI_Tiempo ON YEAR(envio_fecha_programada) = bi_tiempo_anio AND MONTH(envio_fecha_programada) = bi_tiempo_mes
		INNER JOIN GDDIENTOS.Factura ON factura_numero = envio_factura_numero
		INNER JOIN GDDIENTOS.Cliente ON factura_cliente = cliente_codigo
		INNER JOIN GDDIENTOS.Sucursal ON sucursal_codigo = factura_sucursal
	GROUP BY sucursal_localidad, cliente_localidad, bi_tiempo_codigo;
END;
GO

CREATE
	OR

ALTER PROCEDURE migrar_bi_facturacion
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GDDIENTOS.BI_Facturacion (
		bi_facturacion_sucursal,
		bi_facturacion_tiempo,
		bi_facturacion_ubicacion,
		bi_facturacion_tiempo_fabricacion,
		bi_facturacion_cantidad_facturas,
		bi_facturacion_total
		)
	SELECT 
		f.factura_sucursal,
		bi_tiempo_codigo,
		sucursal_localidad,
		(
			SELECT AVG(DATEDIFF(DAY, pedido_fecha, f1.factura_fecha))
			FROM GDDIENTOS.Factura f1
			INNER JOIN GDDIENTOS.Pedido ON pedido_numero = (
				SELECT item_pedido_codigo_pedido
				FROM GDDIENTOS.Item_Pedido
				JOIN GDDIENTOS.Item_Factura ON item_pedido_codigo = item_factura_item_pedido_codigo
				WHERE item_factura_codigo_factura = f1.factura_numero
				GROUP BY item_pedido_codigo_pedido
			)
			WHERE f1.factura_sucursal = f.factura_sucursal
				AND YEAR(f1.factura_fecha) = bi_tiempo_anio
				AND MONTH(f1.factura_fecha) = bi_tiempo_mes
		),
		COUNT(*),
		SUM(f.factura_total)
	FROM GDDIENTOS.Factura f
	INNER JOIN GDDIENTOS.Sucursal ON sucursal_codigo = f.factura_sucursal
	INNER JOIN GDDIENTOS.BI_Tiempo ON YEAR(f.factura_fecha) = bi_tiempo_anio
		AND MONTH(f.factura_fecha) = bi_tiempo_mes
	GROUP BY f.factura_sucursal, bi_tiempo_codigo, bi_tiempo_anio,
		bi_tiempo_mes, sucursal_localidad;

END;
GO

-- Vista 1

CREATE OR ALTER VIEW GDDIENTOS.VW_Ganancias AS
SELECT 
    f.bi_facturacion_sucursal AS [Sucursal],
    t.bi_tiempo_anio AS [Anio],
    t.bi_tiempo_mes AS [Mes],
    SUM(f.bi_facturacion_total) AS [Ingresos],
    ISNULL((
        SELECT SUM(c2.bi_compras_total)
        FROM GDDIENTOS.BI_Compras c2
			INNER JOIN GDDIENTOS.BI_Tiempo t2 ON t2.bi_tiempo_codigo = c2.bi_compras_tiempo
        WHERE c2.bi_compras_sucursal = f.bi_facturacion_sucursal
          AND t2.bi_tiempo_anio = t.bi_tiempo_anio
          AND t2.bi_tiempo_mes = t.bi_tiempo_mes
    ), 0) AS [Egresos],
    SUM(f.bi_facturacion_total) 
    - ISNULL((
        SELECT SUM(c3.bi_compras_total)
        FROM GDDIENTOS.BI_Compras c3
			INNER JOIN GDDIENTOS.BI_Tiempo t3 ON t3.bi_tiempo_codigo = c3.bi_compras_tiempo
        WHERE c3.bi_compras_sucursal = f.bi_facturacion_sucursal
          AND t3.bi_tiempo_anio = t.bi_tiempo_anio
          AND t3.bi_tiempo_mes = t.bi_tiempo_mes
    ), 0) AS [Ganancia]
FROM GDDIENTOS.BI_Facturacion f
INNER JOIN GDDIENTOS.BI_Tiempo t
    ON t.bi_tiempo_codigo = f.bi_facturacion_tiempo
GROUP BY 
    f.bi_facturacion_sucursal,
    t.bi_tiempo_anio,
    t.bi_tiempo_mes
;
GO

-- Vista 2

CREATE OR ALTER VIEW GDDIENTOS.VW_Factura_Promedio AS
SELECT 
    bi_ubicacion_provincia AS [Provincia],
    bi_tiempo_anio AS [Anio],
    bi_tiempo_cuatrimestre AS [Cuatrimestre],
    SUM(bi_facturacion_total) / SUM(bi_facturacion_cantidad_facturas) AS [Monto de factura promedio]
FROM GDDIENTOS.BI_Facturacion
	INNER JOIN GDDIENTOS.BI_Ubicacion ON bi_facturacion_ubicacion = bi_ubicacion_codigo
	INNER JOIN GDDIENTOS.BI_Tiempo ON bi_facturacion_tiempo = bi_tiempo_codigo
GROUP BY 
    bi_facturacion_ubicacion,
    bi_ubicacion_provincia,
    bi_tiempo_anio,
    bi_tiempo_cuatrimestre
;
GO

-- Vista 3

CREATE OR ALTER VIEW GDDIENTOS.VW_Rendimiento_Modelos AS
SELECT
	t.bi_tiempo_anio as [Anio],
	t.bi_tiempo_cuatrimestre as [Cuatrimestre],
	u.bi_ubicacion_localidad as [Localidad],
	re.bi_rango_etario_detalle as [Rango etario],
	ms.bi_modelo_sillon as [Modelo sillon],
	SUM(v.bi_ventas_cantidad) as [Total ventas]
	FROM GDDIENTOS.BI_Ventas v
	INNER JOIN GDDIENTOS.BI_Tiempo t ON v.bi_ventas_tiempo = t.bi_tiempo_codigo
	INNER JOIN GDDIENTOS.BI_Rango_Etario re ON v.bi_ventas_rango_etario = re.bi_rango_etario_codigo
	INNER JOIN GDDIENTOS.BI_Ubicacion u ON v.bi_ventas_ubicacion = u.bi_ubicacion_codigo
	INNER JOIN GDDIENTOS.BI_Modelo_Sillon ms ON v.bi_ventas_modelo = ms.bi_modelo_sillon_codigo
	WHERE bi_ventas_modelo IN (
		SELECT TOP 3 v2.bi_ventas_modelo
		FROM GDDIENTOS.BI_Ventas v2
		INNER JOIN GDDIENTOS.BI_Tiempo t2 ON v2.bi_ventas_tiempo = t2.bi_tiempo_codigo
		WHERE t.bi_tiempo_anio = t2.bi_tiempo_anio
			AND t.bi_tiempo_cuatrimestre = t2.bi_tiempo_cuatrimestre
			AND v2.bi_ventas_ubicacion = v.bi_ventas_ubicacion
			AND v2.bi_ventas_rango_etario = v.bi_ventas_rango_etario
		GROUP BY t2.bi_tiempo_anio, t2.bi_tiempo_cuatrimestre,
			v2.bi_ventas_ubicacion, v2.bi_ventas_rango_etario,
			v2.bi_ventas_modelo
		ORDER BY SUM(v2.bi_ventas_cantidad) DESC
	)
	GROUP BY t.bi_tiempo_anio, t.bi_tiempo_cuatrimestre,
		v.bi_ventas_ubicacion, u.bi_ubicacion_localidad,
		v.bi_ventas_rango_etario, re.bi_rango_etario_detalle,
		v.bi_ventas_modelo, ms.bi_modelo_sillon
;
GO

-- Vista 4

CREATE OR ALTER VIEW GDDIENTOS.VW_Volumen_Pedidos AS
SELECT
    bi_pedidos_sucursal as [Sucursal],
    bi_turno_detalle as [Turno],
    bi_tiempo_anio as [Anio],
    bi_tiempo_mes as [Mes],
    SUM(bi_pedidos_cantidad) as [Cantidad]
FROM GDDIENTOS.BI_Pedidos
	INNER JOIN GDDIENTOS.BI_Tiempo ON bi_pedidos_tiempo = bi_tiempo_codigo
	INNER JOIN GDDIENTOS.BI_Turno ON bi_pedidos_turno = bi_turno_codigo
GROUP BY
    bi_pedidos_sucursal,
	bi_pedidos_turno,
	bi_turno_detalle,
    bi_tiempo_anio,
    bi_tiempo_mes
;
GO

-- Vista 5 (Se usan alias en las tablas para diferenciar los scopes)
CREATE OR ALTER VIEW GDDIENTOS.VW_Conversion_Pedidos AS
SELECT
    P.bi_pedidos_sucursal AS [Sucursal],
    T.bi_tiempo_anio AS [Anio],
    T.bi_tiempo_cuatrimestre AS [Cuatrimestre],
    E.bi_estado_pedido AS [Estado],
    CAST(
        SUM(bi_pedidos_cantidad) * 100.0 /
        (
            SELECT SUM(p2.bi_pedidos_cantidad)
            FROM GDDIENTOS.BI_Pedidos p2
            INNER JOIN GDDIENTOS.BI_Tiempo t2 ON p2.bi_pedidos_tiempo = t2.bi_tiempo_codigo
            WHERE p2.bi_pedidos_sucursal = p.bi_pedidos_sucursal
              AND t2.bi_tiempo_anio = t.bi_tiempo_anio
              AND t2.bi_tiempo_cuatrimestre = t.bi_tiempo_cuatrimestre
        )
        AS DECIMAL(5, 2)
    ) AS Porcentaje
FROM GDDIENTOS.BI_Pedidos P
INNER JOIN GDDIENTOS.BI_Tiempo T ON P.bi_pedidos_tiempo = T.bi_tiempo_codigo
INNER JOIN GDDIENTOS.BI_Estado_Pedido E ON P.bi_pedidos_estado = E.bi_estado_pedido_codigo
GROUP BY
    P.bi_pedidos_sucursal,
    T.bi_tiempo_anio,
    T.bi_tiempo_cuatrimestre,
    P.bi_pedidos_estado,
    E.bi_estado_pedido
;
GO

-- Vista 6 --

CREATE OR ALTER VIEW GDDIENTOS.VW_Tiempo_Promedio_Fabricacion AS
SELECT
	bi_tiempo_anio as [Anio],
	bi_tiempo_cuatrimestre as [Cuatrimestre],
	bi_facturacion_sucursal as [Sucursal],
	bi_facturacion_tiempo_fabricacion as [Tiempo promedio fabricacion]
FROM GDDIENTOS.BI_Facturacion
INNER JOIN GDDIENTOS.BI_Tiempo ON bi_facturacion_tiempo = bi_tiempo_codigo
;
GO

-- Vista 7 -- REVISAR
-- CREATE OR ALTER VIEW GDDIENTOS.VW_Promedio_Compras AS
-- SELECT bi_tiempo_anio AS [Anio], 
-- 	bi_tiempo_mes AS [Mes], 
-- 	AVG(bi_compras_total) AS [Importe]
-- FROM GDDIENTOS.BI_Compras 
-- 	INNER JOIN GDDIENTOS.BI_Tiempo ON bi_compras_tiempo = bi_tiempo_codigo
-- GROUP BY bi_tiempo_anio, bi_tiempo_mes
-- ;
-- GO

-- Vista 7 --
CREATE OR ALTER VIEW GDDIENTOS.VW_Promedio_Compras AS
SELECT bi_tiempo_anio AS [Anio], 
	bi_tiempo_mes AS [Mes], 
	SUM(bi_compras_total)/SUM(bi_compras_cantidad) AS [Promedio compra]
FROM GDDIENTOS.BI_Compras 
	INNER JOIN GDDIENTOS.BI_Tiempo ON bi_compras_tiempo = bi_tiempo_codigo
GROUP BY bi_tiempo_anio, bi_tiempo_mes
;
GO

-- Vista 8 --
CREATE OR ALTER VIEW GDDIENTOS.VW_Compras_Por_Tipo_Material AS
SELECT 
    tm.bi_tipo_material AS [Tipo de Material],
    cs.bi_compra_materiales_sucursal AS [Sucursal],
    t.bi_tiempo_anio AS [Anio],
    t.bi_tiempo_cuatrimestre AS [Cuatrimestre],
    SUM(cs.bi_compra_materiales_total) AS [Total Gastado]
FROM GDDIENTOS.BI_Compra_Materiales cs
INNER JOIN GDDIENTOS.BI_Tipo_Material tm ON cs.bi_compra_materiales_tipo_material = tm.bi_tipo_material_codigo
INNER JOIN GDDIENTOS.BI_Tiempo t ON cs.bi_compra_materiales_tiempo = t.bi_tiempo_codigo
GROUP BY 
    cs.bi_compra_materiales_tipo_material,
    tm.bi_tipo_material,
    cs.bi_compra_materiales_sucursal,
    t.bi_tiempo_anio,
    t.bi_tiempo_cuatrimestre
;
GO

-- Vista 9 -- REVISAR
-- CREATE OR ALTER VIEW GDDIENTOS.VW_Porcentaje_Cumplimiento_Envios AS
-- SELECT 
--     YEAR(envio_fecha_programada) AS Anio,
--     MONTH(envio_fecha_programada) AS Mes,
--     COUNT(*) AS [Total Envios],
--     COUNT(CASE WHEN envio_fecha_entrega <= envio_fecha_programada THEN 1 END) AS 'Envios Cumplidos',
--     CAST(
--         100.0 * COUNT(CASE WHEN envio_fecha_entrega <= envio_fecha_programada THEN 1 END) / COUNT(*)
--         AS DECIMAL(5, 2)
--     ) AS 'Porcentaje Cumplimiento'
-- FROM GDDIENTOS.Envio
-- GROUP BY 
--     YEAR(envio_fecha_programada),
--     MONTH(envio_fecha_programada)
-- ;
-- GO

-- Vista 9 --
CREATE OR ALTER VIEW GDDIENTOS.VW_Porcentaje_Cumplimiento_Envios AS
SELECT 
    bi_tiempo_anio AS Anio,
    bi_tiempo_mes AS Mes,
    SUM(bi_envios_cumplidos+bi_envios_no_cumplidos) AS [Total Envios],
    SUM(bi_envios_cumplidos)*100/SUM(bi_envios_cumplidos+bi_envios_no_cumplidos) AS 'Porcentaje Cumplimiento'
FROM GDDIENTOS.BI_Envios
INNER JOIN GDDIENTOS.BI_Tiempo ON bi_envios_tiempo = bi_tiempo_codigo
GROUP BY 
    bi_tiempo_anio,
    bi_tiempo_mes
;
GO

-- Vista 10 --
CREATE OR ALTER VIEW GDDIENTOS.VW_Localidades_Con_Mayor_Costo_De_Envio AS
SELECT
	u.bi_ubicacion_localidad AS [Localidad cliente],
	SUM(e.bi_envios_total)/SUM(e.bi_envios_cumplidos+e.bi_envios_no_cumplidos) [Costo de envio promedio]
FROM GDDIENTOS.BI_Envios e
INNER JOIN GDDIENTOS.BI_Ubicacion u ON e.bi_envios_ubicacion_cliente = u.bi_ubicacion_codigo
WHERE e.bi_envios_ubicacion_cliente IN (
	SELECT TOP 3 e2.bi_envios_ubicacion_cliente
	FROM GDDIENTOS.BI_Envios e2
	GROUP BY e2.bi_envios_ubicacion_cliente
	ORDER BY
		SUM(e2.bi_envios_total)/SUM(e2.bi_envios_cumplidos+e2.bi_envios_no_cumplidos) DESC
)
GROUP BY
	e.bi_envios_ubicacion_cliente, u.bi_ubicacion_localidad
;
GO
	

CREATE
	OR

ALTER PROCEDURE migrar_todo_bi
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;


		EXEC migrar_bi_estado_pedido;

		EXEC migrar_bi_modelo_sillon;

		EXEC migrar_bi_tipo_material;

		EXEC migrar_bi_turno;

		EXEC migrar_bi_rango_etario;

		EXEC migrar_bi_ubicacion;

		EXEC migrar_bi_tiempo;

		EXEC migrar_bi_pedidos;

		EXEC migrar_bi_ventas;

		EXEC migrar_bi_facturacion;

		EXEC migrar_bi_compras;

		EXEC migrar_bi_compra_materiales;

		EXEC migrar_bi_envios;

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
