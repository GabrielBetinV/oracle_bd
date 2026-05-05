
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

-- Introducir datos compuestos en una index by

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

-- BULLK COLLET
-- ES UNA FORMA DE CARGAR DATOS EN UNA TABLA
-- ES MAS RAPIDO QUE UN FOR     
-- SE UTILIZA PARA CARGAR DATOS EN UNA TABLA

-- El array comienza desde 1, no desde cero

SET SERVEROUTPU ON;
DECLARE

  TYPE EMPLEADOS IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
 
  EMPLES EMPLEADOS;

BEGIN
     SELECT * 
     BULK COLLECT INTO EMPLES
     FROM EMPLOYEES WHERE SALARY > 5000;
    
     FOR I IN 1..EMPLES.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLES(I).FIRST_NAME);
     END LOOP;
END;
/


-- Metodos de las colecciones
/*

---

# ⚡ Tipos de colecciones en PL/SQL

## 🔹 1. Associative Array (Index-By Table)

👉 Es como un **mapa (clave → valor)** en memoria.

* Índices: números o strings
* No tiene tamaño fijo
* Puede ser **disperso** (huecos)
* Solo existe en PL/SQL (no en SQL)

✔ Ideal para:

* Caché en memoria
* Búsquedas rápidas tipo diccionario

🧠 Clave:

> Es el más flexible y rápido, pero no lo puedes usar directamente en SQL

---

## 🔹 2. Nested Table

👉 Es como una **tabla dinámica sin límite fijo**

* Índices numéricos
* Puede crecer dinámicamente (`EXTEND`)
* Puede tener huecos (`DELETE`)
* Sí se puede usar en SQL

✔ Ideal para:

* Pasar datos entre PL/SQL y SQL
* Operaciones tipo tabla

🧠 Clave:

> Es el más parecido a una tabla real

---

## 🔹 3. VARRAY

👉 Es un **arreglo con tamaño máximo definido**

* Tamaño fijo (límite)
* Siempre es **denso** (sin huecos)
* Mantiene el orden
* Se puede usar en SQL

✔ Ideal para:

* Listas pequeñas y controladas
* Datos donde importa el orden

🧠 Clave:

> Es el más estructurado y restringido

---

# 🚀 Diferencia rápida (tipo entrevista)

* **Associative Array** → flexible, rápido, solo memoria, tipo diccionario
* **Nested Table** → dinámico, tipo tabla, permite huecos
* **VARRAY** → tamaño fijo, ordenado, sin huecos

---

*/
SET SERVEROUTPUT ON;
DECLARE
    ------------------------------------------------------------------
    -- Tipos de colecciones
    ------------------------------------------------------------------
    TYPE t_assoc IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    TYPE t_nested IS TABLE OF VARCHAR2(50);
    TYPE t_varray IS VARRAY(5) OF VARCHAR2(50);

    v_assoc  t_assoc;
    v_nested t_nested := t_nested();
    v_varray t_varray := t_varray();

    i NUMBER;
BEGIN
    ------------------------------------------------------------------
    -- ================== ASSOCIATIVE ARRAY ==========================
    ------------------------------------------------------------------
    v_assoc(1) := 'A';
    v_assoc(3) := 'B';
    v_assoc(5) := 'C';

    DBMS_OUTPUT.PUT_LINE('--- ASSOCIATIVE ARRAY ---');

    -- COUNT
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_assoc.COUNT);

    -- FIRST / LAST
    DBMS_OUTPUT.PUT_LINE('FIRST: ' || v_assoc.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST: ' || v_assoc.LAST);

    -- EXISTS
    IF v_assoc.EXISTS(3) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTS(3): SI');
    END IF;

    -- NEXT / PRIOR (recorrido seguro)
    i := v_assoc.FIRST;
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('VALOR: ' || v_assoc(i));
        i := v_assoc.NEXT(i);
    END LOOP;

    -- DELETE
    v_assoc.DELETE(3);
    DBMS_OUTPUT.PUT_LINE('COUNT despues DELETE: ' || v_assoc.COUNT);

    ------------------------------------------------------------------
    -- ================== NESTED TABLE ===============================
    ------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- NESTED TABLE ---');

    -- EXTEND
    v_nested.EXTEND;
    v_nested(1) := 'X';

    v_nested.EXTEND(2);
    v_nested(2) := 'Y';
    v_nested(3) := 'Z';

    -- COUNT
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_nested.COUNT);

    -- FIRST / LAST
    DBMS_OUTPUT.PUT_LINE('FIRST: ' || v_nested.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST: ' || v_nested.LAST);

    -- EXISTS
    IF v_nested.EXISTS(2) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTS(2): SI');
    END IF;

    -- NEXT / PRIOR
    i := v_nested.FIRST;
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('VALOR: ' || v_nested(i));
        i := v_nested.NEXT(i);
    END LOOP;

    -- DELETE (genera huecos)
    v_nested.DELETE(2);

    -- TRIM
    v_nested.TRIM;

    DBMS_OUTPUT.PUT_LINE('COUNT despues DELETE/TRIM: ' || v_nested.COUNT);

    ------------------------------------------------------------------
    -- ================== VARRAY =====================================
    ------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- VARRAY ---');

    -- EXTEND
    v_varray.EXTEND;
    v_varray(1) := 'AA';

    v_varray.EXTEND(2);
    v_varray(2) := 'BB';
    v_varray(3) := 'CC';

    -- COUNT
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_varray.COUNT);

    -- LIMIT
    DBMS_OUTPUT.PUT_LINE('LIMIT: ' || v_varray.LIMIT);

    -- FIRST / LAST
    DBMS_OUTPUT.PUT_LINE('FIRST: ' || v_varray.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST: ' || v_varray.LAST);

    -- EXISTS
    IF v_varray.EXISTS(1) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTS(1): SI');
    END IF;

    -- RECORRIDO
    FOR i IN v_varray.FIRST .. v_varray.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('VALOR: ' || v_varray(i));
    END LOOP;

    -- TRIM
    v_varray.TRIM(1);

    DBMS_OUTPUT.PUT_LINE('COUNT despues TRIM: ' || v_varray.COUNT);

END;
/


SET SERVEROUTPUT ON;
DECLARE
  
   TYPE SUMA_SALARIOS IS RECORD 
      (
         NOMBRE DEPARTMENTS.DEPARTMENT_NAME%TYPE,
         SUMA_SALARIOS NUMBER
      );

  TYPE SUMA_SAL IS TABLE OF SUMA_SALARIOS INDEX BY PLS_INTEGER;
 
  
  SALARIOS SUMA_SAL;
  
BEGIN
     SELECT DEPARTMENT_NAME,SUM(SALARY)
     BULK COLLECT INTO SALARIOS
     FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID)
     GROUP BY DEPARTMENT_NAME;
    
     FOR I IN 1..SALARIOS.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(SALARIOS(I).NOMBRE||' '||SALARIOS(I).SUMA_SALARIOS);
     END LOOP;
     
     DBMS_OUTPUT.PUT_LINE('NÚMERO EMPLEADOS:'||SALARIOS.COUNT());
     DBMS_OUTPUT.PUT_LINE('PRIMER REGISTRO:'||SALARIOS.FIRST());
     DBMS_OUTPUT.PUT_LINE('ULTIMO REGISTRO:'||SALARIOS.LAST());
     IF SALARIOS.EXISTS(20) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO EXISTE');
    END IF;
    SALARIOS.DELETE(1);
    DBMS_OUTPUT.PUT_LINE('PRIMER REGISTRO:'||SALARIOS.FIRST());
    DBMS_OUTPUT.PUT_LINE(SALARIOS.PRIOR(3));
	DBMS_OUTPUT.PUT_LINE(SALARIOS.NEXT(3));
    SALARIOS.DELETE(4);
	DBMS_OUTPUT.PUT_LINE(SALARIOS.PRIOR(3));
	DBMS_OUTPUT.PUT_LINE(SALARIOS.NEXT(3));
