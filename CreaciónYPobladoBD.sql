-- Eliminar tablas hijas primero (dependientes)
DROP TABLE DETALLE_RENTA CASCADE CONSTRAINTS;
DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS;
DROP TABLE STOCK_SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE RENTA CASCADE CONSTRAINTS;
DROP TABLE VENTA CASCADE CONSTRAINTS;
DROP TABLE TARJETA CASCADE CONSTRAINTS;
DROP TABLE RESEÑA CASCADE CONSTRAINTS;
DROP TABLE PLATAFORMA CASCADE CONSTRAINTS;
DROP TABLE CATEGORIA CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE PRODUCTO CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE REPARTIDOR CASCADE CONSTRAINTS;

-- Tabla REGION
CREATE TABLE REGION (
    ID_region NUMBER(38) PRIMARY KEY,
    Nombre_reg VARCHAR2(50 CHAR) NOT NULL
);

-- Tabla CATEGORIA
CREATE TABLE CATEGORIA (
    ID_categoria NUMBER(38) PRIMARY KEY,
    Nombre_categoria VARCHAR2(50 CHAR) NOT NULL
);

-- Tabla PLATAFORMA
CREATE TABLE PLATAFORMA (
    ID_plataforma NUMBER(38) PRIMARY KEY,
    Nombre_plataforma VARCHAR2(50 CHAR) NOT NULL
);

-- Tabla PRODUCTO
CREATE TABLE PRODUCTO (
    ID_producto NUMBER(38) PRIMARY KEY,
    Nombre_prod VARCHAR2(50 CHAR) NOT NULL,
    Precio NUMBER(38) NOT NULL,
    Disponible_para_renta VARCHAR2(3 CHAR) NOT NULL,
    Clasificacion_edad VARCHAR2(15 CHAR) NOT NULL,
    Tipo_producto VARCHAR2(10 CHAR) DEFAULT 'Físico' NOT NULL,
    ID_categoria NUMBER(38) NOT NULL,
    ID_plataforma NUMBER(38) NOT NULL,
    FOREIGN KEY (ID_categoria) REFERENCES CATEGORIA(ID_categoria),
    FOREIGN KEY (ID_plataforma) REFERENCES PLATAFORMA(ID_plataforma)
);

-- Tabla CLIENTE
CREATE TABLE CLIENTE (
    ID_cli NUMBER(38) PRIMARY KEY,
    Run NUMBER(8) NOT NULL,
    Dv_run VARCHAR2(1 CHAR) NOT NULL,
    P_nombre VARCHAR2(30 CHAR) NOT NULL,
    S_nombre VARCHAR2(30 CHAR) NOT NULL,
    P_apellido VARCHAR2(30 CHAR) NOT NULL,
    S_apellido VARCHAR2(30 CHAR) NOT NULL,
    Fecha_nacimiento DATE NOT NULL,
    Correo VARCHAR2(50 CHAR) NOT NULL,
    Contraseña VARCHAR2(20 CHAR) NOT NULL,
    Direccion VARCHAR2(50 CHAR)
);

-- Tabla REPARTIDOR
CREATE TABLE REPARTIDOR (
    ID_rp NUMBER(38) PRIMARY KEY,
    Run_rp NUMBER(8) NOT NULL,
    Dv_run_rp VARCHAR2(1 CHAR) NOT NULL,
    P_nombre_rp VARCHAR2(30 CHAR) NOT NULL,
    S_nombre_rp VARCHAR2(30 CHAR) NOT NULL,
    P_apellido_rp VARCHAR2(30 CHAR) NOT NULL,
    S_apellido_rp VARCHAR2(30 CHAR) NOT NULL,
    Fecha_nacimiento_rp DATE NOT NULL,
    Telefono_rp NUMBER(15) NOT NULL,
    Vehiculo_rp VARCHAR2(30 CHAR) NOT NULL,
    Disponibilidad_rp VARCHAR2(3 CHAR) NOT NULL
);

-- Tabla CIUDAD
CREATE TABLE CIUDAD (
    ID_ciudad NUMBER(38) PRIMARY KEY,
    Nombre_ciu VARCHAR2(50 CHAR) NOT NULL,
    REGION_ID_region NUMBER(38) NOT NULL,
    FOREIGN KEY (REGION_ID_region) REFERENCES REGION(ID_region)
);

-- Tabla COMUNA
CREATE TABLE COMUNA (
    ID_comuna NUMBER(38) PRIMARY KEY,
    Nombre_com VARCHAR2(50 CHAR) NOT NULL,
    CIUDAD_ID_ciudad NUMBER(38) NOT NULL,
    FOREIGN KEY (CIUDAD_ID_ciudad) REFERENCES CIUDAD(ID_ciudad)
);

-- Tabla SUCURSAL
CREATE TABLE SUCURSAL (
    ID_sucursal NUMBER(38) PRIMARY KEY,
    Nombre_suc VARCHAR2(30 CHAR) NOT NULL,
    Direccion VARCHAR2(50 CHAR) NOT NULL,
    COMUNA_ID_comuna NUMBER(38) NOT NULL,
    FOREIGN KEY (COMUNA_ID_comuna) REFERENCES COMUNA(ID_comuna)
);

-- Tabla TARJETA
CREATE TABLE TARJETA (
    ID_tarjeta NUMBER(38) PRIMARY KEY,
    Numero_tarjeta VARCHAR2(20 CHAR) NOT NULL,
    Nombre_titular VARCHAR2(50 CHAR) NOT NULL,
    Fecha_vencimiento DATE NOT NULL,
    Tipo VARCHAR2(15 CHAR) NOT NULL,
    CLIENTE_ID_cli NUMBER(38) NOT NULL,
    FOREIGN KEY (CLIENTE_ID_cli) REFERENCES CLIENTE(ID_cli)
);

