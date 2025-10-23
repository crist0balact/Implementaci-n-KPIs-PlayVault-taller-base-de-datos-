--CREAR TABLAS PARA ALMACENAR KPI
-- Tabla para KPI 1: Clientes con más compras
CREATE TABLE KPI_CLIENTES_TOP (
  ID_cli NUMBER(38),
  Total_compras NUMBER(10)
);

-- Tabla para KPI 2: Ingresos totales por sucursal
CREATE TABLE KPI_INGRESOS_SUCURSAL (
  ID_sucursal NUMBER(38),
  Total_ingresos NUMBER(10,2)
);

-- Tabla para KPI 3: Productos sin reseña
CREATE TABLE KPI_PRODUCTOS_SIN_RESEÑA (
  ID_producto NUMBER(38)
);

-- Tabla para KPI 4: Producto más vendido
CREATE TABLE KPI_PRODUCTO_TOP (
  ID_producto NUMBER(38),
  Total_vendido NUMBER(10)
);

-- Tabla para KPI 5: Rentas con retraso
CREATE TABLE KPI_RENTAS_RETRASO (
  ID_renta NUMBER(38),
  Dias_retraso NUMBER(5)
);

-- Tabla para KPI 6: Promedio de calificación por producto
CREATE TABLE KPI_RESEÑAS_PROMEDIO (
  ID_producto NUMBER(38),
  Promedio NUMBER(4,2)
);

-- Tabla para KPI 7: Total de ventas por mes
CREATE TABLE KPI_VENTAS_MES (
  Mes VARCHAR2(7), -- formato 'YYYY-MM'
  Total NUMBER(10,2)
);

--CREAR PROCEDIMIENTOS/KPIS DENTRO DE UN PACKAGE KPI_ANALISIS
CREATE OR REPLACE PACKAGE KPI_ANALISIS AS
  PROCEDURE Calcular_KPI_Clientes_Top;
  PROCEDURE Calcular_KPI_Ingresos_Sucursal;
  PROCEDURE Calcular_KPI_Productos_Sin_Reseña;
  PROCEDURE Calcular_KPI_Producto_Top;
  PROCEDURE Calcular_KPI_Rentas_Retraso;
  PROCEDURE Calcular_KPI_Reseñas_Promedio;
  PROCEDURE Calcular_KPI_Ventas_Mes;
END KPI_ANALISIS;

--CREAR CUERPO DEL PACKAGE
CREATE OR REPLACE PACKAGE BODY KPI_ANALISIS AS

  --KPI 1 Clientes con más compras
  PROCEDURE Calcular_KPI_Clientes_Top IS
  BEGIN
    DELETE FROM KPI_CLIENTES_TOP;
    INSERT INTO KPI_CLIENTES_TOP (ID_cli, Total_compras)
    SELECT CLIENTE_ID_cli, COUNT(*)
    FROM VENTA
    GROUP BY CLIENTE_ID_cli
    ORDER BY COUNT(*) DESC;
  END;

  --KPI 2 Ingresos totales por sucursal (corregido)
  PROCEDURE Calcular_KPI_Ingresos_Sucursal IS
  BEGIN
    DELETE FROM KPI_INGRESOS_SUCURSAL;
    INSERT INTO KPI_INGRESOS_SUCURSAL (ID_sucursal, Total_ingresos)
    SELECT SUCURSAL_ID_sucursal, SUM(Total)
    FROM VENTA
    GROUP BY SUCURSAL_ID_sucursal;

    MERGE INTO KPI_INGRESOS_SUCURSAL k
    USING (
      SELECT SUCURSAL_ID_sucursal, SUM(Total_renta) AS Total_renta
      FROM RENTA
      GROUP BY SUCURSAL_ID_sucursal
    ) r
    ON (k.ID_sucursal = r.SUCURSAL_ID_sucursal)
    WHEN MATCHED THEN
      UPDATE SET k.Total_ingresos = k.Total_ingresos + r.Total_renta
    WHEN NOT MATCHED THEN
      INSERT (ID_sucursal, Total_ingresos)
      VALUES (r.SUCURSAL_ID_sucursal, r.Total_renta);
  END;

  --KPI 3 Productos sin reseña
  PROCEDURE Calcular_KPI_Productos_Sin_Reseña IS
  BEGIN
    DELETE FROM KPI_PRODUCTOS_SIN_RESEÑA;
    INSERT INTO KPI_PRODUCTOS_SIN_RESEÑA (ID_producto)
    SELECT ID_producto
    FROM PRODUCTO
    WHERE ID_producto NOT IN (
      SELECT DISTINCT PRODUCTO_ID_producto
      FROM RESEÑA
    );
  END;

  --KPI 4 Producto más vendido
  PROCEDURE Calcular_KPI_Producto_Top IS
  BEGIN
    DELETE FROM KPI_PRODUCTO_TOP;
    INSERT INTO KPI_PRODUCTO_TOP (ID_producto, Total_vendido)
    SELECT PRODUCTO_ID_producto, SUM(Cantidad)
    FROM DETALLE_VENTA
    GROUP BY PRODUCTO_ID_producto
    ORDER BY SUM(Cantidad) DESC;
  END;

  --KPI 5 Rentas con retraso
  PROCEDURE Calcular_KPI_Rentas_Retraso IS
  BEGIN
    DELETE FROM KPI_RENTAS_RETRASO;
    INSERT INTO KPI_RENTAS_RETRASO (ID_renta, Dias_retraso)
    SELECT ID_renta, Fecha_devolucion - Fecha_fin
    FROM RENTA
    WHERE Fecha_devolucion > Fecha_fin;
  END;

  --KPI 6 Promedio de calificación por producto
  PROCEDURE Calcular_KPI_Reseñas_Promedio IS
  BEGIN
    DELETE FROM KPI_RESEÑAS_PROMEDIO;
    INSERT INTO KPI_RESEÑAS_PROMEDIO (ID_producto, Promedio)
    SELECT PRODUCTO_ID_producto, AVG(TO_NUMBER(Calificacion))
    FROM RESEÑA
    GROUP BY PRODUCTO_ID_producto;
  END;

  --KPI 7 Total de ventas por mes
  PROCEDURE Calcular_KPI_Ventas_Mes IS
  BEGIN
    DELETE FROM KPI_VENTAS_MES;
    INSERT INTO KPI_VENTAS_MES (Mes, Total)
    SELECT TO_CHAR(Fecha, 'YYYY-MM'), SUM(Total)
    FROM VENTA
    GROUP BY TO_CHAR(Fecha, 'YYYY-MM');
  END;