END;
/

-- VARRAYS
SET SERVEROUTPUT ON
DECLARE
  TYPE V1 IS VARRAY(50) OF VARCHAR2(100);

  -- Hay que inicializar las variables arrays, no nesesariamente
  -- debe ser todas las posiciones
  
  -- Ejemplo 
  -- VAR1 V1 := V1();
  
  -- Con valores  
  VAR1 V1:= V1('ADIOS','HOLA','TERCERO','XXX','ZZZZ');
  
BEGIN
  DBMS_OUTPUT.PUT_LINE(VAR1(1));
  VAR1(1):='HOLA';
  DBMS_OUTPUT.PUT_LINE(VAR1(1));  
  DBMS_OUTPUT.PUT_LINE(VAR1(5));

END;
/

-- Extender varrays
SET SERVEROUTPUT ON
DECLARE
  TYPE V1 IS VARRAY(50) OF VARCHAR2(100);
  

  VAR1 V1:= V1('ADIOS','HOLA','TERCERO','XXX','ZZZZ');
  
BEGIN
  DBMS_OUTPUT.PUT_LINE(VAR1(1));
  VAR1(1):='HOLA';
  DBMS_OUTPUT.PUT_LINE(VAR1(1));  
  DBMS_OUTPUT.PUT_LINE(VAR1(5));
  DBMS_OUTPUT.PUT_LINE(VAR1.count());
  DBMS_OUTPUT.PUT_LINE(VAR1.LIMIT());
  VAR1.EXTEND();
  DBMS_OUTPUT.PUT_LINE(VAR1.count());
  
  -- Añade 5 posiciones mas
  VAR1.EXTEND(5);
  DBMS_OUTPUT.PUT_LINE(VAR1.count());
  --VAR1.EXTEND(50);
END;
/


-- Ejemplo Varray, Bull collect y cursores


SET SERVEROUTPUT ON
DECLARE
  TYPE EMPLEADO IS VARRAY(10) OF EMPLOYEES%ROWTYPE;
  
  EMPLEADOS EMPLEADO:=EMPLEADO();
BEGIN
  SELECT * BULK COLLECT INTO EMPLEADOS
  FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;
  FOR I IN EMPLEADOS.FIRST()..EMPLEADOS.LAST() LOOP
     DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY);
  END LOOP;
END;
/

SET SERVEROUTPUT ON
DECLARE
  TYPE EMPLEADO IS VARRAY(10) OF EMPLOYEES%ROWTYPE;

  CURSOR C1 IS SELECT * 
  FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;

  CONTADOR NUMBER:=1;

  EMPLEADOS EMPLEADO:=EMPLEADO();
BEGIN

  FOR X IN C1 LOOP
    EMPLEADOS.EXTEND(1);
    EMPLEADOS(CONTADOR):=X;
    CONTADOR:=CONTADOR+1;
  END LOOP;
   FOR I IN EMPLEADOS.FIRST..EMPLEADOS.LAST LOOP
     DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY);
     
  END LOOP;
END;
/

-- Crear un varray en la base de datos
CREATE OR REPLACE TYPE DATO IS VARRAY(80) OF VARCHAR2(100);
/
DESC DATO;
/
SET SERVEROUTPUT ON
DECLARE
  DATOS DATO;
BEGIN 
  DATOS:=DATO('UNO','DOS');
  DBMS_OUTPUT.PUT_LINE(DATOS(1));
END;
/

-- Crear una tabla con una columna tipo varray

CREATE TABLE PRUEBA_array (C1 NUMBER, C2 DATO, C3 VARCHAR2(60));
DESC PRUEBA_array
DESC DATO
SELECT * FROM USER_TYPES;
SELECT * FROM USER_VARRAYS;
SELECT * FROM PRUEBA_array;

-- Operador TABLE, acceder a columnas de tipo VARRAY


INSERT INTO PRUEBA_array VALUES(100,DATO('UNO','DOS'),'EJEMPLO');
INSERT INTO PRUEBA_array VALUES(100,DATO('AA','BB','CCC','DDD'),'EJEMPLO');
SELECT C2 FROM PRUEBA_array;

-- No se puede, da error
-- OJO: No se puede acceder a las columnas de un varray directamente
-- Se debe usar el operador TABLE
SELECT C2(1) FROM PRUEBA;

-- El operador table, es como si fuera una tabla

SELECT C1, T2.*,C3
FROM PRUEBA_array, table(PRUEBA_array.C2) T2  
WHERE C1=100;


INSERT INTO PRUEBA_array VALUES(200,DATO('AA1','BB1','CCC1','DDD1'),'OTRO EJEMPLO');

SELECT C1, T2.*,C3
FROM PRUEBA_array, table(PRUEBA_array.C2) T2  
WHERE C1=200;


-- Metodos en los VARRAYS

SET SERVEROUTPUT ON
DECLARE
  TYPE EMPLEADO IS VARRAY(10) OF EMPLOYEES%ROWTYPE; 
  EMPLEADOS EMPLEADO:=EMPLEADO();
BEGIN
  SELECT * BULK COLLECT INTO EMPLEADOS
  FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;
  FOR I IN EMPLEADOS.FIRST()..EMPLEADOS.LAST() LOOP
     DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY);
  END LOOP; 
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.LAST());
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST());
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.NEXT(1));
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.NEXT(10));
   IF EMPLEADOS.EXISTS(20) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO EXISTE');
    END IF;
  --EMPLEADOS.DELETE(2);
END;
/