-- Tabla RESEÑA
CREATE TABLE RESEÑA (
    ID_reseña NUMBER(38) PRIMARY KEY,
    Calificacion VARCHAR2(15 CHAR) NOT NULL,
    Comentario VARCHAR2(50 CHAR),
    Fecha DATE NOT NULL,
    PRODUCTO_ID_producto NUMBER(38) NOT NULL,
    CLIENTE_ID_cli NUMBER(38) NOT NULL,
    FOREIGN KEY (PRODUCTO_ID_producto) REFERENCES PRODUCTO(ID_producto),
    FOREIGN KEY (CLIENTE_ID_cli) REFERENCES CLIENTE(ID_cli)
);

-- Tabla RENTA
CREATE TABLE RENTA (
    ID_renta NUMBER(38) PRIMARY KEY,
    Fecha_inicio DATE NOT NULL,
    Fecha_fin DATE NOT NULL,
    Fecha_devolucion DATE,
    Tarifa_diaria NUMBER(10,3) NOT NULL,
    Total_renta NUMBER(10,3) NOT NULL,
    Multa NUMBER(10,3) NOT NULL,
    SUCURSAL_ID_sucursal NUMBER(38) NOT NULL,
    CLIENTE_ID_cli NUMBER(38) NOT NULL,
    FOREIGN KEY (SUCURSAL_ID_sucursal) REFERENCES SUCURSAL(ID_sucursal),
    FOREIGN KEY (CLIENTE_ID_cli) REFERENCES CLIENTE(ID_cli)
);

-- Tabla DETALLE_RENTA
CREATE TABLE DETALLE_RENTA (
    ID_detalle_renta NUMBER(38) PRIMARY KEY,
    Cantidad NUMBER(5) NOT NULL,
    Precio_unitario NUMBER(10,3) NOT NULL,
    RENTA_ID_renta NUMBER(38) NOT NULL,
    PRODUCTO_ID_producto NUMBER(38) NOT NULL,
    FOREIGN KEY (RENTA_ID_renta) REFERENCES RENTA(ID_renta),
    FOREIGN KEY (PRODUCTO_ID_producto) REFERENCES PRODUCTO(ID_producto)
);

-- Tabla VENTA
CREATE TABLE VENTA (
    ID_venta NUMBER(38) PRIMARY KEY,
    Fecha DATE NOT NULL,
    Total NUMBER(10,3) NOT NULL,
    Metodo_pago VARCHAR2(15 CHAR) NOT NULL,
    Tipo_envio VARCHAR2(15 CHAR) NOT NULL,
    Direccion_envio VARCHAR2(50 CHAR) NOT NULL,
    SUCURSAL_ID_sucursal NUMBER(38) NOT NULL,
    REPARTIDOR_ID_rp NUMBER(38) NOT NULL,
    CLIENTE_ID_cli NUMBER(38) NOT NULL,
    FOREIGN KEY (SUCURSAL_ID_sucursal) REFERENCES SUCURSAL(ID_sucursal),
    FOREIGN KEY (REPARTIDOR_ID_rp) REFERENCES REPARTIDOR(ID_rp),
    FOREIGN KEY (CLIENTE_ID_cli) REFERENCES CLIENTE(ID_cli)
);

-- Tabla DETALLE_VENTA
CREATE TABLE DETALLE_VENTA (
    ID_detalle_venta NUMBER(38) PRIMARY KEY,
    Cantidad NUMBER(5) NOT NULL,
    Precio_unitario NUMBER(10,3) NOT NULL,
    VENTA_ID_venta NUMBER(38) NOT NULL,
    PRODUCTO_ID_producto NUMBER(38) NOT NULL,
    FOREIGN KEY (VENTA_ID_venta) REFERENCES VENTA(ID_venta),
    FOREIGN KEY (PRODUCTO_ID_producto) REFERENCES PRODUCTO(ID_producto)
);

-- Tabla STOCK_SUCURSAL
CREATE TABLE STOCK_SUCURSAL (
    ID_stock NUMBER(38) GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    ID_producto NUMBER(38) NOT NULL,
    ID_sucursal NUMBER(38) NOT NULL,
    Stock_venta NUMBER(38) DEFAULT 0 NOT NULL,
    FOREIGN KEY (ID_producto) REFERENCES PRODUCTO(ID_producto),
    FOREIGN KEY (ID_sucursal) REFERENCES SUCURSAL(ID_sucursal)
);

-- ============================================
-- POBLADO DE TABLAS
-- ============================================
-- REGIONES
-- ============================================
INSERT INTO REGION VALUES (1, 'Metropolitana');
INSERT INTO REGION VALUES (2, 'Valparaíso');
INSERT INTO REGION VALUES (3, 'Biobío');
INSERT INTO REGION VALUES (4, 'Araucanía');

-- ============================================
-- CIUDADES
-- ============================================
INSERT INTO CIUDAD VALUES (1, 'Santiago', 1);       -- Región Metropolitana
INSERT INTO CIUDAD VALUES (2, 'Valparaíso', 2);     -- Región Valparaíso
INSERT INTO CIUDAD VALUES (3, 'Concepción', 3);     -- Región Biobío
INSERT INTO CIUDAD VALUES (4, 'Temuco', 4);         -- Región Araucanía

-- ============================================
-- COMUNAS
-- ============================================
INSERT INTO COMUNA VALUES (1, 'Maipú', 1);              -- Santiago
INSERT INTO COMUNA VALUES (2, 'Providencia', 1);        -- Santiago
INSERT INTO COMUNA VALUES (3, 'Viña del Mar', 2);       -- Valparaíso
INSERT INTO COMUNA VALUES (4, 'Talcahuano', 3);         -- Concepción
INSERT INTO COMUNA VALUES (5, 'Padre Las Casas', 4);    -- Temuco

-- ============================================
-- SUCURSALES
-- ============================================
INSERT INTO SUCURSAL VALUES (1, 'Sucursal Maipú', 'Av. Pajaritos 123', 1);
INSERT INTO SUCURSAL VALUES (2, 'Sucursal Providencia', 'Av. Providencia 456', 2);
INSERT INTO SUCURSAL VALUES (3, 'Sucursal Viña del Mar', 'Av. Libertad 789', 3);
INSERT INTO SUCURSAL VALUES (4, 'Sucursal Talcahuano', 'Av. Colón 321', 4);
INSERT INTO SUCURSAL VALUES (5, 'Sucursal Padre Las Casas', 'Ruta 5 Sur Km 5', 5);

