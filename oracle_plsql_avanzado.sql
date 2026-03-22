
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

-- Son cursores variables, referecias a a otros cursores
set serveroutput on;
DECLARE 
--CURSOR C1 IS SELECT * FROM EMPLOYEE
     TYPE CURSOR_VARIABLE IS REF CURSOR ;
     V1 CURSOR_VARIABLE;
	 X1 CURSOR_VARIABLE;
     
     EMPLEADOS EMPLOYEES%ROWTYPE;
     
BEGIN

    OPEN V1 FOR SELECT * FROM EMPLOYEES;
    FETCH V1 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME||' '||EMPLEADOS.SALARY);
    
    CLOSE V1;

END;
/

-- Trabajar con cursores variables parte 1
set serveroutput on;
DECLARE 
--CURSOR C1 IS SELECT * FROM EMPLOYEE
     TYPE CURSOR_VARIABLE IS REF CURSOR ;
     V1 CURSOR_VARIABLE;
	 X1 CURSOR_VARIABLE;
     
     EMPLEADOS EMPLOYEES%ROWTYPE;
     
BEGIN
   
    -- Aca se coloca el query que estara asociado al cursor
    OPEN V1 FOR SELECT * FROM EMPLOYEES;
    FETCH V1 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME||' '||EMPLEADOS.SALARY);
    
    CLOSE V1;

END;
/

-- Trabajar con cursores variables parte 2

-- La variable C1, puede trabajar con varios querys

set serveroutput on;
DECLARE 
     TYPE CUR_REF1 IS REF CURSOR ;
     C1 CUR_REF1;
     
     EMPLEADOS EMPLOYEES%ROWTYPE;
     
     DEPARTAMENTOS DEPARTMENTS%ROWTYPE;

BEGIN

    OPEN C1 FOR SELECT * FROM EMPLOYEES;
    FETCH C1 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.SALARY);
        
    OPEN C1 FOR SELECT * FROM departments;
    FETCH C1 INTO DEPARTAMENTOS;
    DBMS_OUTPUT.PUT_LINE(DEPARTAMENTOS.DEPARTMENT_NAME);
    
    CLOSE C1;

END;
/

-- Recorrer el cursor con un bucle

set serveroutput on;
DECLARE
    TYPE CURSOR_VARIABLE is REF CURSOR;
    v1 CURSOR_VARIABLE;
    
    empleados employees%rowtype;
    departamentos departments%rowtype;
    
begin 

 DBMS_OUTPUT.PUT_LINE('Prueba');


    open V1 for SELECT * FROM EMPLOYEES;
    FETCH V1 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.SALARY);

    open V1 for SELECT * FROM DEPARTMENTS;
    FETCH V1 INTO DEPARTAMENTOS;
    DBMS_OUTPUT.PUT_LINE(DEPARTAMENTOS.DEPARTMENT_NAME);
    
    CLOSE V1;
	
	    
    OPEN V1 FOR SELECT * FROM DEPARTMENTS;
    FETCH V1 INTO DEPARTAMENTOS;
    WHILE V1%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(DEPARTAMENTOS.DEPARTMENT_NAME);
        FETCH V1 INTO DEPARTAMENTOS;
    END LOOP;
    CLOSE V1;
END;
/


-- REF CURSORS y tipos
-- Se le coloc un tipo, en este caso es de tipo de department

set serveroutput on
DECLARE
    -- CURSOR C1 IS SELECT * FROM EMPLOYEE;
    TYPE CURSOR_VARIABLE IS REF CURSOR RETURN DEPARTMENTS%ROWTYPE;
    V1 CURSOR_VARIABLE ;
    
    DEPARTAMENTOS DEPARTMENTS%ROWTYPE;
BEGIN
OPEN V1 FOR SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID > 150;
    FETCH V1 INTO DEPARTAMENTOS;
    WHILE V1%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(DEPARTAMENTOS.DEPARTMENT_NAME);
        FETCH V1 INTO DEPARTAMENTOS;
    END LOOP;
    CLOSE V1;
END;
/



-- REF CURSORS en funciones

-- Cuando se envia un ref cursors como parametro, se debe coloca in out

CREATE OR REPLACE PACKAGE PAQ1
AS
  TYPE C_VARIABLE IS REF CURSOR;
  FUNCTION DEVOLVER_DATOS(C1 IN OUT C_VARIABLE ,X NUMBER) RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY PAQ1 AS
   FUNCTION DEVOLVER_DATOS(C1 IN OUT C_VARIABLE ,X NUMBER) RETURN VARCHAR2
   IS     
        DEPARTAMENTOS DEPARTMENTS%ROWTYPE;
        EMPLEADOS EMPLOYEES%ROWTYPE;
   BEGIN
        IF X=1 THEN
            OPEN C1 FOR SELECT *  FROM EMPLOYEES;
            FETCH C1 INTO EMPLEADOS;
            RETURN EMPLEADOS.FIRST_NAME; 
            
        ELSE
            OPEN C1 FOR SELECT *  FROM DEPARTMENTS;
            FETCH C1 INTO DEPARTAMENTOS;
            RETURN DEPARTAMENTOS.DEPARTMENT_NAME; 
        END IF;
    END;