-- NESTED TABLES, Tablas anidadas

--NESTED TABLES 
-- NO TIENEN LIMITE DEFINIDO
-- SE ACCEDE POR POR POSICION
-- SPARSE - DIPERSOS HUECOS
-- VARRAYS
SET SERVEROUTPUT ON
DECLARE
  TYPE EMPLEADO IS TABLE OF EMPLOYEES%ROWTYPE;
  
  EMPLEADOS EMPLEADO:=EMPLEADO();
BEGIN
  SELECT * BULK COLLECT INTO EMPLEADOS
  FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;
 
  FOR I IN EMPLEADOS.FIRST()..EMPLEADOS.LAST() LOOP
     DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY);
 
  END LOOP;
END;
/


-- Metodos en los NESTED TABLES


--NESTED TABLES 
-- NO TIENEN LIMITE DEFINIDO
-- SE ACCEDE POR POR POSICION
-- SPARSE - DIPERSOS HUECOS
-- VARRAYS
SET SERVEROUTPUT ON
DECLARE
  TYPE EMPLEADO IS TABLE OF EMPLOYEES%ROWTYPE;
  
  EMPLEADOS EMPLEADO:=EMPLEADO();
BEGIN
  SELECT * BULK COLLECT INTO EMPLEADOS
  FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;
 
  FOR I IN EMPLEADOS.FIRST()..EMPLEADOS.LAST() LOOP
     DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY);
 
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.LAST());
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST());
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS.NEXT(1)); 
  IF EMPLEADOS.EXISTS(20) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO EXISTE');
    END IF;
    EMPLEADOS.DELETE(2);
    FOR I IN EMPLEADOS.FIRST()..EMPLEADOS.LAST() LOOP
        IF EMPLEADOS.EXISTS(I) THEN
            DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY); 
        END IF;
    END LOOP;    
END;
/


-- Crear una nested TAble a nivel de la base de datos


CREATE OR REPLACE TYPE EMPLEADO_NESTED IS TABLE OF VARCHAR2(100);
/

set serveroutput on
DECLARE
  EMPLEADOS EMPLEADO_NESTED;
BEGIN 
  EMPLEADOS:=EMPLEADO_NESTED('SERGIO','ALBERTO','ROSA');
  DBMS_OUTPUT.PUT_LINE(EMPLEADOS(1));
END;
/

desc EMPLEADO_NESTED

/

SELECT * FROM USER_TYPES;
/

-- Crear tablas coon columnas nested tables

desc EMPLEADO_NESTED;
/


-- Se crea de esta manera, indicando donde va a quedar los datos de la tabla auxiliar
CREATE TABLE EMPLES
(
CODIGO NUMBER,
DIRECCION VARCHAR2(100),
DATOS EMPLEADO_NESTED
)
NESTED TABLE DATOS STORE AS TABLA_DATOS;
/

DESC EMPLES;

-- VEr las tablas existentes en el esquema
SELECT * FROM TAB;



-- Trabajar con tablas con columnas NESTED TABLES
  INSERT INTO EMPLES VALUES(100,'DIRECCION 1',EMPLEADO_NESTED('SERGIO','ALBERTO','ROSA'));
  INSERT INTO EMPLES VALUES(200,'DIRECCION 2',EMPLEADO_NESTED('JUAN','MARIA','ANA','LUIS'));

  SELECT * FROM EMPLES;

  -- Acceder a las columnas de un nested table con alias
  SELECT E.CODIGO, T.* 
  FROM EMPLES E, TABLE(E.DATOS) T;


-- Update en tablas con nested tables
  UPDATE EMPLES E
  SET E.DATOS = EMPLEADO_NESTED('SERGIO','ALBERTO','ROSA')
  WHERE E.CODIGO=100;
  
    -- Delete
    DELETE FROM EMPLES E
    WHERE E.CODIGO=100;


-- OBJETCS, NESTED TABLES y VARRAYS

-- Es un objeto que tiene atributos y metodos
-- Nos permite crear objetos complejos
-- Es de SQL, no de PLSQL
-- Se puede usar en tablas, varrays y nested tables
CREATE OR REPLACE TYPE OBJETO_REGIONES IS OBJECT
(
   REGION_ID NUMBER,
   REGION_NAME VARCHAR2(25)
);
/

-- Ekjemplo, Crear un nested table de objetos
CREATE OR REPLACE TYPE NESTED_REGIONES IS TABLE OF OBJETO_REGIONES;
/


-- Crear una tabla con una columna tipo nested table de objetos
CREATE TABLE N_REGIONES
(
CODIGO NUMBER,
REGIONES NESTED_REGIONES
)
NESTED TABLE REGIONES STORE AS TABLA_REGIONES;




-- LOBS, Large objects
-- Son objetos que pueden almacenar grandes cantidades de datos, como texto, imágenes, videos, etc.
-- Son de tipo LOB, CLOB, BLOB, etc 

-- LOBS Internos: Se almacenan dentro de la base de datos, en una tabla auxiliar
-- CLOB: Character Large Object, para almacenar grandes cantidades de texto
-- BLOB: Binary Large Object, para almacenar grandes cantidades de datos binarios, como imágenes


-- Lobs Externos: Se almacenan fuera de la base de datos, en un archivo externo
-- BFILE: Binary File, para almacenar grandes cantidades de datos binarios, pero en un archivo externo




-- Crear columnas de tipo LOB

create table pru_lob (
   codigo number,
   nombre varchar2(100),
   datos  clob
);

DESC PRU_LOB;

insert into pru_lob values ( 1,
                             'PEDRO',
                             'DSFJKDSAFKJSDAKLFJKLDSAJFLKJDSLKFJKLDSJAFLKDJSAKFD SA' );

select *
  from pru_lob;

alter table pru_lob add (
   foto blob
);

DESC PRU_LOB;

-- Esto genera error, porque espera dato binarios para la columna BLOB, por eso se necesita utilizar el paquete DBMS_LOB para insertar datos en columnas de tipo LOB
insert into pru_lob values ( 2,
                             'ROSA',
                             'DSFJKDSAFKJSDAKLFJKLDSAJFLKJDSLKFJKLDSJAFLKDJSAKFD SA',
                             'KKKÑLOPSDFL,DSIMFDSJ' );

-- EMPTY_BLOB y EMPTY_CLOB
-- Funciones que sirven para grabar o inicializar  vacios de blob y clob
-- Se recomienda utilizar estas funciones para inicializar los campos de tipo LOB, 
-- ya que si se intenta insertar un valor nulo, puede generar errores o problemas de rendimiento
-- de esta manera se graba el puntero al LOB, pero el LOB esta vacio, y luego se puede actualizar el LOB con el paquete DBMS_LOB



--EMPTY_CLOB()
--EMPTY_BLOB()