-- ============================================
-- CLIENTES
-- ============================================
INSERT INTO CLIENTE VALUES (1, 23098765, '2', 'Josefa', 'Mariana', 'Contreras', 'Del Río', TO_DATE('2008-03-08','YYYY-MM-DD'), 'josefa.contreras@example.com', 'abc444', 'Calle Libertad 120, Viña del Mar');
INSERT INTO CLIENTE VALUES (2, 14567891, '2', 'Juan', 'Carlos', 'Pérez', 'Gómez', TO_DATE('1989-05-12','YYYY-MM-DD'), 'juan.perez@example.com', 'pass123', 'Av. Pajaritos 100, Maipú');
INSERT INTO CLIENTE VALUES (3, 20123456, '8', 'Isidora', 'Constanza', 'Peña', 'Bravo', TO_DATE('2000-12-01','YYYY-MM-DD'), 'isidora.pena@example.com', 'abc987', 'Av. Providencia 300, Providencia');
INSERT INTO CLIENTE VALUES (4, 18567890, '2', 'Diego', 'Ignacio', 'Pizarro', 'Cáceres', TO_DATE('1997-09-12','YYYY-MM-DD'), 'diego.pizarro@example.com', 'abc456', 'Av. Colón 350, Talcahuano');
INSERT INTO CLIENTE VALUES (5, 24432109, '1', 'Trinidad', 'Renata', 'Meza', 'Figueroa', TO_DATE('2012-02-14','YYYY-MM-DD'), 'trinidad.meza@example.com', 'clave444', 'Ruta 5 Sur 25, Padre Las Casas');
INSERT INTO CLIENTE VALUES (6, 15123456, '5', 'María', 'José', 'Ramírez', 'Torres', TO_DATE('1990-03-22','YYYY-MM-DD'), 'maria.ramirez@example.com', 'clave456', 'Av. Providencia 200, Providencia');
INSERT INTO CLIENTE VALUES (7, 23012345, 'K', 'Ignacio', 'Benjamín', 'Riquelme', 'Escobar', TO_DATE('2008-07-17','YYYY-MM-DD'), 'ignacio.riquelme@example.com', 'clave333', 'Av. Providencia 350, Providencia');
INSERT INTO CLIENTE VALUES (8, 15876543, 'K', 'Carlos', 'Andrés', 'Soto', 'Muñoz', TO_DATE('1991-07-10','YYYY-MM-DD'), 'carlos.soto@example.com', 'abc789', 'Calle Libertad 50, Viña del Mar');
INSERT INTO CLIENTE VALUES (9, 17432109, '7', 'Camila', 'Andrea', 'Navarro', 'Silva', TO_DATE('1994-08-20','YYYY-MM-DD'), 'camila.navarro@example.com', 'abc123', 'Av. Pajaritos 150, Maipú');
INSERT INTO CLIENTE VALUES (10, 16987654, '9', 'Luis', 'Miguel', 'González', 'Vega', TO_DATE('1993-01-15','YYYY-MM-DD'), 'luis.gonzalez@example.com', 'clave654', 'Ruta 5 Sur 10, Padre Las Casas');
INSERT INTO CLIENTE VALUES (11, 19876543, '5', 'Matías', 'Alonso', 'Araya', 'Fuentes', TO_DATE('1999-10-05','YYYY-MM-DD'), 'matias.araya@example.com', 'clave321', 'Av. Pajaritos 180, Maipú');
INSERT INTO CLIENTE VALUES (12, 21543210, '9', 'Daniela', 'Rocío', 'Espinoza', 'Aguilar', TO_DATE('2002-06-25','YYYY-MM-DD'), 'daniela.espinoza@example.com', 'clave222', 'Av. Colón 400, Talcahuano');
INSERT INTO CLIENTE VALUES (13, 16234567, '3', 'Ana', 'Beatriz', 'Fernández', 'Rojas', TO_DATE('1992-11-30','YYYY-MM-DD'), 'ana.fernandez@example.com', 'pass321', 'Av. Colón 300, Talcahuano');
INSERT INTO CLIENTE VALUES (14, 22123456, '3', 'Tomás', 'Felipe', 'Martínez', 'Henríquez', TO_DATE('2005-09-09','YYYY-MM-DD'), 'tomas.martinez@example.com', 'abc333', 'Ruta 5 Sur 20, Padre Las Casas');
INSERT INTO CLIENTE VALUES (15, 24098765, '4', 'Cristóbal', 'Emilio', 'Leiva', 'Zúñiga', TO_DATE('2011-11-11','YYYY-MM-DD'), 'cristobal.leiva@example.com', 'pass333', 'Av. Colón 450, Talcahuano');
INSERT INTO CLIENTE VALUES (16, 22456789, '7', 'Antonia', 'Lucía', 'Vargas', 'Campos', TO_DATE('2006-05-30','YYYY-MM-DD'), 'antonia.vargas@example.com', 'pass222', 'Av. Pajaritos 200, Maipú');
INSERT INTO CLIENTE VALUES (17, 20876543, '6', 'Sebastián', 'Tomás', 'Cifuentes', 'Saavedra', TO_DATE('2001-03-03','YYYY-MM-DD'), 'sebastian.cifuentes@example.com', 'pass111', 'Calle Libertad 100, Viña del Mar');
INSERT INTO CLIENTE VALUES (18, 18123456, '4', 'Valentina', 'Isabel', 'Reyes', 'López', TO_DATE('1996-02-28','YYYY-MM-DD'), 'valentina.reyes@example.com', 'clave987', 'Calle Libertad 80, Viña del Mar');
INSERT INTO CLIENTE VALUES (19, 19123456, 'K', 'Fernanda', 'Paola', 'Salinas', 'Morales', TO_DATE('1998-04-18','YYYY-MM-DD'), 'fernanda.salinas@example.com', 'pass654', 'Ruta 5 Sur 15, Padre Las Casas');
INSERT INTO CLIENTE VALUES (20, 17890123, '1', 'Jorge', 'Esteban', 'Mora', 'Castillo', TO_DATE('1995-06-05','YYYY-MM-DD'), 'jorge.mora@example.com', 'pass789', 'Av. Providencia 250, Providencia');

