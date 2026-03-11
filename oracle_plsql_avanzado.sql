
-- Dependencias
-- Son objetos que dependen de otros objetos. Por ejemplo, una vista puede depender de una tabla. Si se elimina la tabla, la vista también se eliminará.
-- Para ver las dependencias de un objeto, se puede usar la vista USER_DEPENDENCIES. Por ejemplo, para ver las dependencias de una tabla llamada EMPLOYEES, se puede usar la siguiente consulta:

-- Las vistas dependen de as tablas (Directa)
-- Si los proceidmientos almacenados dependen de las tablas, si se eliminan las tablas, los procedimientos almacenados también se eliminarán.
-- o Si los procedimientos almacenados dependen de las vistas (Directa), si se eliminan las vistas, los procedimientos almacenados también se eliminarán. 



-- Detectar dependencias 
-- En esta tabla, se pueden ver las dependencias de los objetos. Por ejemplo, si se quiere ver las dependencias de la tabla EMPLOYEES, se puede usar la siguiente consulta: 

-- No se refieren a foren keys, sino a dependencias entre objetos. Por ejemplo, si una vista depende de una tabla, se mostrará en esta tabla. Si un procedimiento almacenado depende de una vista, también se mostrará en esta tabla.


SELECT * FROM USER_DEPENDENCIES;
SELECT * FROM USER_DEPENDENCIES WHERE NAME='EMPLOYEES';
SELECT * FROM USER_DEPENDENCIES WHERE NAME='EMP_DETAILS_VIEW';
SELECT * FROM USER_DEPENDENCIES WHERE NAME='LISTAR';
SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='EMPLOYEES';

-- Comprobar  el estado de los objetos Oracle

DESC USER_OBJECTS;

SELECT * FROM USER_OBJECTS;

SELECT STATUS,COUNT(*) FROM USER_OBJECTS GROUP BY STATUS;

SELECT * FROM USER_OBJECTS WHERE STATUS='INVALID';

-- Ejemplo practico de invalidacion de un objeto

DESC USER_OBJECTS;

SELECT * FROM USER_OBJECTS;

SELECT STATUS,COUNT(*) FROM USER_OBJECTS GROUP BY STATUS;

SELECT * FROM USER_OBJECTS WHERE STATUS='INVALID';


CREATE TABLE PRUEBA(C1 NUMBER, C2 NUMBER);

SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'PRUEBA';

CREATE VIEW PRUEBA_V AS SELECT C1 FROM PRUEBA;

SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'PRUEBA';


-- Si modifico la tabla PRUEBA especificamente en este caso  el capo que usa la vista,
-- la vista PRUEBA_V se invalidará, ya que depende de la tabla PRUEBA. Para modificar la tabla PRUEBA, se puede usar la siguiente consulta:    
ALTER TABLE PRUEBA MODIFY C2 VARCHAR2(1000); -- Aca no se invalida la vista, ya que la vista no depende del campo C2, sino del campo C1.
ALTER TABLE PRUEBA MODIFY C1 VARCHAR2(1000); -- Aca se invalida la vista, ya que la vista depende del campo C1.


-- Aun que esta invalida la vista, al realizar un select sobre la vista
-- Oracle intentará compilar la vista antes de ejecutar el select.
-- Si la vista no se puede compilar, se mostrará un error.
-- En este caso, la vista se valida, ya que oracle la compila automáticamente.
-- Pero si hay un error en la vista, por ejemplo, si se elimina el campo C1 de la tabla PRUEBA, la vista no se podrá compilar y se mostrará un error al intentar ejecutar el select sobre la vista.

SELECT * FROM PRUEBA_V;

ALTER TABLE PRUEBA DROP COLUMN C1;


-- Compilar procedimientos y funciones invalidas

-- Procedimiento que no depende de nada. 
CREATE OR REPLACE PROCEDURE PROC1
IS
BEGIN
	NULL;
END;
/

SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'PROC%';

-- Procedimiento que depende de PROC1.  
CREATE OR REPLACE PROCEDURE PROC2
IS
BEGIN
	PROC1;
END;
/

SELECT * FROM USER_DEPENDENCIES WHERE NAME='PROC2';

-- Si el PROC1 tiene tiene un error, el PROC2 se invalidará, ya que depende de PROC1.