insert into pru_lob values ( 3,
                             'JUAN',
                             empty_clob(),
                             empty_blob() );
select *
  from pru_lob;



-- BFILENAME - Cargar un BFILE
-- Es una función que sirve para cargar un archivo externo como un BFILE, se le indica el directorio y el nombre del archivo
-- El directorio debe estar creado en la base de datos, y debe tener permisos de lectura

create table imagenes (
   codigo number,
   foto   bfile
);

/
select *
  from imagenes;
/
DESC IMAGENES;
/
declare
   foto bfile;
begin
   foto := bfilename(
      'FICHEROS',
      'gatito1.jpg'
   );
   insert into imagenes values ( 1,
                                 foto );
end;
/


-- Directamente en un SQL
insert into imagenes values ( 2,
                              bfilename(
                                 'FICHEROS',
                                 'gatito1.jpg'
                              ) );

select *
  from imagenes;

select *
  from all_directories;


-- BFILE Ejemplo 1

create table clientes (
   codigo   number,
   nombre   varchar2(100),
   foto     bfile,
   longitud number
);

/

insert into clientes values ( 1,
                              'ROSA',
                              null,
                              null );

insert into clientes values ( 2,
                              'PEDRO',
                              null,
                              null );

insert into clientes values ( 3,
                              'ANTONIO',
                              null,
                              null );

insert into clientes values ( 4,
                              'RAUL',
                              null,
                              null );

insert into clientes values ( 5,
                              'MARIA',
                              null,
                              null );

/


select *
  from clientes;


-- BFILE Ejemplo 2
-- Usos del DBMS_LOB para trabajar con LOBs, en este caso con BFILEs

-- Esta funcion devuelve la longitud del BFILE, si el archivo existe, sino devuelve 0
create or replace function tam (
   directorio varchar2,
   codigo     number
) return number is
   fichero varchar2(100);
   foto    bfile;
begin
   fichero := 'cliente'
              || codigo
              || '.jpg';
   foto := bfilename(
      directorio,
      fichero
   );
   if dbms_lob.fileexists(foto) = 1 then
      return dbms_lob.getlength(foto);
   else
      return 0;
   end if;
end;
/

   SET SERVEROUTPUT ON
EXECUTE DBMS_OUTPUT.PUT_LINE(TAM('FICHEROS',1));

-- BFILE Ejemplo 3

-- Actualizar los clientes para que tengan la foto cargada, y la longitud del archivo
create or replace procedure actualizar_clientes is
   fichero varchar2(100);
   foto    bfile;

-- Cursor para recorrer los clientes, con for update, para poder actualizar los registros
   cursor clientes is
   select codigo
     from clientes
   for update;

begin
   for cliente in clientes loop
      fichero := 'cliente'
                 || cliente.codigo
                 || '.jpg';
      foto := bfilename(
         'FICHEROS',
         fichero
      );
      if dbms_lob.fileexists(foto) = 1 then
         update clientes
            set foto = foto,
                longitud = dbms_lob.getlength(foto)
          where current of cli;
      end if;
   end loop;
end;
/

execute ACTUALIZAR_CLIENTES;
select *
  from clientes;


-- Cargar un BFILE en un BLOB
alter table clientes add comentarios blob default empty_blob();
/
DESC CLIENTES
/
select *
  from clientes;
/
create or replace procedure carga_comentarios is
   cursor cli is
   select *
     from clientes
   for update;
   fichero     varchar2(100);
   comentarios bfile;
   temporal    blob;
begin
   for c1 in cli loop 
        --NOMBRE DEL FICHERO
      fichero := 'comentarios'
                 || c1.codigo
                 || '.docx';
        
        --ASOCIAR EL FICHERO AL BFILE
      comentarios := bfilename(
         'FICHEROS',
         fichero
      );
        
        --ABRIR EL FICHERO. ES OBLIGATORIO SI QUEREMOS USAR LOADFROMMFILE
      dbms_lob.open(
         comentarios,
         dbms_lob.lob_readonly
      );
        
        --ES NECESARIO CREAR UN LOB TEMPORAL, PARA INICIALIZAR EL LOCALIZARO
      dbms_lob.createtemporary(
         temporal,
         true
      );
        
        -- CARGAMOS EL FICHERO A LA VARIABLE TEMPORAL 
      dbms_lob.loadfromfile(
         temporal,
         comentarios,
         dbms_lob.getlength(comentarios)
      );
        
        --MODIFICAMOS LA COLUMNA DE LA TABLA
      update clientes
         set
         comentarios = temporal
       where current of cli;
        
        --CERRAMOS EL FICHERO
      dbms_lob.close(comentarios);
   end loop;
end;
/

EXECUTE CARGA_COMENTARIOS;

select *
  from clientes;



-- DBMS_LOB.READ, para leer el contenido de un LOB, en este caso de un CLOB
alter table clientes add descripcion clob;
/
DESC CLIENTES;
/
select *
  from clientes;
/
declare
   texto varchar2(50) := 'DESCRIPCION DEL CLIENTE:';
begin
   for x in 1..5 loop
      update clientes
         set
         descripcion = texto || x
       where codigo = x;
   end loop;
end;
/

create table prueba_lob (
   descri clob
);

DESC PRUEBA_LOB;

create or replace procedure carga_descri is
   cursor cli is
   select *
     from clientes
   for update;
   temporal clob;
   cantidad integer := 5;
   posicion integer := 1;
begin
   for c1 in cli loop 
        --ABRIR EL FICHERO. ES OBLIGATORIO 
      dbms_lob.open(
         c1.descripcion,
         dbms_lob.lob_readonly
      );
        
       --LEEMOS 5 POSICIONES DE NUESTRO CAMPO DESCRIPCION Y LO DEJAMOS EN LA VARIABLE TEMPORAL
      dbms_lob.read(
         c1.descripcion,
         cantidad,
         posicion,
         temporal
      );
      insert into prueba_lob values ( temporal );
        
       --CERRAR EL LOB
      dbms_lob.close(c1.descripcion);
   end loop;
end;
/

EXECUTE CARGA_DESCRI;

select *
  from prueba_lob;

select *
  from clientes;



-- DBMS_LOB.WRITE, para escribir en un LOB, en este caso en un CLOB

create table prueba_lob1 (
   empleado clob
);
/

create or replace procedure carga_emple is
   cursor cli is
   select *
     from employees;
   temporal clob;
   cantidad integer;
   nombre   varchar2(100);