-- ============================================
-- REPARTIDORES
-- ============================================
INSERT INTO REPARTIDOR VALUES (1, 14500123, 'K', 'Rodrigo', 'Andrés', 'Muñoz', 'Salinas', TO_DATE('1980-04-15','YYYY-MM-DD'), 912345678, 'Moto', 'Sí');
INSERT INTO REPARTIDOR VALUES (2, 15111234, '3', 'Paula', 'Fernanda', 'Gutiérrez', 'Vega', TO_DATE('1985-06-22','YYYY-MM-DD'), 987654321, 'Auto', 'No');
INSERT INTO REPARTIDOR VALUES (3, 15822345, '9', 'Felipe', 'Ignacio', 'Castro', 'Pizarro', TO_DATE('1990-09-10','YYYY-MM-DD'), 956789012, 'Bicicleta', 'Sí');
INSERT INTO REPARTIDOR VALUES (4, 16233456, 'K', 'Nicole', 'Andrea', 'Morales', 'Henríquez', TO_DATE('1992-12-01','YYYY-MM-DD'), 934567890, 'Moto', 'Sí');
INSERT INTO REPARTIDOR VALUES (5, 16944567, '2', 'Cristian', 'Esteban', 'Sanhueza', 'Bravo', TO_DATE('1994-03-18','YYYY-MM-DD'), 923456789, 'Auto', 'No');
INSERT INTO REPARTIDOR VALUES (6, 17455678, '7', 'Tamara', 'Isidora', 'Campos', 'Navarro', TO_DATE('1996-07-25','YYYY-MM-DD'), 945678901, 'Moto', 'Sí');
INSERT INTO REPARTIDOR VALUES (7, 17866789, '5', 'Benjamín', 'Alonso', 'Figueroa', 'Cáceres', TO_DATE('1997-11-30','YYYY-MM-DD'), 978901234, 'Auto', 'Sí');
INSERT INTO REPARTIDOR VALUES (8, 18177890, '1', 'Lorena', 'María', 'Espinoza', 'Zúñiga', TO_DATE('1998-05-09','YYYY-MM-DD'), 965432109, 'Bicicleta', 'No');
INSERT INTO REPARTIDOR VALUES (9, 18588901, '4', 'Gabriel', 'Tomás', 'Aravena', 'Fuentes', TO_DATE('1999-08-14','YYYY-MM-DD'), 987321654, 'Moto', 'Sí');
INSERT INTO REPARTIDOR VALUES (10, 19199012, '6', 'Valeria', 'Constanza', 'Silva', 'Del Río', TO_DATE('2000-01-27','YYYY-MM-DD'), 976543210, 'Auto', 'Sí');

-- ============================================
-- CATEGORÍAS DE VIDEOJUEGOS
-- ============================================
INSERT INTO CATEGORIA VALUES (1, 'Acción');
INSERT INTO CATEGORIA VALUES (2, 'Aventura');
INSERT INTO CATEGORIA VALUES (3, 'Deportes');
INSERT INTO CATEGORIA VALUES (4, 'Terror');
INSERT INTO CATEGORIA VALUES (5, 'Carreras');
INSERT INTO CATEGORIA VALUES (6, 'Rol');

-- ============================================
-- PLATAFORMAS DISPONIBLES
-- ============================================
INSERT INTO PLATAFORMA VALUES (1, 'PlayStation 4');
INSERT INTO PLATAFORMA VALUES (2, 'PlayStation 5');
INSERT INTO PLATAFORMA VALUES (3, 'Xbox One');
INSERT INTO PLATAFORMA VALUES (4, 'Xbox Series X');
INSERT INTO PLATAFORMA VALUES (5, 'Nintendo Switch');
INSERT INTO PLATAFORMA VALUES (6, 'PC');

-- ============================================
-- PRODUCTOS
-- ============================================
INSERT INTO PRODUCTO VALUES (1, 'The Legend of Zelda: Breath of the Wild', 49990, 'Sí', '+12', 'Físico', 2, 5);
INSERT INTO PRODUCTO VALUES (2, 'FIFA 24', 59990, 'Sí', '+7', 'Físico', 3, 2);
INSERT INTO PRODUCTO VALUES (3, 'Resident Evil Village', 39990, 'No', '+18', 'Digital', 4, 4);
INSERT INTO PRODUCTO VALUES (4, 'Gran Turismo 7', 54990, 'Sí', '+7', 'Físico', 5, 2);
INSERT INTO PRODUCTO VALUES (5, 'Elden Ring', 59990, 'No', '+16', 'Digital', 6, 6);
INSERT INTO PRODUCTO VALUES (6, 'Mario Kart 8 Deluxe', 49990, 'Sí', '+7', 'Físico', 5, 5);
INSERT INTO PRODUCTO VALUES (7, 'God of War: Ragnarök', 64990, 'Sí', '+18', 'Físico', 1, 1);
INSERT INTO PRODUCTO VALUES (8, 'Hogwarts Legacy', 59990, 'No', '+12', 'Digital', 2, 2);
INSERT INTO PRODUCTO VALUES (9, 'NBA 2K24', 59990, 'Sí', '+7', 'Físico', 3, 3);
INSERT INTO PRODUCTO VALUES (10, 'The Last of Us Part II', 39990, 'Sí', '+18', 'Físico', 1, 1);
INSERT INTO PRODUCTO VALUES (11, 'Animal Crossing: New Horizons', 44990, 'Sí', '+3', 'Físico', 2, 5);
INSERT INTO PRODUCTO VALUES (12, 'Cyberpunk 2077', 49990, 'No', '+18', 'Digital', 6, 6);
INSERT INTO PRODUCTO VALUES (13, 'Forza Horizon 5', 54990, 'Sí', '+7', 'Físico', 5, 4);
INSERT INTO PRODUCTO VALUES (14, 'Assassin’s Creed Mirage', 59990, 'No', '+16', 'Digital', 1, 6);
INSERT INTO PRODUCTO VALUES (15, 'Metroid Dread', 49990, 'Sí', '+12', 'Físico', 2, 5);
INSERT INTO PRODUCTO VALUES (16, 'Call of Duty: Modern Warfare II', 64990, 'Sí', '+18', 'Físico', 1, 1);
INSERT INTO PRODUCTO VALUES (17, 'It Takes Two', 29990, 'No', '+12', 'Digital', 2, 6);
INSERT INTO PRODUCTO VALUES (18, 'Minecraft', 29990, 'Sí', '+7', 'Físico', 6, 6);
INSERT INTO PRODUCTO VALUES (19, 'Dead Space Remake', 59990, 'No', '+18', 'Digital', 4, 4);
INSERT INTO PRODUCTO VALUES (20, 'Crash Team Racing Nitro-Fueled', 39990, 'Sí', '+7', 'Físico', 5, 5);

