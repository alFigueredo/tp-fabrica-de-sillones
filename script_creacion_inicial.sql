DROP TABLE IF EXISTS GDDIENTOS.Relleno;
DROP TABLE IF EXISTS GDDIENTOS.Madera;
DROP TABLE IF EXISTS GDDIENTOS.Tela;
DROP TABLE IF EXISTS GDDIENTOS.Sillon_Material;
DROP TABLE IF EXISTS GDDIENTOS.Item_Compra;
DROP TABLE IF EXISTS GDDIENTOS.Material;
DROP TABLE IF EXISTS GDDIENTOS.Tipo_Material;
DROP TABLE IF EXISTS GDDIENTOS.Compra;
DROP TABLE IF EXISTS GDDIENTOS.Proveedor;
DROP TABLE IF EXISTS GDDIENTOS.Item_Factura;
DROP TABLE IF EXISTS GDDIENTOS.Item_Pedido;
DROP TABLE IF EXISTS GDDIENTOS.Sillon;
DROP TABLE IF EXISTS GDDIENTOS.Sillon_Modelo;
DROP TABLE IF EXISTS GDDIENTOS.Medida;
DROP TABLE IF EXISTS GDDIENTOS.Envio;
DROP TABLE IF EXISTS GDDIENTOS.Factura;
DROP TABLE IF EXISTS GDDIENTOS.Pedido_Cancelacion;
DROP TABLE IF EXISTS GDDIENTOS.Pedido;
DROP TABLE IF EXISTS GDDIENTOS.Estado;
DROP TABLE IF EXISTS GDDIENTOS.Sucursal;
DROP TABLE IF EXISTS GDDIENTOS.Cliente;
DROP TABLE IF EXISTS GDDIENTOS.Localidad;
DROP TABLE IF EXISTS GDDIENTOS.Provincia;
GO

DROP SCHEMA IF EXISTS GDDIENTOS;
GO

CREATE SCHEMA GDDIENTOS;
GO

