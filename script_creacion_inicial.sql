CREATE TABLE Provincia (
    provincia_codigo BIGINT PRIMARY KEY,
    provincia_nombre NVARCHAR(255)
);

CREATE TABLE Localidad (
    localidad_codigo BIGINT PRIMARY KEY,
    localidad_nombre NVARCHAR(255),
	localidad_provincia BIGINT,
	FOREIGN KEY (localidad_provincia) REFERENCES Provincia(provincia_codigo)
);

CREATE TABLE Cliente (
    cliente_codigo BIGINT PRIMARY KEY,
    cliente_dni BIGINT,
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento DATETIME2,
    cliente_mail NVARCHAR(255),
    cliente_direccion NVARCHAR(255),
    cliente_telefono NVARCHAR(255),
    cliente_provincia BIGINT,
    cliente_localidad BIGINT,
    FOREIGN KEY (cliente_provincia) REFERENCES Provincia(provincia_codigo),
    FOREIGN KEY (cliente_localidad) REFERENCES Localidad(localidad_codigo)
);

CREATE TABLE Sucursal (
    sucursal_codigo BIGINT PRIMARY KEY,
    sucursal_provincia BIGINT,
    sucursal_localidad BIGINT,
    sucursal_direccion NVARCHAR(255),
    sucursal_telefono NVARCHAR(255),
    sucursal_mail NVARCHAR(255),
    FOREIGN KEY (sucursal_provincia) REFERENCES Provincia(provincia_codigo),
    FOREIGN KEY (sucursal_localidad) REFERENCES Localidad(localidad_codigo)
);

CREATE TABLE Estado (
    estado_numero BIGINT PRIMARY KEY,
    estado_tipo NVARCHAR(255)
);

CREATE TABLE Pedido (
    pedido_numero DECIMAL(18,0) PRIMARY KEY,
    pedido_sucursal BIGINT,
    pedido_cliente BIGINT,
    pedido_fecha DATETIME2(6),
    pedido_total DECIMAL(18,2),
    pedido_estado BIGINT,
    FOREIGN KEY (pedido_sucursal) REFERENCES Sucursal(sucursal_codigo),
    FOREIGN KEY (pedido_cliente) REFERENCES Cliente(cliente_codigo),
	FOREIGN KEY (pedido_estado) REFERENCES Estado(estado_numero)
);

CREATE TABLE Pedido_Cancelacion (
    pedido_cancelacion_pedido DECIMAL(18,0) PRIMARY KEY,
    pedido_cancelacion_fecha DATETIME2(6),
    pedido_cancelacion_motivo NVARCHAR(255),
    FOREIGN KEY (pedido_cancelacion_pedido) REFERENCES Pedido(pedido_numero)
);

CREATE TABLE Factura (
    factura_numero BIGINT PRIMARY KEY,
    factura_cliente BIGINT,
    factura_sucursal BIGINT,
    factura_fecha DATETIME2(6),
    factura_total DECIMAL(38,2),
    FOREIGN KEY (factura_cliente) REFERENCES Cliente(cliente_codigo),
    FOREIGN KEY (factura_sucursal) REFERENCES Sucursal(sucursal_codigo)
);

CREATE TABLE Envio (
    envio_numero DECIMAL(18,0) PRIMARY KEY,
    envio_factura_numero BIGINT,
    envio_fecha_programado DATETIME2(6),
    envio_fecha_entrega DATETIME2(6),
    envio_importe_traslado DECIMAL(18,2),
    envio_importe_subida DECIMAL(18,2),
    envio_total DECIMAL(18,2),
    FOREIGN KEY (envio_factura_numero) REFERENCES Factura(factura_numero)
);

CREATE TABLE Medida (
    medida_codigo BIGINT PRIMARY KEY,
    medida_ancho DECIMAL(18,2),
    medida_alto DECIMAL(18,2),
    medida_profundidad DECIMAL(18,2),
    medida_precio DECIMAL(18,2)
);

CREATE TABLE Sillon_Modelo (
    sillon_modelo_codigo BIGINT PRIMARY KEY,
    sillon_modelo NVARCHAR(255),
    sillon_modelo_descripcion NVARCHAR(255),
    sillon_modelo_precio DECIMAL(18,2)
);

CREATE TABLE Sillon (
    sillon_codigo BIGINT PRIMARY KEY,
    sillon_modelo BIGINT,
	sillon_modelo_precio DECIMAL(18,2),
    sillon_medida BIGINT,
	sillon_medida_precio DECIMAL(18,2)
    FOREIGN KEY (sillon_modelo) REFERENCES Sillon_Modelo(sillon_modelo_codigo),
    FOREIGN KEY (sillon_medida) REFERENCES Medida(medida_codigo)
);