-- ============================================
-- STOCK POR SUCURSAL (productos físicos)
-- ============================================
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (1, 1, 10); -- Zelda en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (1, 2, 8);  -- Zelda en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (1, 3, 5);  -- Zelda en Viña

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (2, 1, 12); -- FIFA en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (2, 4, 9);  -- FIFA en Talcahuano
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (2, 5, 6);  -- FIFA en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (4, 2, 7);  -- Gran Turismo en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (4, 3, 4);  -- Gran Turismo en Viña
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (4, 5, 10); -- Gran Turismo en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (6, 1, 15); -- Mario Kart en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (6, 5, 8);  -- Mario Kart en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (7, 2, 6);  -- God of War en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (7, 3, 3);  -- God of War en Viña
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (7, 4, 9);  -- God of War en Talcahuano

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (9, 1, 5);  -- NBA en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (9, 2, 7);  -- NBA en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (9, 4, 4);  -- NBA en Talcahuano

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (10, 1, 6); -- Last of Us en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (10, 2, 5); -- Last of Us en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (10, 3, 2); -- Last of Us en Viña

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (11, 3, 10); -- Animal Crossing en Viña
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (11, 5, 7);  -- Animal Crossing en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (13, 4, 9);  -- Forza en Talcahuano
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (13, 5, 6);  -- Forza en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (15, 1, 4);  -- Metroid en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (15, 3, 5);  -- Metroid en Viña
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (15, 5, 3);  -- Metroid en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (16, 2, 11); -- Call of Duty en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (16, 4, 7);  -- Call of Duty en Talcahuano

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (18, 1, 10); -- Minecraft en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (18, 2, 8);  -- Minecraft en Providencia
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (18, 5, 6);  -- Minecraft en Padre Las Casas

INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (20, 1, 5);  -- Crash Team Racing en Maipú
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (20, 3, 4);  -- Crash Team Racing en Viña
INSERT INTO STOCK_SUCURSAL (ID_producto, ID_sucursal, Stock_venta) VALUES (20, 4, 3);  -- Crash Team Racing en Talcahuano

-- ============================================
-- VENTAS
-- ============================================
INSERT INTO VENTA VALUES (1, TO_DATE('2024-03-15','YYYY-MM-DD'), 59990, 'Tarjeta', 'Domicilio', 'Av. Pajaritos 123', 2, 1, 1);
INSERT INTO VENTA VALUES (2, TO_DATE('2024-04-10','YYYY-MM-DD'), 99980, 'Efectivo', 'Retiro', 'Av. Libertad 789', 5, 3, 2);
INSERT INTO VENTA VALUES (3, TO_DATE('2024-04-10','YYYY-MM-DD'), 64990, 'Tarjeta', 'Domicilio', 'Av. Colón 321', 4, 4, 3);
INSERT INTO VENTA VALUES (4, TO_DATE('2024-04-10','YYYY-MM-DD'), 119970, 'Débito', 'Domicilio', 'Ruta 5 Sur Km 5', 5, 6, 4);
INSERT INTO VENTA VALUES (5, TO_DATE('2024-07-18','YYYY-MM-DD'), 44990, 'Tarjeta', 'Retiro', 'Av. Providencia 456', 2, 7, 5);
INSERT INTO VENTA VALUES (6, TO_DATE('2024-08-03','YYYY-MM-DD'), 109980, 'Efectivo', 'Domicilio', 'Av. Colón 350', 4, 9, 6);
INSERT INTO VENTA VALUES (7, TO_DATE('2024-09-12','YYYY-MM-DD'), 49990, 'Débito', 'Domicilio', 'Ruta 5 Sur 25', 5, 10, 7);
INSERT INTO VENTA VALUES (8, TO_DATE('2024-10-01','YYYY-MM-DD'), 129980, 'Tarjeta', 'Retiro', 'Av. Providencia 300', 1, 1, 8);
INSERT INTO VENTA VALUES (9, TO_DATE('2024-11-20','YYYY-MM-DD'), 29990, 'Efectivo', 'Domicilio', 'Calle Libertad 50', 3, 3, 9);
INSERT INTO VENTA VALUES (10, TO_DATE('2024-12-05','YYYY-MM-DD'), 79980, 'Débito', 'Domicilio', 'Ruta 5 Sur 10', 5, 4, 10);
INSERT INTO VENTA VALUES (11, TO_DATE('2025-01-14','YYYY-MM-DD'), 49990, 'Tarjeta', 'Retiro', 'Av. Pajaritos 180', 1, 6, 11);
INSERT INTO VENTA VALUES (12, TO_DATE('2025-02-28','YYYY-MM-DD'), 179970, 'Efectivo', 'Domicilio', 'Av. Colón 400', 4, 7, 12);
INSERT INTO VENTA VALUES (13, TO_DATE('2025-02-28','YYYY-MM-DD'), 54990, 'Débito', 'Domicilio', 'Av. Colón 300', 4, 9, 13);
INSERT INTO VENTA VALUES (14, TO_DATE('2025-02-28','YYYY-MM-DD'), 99980, 'Tarjeta', 'Retiro', 'Ruta 5 Sur 20', 5, 10, 14);
INSERT INTO VENTA VALUES (15, TO_DATE('2025-05-05','YYYY-MM-DD'), 64990, 'Efectivo', 'Domicilio', 'Av. Colón 450', 4, 1, 15);
INSERT INTO VENTA VALUES (16, TO_DATE('2025-06-18','YYYY-MM-DD'), 119980, 'Débito', 'Domicilio', 'Av. Pajaritos 200', 1, 3, 16);
INSERT INTO VENTA VALUES (17, TO_DATE('2025-07-30','YYYY-MM-DD'), 39990, 'Tarjeta', 'Retiro', 'Calle Libertad 100', 3, 4, 17);
INSERT INTO VENTA VALUES (18, TO_DATE('2025-07-30','YYYY-MM-DD'), 89980, 'Efectivo', 'Domicilio', 'Calle Libertad 80', 3, 6, 18);
INSERT INTO VENTA VALUES (19, TO_DATE('2025-07-30','YYYY-MM-DD'), 54990, 'Débito', 'Domicilio', 'Ruta 5 Sur 15', 5, 7, 19);
INSERT INTO VENTA VALUES (20, TO_DATE('2025-10-20','YYYY-MM-DD'), 194970, 'Tarjeta', 'Retiro', 'Av. Providencia 250', 2, 9, 20);