begin
   for c1 in cli loop 
        
        --ES NECESARIO CREAR UN LOB TEMPORAL, PARA INICIALIZAR EL LOCALIZADOR
      dbms_lob.createtemporary(
         temporal,
         true
      );
        
        --ABRIR EL LOB, EN MODO ESCCRITURA
      dbms_lob.open(
         temporal,
         dbms_lob.lob_readwrite
      );    
           
       --VARIABLE FORMADA POR EL NOMBRE Y APELLIDO DEL EMPLEADO
      nombre := c1.first_name
                || ' '
                || c1.last_name;
        
        --VARIALBE CON LA LONGITUD DLE NOMBRE
      cantidad := length(nombre);
        
        --ESCRIBIMOS EN LA VARIABLE LOB LOS DATOS
      dbms_lob.write(
         temporal,
         cantidad,
         1,
         nombre
      );
        
       -- INSERTAMOS EN LA TABLA
      insert into prueba_lob1 values ( temporal );
        
        --CERRAMOS EL FICHEROS       
      dbms_lob.close(temporal);
   end loop;
end;
/

EXECUTE CARGA_EMPLE;

select *
  from prueba_lob1;


-- DMBS_LOB otras funciones

select *
  from clientes;


-- DBMS_LOB.SUBSTR, para obtener una subcadena de un LOB, en este caso de un CLOB
select descripcion,
       dbms_lob.substr(
          descripcion,
          10,
          1
       ) as texto
  from clientes;


-- DBMS_LOB.INSTR, para buscar una subcadena dentro de un LOB, en este caso de un CLOB, devuelve la posición de la primera ocurrencia de la subcadena, si no la encuentra devuelve 0
select descripcion,
       dbms_lob.instr(
          descripcion,
          '1'
       )
  from clientes;

select dbms_lob.substr(
   foto,
   10,
   1
) as texto
  from clientes;


-- DBMS_LOB excepciones,  si se intenta abrir un BFILE que no existe, se genera la excepcion NOEXIST_DIRECTORY, por eso es importante manejar las excepciones al trabajar con LOBs, para evitar errores y problemas de rendimiento

declare
   foto bfile;
begin
   foto := bfilename(
      'F',
      'gatito1.jpg'
   );
   dbms_lob.open(
      foto,
      dbms_lob.lob_readonly
   );
exception
   when dbms_lob.noexist_directory then
      raise_application_error(
         -20000,
         'EL DIRECTORIO NO EXISTE'
      );
end;
/


-- PL/SQL Nativo, es el lenguaje de programación que se ejecuta dentro de la base de datos, es un lenguaje procedural,
-- que permite crear procedimientos, funciones, paquetes, triggers, etc, para realizar tareas complejas y automatizar procesos dentro de la base de datos.


--Compilacion interpretada, el código se compila en tiempo de ejecución, es decir, 
--cada vez que se ejecuta el bloque de código, se compila y se ejecuta, 
--esto puede generar un impacto en el rendimiento si el bloque de código es muy grande o se ejecuta muchas veces, 
--por eso es recomendable compilar el código antes de ejecutarlo, para evitar este impacto en el rendimiento.


-- Compilacion nativa, el código se compila antes de ejecutarlo, es decir, se compila una sola vez 
--y luego se ejecuta muchas veces, esto mejora el rendimiento, ya que el código ya esta compilado y listo para ejecutarse,
-- para compilar el código se puede utilizar la opción NATIVE al crear el procedimiento, función  

--El uso de la compilación nativa o interpretada, depende del caso de uso, si el bloque de código 
--es muy grande o se ejecuta muchas veces, es recomendable utilizar la compilación nativa, 
--para mejorar el rendimiento, pero si el bloque de código es pequeño o se ejecuta pocas veces, 
--se puede utilizar la compilación interpretada, para facilitar el desarrollo y la depuración del código.



-- Se puede colocar a nivel de base de datos, a nivel de sesión o a nivel de procedimiento, función, paquete, etc
alter session set plsql_code_type = 'INTERPRETED';
/

create or replace procedure ejemplo as
begin
   dbms_output.put_line('EJEMPLO');
end;
/


select *
  from user_plsql_object_settings
 where name like 'EJEMPLO';


-- Ejemplo 

alter session set plsql_code_type = 'INTERPRETED';

create or replace procedure n1 as
   v varchar2(1000) := 'A';
   x date;
   z varchar2(1000);
begin
   dbms_output.put_line(to_char(
      sysdate,
      'mi:ss'
   ));
   for i in 1..100000000 loop
      for x in 1..15 loop
         v := 'A'
              || substr(
            'AAAAAA',
            1,
            5
         );
      end loop;
   end loop;

   dbms_output.put_line(to_char(
      sysdate,
      'mi:ss'
   ));
end;
/

   set serveroutput on
execute n1;

alter session set plsql_code_type = 'NATIVE';
alter session set plsql_code_type = 'INTERPRETED';

/
select *
  from user_plsql_object_settings
 where name like 'N1';

 --Sobre carga en PL SQL, es la capacidad de crear varios procedimientos o funciones con el mismo nombre, 
 --pero con diferentes parámetros, esto permite tener una mayor flexibilidad y reutilización del código, 
 --ya que se pueden crear diferentes versiones de un mismo procedimiento o función, para diferentes casos de uso, 
 --sin tener que crear procedimientos o funciones con nombres diferentes. 

 -- Ejemplo, 

 CREATE OR REPLACE PACKAGE SOBRECARGA AS
  FUNCTION CONCATENAR(A NUMBER,B NUMBER) RETURN NUMBER;
  FUNCTION CONCATENAR(A VARCHAR2,B VARCHAR2) RETURN VARCHAR2;
  FUNCTION CONCATENAR(A DATE,B NUMBER) RETURN DATE;
  
END SOBRECARGA;
/
CREATE OR REPLACE PACKAGE BODY SOBRECARGA AS
  FUNCTION CONCATENAR(A NUMBER,B NUMBER) RETURN NUMBER
  IS
  BEGIN
    RETURN A+B;
 END CONCATENAR;
  
  FUNCTION CONCATENAR( A VARCHAR2,B VARCHAR2) RETURN VARCHAR2
  IS
  BEGIN
    RETURN A||' '||B;
 END;
  
 FUNCTION CONCATENAR( A DATE,B NUMBER) RETURN DATE
  IS
  BEGIN
    RETURN A+B;
 END;

END SOBRECARGA;
/


SET SERVEROUTPUT ON
EXECUTE DBMS_OUTPUT.PUT_LINE(SOBRECARGA.CONCATENAR('ALBERTO','PÈREZ'));
EXECUTE DBMS_OUTPUT.PUT_LINE(SOBRECARGA.CONCATENAR(10,30));
EXECUTE DBMS_OUTPUT.PUT_LINE(SOBRECARGA.CONCATENAR(SYSDATE,10));