END KPI_ANALISIS;

--CREAR TRIGGERS
--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 1: Clientes con más compras
-- Se ejecuta cuando se insertan, eliminan o actualizan ventas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_clientes_top
AFTER INSERT OR DELETE OR UPDATE ON VENTA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Clientes_Top;
END;
/

--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 2: Ingresos totales por sucursal
-- Se ejecuta cuando cambian datos en VENTA o RENTA
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_ingresos_sucursal_venta
AFTER INSERT OR DELETE OR UPDATE ON VENTA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Ingresos_Sucursal;
END;
/

CREATE OR REPLACE TRIGGER trg_kpi_ingresos_sucursal_renta
AFTER INSERT OR DELETE OR UPDATE ON RENTA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Ingresos_Sucursal;
END;
/

--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 3: Productos sin reseña
-- Se ejecuta cuando se insertan, eliminan o actualizan reseñas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_productos_sin_reseña
AFTER INSERT OR DELETE OR UPDATE ON RESEÑA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Productos_Sin_Reseña;
END;
/

--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 4: Producto más vendido
-- Se ejecuta cuando se insertan, eliminan o actualizan detalles de venta
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_producto_top
AFTER INSERT OR DELETE OR UPDATE ON DETALLE_VENTA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Producto_Top;
END;
/

--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 5: Rentas con retraso
-- Se ejecuta cuando se insertan, eliminan o actualizan rentas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_rentas_retraso
AFTER INSERT OR DELETE OR UPDATE ON RENTA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Rentas_Retraso;
END;
/

--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 6: Promedio de calificación por producto
-- Se ejecuta cuando se insertan, eliminan o actualizan reseñas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_reseñas_promedio
AFTER INSERT OR DELETE OR UPDATE ON RESEÑA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Reseñas_Promedio;
END;
/

--------------------------------------------------------------------------------
-- TRIGGER PARA KPI 7: Total de ventas por mes
-- Se ejecuta cuando se insertan, eliminan o actualizan ventas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_kpi_ventas_mes
AFTER INSERT OR DELETE OR UPDATE ON VENTA
BEGIN
  KPI_ANALISIS.Calcular_KPI_Ventas_Mes;
END;
/

--------------------------------------------------------------------------------
-- FUNCIONES ALMACENADAS PARA CONSULTA DE KPIs Y MÉTRICAS
--------------------------------------------------------------------------------
-- FUNCIÓN 1: Total global de ventas
-- Sin parámetros. Devuelve la suma total de todas las ventas registradas.
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Total_Ventas_Global RETURN NUMBER IS
  total NUMBER;