END;
/


--PROBAR EL CODIGO ANTERIOR
set serveroutput on;
DECLARE
  DATOS PAQ1.C_VARIABLE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(PAQ1.DEVOLVER_DATOS(DATOS,2));
END;
/


-- Compartir cursores
-- Como esos datos estan apuntados  por punteros en memoria
-- se puede compartir, es decir, en este caso le paso la variable V1  a la V2
-- Pero apuntan a la misma informacion, no se hace una copia

SET SERVEROUTPUT ON;


DECLARE
-- CURSOR C1 IS SELECT * FROM EMPLOYEE;
    TYPE CURSOR_VARIABLE IS REF CURSOR RETURN EMPLOYEES%ROWTYPE;
    V1 CURSOR_VARIABLE;
    V2 CURSOR_VARIABLE;
   
    EMPLEADOS EMPLOYEES%ROWTYPE;
    
BEGIN
    --ABRIMOS EL CURSOR CON LA PRIMERA VARIABLE
    OPEN V1 FOR SELECT * FROM EMPLOYEES ORDER BY FIRST_NAME;
    FETCH V1 INTO EMPLEADOS;
    
    -- Aca va a la fila uno
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME||' '||EMPLEADOS.SALARY);
    
    --ASIGNAMOS V1 A V2
    V2:=V1;
    FETCH V2 INTO EMPLEADOS;
    
    -- En este cso no muestra el numero uno, sino , el numero dos
    -- ya que sigue la referencia del puntero
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME||' '||EMPLEADOS.SALARY);
    
    FETCH V1 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME||' '||EMPLEADOS.SALARY);
    
    FETCH V2 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME||' '||EMPLEADOS.SALARY);
   
    CLOSE V1;
END;
/

-- SYS_REFCURSOR

SET SERVEROUTPUT ON

--SYS_REFCURSOR
-- Es un tipo predefinido, que es de tipo ref cursors
-- Sirve para indicar que una variable de tipo ref cursors, sin colcar el tipo
-- Si la variable retorna algo, no puede utilizarse

DECLARE
    --TYPE CURSOR_VARIABLE is REF CURSOR RETURN EMPLOYEES%ROWTYPE;
    V1 SYS_REFCURSOR;
    
    DEPARTAMENTOS DEPARTMENTS%ROWTYPE;   
    
begin 

	    
    OPEN V1 FOR SELECT * FROM DEPARTMENTS;
    FETCH V1 INTO DEPARTAMENTOS;
    WHILE V1%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(DEPARTAMENTOS.DEPARTMENT_NAME);
        FETCH V1 INTO DEPARTAMENTOS;
    END LOOP;
    CLOSE V1;
END;
/

-- Colecciones
-- Son parecidos a los arrays, donde guarda colecciones de objetos


-- Crear index By TALES Arrays asociativos
SET SERVEROUTPUT ON
DECLARE
  TYPE DEPARTAMENTOS IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE 
    INDEX BY PLS_INTEGER;
    
  DEPTS DEPARTAMENTOS;
  
  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
  
  EMPLES EMPLEADOS;
  
  TYPE NOMBRE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY VARCHAR2(2);
  NOMBRES NOMBRE;
  
BEGIN

  -- Acceder a las variables, con la claves, es decir 1, 2, 3 , AA, -1, etc
  -- no posiciones

  DEPTS(1):='HOLA';
  DEPTS(2):='ADIOS';
  DEPTS(50):='OTRO VALOR';
  DEPTS(-10):='SIGUIENTE VALOR';
  NOMBRES('AA'):='PEDRO';
    
  DBMS_OUTPUT.PUT_LINE(DEPTS(2));
  DBMS_OUTPUT.PUT_LINE(DEPTS(-10)); 
  DBMS_OUTPUT.PUT_LINE(NOMBRES('AA')); 
END;
/


--SPARSE

-- Introducir datos en na index by TABLE

SET SERVEROUTPUT ON
DECLARE
  TYPE DEPARTAMENTOS IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE 
    INDEX BY PLS_INTEGER;
    
  DEPTS DEPARTAMENTOS;
  
  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
  
  EMPLES EMPLEADOS;
  
  TYPE NOMBRE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY VARCHAR2(2);
  NOMBRES NOMBRE;
  
BEGIN
  DEPTS(1):='HOLA';
  DEPTS(2):='ADIOS';
  DEPTS(50):='OTRO VALOR';
  DEPTS(-10):='SIGUIENTE VALOR';
  NOMBRES('AA'):='PEDRO';
    
  DBMS_OUTPUT.PUT_LINE(DEPTS(2));
  DBMS_OUTPUT.PUT_LINE(DEPTS(-10)); 
  DBMS_OUTPUT.PUT_LINE(NOMBRES('AA')); 