-- SQL dinamico con PL/SQL, es la capacidad de ejecutar sentencias SQL dinámicas, es decir, 
-- sentencias SQL que se construyen en tiempo de ejecución, esto permite tener una mayor flexibilidad y reutilización del código, 
-- ya que se pueden construir sentencias SQL dinámicas para diferentes casos de uso, sin tener que crear procedimientos o funciones con nombres diferentes.



-- Parte 1, SQL dinamico con EXECUTE IMMEDIATE, es la forma mas sencilla de ejecutar sentencias SQL dinámicas,
-- se utiliza para ejecutar sentencias SQL que no devuelven resultados, como INSERT, UPDATE, DELETE, etc, 
-- pero no se puede utilizar para ejecutar sentencias SQL que devuelven resultados, como SELECT, para eso se debe utilizar el paquete DBMS_SQL.

-- Se debe colocar el authid current_user, para que el procedimiento se ejecute con los privilegios del usuario que lo ejecuta, 
-- y no con los privilegios del propietario del procedimiento, esto es importante para evitar problemas de seguridad,
-- ya que si el procedimiento se ejecuta con los privilegios del propietario, puede acceder a objetos que el usuario que lo ejecuta no tiene permisos para acceder.
-- Esto esta habilitado desde la version 12c, antes de esa version, el procedimiento se ejecutaba con los privilegios del propietario,
-- lo que generaba problemas de seguridad, por eso es importante colocar el authid current_user, para evitar estos problemas de seguridad.

CREATE OR REPLACE PROCEDURE CREAR_TABLA(NOMBRE_TABLA VARCHAR2,COLUMNAS VARCHAR2) AUTHID CURRENT_USER
IS

BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE ' ||NOMBRE_TABLA ||'(' ||COLUMNAS||')';
END;
/

EXECUTE hr.CREAR_TABLA('PRUEBA','CODIGO NUMBER, DATOS VARCHAR2(100)');


-- Parte 2, Otra forma de hacerlo, es construyendo la sentencia SQL en una variable, y 
-- luego ejecutando esa variable con EXECUTE IMMEDIATE, esto permite tener una mayor flexibilidad, 
-- ya que se pueden construir sentencias SQL dinámicas mas complejas, con condiciones, bucles, etc, y luego ejecutarlas con EXECUTE IMMEDIATE.
CREATE OR REPLACE PROCEDURE CREAR_TABLA1(NOMBRE_TABLA VARCHAR2,COLUMNAS VARCHAR2) AUTHID CURRENT_USER
IS
COMANDO VARCHAR2(100);
BEGIN
   COMANDO:='CREATE TABLE ' ||NOMBRE_TABLA ||'(' ||COLUMNAS||')';
   DBMS_OUTPUT.PUT_LINE(COMANDO);
   EXECUTE IMMEDIATE COMANDO;
END;
/

SET SERVEROUTPUT ON
EXECUTE CREAR_TABLA1('PRU3','CODIGO NUMBER, DATOS VARCHAR2(100)');


-- Execute inmediate con comandos DML Parte 1

--EXECUTE IMMEDIATE cadena
INSERT INTO PRU1 VALUES (1,'DATO1');
INSERT INTO PRU1 VALUES (2,'DATO2');
INSERT INTO PRU1 VALUES (3,'DATO3');

-- Funcion que borra los datos de la tabla PRU1, y devuelve el numero de filas borradas, utilizando EXECUTE IMMEDIATE
-- para ejecutar el comando DELETE, y SQL%ROWCOUNT para obtener el numero de filas borradas.
   
CREATE OR REPLACE function EJEMPLO_DML 
RETURN NUMBER
AUTHID CURRENT_USER --DEFINER
IS
   COMANDO VARCHAR2(100);
   FILAS NUMBER;
BEGIN
   COMANDO:='DELETE FROM PRU1';
   DBMS_OUTPUT.PUT_LINE(COMANDO);
   EXECUTE IMMEDIATE COMANDO;
   FILAS:=SQL%ROWCOUNT;
   RETURN FILAS;
END;
/

BEGIN
      DBMS_OUTPUT.PUT_LINE('SE HAN BORRADO ' ||EJEMPLO_DML||' FILAS');

END;
/

-- Excecute inmediate con comandos DML Parte 2, con una condicion para borrar solo los datos que cumplan esa condicion, y devolver el numero de filas borradas.

--EXECUTE IMMEDIATE cadena
INSERT INTO PRU1 VALUES (1,'DATO1');
INSERT INTO PRU1 VALUES (2,'DATO2');
INSERT INTO PRU1 VALUES (3,'DATO3');

CREATE OR REPLACE FUNCTION EJEMPLO_DML(CONDICION VARCHAR2)
RETURN NUMBER
AUTHID CURRENT_USER
IS
    COMANDO VARCHAR2(100);
    FILAS NUMBER;
BEGIN
    COMANDO:='DELETE FROM PRU1 WHERE '||CONDICION;
    DBMS_OUTPUT.PUT_LINE(COMANDO);
    EXECUTE IMMEDIATE(COMANDO);
    FILAS:=SQL%ROWCOUNT;
    RETURN FILAS;
END;
/

DECLARE
   CONDICION VARCHAR2(100);
   NUM_FILAS NUMBER;
BEGIN
    CONDICION:='CODIGO=1';
    NUM_FILAS:=EJEMPLO_DML(CONDICION);
    DBMS_OUTPUT.PUT_LINE('SE HAN BORRADO '||NUM_FILAS||' FILAS');
END;
/


-- Clausula INTO y USING

-- Into, son las variables donde se van a almacenar los resultados de la consulta, 
-- cuando se ejecuta una sentencia SQL que devuelve resultados, como un SELECT, 
-- se deben utilizar variables para almacenar esos resultados, y esas variables
-- se indican con la clausula INTO, para que el resultado de la consulta se almacene en esas variables.

-- Using, son las variables que se utilizan para pasar valores a la consulta, 
-- cuando se ejecuta una sentencia SQL que tiene condiciones, como un WHERE,
-- se deben utilizar variables para pasar esos valores a la consulta, y esas variables se indican con

CREATE OR REPLACE FUNCTION NUM_EMPLE(DEPARTAMENTO NUMBER)
RETURN NUMBER
IS  
    COMANDO VARCHAR2(200);
    NUM_EMPLEADOS NUMBER;
BEGIN
    COMANDO:='SELECT COUNT(*) FROM EMPLOYEES WHERE DEPARTMENT_ID=:DEPARTAMENTO';
    EXECUTE IMMEDIATE COMANDO INTO NUM_EMPLEADOS USING DEPARTAMENTO;
    RETURN NUM_EMPLEADOS;
END;
/
    
DECLARE
    DEPART NUMBER;
    EMPLE NUMBER;