-- ============================================
-- DETALLE_VENTA
-- ============================================
-- VENTA 1: Zelda
INSERT INTO DETALLE_VENTA VALUES (1, 1, 59990, 1, 1);

-- VENTA 2: FIFA + Mario Kart
INSERT INTO DETALLE_VENTA VALUES (2, 1, 49990, 2, 2);
INSERT INTO DETALLE_VENTA VALUES (3, 1, 50000, 2, 6);

-- VENTA 3: God of War
INSERT INTO DETALLE_VENTA VALUES (4, 1, 64990, 3, 7);

-- VENTA 4: Last of Us + Metroid + Animal Crossing
INSERT INTO DETALLE_VENTA VALUES (5, 1, 39990, 4, 10);
INSERT INTO DETALLE_VENTA VALUES (6, 1, 40000, 4, 15);
INSERT INTO DETALLE_VENTA VALUES (7, 1, 40000, 4, 11);

-- VENTA 5: Animal Crossing
INSERT INTO DETALLE_VENTA VALUES (8, 1, 44990, 5, 11);

-- VENTA 6: Forza + FIFA
INSERT INTO DETALLE_VENTA VALUES (9, 1, 54990, 6, 13);
INSERT INTO DETALLE_VENTA VALUES (10, 1, 55000, 6, 2);

-- VENTA 7: God of War
INSERT INTO DETALLE_VENTA VALUES (11, 1, 49990, 7, 7);

-- VENTA 8: Call of Duty + Zelda
INSERT INTO DETALLE_VENTA VALUES (12, 1, 64990, 8, 16);
INSERT INTO DETALLE_VENTA VALUES (13, 1, 65000, 8, 1);

-- VENTA 9: Minecraft
INSERT INTO DETALLE_VENTA VALUES (14, 1, 29990, 9, 18);

-- VENTA 10: Crash Team Racing + Metroid
INSERT INTO DETALLE_VENTA VALUES (15, 1, 39990, 10, 20);
INSERT INTO DETALLE_VENTA VALUES (16, 1, 40000, 10, 15);

-- VENTA 11: Zelda
INSERT INTO DETALLE_VENTA VALUES (17, 1, 49990, 11, 1);

-- VENTA 12: FIFA + NBA + Hogwarts
INSERT INTO DETALLE_VENTA VALUES (18, 1, 59990, 12, 2);
INSERT INTO DETALLE_VENTA VALUES (19, 1, 60000, 12, 9);
INSERT INTO DETALLE_VENTA VALUES (20, 1, 60000, 12, 8);