CREATE TABLE GDDIENTOS.Provincia (
    provincia_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    provincia_nombre NVARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.Localidad (
    localidad_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    localidad_nombre NVARCHAR(255) NOT NULL,
	localidad_provincia BIGINT NOT NULL,
	FOREIGN KEY (localidad_provincia) REFERENCES GDDIENTOS.Provincia(provincia_codigo)
);

CREATE TABLE GDDIENTOS.Cliente (
    cliente_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    cliente_dni BIGINT NOT NULL,
    cliente_nombre NVARCHAR(255) NOT NULL,
    cliente_apellido NVARCHAR(255) NOT NULL,
    cliente_fechaNacimiento DATETIME2 NOT NULL,
    cliente_mail NVARCHAR(255) NOT NULL,
    cliente_direccion NVARCHAR(255) NOT NULL,
    cliente_telefono NVARCHAR(255) NOT NULL,
    cliente_provincia BIGINT NOT NULL,
    cliente_localidad BIGINT NOT NULL,
    FOREIGN KEY (cliente_provincia) REFERENCES GDDIENTOS.Provincia(provincia_codigo),
    FOREIGN KEY (cliente_localidad) REFERENCES GDDIENTOS.Localidad(localidad_codigo)
);

CREATE TABLE GDDIENTOS.Sucursal (
    sucursal_codigo BIGINT PRIMARY KEY,
    sucursal_provincia BIGINT NOT NULL,
    sucursal_localidad BIGINT NOT NULL,
    sucursal_direccion NVARCHAR(255) NOT NULL,
    sucursal_telefono NVARCHAR(255) NOT NULL,
    sucursal_mail NVARCHAR(255) NOT NULL,
    FOREIGN KEY (sucursal_provincia) REFERENCES GDDIENTOS.Provincia(provincia_codigo),
    FOREIGN KEY (sucursal_localidad) REFERENCES GDDIENTOS.Localidad(localidad_codigo)
);

CREATE TABLE GDDIENTOS.Estado (
    estado_numero BIGINT IDENTITY(1,1) PRIMARY KEY,
    estado_tipo NVARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.Pedido (
    pedido_numero DECIMAL(18,0) PRIMARY KEY,
    pedido_sucursal BIGINT NOT NULL,
    pedido_cliente BIGINT NOT NULL,
    pedido_fecha DATETIME2(6) NOT NULL,
    pedido_total DECIMAL(18,2) NOT NULL,
    pedido_estado BIGINT NOT NULL,
    FOREIGN KEY (pedido_sucursal) REFERENCES GDDIENTOS.Sucursal(sucursal_codigo),
    FOREIGN KEY (pedido_cliente) REFERENCES GDDIENTOS.Cliente(cliente_codigo),
	FOREIGN KEY (pedido_estado) REFERENCES GDDIENTOS.Estado(estado_numero)
);

CREATE TABLE GDDIENTOS.Pedido_Cancelacion (
    pedido_cancelacion_pedido DECIMAL(18,0) PRIMARY KEY,
    pedido_cancelacion_fecha DATETIME2(6) NOT NULL,
    pedido_cancelacion_motivo NVARCHAR(255) NOT NULL,
    FOREIGN KEY (pedido_cancelacion_pedido) REFERENCES GDDIENTOS.Pedido(pedido_numero)
);

CREATE TABLE GDDIENTOS.Factura (
    factura_numero BIGINT PRIMARY KEY,
    factura_cliente BIGINT NOT NULL,
    factura_sucursal BIGINT NOT NULL,
    factura_fecha DATETIME2(6) NOT NULL,
    factura_total DECIMAL(38,2) NOT NULL,
    FOREIGN KEY (factura_cliente) REFERENCES GDDIENTOS.Cliente(cliente_codigo),
    FOREIGN KEY (factura_sucursal) REFERENCES GDDIENTOS.Sucursal(sucursal_codigo)
);

CREATE TABLE GDDIENTOS.Envio (
    envio_numero DECIMAL(18,0) PRIMARY KEY,
    envio_factura_numero BIGINT NOT NULL,
    envio_fecha_programada DATETIME2(6) NOT NULL,
    envio_fecha_entrega DATETIME2(6) NOT NULL,
    envio_importe_traslado DECIMAL(18,2) NOT NULL,
    envio_importe_subida DECIMAL(18,2) NOT NULL,
    envio_total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (envio_factura_numero) REFERENCES GDDIENTOS.Factura(factura_numero)
);

CREATE TABLE GDDIENTOS.Medida (
    medida_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    medida_ancho DECIMAL(18,2) NOT NULL,
    medida_alto DECIMAL(18,2) NOT NULL,
    medida_profundidad DECIMAL(18,2) NOT NULL,
    medida_precio DECIMAL(18,2) NOT NULL
);

CREATE TABLE GDDIENTOS.Sillon_Modelo (
    sillon_modelo_codigo BIGINT PRIMARY KEY,
    sillon_modelo NVARCHAR(255) NOT NULL,
    sillon_modelo_descripcion NVARCHAR(255) NOT NULL,
    sillon_modelo_precio DECIMAL(18,2) NOT NULL
);

CREATE TABLE GDDIENTOS.Sillon (
    sillon_codigo BIGINT PRIMARY KEY,
    sillon_modelo BIGINT NOT NULL,
	sillon_modelo_precio DECIMAL(18,2) NOT NULL,
    sillon_medida BIGINT NOT NULL,
	sillon_medida_precio DECIMAL(18,2) NOT NULL
    FOREIGN KEY (sillon_modelo) REFERENCES GDDIENTOS.Sillon_Modelo(sillon_modelo_codigo),
    FOREIGN KEY (sillon_medida) REFERENCES GDDIENTOS.Medida(medida_codigo)
);

CREATE TABLE GDDIENTOS.Item_Pedido (
    item_pedido_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    item_pedido_codigo_pedido DECIMAL(18,0) NOT NULL,
    item_pedido_sillon BIGINT NOT NULL,
    item_pedido_precio_unitario DECIMAL(18,2) NOT NULL,
    item_pedido_cantidad BIGINT NOT NULL,
    item_pedido_subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (item_pedido_codigo_pedido) REFERENCES GDDIENTOS.Pedido(pedido_numero),
	FOREIGN KEY (item_pedido_sillon) REFERENCES GDDIENTOS.Sillon(sillon_codigo)
);

CREATE TABLE GDDIENTOS.Item_Factura (
    item_factura_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    item_factura_item_pedido_codigo BIGINT NOT NULL,
    item_factura_codigo_factura BIGINT NOT NULL,
    item_factura_precio_unitario DECIMAL(18,2) NOT NULL,
    item_factura_cantidad DECIMAL(18,0) NOT NULL,
    item_factura_subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (item_factura_item_pedido_codigo) REFERENCES GDDIENTOS.Item_Pedido(item_pedido_codigo),
    FOREIGN KEY (item_factura_codigo_factura) REFERENCES GDDIENTOS.Factura(factura_numero)
);

CREATE TABLE GDDIENTOS.Proveedor (
    proveedor_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    proveedor_cuit NVARCHAR(255) NOT NULL,
    proveedor_razonSocial NVARCHAR(255) NOT NULL,
    proveedor_direccion NVARCHAR(255) NOT NULL,
    proveedor_provincia BIGINT NOT NULL,
    proveedor_localidad BIGINT NOT NULL,
    proveedor_mail NVARCHAR(255) NOT NULL,
    proveedor_telefono NVARCHAR(255) NOT NULL,
    FOREIGN KEY (proveedor_provincia) REFERENCES GDDIENTOS.Provincia(provincia_codigo),
    FOREIGN KEY (proveedor_localidad) REFERENCES GDDIENTOS.Localidad(localidad_codigo)
);

CREATE TABLE GDDIENTOS.Compra (
    compra_numero DECIMAL(18,0) PRIMARY KEY,
    compra_sucursal BIGINT NOT NULL,
    compra_proveedor BIGINT NOT NULL,
    compra_fecha DATETIME2(6) NOT NULL,
    compra_total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (compra_sucursal) REFERENCES GDDIENTOS.Sucursal(sucursal_codigo),
    FOREIGN KEY (compra_proveedor) REFERENCES GDDIENTOS.Proveedor(proveedor_codigo)
);

CREATE TABLE GDDIENTOS.Tipo_Material (
    tipo_material_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    tipo_material_nombre NVARCHAR(255) NOT NULL
);

CREATE TABLE GDDIENTOS.Material (
    material_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    material_tipo BIGINT NOT NULL,
    material_nombre NVARCHAR(255) NOT NULL,
    material_descripcion NVARCHAR(255) NOT NULL,
    material_precio DECIMAL(38,2) NOT NULL,
    FOREIGN KEY (material_tipo) REFERENCES GDDIENTOS.Tipo_Material(tipo_material_codigo)
);

CREATE TABLE GDDIENTOS.Item_Compra (
    item_compra_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    item_compra_codigo_compra DECIMAL(18,0) NOT NULL,
    item_compra_material BIGINT NOT NULL,
    item_compra_precio_unitario DECIMAL(18,2) NOT NULL,
    item_compra_cantidad DECIMAL(18,0) NOT NULL,
    item_compra_subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (item_compra_codigo_compra) REFERENCES GDDIENTOS.Compra(compra_numero),
    FOREIGN KEY (item_compra_material) REFERENCES GDDIENTOS.Material(material_codigo)
);

CREATE TABLE GDDIENTOS.Sillon_Material (
    sillon_material_codigo_sillon BIGINT NOT NULL,
    sillon_material_codigo_material BIGINT NOT NULL,
    sillon_material_precio DECIMAL(38,2) NOT NULL,
    PRIMARY KEY (sillon_material_codigo_sillon, sillon_material_codigo_material),
    FOREIGN KEY (sillon_material_codigo_sillon) REFERENCES GDDIENTOS.Sillon(sillon_codigo),
    FOREIGN KEY (sillon_material_codigo_material) REFERENCES GDDIENTOS.Material(material_codigo)
);

CREATE TABLE GDDIENTOS.Tela (
    tela_material_codigo BIGINT PRIMARY KEY,
    tela_color NVARCHAR(255) NOT NULL,
    tela_textura NVARCHAR(255) NOT NULL,
    FOREIGN KEY (tela_material_codigo) REFERENCES GDDIENTOS.Material(material_codigo)
);

CREATE TABLE GDDIENTOS.Madera (
    madera_material_codigo BIGINT PRIMARY KEY,
    madera_color NVARCHAR(255) NOT NULL,
    madera_dureza NVARCHAR(255) NOT NULL,
    FOREIGN KEY (madera_material_codigo) REFERENCES GDDIENTOS.Material(material_codigo)
);

CREATE TABLE GDDIENTOS.Relleno (
    relleno_material_codigo BIGINT PRIMARY KEY,
    relleno_densidad DECIMAL(38,2) NOT NULL,
    FOREIGN KEY (relleno_material_codigo) REFERENCES GDDIENTOS.Material(material_codigo)
);
GO


CREATE OR ALTER PROCEDURE migrar_provincia
AS 
BEGIN
    SET NOCOUNT ON;

    INSERT INTO GDDIENTOS.Provincia(provincia_nombre)
    SELECT sucursal_provincia FROM gd_esquema.Maestra
    GROUP BY sucursal_provincia
    HAVING sucursal_provincia IS NOT NULL
    ;

    INSERT INTO GDDIENTOS.Provincia(provincia_nombre)
    SELECT cliente_provincia FROM gd_esquema.Maestra
    GROUP BY cliente_provincia
    HAVING cliente_provincia IS NOT NULL
        AND cliente_provincia NOT IN (
            SELECT provincia_nombre FROM GDDIENTOS.Provincia
        )
    ;

    INSERT INTO GDDIENTOS.Provincia(provincia_nombre)
    SELECT proveedor_provincia FROM gd_esquema.Maestra
    GROUP BY proveedor_provincia
    HAVING proveedor_provincia IS NOT NULL
        AND proveedor_provincia NOT IN (
            SELECT provincia_nombre FROM GDDIENTOS.Provincia
        )
    ;
END;
GO

CREATE OR ALTER PROCEDURE migrar_localidad
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO GDDIENTOS.Localidad(localidad_nombre, localidad_provincia)
    SELECT sucursal_localidad, provincia_codigo FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Provincia ON sucursal_provincia = provincia_nombre
    GROUP BY sucursal_localidad, provincia_codigo
    HAVING sucursal_localidad IS NOT NULL
    ;


    INSERT INTO GDDIENTOS.Localidad(localidad_nombre, localidad_provincia)
    SELECT cliente_localidad, provincia_codigo FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Provincia ON cliente_provincia = provincia_nombre
    GROUP BY cliente_localidad, provincia_codigo
    HAVING cliente_localidad IS NOT NULL
        AND cliente_localidad NOT IN (
            SELECT localidad_nombre FROM GDDIENTOS.Localidad
            WHERE localidad_provincia = provincia_codigo
        )
    ;

    INSERT INTO GDDIENTOS.Localidad(localidad_nombre, localidad_provincia)
    SELECT proveedor_localidad, provincia_codigo FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Provincia ON proveedor_provincia = provincia_nombre
    GROUP BY proveedor_localidad, provincia_codigo
    HAVING proveedor_localidad IS NOT NULL
        AND proveedor_localidad NOT IN (
            SELECT localidad_nombre FROM GDDIENTOS.Localidad
            WHERE localidad_provincia = provincia_codigo
        )
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_clientes
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Cliente(cliente_dni, cliente_nombre,
        cliente_apellido, cliente_fechaNacimiento, cliente_mail,
        cliente_direccion, cliente_telefono, cliente_provincia,
        cliente_localidad)
    SELECT Cliente_Dni, Cliente_Nombre, Cliente_Apellido,
        Cliente_FechaNacimiento, Cliente_Mail, Cliente_Direccion,
        Cliente_Telefono, provincia_codigo, localidad_codigo
    FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Provincia ON provincia_nombre = Cliente_Provincia
    JOIN GDDIENTOS.Localidad ON localidad_nombre = Cliente_Localidad
        AND provincia_codigo = localidad_provincia
    GROUP BY Cliente_Dni, Cliente_Nombre, Cliente_Apellido,
        Cliente_FechaNacimiento, Cliente_Mail, Cliente_Direccion,
        Cliente_Telefono, provincia_codigo, localidad_codigo
    ;

END

GO

CREATE OR ALTER PROCEDURE migrar_sucursal
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Sucursal(sucursal_codigo, sucursal_provincia,
        sucursal_localidad, sucursal_direccion, sucursal_telefono,
        sucursal_mail)
    SELECT Sucursal_NroSucursal, provincia_codigo, localidad_codigo,
        Sucursal_Direccion, Sucursal_telefono,Sucursal_mail
    FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Provincia ON provincia_nombre = Sucursal_Provincia
    JOIN GDDIENTOS.Localidad ON localidad_nombre = Sucursal_Localidad
        AND provincia_codigo = localidad_provincia
    GROUP BY Sucursal_NroSucursal, provincia_codigo, localidad_codigo,
        Sucursal_Direccion, Sucursal_telefono,Sucursal_mail
    ;
END

GO

CREATE OR ALTER PROCEDURE migrar_estado
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Estado(estado_tipo)
    SELECT pedido_estado FROM gd_esquema.Maestra
    GROUP BY Pedido_Estado
    HAVING pedido_estado IS NOT NULL
    ;
    INSERT INTO GDDIENTOS.Estado(estado_tipo)
        VALUES ('PENDIENTE')
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_pedido
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Pedido(pedido_numero, pedido_sucursal,
        pedido_cliente, pedido_fecha, pedido_total, pedido_estado)
    SELECT pedido_numero, Sucursal_NroSucursal, cliente_codigo,
        pedido_fecha, pedido_total, estado_numero 
        FROM gd_esquema.Maestra Ms
        JOIN GDDIENTOS.Cliente Cl ON Cl.cliente_dni = Ms.Cliente_Dni
            AND cl.cliente_apellido+cl.cliente_nombre=ms.Cliente_Apellido+ms.Cliente_Nombre
        JOIN GDDIENTOS.Sucursal ON sucursal_codigo = Sucursal_NroSucursal
        JOIN GDDIENTOS.Estado ON estado_tipo = Pedido_Estado
        GROUP BY pedido_numero, Sucursal_NroSucursal, cliente_codigo,
            pedido_fecha, pedido_total, estado_numero
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_pedido_cancelacion
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Pedido_Cancelacion(pedido_cancelacion_pedido,
        pedido_cancelacion_fecha, pedido_cancelacion_motivo)
    SELECT pedido_numero, pedido_cancelacion_fecha, pedido_cancelacion_motivo
        FROM gd_esquema.Maestra
        GROUP BY pedido_numero, pedido_cancelacion_fecha, pedido_cancelacion_motivo
        HAVING pedido_cancelacion_fecha IS NOT NULL
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_factura
AS
BEGIN
SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Factura(factura_numero, factura_cliente,
        factura_sucursal, factura_fecha, factura_total)
    SELECT factura_numero, cliente_codigo, Sucursal_NroSucursal,
        Factura_Fecha, Factura_Total
    FROM gd_esquema.Maestra M
    JOIN GDDIENTOS.cliente C ON M.Cliente_Dni=C.cliente_dni
        AND M.Cliente_Apellido+M.Cliente_Nombre=C.cliente_apellido+C.cliente_nombre
    WHERE factura_numero IS NOT NULL
    GROUP BY factura_numero, cliente_codigo, Sucursal_NroSucursal,
        Factura_Fecha, Factura_Total
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_envio
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO GDDIENTOS.Envio(envio_numero, envio_factura_numero,
        envio_fecha_programada, envio_fecha_entrega, envio_importe_traslado,
        envio_importe_subida, envio_total)
    SELECT Envio_Numero, factura_numero, Envio_Fecha_Programada,
        Envio_Fecha, Envio_ImporteTraslado, Envio_importeSubida,
        Envio_Total
    FROM gd_esquema.Maestra
    GROUP BY Envio_Numero, factura_numero, Envio_Fecha_Programada,
        Envio_Fecha, Envio_ImporteTraslado, Envio_importeSubida,
        Envio_Total
    HAVING envio_numero IS NOT NULL
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_medida
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Medida(medida_ancho, medida_alto,
        medida_profundidad, medida_precio)
    SELECT Sillon_Medida_Ancho, Sillon_Medida_Alto,
        Sillon_Medida_Profundidad, Sillon_Medida_Precio
    FROM gd_esquema.Maestra 
    WHERE Sillon_Medida_Alto IS NOT NULL
    GROUP BY Sillon_Medida_Ancho, Sillon_Medida_Alto,
        Sillon_Medida_Profundidad, Sillon_Medida_Precio
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_sillon_modelo
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Sillon_Modelo(sillon_modelo_codigo, sillon_modelo,
        sillon_modelo_descripcion, sillon_modelo_precio)
    SELECT Sillon_Modelo_Codigo, Sillon_Modelo, Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
    GROUP BY Sillon_Modelo_Codigo, Sillon_Modelo, Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    HAVING Sillon_Modelo_Codigo IS NOT NULL
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_sillon
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Sillon(sillon_codigo, sillon_modelo,
        sillon_modelo_precio, sillon_medida, sillon_medida_precio)
    SELECT sillon_codigo, Ms.Sillon_Modelo_Codigo, Ms.sillon_modelo_precio,
        medida_codigo, sillon_medida_precio
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Medida ON Sillon_Medida_Alto=medida_alto
        AND Sillon_Medida_Ancho=medida_ancho
        AND Sillon_Medida_Profundidad=medida_profundidad
    GROUP BY sillon_codigo, Ms.Sillon_Modelo_Codigo, Ms.sillon_modelo_precio,
        medida_codigo, sillon_medida_precio
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_item_pedido
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Item_Pedido(item_pedido_codigo_pedido, item_pedido_sillon,
        item_pedido_cantidad, item_pedido_precio_unitario, item_pedido_subtotal)
    SELECT pedido_numero, sillon_codigo, Detalle_Pedido_Cantidad,
        Detalle_Pedido_Precio, Detalle_Pedido_SubTotal 
    FROM gd_esquema.Maestra
    GROUP BY pedido_numero, sillon_codigo, Detalle_Pedido_Cantidad,
        Detalle_Pedido_Precio, Detalle_Pedido_SubTotal 
    HAVING pedido_numero IS NOT NULL
        AND sillon_codigo IS NOT NULL
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_item_factura
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO GDDIENTOS.Item_Factura(item_factura_codigo_factura,
        item_factura_item_pedido_codigo, item_factura_precio_unitario,
        item_factura_cantidad, item_factura_subtotal)
    SELECT factura_numero, item_pedido_codigo, Detalle_Factura_Precio,
        Detalle_Factura_Cantidad, Detalle_Factura_SubTotal 
    FROM gd_esquema.Maestra 
    JOIN GDDIENTOS.Item_Pedido ON item_pedido_codigo_pedido = pedido_numero
        AND item_pedido_precio_unitario = detalle_factura_precio
        AND item_pedido_cantidad = detalle_factura_cantidad
    GROUP BY factura_numero, item_pedido_codigo, Detalle_Factura_Precio,
        Detalle_Factura_Cantidad, Detalle_Factura_SubTotal
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_proveedor
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO GDDIENTOS.Proveedor(proveedor_cuit, proveedor_razonSocial,
        proveedor_direccion, proveedor_provincia, proveedor_localidad,
        proveedor_mail, proveedor_telefono)
    SELECT proveedor_cuit, Proveedor_RazonSocial, Proveedor_Direccion,
        provincia_codigo, localidad_codigo, Proveedor_Mail,
        Proveedor_Telefono
    FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Provincia ON provincia_nombre = Proveedor_Provincia
    JOIN GDDIENTOS.Localidad ON localidad_nombre = Proveedor_Localidad
        AND localidad_provincia=provincia_codigo
    GROUP BY proveedor_cuit, Proveedor_RazonSocial, Proveedor_Direccion,
        provincia_codigo, localidad_codigo, Proveedor_Mail,
        Proveedor_Telefono
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_compra
AS
BEGIN 
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Compra(compra_numero, compra_sucursal,
        compra_proveedor, compra_fecha, compra_total)
    SELECT Compra_Numero, Sucursal_NroSucursal, proveedor_codigo,
        Compra_Fecha, Compra_Total
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Proveedor P
        ON Ms.proveedor_cuit+Ms.proveedor_razonSocial=P.proveedor_cuit+P.proveedor_razonSocial
    GROUP BY Compra_Numero, Sucursal_NroSucursal, proveedor_codigo,
        Compra_Fecha, Compra_Total
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_tipo_material
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Tipo_Material(tipo_material_nombre)
    SELECT material_tipo FROM gd_esquema.Maestra
    GROUP BY material_tipo 
    HAVING material_tipo IS NOT NULL
        AND material_tipo NOT IN (
            SELECT tipo_material_nombre FROM GDDIENTOS.Tipo_Material
        )
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_material
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Material(material_tipo, material_nombre,
        material_descripcion, material_precio)
    SELECT tipo_material_codigo, Material_Nombre, Material_Descripcion, Material_Precio
    FROM gd_esquema.Maestra
    JOIN GDDIENTOS.Tipo_Material ON Material_Tipo = tipo_material_nombre
    GROUP BY tipo_material_codigo, Material_Nombre, Material_Descripcion, Material_Precio
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_item_compra
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Item_Compra(item_compra_codigo_compra, item_compra_material,
        item_compra_precio_unitario, item_compra_cantidad, item_compra_subtotal)
    SELECT Compra_Numero, material_codigo, Detalle_Compra_Precio,
        Detalle_Compra_Cantidad, Detalle_Compra_SubTotal
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Tipo_Material ON tipo_material_nombre=Material_Tipo
    JOIN GDDIENTOS.Material Mt ON tipo_material_codigo=Mt.material_tipo
        AND Ms.Material_Nombre = Mt.material_nombre
    GROUP BY Compra_Numero, material_codigo, Detalle_Compra_Precio,
        Detalle_Compra_Cantidad, Detalle_Compra_SubTotal
    HAVING compra_numero IS NOT NULL
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_sillon_material
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO GDDIENTOS.Sillon_Material(sillon_material_codigo_sillon,
        sillon_material_codigo_material, sillon_material_precio)
    SELECT sillon_codigo, material_codigo, Ms.Material_Precio
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Tipo_Material ON tipo_material_nombre = Material_Tipo
    JOIN GDDIENTOS.Material Mt ON tipo_material_codigo = Mt.material_tipo
        AND Ms.Material_Nombre = Mt.material_nombre
    GROUP BY sillon_codigo, material_codigo, Ms.Material_Precio
    HAVING sillon_codigo IS NOT NULL
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_tela
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO GDDIENTOS.Tela(tela_material_codigo, tela_color, tela_textura)
    SELECT material_codigo, Tela_Color, Tela_Textura
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Material Mt ON Ms.material_nombre = Mt.Material_Nombre
    WHERE Tela_Color IS NOT NULL
        AND Ms.Material_tipo = 'Tela'
    GROUP BY material_codigo, Tela_Color, Tela_Textura
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_madera
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO GDDIENTOS.Madera(madera_material_codigo, madera_color, madera_dureza)
    SELECT material_codigo, madera_color, madera_dureza
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Material Mt ON Ms.Material_Nombre = Mt.material_nombre
    WHERE madera_color IS NOT NULL
        AND Ms.Material_Tipo = 'Madera'
    GROUP BY material_codigo, madera_color, madera_dureza
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_relleno
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO GDDIENTOS.Relleno(relleno_material_codigo, relleno_densidad)
    SELECT material_codigo, relleno_densidad
    FROM gd_esquema.Maestra Ms
    JOIN GDDIENTOS.Material Mt ON Ms.Material_Nombre = Mt.material_nombre
    WHERE Ms.Material_Tipo = 'Relleno'
    GROUP BY material_codigo, relleno_densidad
    ;
END
GO

CREATE OR ALTER PROCEDURE migrar_todo
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC migrar_provincia;
        EXEC migrar_localidad;
        EXEC migrar_clientes;
        EXEC migrar_sucursal;
        EXEC migrar_estado;
        EXEC migrar_pedido;
        EXEC migrar_pedido_cancelacion;
        EXEC migrar_factura;
        EXEC migrar_envio;
        EXEC migrar_medida;
        EXEC migrar_sillon_modelo;
        EXEC migrar_sillon;
        EXEC migrar_item_pedido;
        EXEC migrar_item_factura;
        EXEC migrar_proveedor;
        EXEC migrar_compra;
        EXEC migrar_tipo_material;
        EXEC migrar_material;
        EXEC migrar_item_compra;
        EXEC migrar_sillon_material;
        EXEC migrar_tela;
        EXEC migrar_madera;
        EXEC migrar_relleno;

        COMMIT TRANSACTION;
        PRINT 'Migracion completa.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC migrar_todo;
