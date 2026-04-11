
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
CREATE OR REPLACE TYPE OBJETO_REGIONES IS OBJECT
(
   REGION_ID NUMBER,
   REGION_NAME VARCHAR2(25)
);
/


CREATE OR REPLACE TYPE NESTED_REGIONES IS TABLE OF OBJETO_REGIONES;
/

CREATE TABLE N_REGIONES
(
CODIGO NUMBER,
REGIONES NESTED_REGIONES
)
NESTED TABLE REGIONES STORE AS TABLA_REGIONES