CREATE TABLE Item_Pedido (
    item_pedido_codigo BIGINT PRIMARY KEY,
    item_pedido_codigo_pedido DECIMAL(18,0),
    item_pedido_sillon BIGINT,
    item_pedido_precio_unitario DECIMAL(18,2),
    item_pedido_cantidad BIGINT,
    item_pedido_subtotal DECIMAL(18,2),
    FOREIGN KEY (item_pedido_codigo_pedido) REFERENCES Pedido(pedido_numero),
	FOREIGN KEY (item_pedido_sillon) REFERENCES Sillon(sillon_codigo)
);

CREATE TABLE Item_Factura (
    item_factura_codigo BIGINT PRIMARY KEY,
    item_factura_item_pedido_codigo BIGINT,
    item_factura_codigo_factura BIGINT,
    item_factura_precio_unitario DECIMAL(18,2),
    item_factura_cantidad DECIMAL(18,0),
    item_factura_subtotal DECIMAL(18,2),
    FOREIGN KEY (item_factura_item_pedido_codigo) REFERENCES Item_Pedido(item_pedido_codigo),
    FOREIGN KEY (item_factura_codigo_factura) REFERENCES Factura(factura_numero)
);

CREATE TABLE Proveedor (
    proveedor_codigo BIGINT PRIMARY KEY,
    proveedor_cuit NVARCHAR(255),
    proveedor_razonSocial NVARCHAR(255),
    proveedor_direccion NVARCHAR(255),
    proveedor_provincia BIGINT,
    proveedor_localidad BIGINT,
    proveedor_mail NVARCHAR(255),
    proveedor_telefono NVARCHAR(255),
    FOREIGN KEY (proveedor_provincia) REFERENCES Provincia(provincia_codigo),
    FOREIGN KEY (proveedor_localidad) REFERENCES Localidad(localidad_codigo)
);

CREATE TABLE Compra (
    compra_numero DECIMAL(18,0) PRIMARY KEY,
    compra_sucursal BIGINT,
    compra_proveedor BIGINT,
    compra_fecha DATETIME2(6),
    compra_total DECIMAL(18,2),
    FOREIGN KEY (compra_sucursal) REFERENCES Sucursal(sucursal_codigo),
    FOREIGN KEY (compra_proveedor) REFERENCES Proveedor(proveedor_codigo)
);

CREATE TABLE Tipo_Material (
    tipo_material_codigo BIGINT PRIMARY KEY,
    tipo_material_nombre NVARCHAR(255)
);

CREATE TABLE Material (
    material_codigo BIGINT PRIMARY KEY,
    material_tipo BIGINT,
    material_nombre NVARCHAR(255),
    material_descripcion NVARCHAR(255),
    material_precio DECIMAL(38,2),
    FOREIGN KEY (material_tipo) REFERENCES Tipo_Material(tipo_material_codigo)
);

CREATE TABLE Item_Compra (
    item_compra_codigo BIGINT PRIMARY KEY,
    item_compra_codigo_compra DECIMAL(18,0),
    item_compra_material BIGINT,
    item_compra_precio_unitario DECIMAL(18,2),
    item_compra_cantidad DECIMAL(18,0),
    item_compra_subtotal DECIMAL(18,2),
    FOREIGN KEY (item_compra_codigo_compra) REFERENCES Compra(compra_numero),
    FOREIGN KEY (item_compra_material) REFERENCES Material(material_codigo)
);

CREATE TABLE Sillon_Material (
    sillon_material_codigo_sillon BIGINT,
    sillon_material_codigo_material BIGINT,
    sillon_material_precio DECIMAL(38,2),
    PRIMARY KEY (sillon_material_codigo_sillon, sillon_material_codigo_material),
    FOREIGN KEY (sillon_material_codigo_sillon) REFERENCES Sillon(sillon_codigo),
    FOREIGN KEY (sillon_material_codigo_material) REFERENCES Material(material_codigo)
);

CREATE TABLE Tela (
    tela_material_codigo BIGINT PRIMARY KEY,
    tela_color NVARCHAR(255),
    tela_textura NVARCHAR(255),
    FOREIGN KEY (tela_material_codigo) REFERENCES Material(material_codigo)
);

CREATE TABLE Madera (
    madera_material_codigo BIGINT PRIMARY KEY,
    madera_color NVARCHAR(255),
    madera_dureza NVARCHAR(255),
    FOREIGN KEY (madera_material_codigo) REFERENCES Material(material_codigo)
);

CREATE TABLE Relleno (
    relleno_material_codigo BIGINT PRIMARY KEY,
    relleno_densidad DECIMAL(38,2),
    FOREIGN KEY (relleno_material_codigo) REFERENCES Material(material_codigo)
);