BEGIN
    DEPART:=100;
    EMPLE:=NUM_EMPLE(DEPART);
    DBMS_OUTPUT.PUT_LINE('HAY '||EMPLE ||' EMPLEADOS EN EL DEPARTAMENTO '|| DEPART);
END;
/

-- BULK COLLECT, Carga masiva de filas
-- Es una forma de cargar grandes cantidades de datos en una variable, utilizando la clausula BULK COLLECT,
-- esto permite mejorar el rendimiento, ya que se carga toda la información de una sola vez, en lugar de cargarla fila por fila, como se hace con un cursor normal.
-- Se utiliza con la clausula INTO, para indicar la variable donde se van a almacenar los resultados

DECLARE 
  -- CREAR UN TIPO
  TYPE EMPLE_TYPE IS RECORD
  (
    NOMBRE_COMPLETO VARCHAR2(100),
    SALARIO NUMBER,
    IMPUESTOS NUMBER
    );
    
  -- CREAR TABLE INDEX TABLE 
  TYPE EMPLEADO IS TABLE OF EMPLE_TYPE INDEX BY PLS_INTEGER;
  
  EMPLEADOS EMPLEADO;
  CONDICION NUMBER;
  COMANDO VARCHAR2(1000);
BEGIN
    CONDICION:=5000;

    -- Construimos la consulta SQL dinámica, utilizando la variable CONDICION para filtrar los resultados, 
    --y luego ejecutamos esa consulta con EXECUTE IMMEDIATE, 
    -- utilizando la clausula BULK COLLECT INTO para cargar los resultados en la variable EMPLEADOS.

    -- El q, es una forma de escribir cadenas de texto sin tener que escapar las comillas simples,

    COMANDO:=q'[ SELECT FIRST_NAME ||' '|| LAST_NAME,SALARY, SALARY*15/100 FROM EMPLOYEES
               WHERE SALARY> :CONDICION ORDER BY SALARY DESC]';
    EXECUTE IMMEDIATE COMANDO BULK COLLECT INTO EMPLEADOS USING  CONDICION;
    
    FOR X IN 1..EMPLEADOS.COUNT()
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS(X).NOMBRE_COMPLETO||' '||EMPLEADOS(X).SALARIO||' '||EMPLEADOS(X).IMPUESTOS);
    END LOOP;
END;
/

-- OPEN-FETCH-CLOSE, es una forma de ejecutar sentencias SQL dinámicas que devuelven resultados, 
-- como un SELECT, utilizando cursores dinámicos, esto permite tener una mayor flexibilidad, 
-- ya que se pueden construir sentencias SQL dinámicas mas complejas, con condiciones, bucles, etc, y luego ejecutarlas con OPEN-FETCH-CLOSE.        


DECLARE 
  -- CREAR UN TIPO
  TYPE EMPLE_TYPE IS RECORD
  (
    NOMBRE_COMPLETO VARCHAR2(100),
    SALARIO NUMBER,
    IMPUESTOS NUMBER
    );
    
  -- CREAR TABLE INDEX TABLE 
  TYPE EMPLEADO IS TABLE OF EMPLE_TYPE INDEX BY PLS_INTEGER;
  
  EMPLEADOS EMPLEADO;
  CONDICION NUMBER;
  COMANDO VARCHAR2(1000);
  
  --CREAMOS UN REF CURSOR
  TYPE V_CURSOR IS REF CURSOR;
  C1 V_CURSOR;
  
BEGIN
    CONDICION:=5000;
    COMANDO:=q'[ SELECT FIRST_NAME ||' '|| LAST_NAME,SALARY, SALARY*15/100 FROM EMPLOYEES
               WHERE SALARY> :CONDICION ORDER BY SALARY DESC]';
    OPEN C1 FOR COMANDO USING CONDICION;
    FETCH C1 BULK COLLECT INTO EMPLEADOS ;
    
    FOR X IN 1..EMPLEADOS.COUNT()
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS(X).NOMBRE_COMPLETO||' '||EMPLEADOS(X).SALARIO||' '||EMPLEADOS(X).IMPUESTOS);
    END LOOP;
END;
/

-- DMBS_SQL, es un paquete que permite ejecutar sentencias SQL dinámicas, como una alternativa a EXECUTE IMMEDIATE,
-- este paquete es mas complejo de utilizar que EXECUTE IMMEDIATE, pero permite tener un mayor control sobre la ejecución 
-- de las sentencias SQL dinámicas, como por ejemplo, manejar errores, obtener el número de filas afectadas, etc. 


-- Cuando usar el paquete DBMS_SQL y cuando usar EXECUTE IMMEDIATE, se recomienda utilizar 
-- EXECUTE IMMEDIATE para sentencias SQL dinámicas simples, como INSERT, UPDATE, DELETE, etc,
-- y utilizar el paquete DBMS_SQL para sentencias SQL dinámicas mas complejas, como SELECT,
-- que devuelven resultados, o cuando se necesita un mayor control sobre la ejecución de las sentencias SQL dinámicas, 
-- como manejar errores, obtener el número de filas afectadas, etc.    




-- OPEN-PARSE-EXCUTE-FETCH-CLOSE, es una forma de ejecutar sentencias SQL dinámicas utilizando el paquete DBMS_SQL,
-- esto permite tener un mayor control sobre la ejecución de las sentencias SQL dinámicas, como por ejemplo,
-- manejar errores, obtener el número de filas afectadas, etc.

CREATE OR REPLACE PROCEDURE CREAR_TABLA(TABLA VARCHAR2, COLUMNAS VARCHAR2)
AUTHID CURRENT_USER
IS
    ID_CURSOR INTEGER;
    NUM_FILAS INTEGER;
BEGIN
    ID_CURSOR:=DBMS_SQL.OPEN_CURSOR;
    -- CREATE TABLE T1 ( CODIGO NUMBER )
    DBMS_SQL.PARSE(ID_CURSOR, 'CREATE TABLE '||TABLA||'('||COLUMNAS||')',DBMS_SQL.NATIVE);
    NUM_FILAS:=DBMS_SQL.EXECUTE(ID_CURSOR);
    DBMS_SQL.CLOSE_CURSOR(ID_CURSOR);
    DBMS_OUTPUT.PUT_LINE(NUM_FILAS);
END;
/

BEGIN
    CREAR_TABLA('T1','CODIGO NUMBER, DATOS VARCHAR2(100)');
END;
/

DESC T1;


-- BIND_VARIABLES, es una forma de pasar variables a las sentencias SQL dinámicas, utilizando el paquete DBMS_SQL, 
-- esto permite tener una mayor flexibilidad, ya que se pueden construir sentencias SQL dinámicas mas comple

CREATE TABLE REGIONES AS SELECT * FROM REGIONS;
/

SELECT * FROM REGIONES;
/