BEGIN
  SELECT SUM(Total) INTO total FROM VENTA;
  RETURN NVL(total, 0); -- Si no hay ventas, devuelve 0
END;
/

--------------------------------------------------------------------------------
-- FUNCIÓN 2: Total de ventas por cliente
-- Con parámetro. Devuelve la suma de ventas asociadas a un cliente específico.
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Total_Ventas_Cliente(p_id_cliente NUMBER) RETURN NUMBER IS
  total NUMBER;
BEGIN
  SELECT SUM(Total) INTO total
  FROM VENTA
  WHERE CLIENTE_ID_cli = p_id_cliente;
  RETURN NVL(total, 0); -- Si el cliente no tiene ventas, devuelve 0
END;
/

--------------------------------------------------------------------------------
-- FUNCIÓN 3: Promedio de calificación por producto
-- Con parámetro. Devuelve el promedio de calificaciones para un producto dado.
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Promedio_Calificacion_Producto(p_id_producto NUMBER) RETURN NUMBER IS
  promedio NUMBER;
BEGIN
  SELECT AVG(TO_NUMBER(Calificacion)) INTO promedio
  FROM RESEÑA
  WHERE PRODUCTO_ID_producto = p_id_producto;
  RETURN NVL(promedio, 0); -- Si no hay reseñas, devuelve 0
END;
/

--------------------------------------------------------------------------------
-- FUNCIÓN 4: Total de rentas con retraso
-- Sin parámetros. Devuelve la cantidad de rentas que fueron devueltas tarde.
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Total_Rentas_Retrasadas RETURN NUMBER IS
  total NUMBER;
BEGIN
  SELECT COUNT(*) INTO total
  FROM RENTA
  WHERE Fecha_devolucion > Fecha_fin;
  RETURN total;
END;
/

--------------------------------------------------------------------------------
-- COMPROBAR FUNCIONES ALMACENADAS
--------------------------------------------------------------------------------
-- Total global de ventas (sin parámetro)
SELECT Total_Ventas_Global FROM DUAL;

-- Total de ventas por cliente con ID
SELECT Total_Ventas_Cliente(1) FROM DUAL;

-- Promedio de calificación del producto con ID
SELECT Promedio_Calificacion_Producto(2) FROM DUAL;

-- Total de rentas con retraso (sin parámetro)
SELECT Total_Rentas_Retrasadas FROM DUAL;

-- Ejecutar cada procedimiento manualmente
EXEC KPI_ANALISIS.Calcular_KPI_Clientes_Top;
EXEC KPI_ANALISIS.Calcular_KPI_Ingresos_Sucursal;
EXEC KPI_ANALISIS.Calcular_KPI_Productos_Sin_Reseña;
EXEC KPI_ANALISIS.Calcular_KPI_Producto_Top;
EXEC KPI_ANALISIS.Calcular_KPI_Rentas_Retraso;
EXEC KPI_ANALISIS.Calcular_KPI_Reseñas_Promedio;
EXEC KPI_ANALISIS.Calcular_KPI_Ventas_Mes;

-- Comprobar KPI
SELECT * FROM KPI_CLIENTES_TOP;
SELECT * FROM KPI_INGRESOS_SUCURSAL;
SELECT * FROM KPI_PRODUCTOS_SIN_RESEÑA;
SELECT * FROM KPI_PRODUCTO_TOP;
SELECT * FROM KPI_RENTAS_RETRASO;
SELECT * FROM KPI_RESEÑAS_PROMEDIO;
SELECT * FROM KPI_VENTAS_MES;


--PRUEBA TEMPORAL DE KPI PROMEDIO RESEÑAS
SELECT * FROM RESEÑA;
INSERT INTO RESEÑA VALUES (21, '1', 'Nada que ver con el 1.', TO_DATE('2025-11-9','YYYY-MM-DD'), 10, 4);

--PRUEBA TEMPORAL DE KPI PRODUCTOS SIN RESEÑAS
INSERT INTO RESEÑA VALUES (22, '1', 'xd.', TO_DATE('2025-11-9','YYYY-MM-DD'), 17, 4);

--PRUEBA TEMPORAL DE KPI VENTA POR CLIENTE
SELECT * FROM VENTA;
SELECT * FROM DETALLE_VENTA;
INSERT INTO VENTA VALUES (21, TO_DATE('2024-03-15','YYYY-MM-DD'), 59990, 'Tarjeta', 'Domicilio', 'Av. Pajaritos 123', 2, 1, 1);
INSERT INTO DETALLE_VENTA VALUES (21, 1, 59990, 1, 1);