-- ============================================
-- RENTAS
-- ============================================
-- RENTAS DEVUELTAS A TIEMPO
INSERT INTO RENTA VALUES (1, TO_DATE('2024-03-10','YYYY-MM-DD'), TO_DATE('2024-03-17','YYYY-MM-DD'), TO_DATE('2024-03-17','YYYY-MM-DD'), 3990, 27930, 0, 1, 1);
INSERT INTO RENTA VALUES (2, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-08','YYYY-MM-DD'), TO_DATE('2024-04-08','YYYY-MM-DD'), 4990, 69860, 0, 2, 2);
INSERT INTO RENTA VALUES (4, TO_DATE('2024-06-12','YYYY-MM-DD'), TO_DATE('2024-06-19','YYYY-MM-DD'), TO_DATE('2024-06-19','YYYY-MM-DD'), 3990, 27930, 0, 5, 4);
INSERT INTO RENTA VALUES (6, TO_DATE('2024-08-15','YYYY-MM-DD'), TO_DATE('2024-08-22','YYYY-MM-DD'), TO_DATE('2024-08-22','YYYY-MM-DD'), 4990, 34930, 0, 2, 6);
INSERT INTO RENTA VALUES (7, TO_DATE('2024-09-03','YYYY-MM-DD'), TO_DATE('2024-09-10','YYYY-MM-DD'), TO_DATE('2024-09-10','YYYY-MM-DD'), 3490, 24430, 0, 3, 7);
INSERT INTO RENTA VALUES (9, TO_DATE('2024-11-01','YYYY-MM-DD'), TO_DATE('2024-11-06','YYYY-MM-DD'), TO_DATE('2024-11-06','YYYY-MM-DD'), 4490, 22450, 0, 4, 9);
INSERT INTO RENTA VALUES (10, TO_DATE('2024-12-10','YYYY-MM-DD'), TO_DATE('2024-12-17','YYYY-MM-DD'), TO_DATE('2024-12-17','YYYY-MM-DD'), 3990, 27930, 0, 5, 10);
INSERT INTO RENTA VALUES (12, TO_DATE('2025-02-14','YYYY-MM-DD'), TO_DATE('2025-02-21','YYYY-MM-DD'), TO_DATE('2025-02-21','YYYY-MM-DD'), 3490, 24430, 0, 1, 12);
INSERT INTO RENTA VALUES (15, TO_DATE('2025-05-20','YYYY-MM-DD'), TO_DATE('2025-05-27','YYYY-MM-DD'), TO_DATE('2025-05-27','YYYY-MM-DD'), 4990, 34930, 0, 2, 15);
INSERT INTO RENTA VALUES (17, TO_DATE('2025-07-15','YYYY-MM-DD'), TO_DATE('2025-07-22','YYYY-MM-DD'), TO_DATE('2025-07-22','YYYY-MM-DD'), 3990, 27930, 0, 3, 17);

-- RENTAS CON RETRASO
INSERT INTO RENTA VALUES (3, TO_DATE('2024-05-05','YYYY-MM-DD'), TO_DATE('2024-05-10','YYYY-MM-DD'), TO_DATE('2024-05-12','YYYY-MM-DD'), 4490, 22450, 8980, 4, 3);
INSERT INTO RENTA VALUES (5, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-07-06','YYYY-MM-DD'), TO_DATE('2024-07-09','YYYY-MM-DD'), 6499, 64990, 38994, 5, 5);
INSERT INTO RENTA VALUES (8, TO_DATE('2024-10-20','YYYY-MM-DD'), TO_DATE('2024-10-27','YYYY-MM-DD'), TO_DATE('2024-10-29','YYYY-MM-DD'), 3990, 55860, 7980, 1, 8);
INSERT INTO RENTA VALUES (11, TO_DATE('2025-01-05','YYYY-MM-DD'), TO_DATE('2025-01-12','YYYY-MM-DD'), TO_DATE('2025-01-16','YYYY-MM-DD'), 4990, 69980, 39920, 2, 11);
INSERT INTO RENTA VALUES (13, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-08','YYYY-MM-DD'), TO_DATE('2025-03-10','YYYY-MM-DD'), 3490, 24430, 6980, 3, 13);
INSERT INTO RENTA VALUES (14, TO_DATE('2025-04-10','YYYY-MM-DD'), TO_DATE('2025-04-17','YYYY-MM-DD'), TO_DATE('2025-04-20','YYYY-MM-DD'), 3990, 55860, 23940, 4, 14);
INSERT INTO RENTA VALUES (16, TO_DATE('2025-06-05','YYYY-MM-DD'), TO_DATE('2025-06-12','YYYY-MM-DD'), TO_DATE('2025-06-15','YYYY-MM-DD'), 4490, 62860, 26940, 5, 16);
INSERT INTO RENTA VALUES (18, TO_DATE('2025-08-01','YYYY-MM-DD'), TO_DATE('2025-08-08','YYYY-MM-DD'), TO_DATE('2025-08-10','YYYY-MM-DD'), 6499, 32495, 12998, 1, 18);
INSERT INTO RENTA VALUES (19, TO_DATE('2025-09-10','YYYY-MM-DD'), TO_DATE('2025-09-17','YYYY-MM-DD'), TO_DATE('2025-09-20','YYYY-MM-DD'), 4990, 69860, 29940, 2, 19);
INSERT INTO RENTA VALUES (20, TO_DATE('2025-10-25','YYYY-MM-DD'), TO_DATE('2025-11-01','YYYY-MM-DD'), TO_DATE('2025-11-03','YYYY-MM-DD'), 3490, 24430, 6980, 3, 20);

-- ============================================
-- DETALLE_RENTA
-- ============================================
-- DETALLE_RENTA para RENTAS devueltas a tiempo
INSERT INTO DETALLE_RENTA VALUES (1, 1, 3990, 1, 1);
INSERT INTO DETALLE_RENTA VALUES (2, 2, 4990, 2, 2);
INSERT INTO DETALLE_RENTA VALUES (3, 1, 3990, 4, 4);
INSERT INTO DETALLE_RENTA VALUES (4, 1, 4990, 6, 6);
INSERT INTO DETALLE_RENTA VALUES (5, 1, 3490, 7, 7);
INSERT INTO DETALLE_RENTA VALUES (6, 1, 4490, 9, 9);
INSERT INTO DETALLE_RENTA VALUES (7, 1, 3990, 10, 10);
INSERT INTO DETALLE_RENTA VALUES (8, 1, 3490, 12, 12);
INSERT INTO DETALLE_RENTA VALUES (9, 1, 4990, 15, 15);
INSERT INTO DETALLE_RENTA VALUES (10, 1, 3990, 17, 17);

-- DETALLE_RENTA para RENTAS con retraso
INSERT INTO DETALLE_RENTA VALUES (11, 1, 4490, 3, 3);
INSERT INTO DETALLE_RENTA VALUES (12, 2, 6499, 5, 5);
INSERT INTO DETALLE_RENTA VALUES (13, 1, 3990, 8, 8);
INSERT INTO DETALLE_RENTA VALUES (14, 2, 4990, 11, 11);
INSERT INTO DETALLE_RENTA VALUES (15, 1, 3490, 13, 13);
INSERT INTO DETALLE_RENTA VALUES (16, 2, 3990, 14, 14);
INSERT INTO DETALLE_RENTA VALUES (17, 2, 4490, 16, 16);
INSERT INTO DETALLE_RENTA VALUES (18, 1, 6499, 18, 18);
INSERT INTO DETALLE_RENTA VALUES (19, 2, 4990, 19, 19);
INSERT INTO DETALLE_RENTA VALUES (20, 1, 3490, 20, 20);

-- ============================================
-- TARJETAS DE CLIENTES QUE HAN RENTADO
-- ============================================
INSERT INTO TARJETA VALUES (1, '4567123412341234', 'Juan Pérez', TO_DATE('2026-08-31','YYYY-MM-DD'), 'Crédito', 1);
INSERT INTO TARJETA VALUES (2, '5123456789012345', 'Camila Soto', TO_DATE('2027-03-31','YYYY-MM-DD'), 'Débito', 2);
INSERT INTO TARJETA VALUES (3, '4012888888881881', 'Luis Martínez', TO_DATE('2026-12-31','YYYY-MM-DD'), 'Crédito', 4);
INSERT INTO TARJETA VALUES (4, '378282246310005', 'Valentina Rojas', TO_DATE('2028-06-30','YYYY-MM-DD'), 'Crédito', 5);
INSERT INTO TARJETA VALUES (5, '6011111111111117', 'Diego Fuentes', TO_DATE('2027-11-30','YYYY-MM-DD'), 'Débito', 7);
INSERT INTO TARJETA VALUES (6, '3530111333300000', 'Sofía Ramírez', TO_DATE('2026-09-30','YYYY-MM-DD'), 'Crédito', 9);
INSERT INTO TARJETA VALUES (7, '4111111111111111', 'Ignacio Torres', TO_DATE('2028-01-31','YYYY-MM-DD'), 'Débito', 10);
INSERT INTO TARJETA VALUES (8, '5105105105105100', 'Fernanda Díaz', TO_DATE('2027-07-31','YYYY-MM-DD'), 'Crédito', 11);
INSERT INTO TARJETA VALUES (9, '6011000990139424', 'Matías Herrera', TO_DATE('2026-05-31','YYYY-MM-DD'), 'Débito', 13);
INSERT INTO TARJETA VALUES (10, '4000056655665556', 'Carolina Muñoz', TO_DATE('2027-10-31','YYYY-MM-DD'), 'Crédito', 15);
INSERT INTO TARJETA VALUES (11, '2223000048400011', 'Tomás Vega', TO_DATE('2026-03-31','YYYY-MM-DD'), 'Débito', 16);
INSERT INTO TARJETA VALUES (12, '5200828282828210', 'Antonia Bravo', TO_DATE('2028-04-30','YYYY-MM-DD'), 'Crédito', 18);
INSERT INTO TARJETA VALUES (13, '6011000400000000', 'Benjamín Reyes', TO_DATE('2027-06-30','YYYY-MM-DD'), 'Débito', 20);

-- ============================================
-- RESEÑAS DE CLIENTES
-- ============================================
INSERT INTO RESEÑA VALUES (1, '5', 'Muy buen juego de fútbol, gráficos mejorados.', TO_DATE('2024-04-15','YYYY-MM-DD'), 2, 5);
INSERT INTO RESEÑA VALUES (2, '4', 'Divertido para jugar en familia, algo repetitivo.', TO_DATE('2024-04-12','YYYY-MM-DD'), 5, 4);
INSERT INTO RESEÑA VALUES (3, '5', 'Historia y jugabilidad. Lo mejor de la saga.', TO_DATE('2024-06-01','YYYY-MM-DD'), 7, 5);
INSERT INTO RESEÑA VALUES (4, '4', 'Buena narrativa, algo lento al inicio.', TO_DATE('2024-06-10','YYYY-MM-DD'), 10, 4);
INSERT INTO RESEÑA VALUES (5, '5', 'Relajante y adictivo. Ideal para descansar.', TO_DATE('2024-07-20','YYYY-MM-DD'), 11, 5);
INSERT INTO RESEÑA VALUES (6, '4', 'Fanáticos de autos. Gráficos excelentes.', TO_DATE('2024-08-10','YYYY-MM-DD'), 13, 4);
INSERT INTO RESEÑA VALUES (7, '3', 'Entretenido pero algo corto.', TO_DATE('2024-09-15','YYYY-MM-DD'), 14, 3);
INSERT INTO RESEÑA VALUES (8, '5', 'Acción intensa y buen multijugador.', TO_DATE('2024-10-05','YYYY-MM-DD'), 16, 5);
INSERT INTO RESEÑA VALUES (9, '4', 'Creativo y educativo. Ideal para niños.', TO_DATE('2024-11-25','YYYY-MM-DD'), 18, 4);
INSERT INTO RESEÑA VALUES (10, '4', 'Controles duros, pero muy entretenido.', TO_DATE('2024-12-10','YYYY-MM-DD'), 20, 4);
INSERT INTO RESEÑA VALUES (11, '5', 'Obra maestra. Mundo abierto impresionante.', TO_DATE('2025-01-20','YYYY-MM-DD'), 1, 5);
INSERT INTO RESEÑA VALUES (12, '4', 'Buen simulador de conducción.', TO_DATE('2025-03-15','YYYY-MM-DD'), 4, 4);
INSERT INTO RESEÑA VALUES (13, '5', 'Ideal para jugar con amigos. Muy divertido.', TO_DATE('2025-03-20','YYYY-MM-DD'), 6, 5);
INSERT INTO RESEÑA VALUES (14, '3', 'Modo carrera necesita mejoras.', TO_DATE('2025-04-01','YYYY-MM-DD'), 9, 3);
INSERT INTO RESEÑA VALUES (15, '4', 'Gran diseño y jugabilidad clásica.', TO_DATE('2025-05-10','YYYY-MM-DD'), 15, 4);
INSERT INTO RESEÑA VALUES (16, '5', 'FIFA sigue siendo el rey del fútbol.', TO_DATE('2025-06-01','YYYY-MM-DD'), 2, 5);
INSERT INTO RESEÑA VALUES (17, '4', 'Buena historia, algo predecible.', TO_DATE('2025-06-25','YYYY-MM-DD'), 7, 4);
INSERT INTO RESEÑA VALUES (18, '3', 'Esperaba más del final.', TO_DATE('2025-08-01','YYYY-MM-DD'), 10, 3);
INSERT INTO RESEÑA VALUES (19, '5', 'Relajante después del trabajo.', TO_DATE('2025-08-20','YYYY-MM-DD'), 11, 5);
INSERT INTO RESEÑA VALUES (20, '4', 'Variedad de autos y pistas.', TO_DATE('2025-09-10','YYYY-MM-DD'), 13, 4);