CREATE OR REPLACE PROCEDURE MOD_COLUMNA(TABLA VARCHAR2,COLUMNA VARCHAR2, VALOR_ANTIGUO VARCHAR2, VALOR_NUEVO VARCHAR2)
AUTHID CURRENT_USER

IS
--VARIABLE PAR5A ALBERGAR EL IDE DEL CURSOR
ID_CURSOR INTEGER;
NUM_FILAS NUMBER;

BEGIN
  ID_CURSOR:=DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(ID_CURSOR,'UPDATE ' ||TABLA ||' SET '||COLUMNA||'=:VALOR_NUEVO WHERE '||COLUMNA||'=:VALOR_ANTIGUO',DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(ID_CURSOR,':VALOR_ANTIGUO',VALOR_ANTIGUO);
  DBMS_SQL.BIND_VARIABLE(ID_CURSOR,':VALOR_NUEVO',VALOR_NUEVO);

  NUM_FILAS:=DBMS_SQL.EXECUTE(ID_CURSOR);
  DBMS_SQL.CLOSE_CURSOR(ID_CURSOR);
  DBMS_OUTPUT.PUT_LINE(NUM_FILAS||' MODIFICADAS');
END;
/

EXECUTE MOD_COLUMNA('REGIONES','REGION_NAME','Asia','ASIA');


-- BIND_ARRAY, es una forma de pasar arrays de variables a las sentencias SQL dinámicas, utilizando el paquete DBMS_SQL,
-- esto permite tener una mayor flexibilidad, ya que se pueden construir sentencias SQL dinámicas mas complejas, 
-- con condiciones, bucles, etc, y luego ejecutarlas con el paquete DBMS_SQL, utilizando arrays de variables para pasar los valores a las sentencias SQL dinámicas.   

--BIND_ARRAY
DECLARE
    ID_CURSOR INTEGER;
    NUM_FILAS INTEGER;

    CODIGOS DBMS_SQL.NUMBER_TABLE;  --
    REGIONES DBMS_SQL.VARCHAR2_TABLE;
BEGIN
    CODIGOS(1):=10;
    CODIGOS(2):=20;
    CODIGOS(3):=30;
    REGIONES(1):='AUSTRALIA';
    REGIONES(2):='ANTARTIDA';
    REGIONES(3):='NUEVA ZELANDA';
    
    ID_CURSOR:=DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(ID_CURSOR, 'INSERT INTO REGIONES VALUES (:COD,:REG)', DBMS_SQL.NATIVE);
    
    DBMS_SQL.BIND_ARRAY(ID_CURSOR,':COD',CODIGOS);
    DBMS_SQL.BIND_ARRAY(ID_CURSOR,':REG',REGIONES);
    
    NUM_FILAS:=DBMS_SQL.EXECUTE(ID_CURSOR);
    DBMS_SQL.CLOSE_CURSOR(ID_CURSOR);
END;
/

SELECT * FROM REGIONES;
     


-- SELECTS, es una forma de ejecutar sentencias SQL dinámicas que devuelven resultados, como un SELECT, utilizando el paquete DBMS_SQL,


-- Parte 1, DEFINE_COLUMN, es una forma de definir las columnas que se van a devolver en la consulta,
-- utilizando el paquete DBMS_SQL, esto permite tener una mayor flexibilidad, ya que se pueden construir sentencias SQL dinámicas mas complejas,
--con condiciones, bucles, etc, y luego ejecutarlas con el paquete DBMS_SQL, utilizando DEFINE_COLUMN para definir las columnas que se van a devolver en la consulta.

CREATE OR REPLACE FUNCTION BUSCAR_EMPLEADO(CODIGO NUMBER)
RETURN VARCHAR2
IS
    ID_CURSOR INTEGER;
    NUM_FILAS INTEGER;
    NOMBRE VARCHAR2(100);
BEGIN

    ID_CURSOR:=DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(ID_CURSOR, 'SELECT FIRST_NAME,SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID= :COD', DBMS_SQL.NATIVE);

    -- (el id del cursor, el numero de la columna, la variable donde se va a almacenar el resultado entonces se esta indicando que 
    -- el tipo de esa variables es la que se espera, el tamaño de la variable)
    DBMS_SQL.DEFINE_COLUMN(ID_CURSOR, 1, NOMBRE, 20);
    
    DBMS_SQL.BIND_VARIABLE(ID_CURSOR,':COD',CODIGO);
    
    NUM_FILAS:=DBMS_SQL.EXECUTE(ID_CURSOR);
    IF DBMS_SQL.FETCH_ROWS(ID_CURSOR) = 0 THEN
        RETURN 'NO EXISTE EL EMPLEADO';
    END IF;
    DBMS_SQL.COLUMN_VALUE(ID_CURSOR, 1, NOMBRE);
    DBMS_SQL.CLOSE_CURSOR(ID_CURSOR);
    RETURN NOMBRE;
END;
/


SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.PUT_LINE(BUSCAR_EMPLEADO(0));
END;


-- Parte 2, con un bucle para devolver todos los empleados que cumplan la condicion, utilizando el paquete DBMS_SQL,

CREATE OR REPLACE PROCEDURE BUSCAR_EMPLEADO1(SALARIO NUMBER)
IS
    ID_CURSOR INTEGER;
    NUM_FILAS INTEGER;
    NOMBRE VARCHAR2(100);
    APELLIDO VARCHAR2(100);
BEGIN

    ID_CURSOR:=DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(ID_CURSOR, 'SELECT FIRST_NAME,LAST_NAME FROM EMPLOYEES WHERE SALARY > :SALARIO', DBMS_SQL.NATIVE);
    DBMS_SQL.DEFINE_COLUMN(ID_CURSOR, 1, NOMBRE, 20);
    DBMS_SQL.DEFINE_COLUMN(ID_CURSOR, 2, APELLIDO, 20);
    
    DBMS_SQL.BIND_VARIABLE(ID_CURSOR,':SALARIO',SALARIO);
    
    NUM_FILAS:=DBMS_SQL.EXECUTE(ID_CURSOR);
    
    LOOP
        IF DBMS_SQL.FETCH_ROWS(ID_CURSOR) = 0 THEN
            EXIT;
        END IF;
    
        DBMS_SQL.COLUMN_VALUE(ID_CURSOR, 1, NOMBRE);
        DBMS_SQL.COLUMN_VALUE(ID_CURSOR, 2, APELLIDO);
        DBMS_OUTPUT.PUT_LINE('NOMBRE:'||NOMBRE||' Y EL APELLIDO ES '||APELLIDO);
    END LOOP;
        
    DBMS_SQL.CLOSE_CURSOR(ID_CURSOR);
END;
/


SET SERVEROUTPUT ON
BEGIN
   BUSCAR_EMPLEADO1(5000);
END;