-- Aunque corrija el error en PROC1, el PROC2 seguirá estando invalido,
-- ya que no se ha compilado después de corregir el error en PROC1. 
-- En caso de que Oracle no compile automáticamente el PROC2 después de 
--corregir el error en PROC1.


--Para compilar el PROC2, se puede usar la siguiente consulta:
ALTER PROCEDURE PROC2 COMPILE;

-- Tambien se puede hacer con las funciones
-- Ejemplo de función que depende de PROC1.
-- Alter function F1 COMPILE; 



-- Compilar paquetes invalidos


-- Spec de un paquete 
CREATE OR REPLACE PACKAGE  PAQ1 IS
    FUNCTION F1 RETURN NUMBER;
    PROCEDURE P1;
    PROCEDURE P2;
END;
/

SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'PAQ%';

-- Cuerpo del paquete
CREATE OR REPLACE PACKAGE BODY PAQ1 
IS
    FUNCTION F1 RETURN NUMBER
    IS
    BEGIN
        RETURN 0;
    END;
    
    
    PROCEDURE P1 IS 
    BEGIN
        NULL;
    END;
    
    PROCEDURE P2 IS 
    BEGIN
        NULL;
    END;
END;
/

-- si modifico la cabecera de un paquete, el cuerpo del paquete se invalidará, 
-- ya que depende de la cabecera del paquete. 

-- si modifico el body del paquete, la cabecera del paquete no se invalidará, 
-- ya que la cabecera del paquete no depende del body del paquete.

ALTER PACKAGE PAQ1 COMPILE;
ALTER PACKAGE  PAQ1  COMPILE BODY;
    
-- UTLDTREE, Ver jerarquias de dependencias

DESC USER_DEPENDENCIES;
SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PRUEBA';

CREATE OR REPLACE PROCEDURE PRUEBA_P
IS
    X NUMBER;
BEGIN 
    SELECT COUNT(*) INTO X FROM PRUEBA_V ;
END;
/

SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PRUEBA_V';


-- Con este script, se puede ver la jerarquia de dependencias de un objeto.
--  Por ejemplo, si se quiere ver la jerarquia de dependencias de la tabla PRUEBA,
--  se puede usar el siguiente script:

-- OJO, hay que ver e, video para poder ejecutar el script que crea
-- la tabla DEPTREE, el procedimiento deptree_fill y el procedimiento deptree_print.   


-- Ejecutar el procedimiento deptree_fill para llenar la tabla DEPTREE con las dependencias de la tabla PRUEBA.
-- Parametros,  (tipo de objeto de donde partimos, esquema de donde partimos, nombre del objeto de donde partimos   )

EXECUTE SYS.deptree_fill('TABLE','HR','PRUEBA');
SELECT * FROM DEPTREE;

SELECT LPAD(SEQ#,NESTED_LEVEL*1+1,'*') ||'  '||TYPE||' '||SCHEMA||' '||NAME FROM DEPTREE;



-- DBMS_UTILITY, Su uso con dependencias

set serveroutput on;

-- Determinal as dependencias de un objeto, por ejemplo, para la tabla PRUEBA,
-- se puede usar la siguiente consulta:
EXECUTE  DBMS_UTILITY.GET_DEPENDENCY('TABLE','HR','PRUEBA');


-- Validar un objeto, por ejemplo, para la tabla PRUEBA
-- Parametros () (tipo de objeto, esquema, nombre del objeto, nivel de validacion)
EXECUTE  DBMS_UTILITY.VALIDATE('HR','PRUEBA',1);

/*
1 = TABLE/PROCEDURE/TYPE
2 = BODY
3 = TRIGGER
4 = INDEX
5 = CLUSTER
8 = LOB
9 = DIRECTORY
10 = QUEUE*/


-- Compilar un objeto, por ejemplo, para la tabla PRUEBA
-- parametros () (esquema, nombre del objeto, tipo de compilacion, reutilizar configuraciones)
set serveroutput on;
EXECUTE  DBMS_UTILITY.COMPILE_SCHEMA('HR',COMPILE_ALL=>FALSE,REUSE_SETTINGS=>TRUE);


-- Cursores Varables : REF CURSORS
-- Son cursores que se pueden pasar como parámetros a procedimientos y funciones.
-- Se pueden usar para devolver un conjunto de resultados de una consulta a un programa cliente, como una aplicación Java o una aplicación .NET.


