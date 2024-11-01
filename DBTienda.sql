CREATE TABLE Medida(
	IdMedida INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(50) NOT NULL,
	Abreviatura VARCHAR(4) NOT NULL,
	Equivalente VARCHAR(4) NOT NULL,
	Varlor INT NOT NULL
)

CREATE TABLE Categoria(
	IdCategoria INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(50) NOT NULL,
	Activo BIT DEFAULT 1,
	IdMedida INT REFERENCES Medida(IdMedida)
)

CREATE TABLE Producto(
	IdProducto INT PRIMARY KEY IDENTITY(1,1),
	Codigo VARCHAR(50) NOT NULL,
	Descripcion VARCHAR(150) NOT NULL,
	PrecioCompra DECIMAL(10,2) NOT NULL,
	PrecioVenta DECIMAL(10,2) NOT NULL,
	Cantidad INT NOT NULL,
	Activo BIT DEFAULT 1,
	IdCategoria INT REFERENCES Categoria(IdCategoria)
)

CREATE TABLE Rol(
	IdRol INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(50) NOT NULL
)

CREATE TABLE Usuario(
	IdUsuario INT PRIMARY KEY IDENTITY(1,1),
	NombreCompleto VARCHAR(50) NOT NULL,
	NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
	Correo VARCHAR(50) NOT NULL,
	Clave VARCHAR(100) NOT NULL,
	ResetearClave BIT DEFAULT 1,
	Activo BIT DEFAULT 1,
	IdRol INT REFERENCES Rol(IdRol)
)

CREATE TABLE CorrelativoVenta(
	Serie VARCHAR(3) NOT NULL,
	Numero INT NOT NULL,
	Activo BIT DEFAULT 1,
	PRIMARY KEY(Serie, Numero)
)

CREATE TABLE Venta(
	IdVenta INT PRIMARY KEY IDENTITY(1,1),
	NumeroVenta VARCHAR(10),
	NombreCliente VARCHAR(60),
	PrecioTotal DECIMAL(10,2) NOT NULL,
	PagoCon DECIMAL(10,2),
	Cambio DECIMAL(10,2),
	FechaRegistro DATETIME DEFAULT GETDATE(),
	Activo BIT DEFAULT 1,
	IdUsuarioRegistro INT REFERENCES Usuario(IdUsuario)
)

CREATE TABLE DetalleVenta(
	IdDetalleVenta INT PRIMARY KEY IDENTITY(1,1),
	Cantidad INT,
	PrecioVenta DECIMAL(10,2),
	PrecioTotal DECIMAL(10,2),
	IdVenta INT REFERENCES Venta(IdVenta),
	IdProducto INT REFERENCES Producto(IdProducto)
)

CREATE TABLE Negocio(
	IdNegocio INT PRIMARy KEY IDENTITY(1,1),
	RazonSocial VARCHAR(100),
	RUC VARCHAR(20),
	Direccion VARCHAR(100),
	Celular VARCHAR(10),
	Correo VARCHAR(30),
	SimboloMoneda VARCHAR(5),
	NombreLogo VARCHAR(100),
	UrlLogo VARCHAR(200)
)

CREATE TABLE Menu(
	IdMenu INT PRIMARY KEY IDENTITY(1,1),
	NombreMenu VARCHAR(50) NOT NULL,
	IdMenuPadre INT DEFAULT 0 NOT NULL
)

CREATE TABLE MenuRol(
	IdMenuRol INT PRIMARY KEY IDENTITY(1,1),
	Activo BIT DEFAULT 1,
	IdMenu INT REFERENCES Menu(IdMenu),
	IdRol INT REFERENCES Rol(IdRol)
)

CREATE PROCEDURE sp_listaMedida
AS
BEGIN
	SELECT 
		IdMedida,
		Nombre,
		Abreviatura,
		Equivalente,
		Valor
	FROM 
		Medida
END

CREATE PROCEDURE sp_listaCategoria(
	@Buscar VARCHAR(50) = ''
)
AS
BEGIN
	SELECT
		c.IdCategoria,
		c.Nombre,
		m.IdMedida,
		m.Nombre[NombreMedida],
		c.Activo
	FROM
		Categoria c
	INNER JOIN 
		Medida m ON m.IdMedida = c.IdMedida
	WHERE 
		CONCAT(c.Nombre, m.Nombre, IIF(c.Activo = 1, 'SI', 'NO')) LIKE '%' + @Buscar + '%'
END

CREATE PROCEDURE sp_crearCategoria(
	@Nombre VARCHAR(50),
	@IdMedida INT,
	@MsjError VARCHAR(100) OUTPUT
)
AS
BEGIN
	SET @MsjError = ''

	IF(EXISTS(SELECT * FROM Categoria WHERE Nombre = @Nombre))
	BEGIN
		SET @MsjError = 'El nombre de categoria ya existe'
		return
	END

	INSERT INTO 
		Categoria(
			Nombre, 
			IdMedida)
	VALUES(
		@Nombre, 
		@IdMedida)
END

CREATE PROCEDURE sp_editarCategoria(
	@IdCategoria INT,
	@Nombre VARCHAR(50),
	@IdMedida INT,
	@Activo INT,
	@MsjError VARCHAR(100) OUTPUT
)
AS
BEGIN
	SET @MsjError = ''

	IF(EXISTS(SELECT * FROM Categoria WHERE Nombre = @Nombre AND IdCategoria != @IdCategoria))
	BEGIN
		SET @MsjError = 'El nombre de categoria ya existe'
		return
	END

	UPDATE Categoria SET
		Nombre = @Nombre,
		IdMedida = @IdMedida,
		Activo = @Activo
	WHERE
		IdCategoria = @IdCategoria
END