END;
/
--SPARSE

SET SERVEROUTPUT ON
DECLARE
  TYPE DEPARTAMENTOS IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE 
    INDEX BY PLS_INTEGER;
    
  DEPTS DEPARTAMENTOS;
  
  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
  
  EMPLES EMPLEADOS;
  
  TYPE NOMBRE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY VARCHAR2(2);
  NOMBRES NOMBRE;
  
BEGIN
  DEPTS(1):='HOLA';
  DEPTS(2):='ADIOS';
  DEPTS(50):='OTRO VALOR';
  DEPTS(-10):='SIGUIENTE VALOR';
  NOMBRES('AA'):='PEDRO';
  
  EMPLES(10).FIRST_NAME:='SERGIO';
    
  DBMS_OUTPUT.PUT_LINE(DEPTS(2));
  DBMS_OUTPUT.PUT_LINE(DEPTS(-10)); 
  DBMS_OUTPUT.PUT_LINE(NOMBRES('AA')); 
  DBMS_OUTPUT.PUT_LINE(EMPLES(10).FIRST_NAME); 
  DBMS_OUTPUT.PUT_LINE(EMPLES(10).LAST_NAME); 
  
END;
/
--SPARSE

-- Introducir datos comuestos en una index by

SET SERVEROUTPUT ON
DECLARE
  TYPE DEPARTAMENTOS IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE 
    INDEX BY PLS_INTEGER;
    
  DEPTS DEPARTAMENTOS;
  
  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
  
  EMPLES EMPLEADOS;
  
  TYPE NOMBRE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY VARCHAR2(2);
  NOMBRES NOMBRE;
  
BEGIN
  DEPTS(1):='HOLA';
  DEPTS(2):='ADIOS';
  DEPTS(50):='OTRO VALOR';
  DEPTS(-10):='SIGUIENTE VALOR';
  NOMBRES('AA'):='PEDRO';
  
  -- Se indica la columna con el punto
  EMPLES(10).FIRST_NAME:='SERGIO';
    
  DBMS_OUTPUT.PUT_LINE(DEPTS(2));
  DBMS_OUTPUT.PUT_LINE(DEPTS(-10)); 
  DBMS_OUTPUT.PUT_LINE(NOMBRES('AA')); 
  DBMS_OUTPUT.PUT_LINE(EMPLES(10).FIRST_NAME); 
   DBMS_OUTPUT.PUT_LINE(EMPLES(10).LAST_NAME); 
  
END;
/
--SPARSE

-- Cargar una index Table con un a tabla. Datos Simples
SET SERVEROUTPUT ON
DECLARE
  TYPE DEPARTAMENTOS IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE 
    INDEX BY PLS_INTEGER;
    
  DEPTS DEPARTAMENTOS;
  CURSOR CUR_DEPT IS SELECT * FROM DEPARTMENTS;
  X PLS_INTEGER:=1;
  
  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
  
  EMPLES EMPLEADOS;
  
  TYPE NOMBRE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY VARCHAR2(2);
  NOMBRES NOMBRE;
  
BEGIN
  FOR DEP1 IN CUR_DEPT LOOP
    -- Cargar los nombres de la tabla al DEPTS(X)
    DEPTS(X):=DEP1.DEPARTMENT_NAME;
    X:=X+1;
  END LOOP;
  
  FOR I IN 1..X-1 LOOP
    -- Mostrar la info del array
    DBMS_OUTPUT.PUT_LINE(DEPTS(I));
  END LOOP;
END;
/

-- Cargar una index Table con un a tabla. Datos Compuestos
SET SERVEROUTPUT ON
DECLARE
  TYPE DEPARTAMENTOS IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE 
    INDEX BY PLS_INTEGER;
    
  DEPTS DEPARTAMENTOS;
  CURSOR CUR_DEPT IS SELECT * FROM DEPARTMENTS;
  X PLS_INTEGER:=1;
  
  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
  CURSOR CUR_EMP IS SELECT * FROM  EMPLOYEES WHERE SALARY > 5000;
  Z PLS_INTEGER:=1;
  
  EMPLES EMPLEADOS;
  
  TYPE NOMBRE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY VARCHAR2(2);
  NOMBRES NOMBRE;
  
BEGIN
/*
  FOR DEP1 IN CUR_DEPT LOOP
    DEPTS(X):=DEP1.DEPARTMENT_NAME;
    X:=X+1;
  END LOOP;
  
  FOR I IN 1..X-1 LOOP
    DBMS_OUTPUT.PUT_LINE(DEPTS(I));
  END LOOP;
 */ 
  FOR EMP1 IN CUR_EMP LOOP
    EMPLES(Z):=EMP1;
    Z:=Z+1;
  END LOOP;
  FOR I IN 1..Z-1 LOOP
    DBMS_OUTPUT.PUT_LINE(EMPLES(I).FIRST_NAME||' '||EMPLES(I).SALARY);
  END LOOP;  
END;
/

-- BULK COLLET




























