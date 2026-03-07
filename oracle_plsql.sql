-- Bloques Anonimos
-- Son bloques PL/SQL que no tienen un nombre y no se almacenan en la base de datos.
-- Se utilizan para ejecutar código PL/SQL de manera temporal.  
BEGIN 
  NULL;
END;


-- Visualizar salida por pantalla
-- Se utiliza el paquete DBMS_OUTPUT para mostrar mensajes en la consola.
-- Asegúrate de habilitar la salida en tu entorno de desarrollo (por ejemplo, SQL*Plus o SQL Developer).
SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hola, Mundo!');
  DBMS_OUTPUT.PUT_LINE(100 + 200);

  -- Concatena cadenas y resultados
  DBMS_OUTPUT.PUT_LINE('La suma de 100 y 200 es: ' || (100 + 200));
END;



-- Variables y tipos de datos

-- Son declaraciones que permiten almacenar y manipular datos en PL/SQL.
-- Deben declararse en la sección DECLARE de un bloque PL/SQL.


--  Ejemplo de declaración de variables: (Nombre, Tipo de dato)
DECLARE
  v_nombre VARCHAR2(50); -- Variable para almacenar un nombre 
  v_edad NUMBER;         -- Variable para almacenar una edad
BEGIN
  v_nombre := 'Juan Perez'; -- Asignación de valor a la variable
  v_edad := 30;             -- Asignación de valor a la variable

  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
  DBMS_OUTPUT.PUT_LINE('Edad: ' || v_edad);
END;



-- Hay varios tipo de variables
-- Escalares: Almacenan un solo valor (NUMBER, VARCHAR2, DATE, BOOLEAN)

/*
  Tipos de variables escalares comunes:

  - NUMBER
    * Almacena números enteros y decimales.
    * Puede definirse con precisión y escala.
    * Ejemplo:
        v_total NUMBER(10,2);

  - VARCHAR2
    * Almacena cadenas de texto de longitud variable.
    * Máximo 32,767 caracteres en PL/SQL.
    * Ejemplo:
        v_nombre VARCHAR2(100);

  - CHAR
    * Cadena de longitud fija.
    * Se rellena con espacios si el valor es menor.
    * Uso poco recomendado frente a VARCHAR2.
    * Ejemplo:
        v_codigo CHAR(5);

  - DATE
    * Almacena fecha y hora (año, mes, día, hora, minuto, segundo).
    * No almacena zona horaria.
    * Ejemplo:
        v_fecha DATE := SYSDATE;

  - TIMESTAMP
    * Similar a DATE pero con mayor precisión (fracciones de segundo).
    * Ejemplo:
        v_ts TIMESTAMP := SYSTIMESTAMP;

  - BOOLEAN
    * Valores lógicos: TRUE, FALSE, NULL.
    * Solo puede usarse en PL/SQL (no en SQL).
    * Ejemplo:
        v_activo BOOLEAN := TRUE;
*/

SET SERVEROUTPUT ON;
DECLARE 
  NAME VARCHAR2(100);
  LASTNAME VARCHAR2(50);

BEGIN
  NAME := 'Gabriel';
  LASTNAME := 'Betin';

  DBMS_OUTPUT.PUT_LINE('Nombre: ' || NAME);
  DBMS_OUTPUT.PUT_LINE('Apellido: ' || LASTNAME);
  DBMS_OUTPUT.PUT_LINE('Nombre Completo: ' || NAME || ' ' || LASTNAME);
END;




-- Compuestas: Almacenan múltiples valores (ARRAYS, RECORDS)


/*
  Tipos de variables compuestas:

  - RECORD
    * Estructura similar a una fila de tabla.
    * Puede contener campos de diferentes tipos.
    * Muy usado para SELECT ... INTO.
    * Ejemplo:
        TYPE t_empleado IS RECORD (
          id       NUMBER,
          nombre   VARCHAR2(100),
          salario  NUMBER(10,2)
        );
        v_emp t_empleado;

  - COLLECTIONS (Arreglos)

    * Associative Array (INDEX BY)
      - Arreglo en memoria indexado por número o VARCHAR2.
      - No se guarda en BD.
      - Ejemplo:
          TYPE t_lista IS TABLE OF VARCHAR2(100)
          INDEX BY PLS_INTEGER;
          v_lista t_lista;

    * Nested Table
      - Puede almacenarse en tablas.
      - Ejemplo:
          TYPE t_nombres IS TABLE OF VARCHAR2(100);

    * VARRAY
      - Arreglo de tamaño fijo.
      - Se almacena como una sola unidad.
      - Ejemplo:
          TYPE t_notas IS VARRAY(5) OF NUMBER;
*/




-- Referenciadas: Almacenan referencias a otros objetos (CURSORES, OBJETOS)

/*
  Tipos de variables referenciadas:

  - Cursor
    * Apuntan a un conjunto de resultados.
    * Pueden ser explícitos o implícitos.
    * Ejemplo:
        CURSOR c_empleados IS
          SELECT * FROM empleados;
        v_emp empleados%ROWTYPE;

  - REF CURSOR
    * Cursor dinámico.
    * Muy usado en procedimientos y paquetes.
    * Ejemplo:
        TYPE t_cursor IS REF CURSOR;
        v_cursor t_cursor;

  - Variables %TYPE
    * Toman el tipo de una columna.
    * Protege contra cambios de esquema.
    * Ejemplo:
        v_salario empleados.salario%TYPE;

  - Variables %ROWTYPE
    * Representan una fila completa de una tabla.
    * Ejemplo:
        v_fila empleados%ROWTYPE;

  - Objetos (OBJECT TYPE)
    * Variables basadas en tipos objeto definidos en BD.
    * Ejemplo:
        TYPE t_direccion IS OBJECT (
          calle VARCHAR2(100),
          ciudad VARCHAR2(50)
        );
*/



-- LOBs: Almacenan grandes cantidades de datos (CLOB, BLOB)
/*
  Tipos de LOB:

  - CLOB (Character Large Object)
    * Texto grande (XML, JSON, documentos).
    * Ejemplo:
        v_texto CLOB;

  - BLOB (Binary Large Object)
    * Datos binarios (imágenes, PDFs).
    * Ejemplo:
        v_binario BLOB;

  - NCLOB
    * Texto con soporte Unicode.
    * Ejemplo:
        v_ntexto NCLOB;

  - BFILE
    * Archivo binario externo (solo lectura).
    * Requiere DIRECTORY.
    * Ejemplo:
        v_archivo BFILE;
*/





-- Bind: Utilizadas para pasar datos entre SQL y PL/SQL.  
/*
  Variables Bind:

  - Se definen fuera del bloque PL/SQL.
  - Muy usadas en SQL*Plus, SQL Developer y aplicaciones.
  - Mejoran rendimiento y seguridad (evitan SQL Injection).

  Ejemplo:
      VARIABLE v_total NUMBER

      BEGIN
        :v_total := 1000;
      END;
      /

      PRINT v_total;
*/







-- Constantes y null


-- Las constantes son valores que no cambian durante la ejecución del bloque PL/SQL.
-- Se declaran usando la palabra clave CONSTANT.  

-- El null, representa la ausencia de valor en una variable.
-- Se puede asignar explícitamente a una variable para indicar que no tiene valor.  


SET SERVEROUTPUT ON;
DECLARE     
  v_pi CONSTANT NUMBER := 3.1416; -- Declaración de una constante, se debe inicializar al declararla sino da error
  v_nombre VARCHAR2(50);          -- Declaración de una variable  
BEGIN
  v_nombre := NULL;                -- Asignación de NULL a la variable  

  DBMS_OUTPUT.PUT_LINE('Valor de la constante PI: ' || v_pi);
  IF v_nombre IS NULL THEN    
    DBMS_OUTPUT.PUT_LINE('La variable v_nombre es NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El valor de v_nombre es: ' || v_nombre);
  END IF;     

END;


-- Variables boolean
-- Son variables que pueden tomar los valores TRUE, FALSE o NULL.
-- Se utilizan para controlar el flujo de ejecución en estructuras condicionales y bucles.  

SET SERVEROUTPUT ON;
DECLARE 
  v_es_mayor BOOLEAN; -- Declaración de una variable booleana
  v_edad NUMBER := 20; -- Declaración de una variable numérica    
BEGIN
  -- Asignación de valor a la variable booleana basada en una condición
  v_es_mayor := v_edad >= 18;   
  IF v_es_mayor THEN    
    DBMS_OUTPUT.PUT_LINE('La persona es mayor de edad.');  
  ELSE    
    DBMS_OUTPUT.PUT_LINE('La persona es menor de edad.');  
  END IF; 
END;  


-- %TYPE
-- Se utiliza para declarar una variable con el mismo tipo de dato que una columna de una tabla o una variable existente.
-- Esto ayuda a mantener la consistencia de tipos de datos y facilita el mantenimiento del código.

SET SERVEROUTPUT ON;
DECLARE 
  v_salario employees.salary%TYPE; -- Declaración de una variable con el mismo tipo que la columna salario de la tabla empleados 
BEGIN
  v_salario := 5000.00; -- Asignación de un valor a la variable  
  DBMS_OUTPUT.PUT_LINE('El salario es: ' || v_salario); 
END;  


-- Operadores
-- Son símbolos que se utilizan para realizar operaciones sobre datos en PL/SQL.
-- Pueden ser aritméticos, de comparación, lógicos, entre otros.


/*
   + : Suma
    - : Resta
    * : Multiplicación
    / : División
    MOD : Módulo (resto de una división)
    = : Igualdad
    <> o != : Diferente
    < : Menor que
    > : Mayor que 
    <= : Menor o igual que
    >= : Mayor o igual que      
    ** : Exponenciación
    AND : Operador lógico Y
    OR : Operador lógico O
    || : Concatenación de cadenas 
         
*/

SET SERVEROUTPUT ON;
DECLARE 
  v_a NUMBER := 10; 
  v_b NUMBER := 20; 
  v_resultado NUMBER;

BEGIN
  -- Operadores aritméticos   
  v_resultado := v_a + v_b;
  DBMS_OUTPUT.PUT_LINE('Suma: ' || v_resultado);

  v_resultado := v_b - v_a;
  DBMS_OUTPUT.PUT_LINE('Resta: ' || v_resultado);  

  v_resultado := v_a * v_b;       
  DBMS_OUTPUT.PUT_LINE('Multiplicación: ' || v_resultado);
 
  v_resultado := v_b / v_a; 
  DBMS_OUTPUT.PUT_LINE('División: ' || v_resultado);
  
  v_resultado := MOD(v_b, v_a);
  DBMS_OUTPUT.PUT_LINE('Módulo: ' || v_resultado);
 
 
  -- Operadores de comparación
  IF v_a < v_b THEN    
    DBMS_OUTPUT.PUT_LINE(v_a || ' es menor que ' || v_b);  
  END IF;   

  IF v_b >= v_a THEN    
    DBMS_OUTPUT.PUT_LINE(v_b || ' es mayor o igual que ' || v_a);  
  END IF;

  -- Operadores lógicos
  IF (v_a < v_b) AND (v_b > 15) THEN
    DBMS_OUTPUT.PUT_LINE('Ambas condiciones son verdaderas.');  
  END IF;

  IF (v_a > v_b) OR (v_b > 15) THEN    
    DBMS_OUTPUT.PUT_LINE('Al menos una de las condiciones es verdadera.');  
  END IF;

END;


-- Comentarios
-- Se utilizan para agregar notas y explicaciones en el código PL/SQL.

-- Pueden ser de una sola línea o de múltiples líneas.
-- Comentario de una sola línea

-- Este es un comentario de una sola línea
SET SERVEROUTPUT ON;
DECLARE 
  v_pi CONSTANT NUMBER := 3.1416; -- Declaración de una constante, se debe inicializar al declararla sino da error
  v_nombre VARCHAR2(50);          -- Declaración de una variable  
BEGIN
  v_nombre := NULL;                -- Asignación de NULL a la variable    
  DBMS_OUTPUT.PUT_LINE('Valor de la constante PI: ' || v_pi);     
  IF v_nombre IS NULL THEN    
    DBMS_OUTPUT.PUT_LINE('La variable v_nombre es NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El valor de v_nombre es: ' || v_nombre);
  END IF; 
END;    


-- Comentario de múltiples líneas
/*    
  Este es un comentario de múltiples líneas.
  Puede abarcar varias líneas.
  Útil para explicar bloques de código complejos.
*/      


-- Bloques anidados
-- Son bloques PL/SQL que se encuentran dentro de otros bloques PL/SQL.
-- Permiten organizar el código en secciones lógicas y manejar el alcance de las variables. 

SET SERVEROUTPUT ON;
DECLARE
BEGIN
    dbms_output.put_line('EN EL PRIMER BLOQUE');
    DECLARE
        x   NUMBER := 10;
    BEGIN
        dbms_output.put_line(x);
    END;
END;



-- Ambito de las variable en bloques anidados
-- El ámbito de una variable determina dónde puede ser accedida dentro del código PL/SQL.
-- Las variables declaradas en un bloque externo no son accesibles en bloques internos, y viceversa.  

-- Las variables del bloque padre son accesibles en los bloques hijos, pero las variables del bloque hijo no son accesibles en el bloque padre.
-- Pero si se crea una variable con el mismo nombre en el bloque hijo, esta "oculta" a la variable del bloque padre dentro del ámbito del bloque hijo.
-- Toma la definición de la variable más cercana en el ámbito.
-- en este caso , toma la variable x del bloque hijo.


SET SERVEROUTPUT ON;

DECLARE
    x   NUMBER := 20;  --GLOBAL
    Z   NUMBER:=30;
BEGIN
    dbms_output.put_line('X:='|| x);
    DECLARE
        x   NUMBER := 10;  --LOCAL
        z   number:=100;
        y number:=200;
    BEGIN
        dbms_output.put_line('X:='|| x);
        dbms_output.put_line('Z:='|| Z);
    END;
    dbms_output.put_line('Y:='|| y);   
END;

-- Uso de funciones SQL en PL/SQL
-- PL/SQL permite utilizar funciones SQL integradas para realizar diversas operaciones. 
-- No se permiten funcones de grupos, como las usamos en los select
-- tienen que ser de una sola linea

SET SERVEROUTPUT ON;
DECLARE
  X VARCHAR2(50);
  MAYUS VARCHAR2(100);
  FECHA DATE;
  Z NUMBER:=109.80;
BEGIN
  X:='Ejemplo';
  DBMS_OUTPUT.PUT_LINE(SUBSTR(X,1,3));
  MAYUS:=UPPER(X);
  DBMS_OUTPUT.PUT_LINE(MAYUS);
  FECHA:=SYSDATE;
  DBMS_OUTPUT.PUT_LINE(FECHA);
  DBMS_OUTPUT.PUT_LINE(FLOOR(Z));


END;



-- Estructuras de control
-- Permiten controlar el flujo de ejecución del código PL/SQL.  

/*
  - Estructuras condicionales:
    * IF ... THEN ... ELSE
    * CASE

  - Bucles:
    * LOOP ... END LOOP
    * WHILE ... END WHILE
    * FOR ... END FOR

*/

-- Estructuras de control
-- Permiten controlar el flujo de ejecución del código PL/SQL.  

/*
  - Estructuras condicionales:
    * IF ... THEN ... ELSE
    * CASE

  - Bucles:
    * LOOP ... END LOOP
    * WHILE ... END WHILE
    * FOR ... END FOR

*/


-- Operadores logicos

/*
   Operadores relacionales o de comparacion

     = : Igualdad
    <> o != : Diferente
    < : Menor que
    > : Mayor que 
    <= : Menor o igual que
    >= : Mayor o igual que  


    Operaciones logicos

    AND : Operador lógico Y
    OR : Operador lógico O
    NOT  : Negacion
         
*/




-- Comando IF y ELSE
-- Se utiliza para  condiciones simple, si se cumple una condicion
-- Ejecuta un programa o una sentencia
-- Si no, ejecuta algo


SET SERVEROUTPUT ON;
DECLARE
    x   NUMBER := 20;
BEGIN
    IF
        x = 10
    THEN
        dbms_output.put_line('X:=10');
    ELSE
        dbms_output.put_line('X:=OTHER VALUE');
    END IF;
END;




-- Comando ElSIF
-- Multiples condiciones


SET SERVEROUTPUT ON;

DECLARE
    sales   NUMBER := 25000;
    bonus   NUMBER := 0;
BEGIN
    IF
        sales > 50000
    THEN
        bonus := 1500;
    ELSIF sales > 35000 THEN
        bonus := 500;
    ELSIF sales > 20000 THEN
        bonus := 150;
    ELSE
        bonus := 100;
    END IF;

    dbms_output.put_line('Sales = '
    || sales
    || ', bonus = '
    || bonus
    || '.');

END;


-- Comando CASE
--  Una forma mas simple de costruir condiciones multiples


SET SERVEROUTPUT ON;
declare                                                                                         
  v1 CHAR(1);
BEGIN
  v1 := 'B';
  CASE v1
    WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
    ELSE DBMS_OUTPUT.PUT_LINE('POOR¡¡¡¡');
  END CASE;
END;
/                                                                                                                                 


-- Serached CASE
-- Nos permite hacer mas de una condicion, no solo el de igualdad
-- p por ejemplo condicion 1 y condicion 2

SET SERVEROUTPUT ON;
declare                                                                                         
  bonus  number;
BEGIN
  bonus := 100;
  CASE 
    WHEN bonus >500 THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN bonus <= 500 and bonus > 250 THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN bonus <= 250 and bonus > 100 THEN DBMS_OUTPUT.PUT_LINE('Good');
    ELSE DBMS_OUTPUT.PUT_LINE('POOR¡¡¡¡');
  END CASE;
END;
/          


-- Bucle LOOP
-- Su formato mas sencillo es un bicle infinito
-- Se le debe indicar una condicion de salida

-- Se utiliza cuando no se conoce el numero de iteraciones
SET SERVEROUTPUT ON;
DECLARE
   X NUMBER:=1;
BEGIN
    LOOP 
     DBMS_OUTPUT.PUT_LINE(X);
     X:=X+1;

     -- Forma 1 para condicionar la salida
    /* IF X = 11
       THEN EXIT;
     END IF;*/

     -- Forma 2 para condicionar la salida
     EXIT WHEN X=11;
    END LOOP;
END;
/


-- Loop anidados
-- Loops dentro de un loops

-- Se colocan etiquetas para identificarlas
SET SERVEROUTPUT ON;
DECLARE
  s  PLS_INTEGER := 0;
  i  PLS_INTEGER := 0;
  j  PLS_INTEGER;
BEGIN

  -- Etiqueta para el loop iniciar
  <<parent>>
  LOOP
    i := i + 1;
    j := 100;
    DBMS_OUTPUT.PUT_LINE('Parent:'||i);

    -- Etiqueta para el loop que esta interno, el hijo
    <<child>>
    LOOP
      --Print child
      dbms_output.put_line('Child:'||j);
      j:=j+1;
  
      -- En las salidas, se indica la etiqueta del loop que queremos salir
      EXIT parent WHEN (i> 3);
      EXIT child WHEN (j > 105);
    END LOOP child;
  END LOOP parent;
  DBMS_OUTPUT.PUT_LINE('FINISH¡¡¡');
END;
/
 


-- Comando Continue
-- Impide que siga las lineas, y se va al principio para 
-- Seguir con la siguiente iteracion


SET SERVEROUTPUT ON;
DECLARE
  x NUMBER := 0;
BEGIN
  LOOP -- CON CONTINUE SALTAMOS AQUI
    DBMS_OUTPUT.PUT_LINE ('LOOP:  x = ' || TO_CHAR(x));
    x := x + 1;
    /*IF x < 3 THEN
      CONTINUE;
    END IF;*/
    CONTINUE WHEN X <3;
    DBMS_OUTPUT.PUT_LINE
      ('DESPUES DE  CONTINUE:  x = ' || TO_CHAR(x));
    EXIT WHEN x = 5;
  END LOOP;
 
  DBMS_OUTPUT.PUT_LINE (' DESPUES DEL  LOOP:  x = ' || TO_CHAR(x));
END;
/



-- Bucle FOR

-- Se coloa el valor inicial y el valor final
-- Deben ser numericos

SET SERVEROUTPUT ON;
BEGIN
    FOR i IN 5..15 LOOP   --PLS_INTEGER
        dbms_output.put_line(i);
    END LOOP;
END;
/


-- BUCLE FOR REVERSE
-- Recorreo de modo inverso, por ejemplo
-- del 15 al 5, pero los parametros siguen ogual, valor inicial .......  valor final
-- lo que lo diferencia es la palabra reverse

-- tambien se puede utilizar exit y continue

SET SERVEROUTPUT ON;
BEGIN
    FOR i IN REVERSE 5..15 LOOP   --PLS_INTEGER
        dbms_output.put_line(i);
        EXIT WHEN i=10;
    END LOOP; 
END;
/

-- Es importante tener en cuenta
-- Que la variable i del bucle no se declara  antes, porque siempre va a ser
-- pls_integer, numerico

-- Si se declara antes, es una variable independiente

SET SERVEROUTPUT ON;
DECLARE 
  i VARCHAR2(100):='AAAAA';
BEGIN
    FOR i IN REVERSE 5..15 LOOP   --PLS_INTEGER
        dbms_output.put_line(i);
        EXIT WHEN i=10;
    END LOOP;
    dbms_output.put_line(i);
END;
/



-- Bucle While
-- Permite realizar un bucle controlado
-- Se coloca la condicion o la egacion de una condicion antes, y si se cumple, ingresa al loop


-- tambien se puede utilizar exit y continue

SET SERVEROUTPUT ON;
DECLARE
  done  BOOLEAN := FALSE;
  X NUMBER:=0;
BEGIN
  
  WHILE X <10 LOOP
    DBMS_OUTPUT.PUT_LINE(X);
    X:=X+1;
    EXIT WHEN X=5;
  END LOOP;

  WHILE done LOOP
    DBMS_OUTPUT.PUT_LINE ('No imprimas esto.');
    done := TRUE;  
  END LOOP;

  WHILE NOT done LOOP
    DBMS_OUTPUT.PUT_LINE ('He pasado por aqu�');
    done := TRUE;
  END LOOP;
END;
/


-- Comando GOTO
--  Nos permite irnos a un punto o bloque  especifico del programa
-- No se recomienda, porque rompe la programacion logica estructurada

-- Se coloca una etiqueta, para identificar en donde se debe ubicar
SET SERVEROUTPUT ON;
DECLARE
  p  VARCHAR2(30);
  n  PLS_INTEGER :=5;
BEGIN
  FOR j in 2..ROUND(SQRT(n)) LOOP
    IF n MOD j = 0 THEN
      p := ' no es un n�mero primo';
      GOTO print_now;
    END IF;
  END LOOP;

  p := ' Es un n�mero primo';
 
  <<print_now>>
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(n) || p);
END;
/



-- Usar SQL en  PL/SQl

-- POdemos hacer los select, pero con la clausula into
-- y el query solo debe devolver una sola fila
-- se pueden consultar varias columnas con varios into, pero el query
-- solo debe retornar una sola fila

-- y si no hay flas, genera un error data found

SET SERVEROUTPUT ON;
DECLARE
    salario   NUMBER;
    NOMBRE EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT  --SOLO PUEDE DEVOLVER UNA FILA
        salary,FIRST_NAME INTO salario,NOMBRE
    FROM
        employees
    WHERE
        employee_id = 10000;
    dbms_output.put_line(salario);
      dbms_output.put_line(NOMBRE);
END;
/





-- %ROWTYPE
-- Es para cuando voya  hacer un select y quiero recuperar toda la fila
-- Es decir, en una variable guardare todos los campos de la tabla


-- Si se hace cambio sobre la variable rowtype, no afecta el registro de la tabla original
SET SERVEROUTPUT ON;
DECLARE
    salario   NUMBER;
    NOMBRE EMPLOYEES.FIRST_NAME%TYPE;
    EMPLEADO EMPLOYEES%ROWTYPE;
BEGIN
    SELECT  --SOLO PUEDE DEVOLVER UNA FILA
        * INTO EMPLEADO
    FROM
        employees
    WHERE
        employee_id = 100;

    
    -- De esta manera  obtengo los valores de cada campo
    dbms_output.put_line(EMPLEADO.SALARY*100);
    dbms_output.put_line(EMPLEADO.FIRST_NAME);
END;
/


-- INSERT EN PL SQL
-- Se hace igual que en sql, pero se recomienda dentro de un bloque
-- Se utilizan variables para colocar en el values
-- Se debe indicar el commit

DECLARE
   COL1 TEST.C1%TYPE;
BEGIN
   COL1:=20;
   INSERT INTO TEST (C1,C2) VALUES (COL1,'BBBBBBB');
   COMMIT;
END;
/





-- UPDATES EN PL SQL 
-- Se hace igual que en sql, pero se recomienda dentro de un bloque
-- Se pueden utilizar variaables para colocarles como el valor a actualizar
-- en el campo correspondiente
-- Se debe indicar el commit



DECLARE
   T TEST.C1%TYPE;
BEGIN
   T:=10;
   UPDATE TEST SET C2='CCCCC' WHERE C1=T;
   COMMIT;
END;
/



-- DELETE EN PL SQL
-- Se hace igual que en sql, pero se recomienda dentro de un bloque
-- Se pueden utilizar variaables para  colocarle al valor
-- sobre los campos del where
-- Se debe indicar el commit



DECLARE
    T TEST.C1%TYPE;
BEGIN
    T:=20;
    DELETE FROM TEST WHERE C1=T;
    COMMIT;
END;
/


-- Excepciones

-- Sirven para controlar errores

-- Hay execpciones de oracle y las que el usuario puede crear.


-- Sintaxis de las excepciones
/*
SET SERVEROUTPUT ON;
DECLARE
    empl   employees%rowtype;
BEGIN
    SELECT
        *
    INTO
        empl
    FROM
        employees
    WHERE
        employee_id > 1;

    dbms_output.put_line(empl.first_name);
EXCEPTION
    WHEN ex1 THEN
        NULL;
    WHEN ex2 THEN
        NULL;
    WHEN OTHERS THEN
        NULL;
END;
*/

-- Excepciones predefinidas
-- Son excepciones de oracle
-- conjunto de errores de oracle


-- NO_DATA_FOUND   ORA-01403  -- No hay datos
-- TOO_MANY_ROWS              -- Mas de una fila
-- ZERO_DIVIDE                -- Division por cero  
-- DUP_VAL_ON_INDEX           -- LA clave ya existe


SET SERVEROUTPUT ON;
DECLARE
    EMPL EMPLOYEES%ROWTYPE;
BEGIN
    SELECT * INTO EMPL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID>1;
    
    DBMS_OUTPUT.PUT_LINE(EMPL.FIRST_NAME);
EXCEPTION
-- NO_DATA_FOUND   ORA-01403
-- TOO_MANY_ROWS
-- ZERO_DIVIDE
-- DUP_VAL_ON_INDEX
   WHEN NO_DATA_FOUND THEN 
       DBMS_OUTPUT.PUT_LINE('ERROR, EMPLEADO INEXISTENTE');
  WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR, DEMASIADOS EMPLEADO');
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDEFINIDO');

END;
/



-- Excepciones no predefinidas
-- on errores que sí existen en la base de datos (tienen un código ORA-xxxxx)
-- pero NO tienen un nombre incorporado en PL/SQL como lo tienen las excepciones


SET SERVEROUTPUT ON;
DECLARE

   -- Declaramos una variable de tipo exception
   MI_EXCEP EXCEPTION;

   -- Es una orden al compilador, cuando aparezca la excpecion, lo asocie al codigo de error (-937)
   PRAGMA EXCEPTION_INIT(MI_EXCEP,-937);
  
  
   V1 NUMBER;
   V2 NUMBER;
BEGIN
    SELECT EMPLOYEE_ID,SUM(SALARY) INTO V1,V2 FROM EMPLOYEES; 
    DBMS_OUTPUT.PUT_LINE(V1);
EXCEPTION
   WHEN MI_EXCEP THEN 
       DBMS_OUTPUT.PUT_LINE('FUNCION DE GRUPO INCORRECTA');
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDEFINIDO');
END;
/




-- SQLCODE Y SQLERRM
-- NO son excepciones, son funciones implícitas del motor PL/SQL para manejo y diagnóstico de errores.
-- SQLCODE -> El código numérico del error (ej: -937, -2291)
-- SQLERRM -> El mensaje del error (ej: ORA-00937: not a single-group group function)

-- OJO hay que crear la tabla
create table errors (
  code number,
  message varchar2(200)
);

SET SERVEROUTPUT ON;
DECLARE
   EMPL EMPLOYEES%ROWTYPE;
   CODE NUMBER;
   MESSAGE VARCHAR2(100);
BEGIN
   SELECT * INTO EMPL FROM EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE(EMPL.SALARY);
EXCEPTION   
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        CODE:=SQLCODE;
        MESSAGE:=SQLERRM;
        INSERT INTO ERRORS VALUES (CODE,MESSAGE);
        COMMIT;
END;
/


-- Controlar SQL con excepciones
-- Si el registro no existe, lo inserta

SET SERVEROUTPUT ON;
DECLARE
  REG REGIONS%ROWTYPE;
  REG_CONTROL REGIONS.REGION_ID%TYPE;
BEGIN
   REG.REGION_ID:=100;
   REG.REGION_NAME:='AFRICA';
   SELECT REGION_ID INTO REG_CONTROL FROM REGIONS
   WHERE REGION_ID=REG.REGION_ID;
   DBMS_OUTPUT.PUT_LINE('LA REGION YA EXISTE');
EXCEPTION   
   WHEN NO_DATA_FOUND  THEN
        INSERT INTO REGIONS VALUES (REG.REGION_ID,REG.REGION_NAME);
        COMMIT;
END;
/






-- Excepciones controladas por el desarrollador
-- Se lanza el error con raise

-- RAISE, lanza el error
SET SERVEROUTPUT ON;
DECLARE
   reg_max EXCEPTION;
   regn NUMBER;
   regt varchar2(200);
BEGIN
   regn:=101;
   regt:='ASIA';
   IF regn > 100 THEN
         RAISE reg_max;  
    ELSE
       insert into regions values (regn,regt);
       commit;
      END IF;
EXCEPTION
  WHEN reg_max THEN  
    DBMS_OUTPUT.PUT_LINE('La region no puede ser mayor de 100.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error indefinido');
END;
/


-- Ambito de las excepciones
-- Son practicamente, igual a las de las variables

-- Cuando tengo datos anidados, los bloques hijos puede leer la de los padres
-- Pero el padre no puede leer la del hijo
SET SERVEROUTPUT ON;
DECLARE
   
   regn NUMBER;
   regt varchar2(200);
BEGIN
   regn:=101;
   regt:='ASIA';
   DECLARE 
     reg_max EXCEPTION;
   BEGIN
       IF regn > 100 THEN
             RAISE reg_max;  
       ELSE
           insert into regions values (regn,regt);
           commit;
       END IF;
    EXCEPTION
    WHEN reg_max THEN  
        DBMS_OUTPUT.PUT_LINE('La region no puede ser mayor de 100.BLOQUE HIJO');
    END;
EXCEPTION
/*  WHEN reg_max THEN  
    DBMS_OUTPUT.PUT_LINE('La region no puede ser mayor de 100.');*/
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error indefinido');
END;
/

-- Comando RAISE_APPLICATION_ERROR
-- Se lanza un error  indicando  el codigo y mensaje propios
-- los codigos lo inventamos nosotros

/*

  lanzar un error personalizado,
  con código y mensaje propios,
  como si fuera un error ORA real.


  error_number  Código entre -20000 y -20999
  error_message Mensaje claro para el usuario
  keep_errors TRUE → conserva error original

*/

-- Código entre -20000 y -20999

SET SERVEROUTPUT ON;
DECLARE   
   regn NUMBER;
   regt varchar2(200);
BEGIN
   regn:=101;
   regt:='ASIA';
   iF regn > 100 THEN
       -- EL CODIGO DEBE ESTAR ENTRE -20000 Y -20999
       RAISE_APPLICATION_ERROR(-20001,'LA ID NO PUEDE SER MAYOR DE 100');  
    ELSE
       insert into regions values (regn,regt);
       commit;
    END IF;
END;
/



-- Colecciones y tipos compuestos
-- Son de dos tipos



--  1. PL/SQL Records , son parecidos a una fila 
-- Ejemplo , el %rowtype

--  2. Colecciones, son parecias a las tablas
     --  Arrays asociativos
     --  Tablas anidadas, nested tables
     --  varrays



--  1. PL/SQL Records , son parecidos a una fila 
-- Una opciones es el %rowtype
-- Declararlo 
-- TYPE nombre  IS RECORD
-- Despues que lo declaro, le puedo agregar los campos de ese record

/*
  Ejemplo

  TYPE empleado IS RECORD
  (
  nombre varchar2 (100),
  salario numbr,
  fecha employees.hire_date%type,
  datos_completos employees%rowtype

  );

Se declara la variable del tipo record
emple1 empleado;

*/

-- Cursores

-- Hay dos tipos de cursores, los explicitos y los implicitos

-- Cursores implicitos
-- Son aquellos que se generan automáticamente al ejecutar una sentencia SQL que devuelve una sola fila (SELECT ... INTO).
-- No requieren declaración explícita ni control manual de apertura, recuperación y cierre.
-- Se utilizan para manejar resultados de consultas que devuelven una sola fila.
-- Ejemplo de cursor implícito:
set serveroutput on;
DECLARE
  v_employee_id employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;   
BEGIN
  SELECT employee_id, first_name INTO v_employee_id, v_first_name FROM employees WHERE employee_id = 100; -- Esta consulta devuelve una sola fila
  DBMS_OUTPUT.PUT_LINE('ID: ' || v_employee_id || ', Name: ' || v_first_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró el empleado.');    
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Se encontró más de un empleado con el mismo ID.');    
END;
/ 



-- Cursores explicitos
-- Son aquellos que el programador define y controla su apertura, recuperación de datos y cierre.
-- Se declaran con la palabra clave CURSOR y se les asigna una consulta SQL.
-- Se utilizan para manejar conjuntos de resultados que devuelven varias filas.
-- Ejemplo de cursor explícito:
set serveroutput on;
DECLARE
  CURSOR c_empleados IS
    SELECT employee_id, first_name, salary FROM employees;
  v_employee_id employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  OPEN c_empleados; -- Abrir el cursor
  LOOP
    FETCH c_empleados INTO v_employee_id, v_first_name, v_salary; -- Recuperar datos
    EXIT WHEN c_empleados%NOTFOUND; -- Salir del bucle cuando no haya más filas
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_employee_id || ', Name: ' || v_first_name || ', Salary: ' || v_salary);
  END LOOP  ;
  CLOSE c_empleados; -- Cerrar el cursor
END;
/



--Atributos de los cursores
-- Son propiedades que proporcionan información sobre el estado del cursor.
-- Algunos atributos comunes son:   
/*
  %ISOPEN: Indica si el cursor está abierto (TRUE o FALSE).
  %FOUND: Indica si la última operación de recuperación devolvió una fila (TRUE o FALSE).
  %NOTFOUND: Indica si la última operación de recuperación no devolvió ninguna fila (TRUE o FALSE).
  %ROWCOUNT: Devuelve el número de filas recuperadas hasta el momento.
*/  


-- Ejemplos de uso de atributos de cursores:
set serveroutput on;
DECLARE
  CURSOR c_empleados IS
    SELECT employee_id, first_name FROM employees;
  v_employee_id employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;
BEGIN
  OPEN c_empleados;
  
  IF c_empleados%ISOPEN THEN
     DBMS_OUTPUT.PUT_LINE('Cursor abierto: TRUE');
  ELSE
     DBMS_OUTPUT.PUT_LINE('Cursor abierto: FALSE');
  END IF;
  
  LOOP    
    FETCH c_empleados INTO v_employee_id, v_first_name;
    EXIT WHEN c_empleados%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_employee_id || ', Name: ' || v_first_name);
  END LOOP;   
  DBMS_OUTPUT.PUT_LINE('Filas recuperadas: ' || c_empleados%ROWCOUNT);
  CLOSE c_empleados;
  
    IF c_empleados%ISOPEN THEN
     DBMS_OUTPUT.PUT_LINE('Cursor abierto: TRUE');
  ELSE
     DBMS_OUTPUT.PUT_LINE('Cursor abierto: FALSE');
  END IF;
  --DBMS_OUTPUT.PUT_LINE('Cursor abierto después de cerrar: ' || c_empleados%ISOPEN);
END;  
/


-- Ciclo de vida de un cursor
-- Declaración: Se define el cursor con la consulta SQL.
-- Apertura: Se abre el cursor para ejecutar la consulta y preparar el conjunto de resultados.
-- Recuperación: Se recuperan las filas del conjunto de resultados utilizando FETCH.
-- Cierre: Se cierra el cursor para liberar los recursos asociados. 


-- Crear un cursor

-- En este ejemplo, se declara un cursor para seleccionar todas las filas de la tabla REGIONS, luego se abre el cursor, se recuperan dos filas y se imprimen los valores de REGION_ID, y finalmente se cierra el cursor.
-- pero se puede recuperar todas las filas, pero en este ejemplo solo se recuperan dos para mostrar el uso del cursor y sus atributos.
-- Si se intenta recuperar una fila después de que el cursor ha devuelto todas las filas, el atributo %NOTFOUND se volverá TRUE, lo que indica que no hay más filas para recuperar.

set serveroutput on;
DECLARE
  CURSOR C1 IS SELECT * FROM REGIONS;
  V1 REGIONS%ROWTYPE;
BEGIN
  OPEN C1;
  FETCH C1 INTO  V1;
  DBMS_OUTPUT.PUT_LINE(V1.REGION_ID);
  FETCH C1 INTO  V1;
  DBMS_OUTPUT.PUT_LINE(V1.REGION_ID);
  CLOSE C1;
END;
/


-- Reccorrer un cursor con el bucle loop
-- En este ejemplo, se declara un cursor para seleccionar todas las filas de la tabla REGIONS, luego se abre el cursor y se utiliza un bucle LOOP para recuperar cada fila una por una. Dentro del bucle, se imprime el valor de REGION_NAME para cada fila recuperada. El bucle continúa hasta que el atributo %NOTFOUND del cursor se vuelve TRUE, lo que indica que no hay más filas para recuperar. Finalmente, se cierra el cursor.
-- Este es un patrón común para recorrer los resultados de un cursor explícito en PL/SQL.
-- Si se intenta recuperar una fila después de que el cursor ha devuelto todas las filas, el atributo %NOTFOUND se volverá TRUE, lo que indica que no hay más filas para recuperar.



set serveroutput on;
DECLARE
  CURSOR C1 IS SELECT * FROM REGIONS;
  V1 REGIONS%ROWTYPE;
BEGIN
  OPEN C1;
  LOOP
      FETCH C1 INTO  V1;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V1.REGION_NAME);
  END LOOP;
  CLOSE C1;
END;
/


-- Recorrer cursor con FOR
-- En este ejemplo, se declara un cursor para seleccionar todas las filas de la tabla REGIONS y se utiliza un bucle FOR para recorrer cada fila del cursor. Dentro del bucle, se imprime el valor de REGION_NAME para cada fila recuperada. El bucle FOR maneja automáticamente la apertura, recuperación y cierre del cursor, lo que simplifica el código y reduce la posibilidad de errores relacionados con el manejo manual del cursor.
-- Este es un patrón común para recorrer los resultados de un cursor explícito en PL/SQL  
-- Si se intenta recuperar una fila después de que el cursor ha devuelto todas las filas, el bucle FOR terminará automáticamente, ya que el cursor se cierra al finalizar el recorrido.
-- Todos los comandos estan de forma implicita, es decir, no se necesita abrir, recuperar o cerrar el cursor, el bucle FOR se encarga de todo eso automáticamente.


set serveroutput on;
DECLARE
  CURSOR C1 IS SELECT * FROM REGIONS;
  V1 REGIONS%ROWTYPE;
BEGIN
  OPEN C1;
  LOOP
      FETCH C1 INTO  V1;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V1.REGION_NAME);
  END LOOP;
  CLOSE C1;
  ----------------------
  ---BUCLE FOR
  FOR i IN C1 LOOP
    DBMS_OUTPUT.PUT_LINE(i.REGION_NAME);
  END LOOP;
END;
/



-- Recorrer cursor con FOR sin declarar el cursor
-- En este ejemplo, se utiliza un bucle FOR para recorrer directamente el
--resultado de una consulta SQL sin declarar un cursor explícito. El bucle FOR maneja automáticamente la apertura, recuperación y
--cierre del cursor implícito generado por la consulta SQL. Dentro del bucle, se imprime el valor de REGION_NAME para cada fila recuperada. Este enfoque es más conciso y se utiliza comúnmente cuando no se necesita un control detallado sobre el cursor.

set serveroutput on;
BEGIN
  FOR i IN (SELECT * FROM REGIONS) LOOP
    DBMS_OUTPUT.PUT_LINE(i.REGION_NAME);
  END LOOP;
END;
/




-- Cursores con parametros

-- En este ejemplo, se declara un cursor con un parámetro de entrada (SAL) que se utiliza para filtrar los resultados de la consulta SQL. El cursor selecciona todas las filas de la tabla EMPLOYEES donde el salario es mayor que el valor del parámetro SAL. Luego, se abre el cursor pasando un valor específico (10000) para el parámetro SAL y se utiliza un bucle LOOP para recuperar cada fila una por una. Dentro del bucle, se imprime el nombre y el salario de cada empleado que cumple con la condición. El bucle continúa hasta que el atributo %NOTFOUND del cursor se vuelve TRUE, lo que indica que no hay más filas para recuperar. Finalmente, se imprime el número total de empleados encontrados utilizando el atributo %ROWCOUNT del cursor y se cierra el cursor.
-- Este es un patrón común para utilizar cursores con parámetros en PL/SQL, lo que permite reutilizar el cursor con diferentes valores de entrada para obtener resultados específicos según las necesidades del programa.
-- Si se intenta recuperar una fila después de que el cursor ha devuelto todas las filas, el atributo %NOTFOUND se volverá TRUE, lo que indica que no hay más filas para recuperar.

set serveroutput on;
DECLARE
  CURSOR C1(SAL number) IS SELECT * FROM employees
  where SALARY> SAL;
  empl EMPLOYEES%ROWTYPE;
BEGIN
  OPEN C1(10000);
  LOOP
      FETCH C1 INTO  empl;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(empl.first_name||' '||empl.salary);
  END LOOP;
  dbms_output.put_line('He encontrado '||c1%rowcount||' empleados');
  CLOSE C1;
END;
/



-- Updates, deletes con where current of
-- Permite realizar operaciones de actualización o eliminación en la fila actual del cursor.
-- Se utiliza la cláusula WHERE CURRENT OF para referirse a la fila actual del cursor.
-- En este ejemplo, se declara un cursor para seleccionar todas las filas de la tabla EMPLO

set serveroutput on;
DECLARE
 empl employees%rowtype;
  CURSOR cur IS SELECT * FROM employees FOR UPDATE;
BEGIN
  OPEN cur;
  LOOP
    FETCH cur INTO empl;
    EXIT   WHEN cur%notfound;
    IF EMPL.COMMISSION_PCT IS NOT NULL THEN
       UPDATE employees SET SALARY=SALARY*1.10 WHERE CURRENT OF cur;
    ELSE
        UPDATE employees SET SALARY=SALARY*1.15 WHERE CURRENT OF cur;
    END IF;
  END LOOP;
 
  CLOSE cur;
END;

/

-- Procedimientos y funciones almacenadas

-- PROCEDURES
-- FUNCTIONS
-- PACKAGES
-- TRIGGERS


/* 
   1- CREAR EL OBJETO
       CODIGO FUENTE
       CODIGO PSEUDO-COMPILADO
   2- INVOCAR EN CUALQUIER MOMENTO (SQL)
   */

-- crear un procedimiento 
/*CREATE OR REPLACE PROCEDURE PR1
IS 
   X NUMBER:=10;
BEGIN
   DBMS_OUTPUT.PUT_LINE(X);
END;*/


-- Ejecutar o invocar el procedimiento

set serveroutput on;
begin 
    pr1; 
end;
/


-- Otra forma de ejecutar
execute pr1;

-- Ver los objetos de la base de datos

-- USER_PROCEDURES
-- Muestra información sobre los procedimientos almacenados 
-- definidos por el usuario en el esquema actual.

SELECT * FROM USER_PROCEDURES;  

-- USER_SOURCE
-- Muestra el código fuente de los objetos almacenados 
-- (procedimientos, funciones, paquetes, etc.) 
--definidos por el usuario en el esquema actual.

SELECT * FROM USER_SOURCE;


--USER_OBJECTS
-- Muestra información sobre todos los objetos 
-- (procedimientos, funciones, paquetes, tablas, vistas, etc.) 
--definidos por el usuario en el esquema actual.
SELECT * FROM USER_OBJECTS 
WHERE OBJECT_TYPE='PROCEDURE';

SELECT OBJECT_TYPE,COUNT(*) FROM USER_OBJECTS
GROUP BY OBJECT_TYPE;

SELECT * FROM USER_SOURCE
WHERE NAME='PR1';

SELECT TEXT FROM USER_SOURCE
WHERE NAME='PR1';


-- Parametros de funciones y procedimientos
-- IN: El valor se pasa al procedimiento o función, pero no se puede modificar dentro del procedimiento o función.
-- OUT: El valor se devuelve al programa que llamó al procedimiento o función, pero no se puede pasar un valor al procedimiento o función.
-- IN OUT: El valor se pasa al procedimiento o función y también se devuelve al programa que llamó al procedimiento o función, lo que permite modificar el valor dentro del procedimiento o función.

/*CREATE OR REPLACE PROCEDURE CALC_TAX 
(EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    T1 IN NUMBER)
IS
  TAX NUMBER:=0;
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;
   SELECT SALARY INTO SAL FROM EMPLOYEES    WHERE EMPLOYEE_ID=EMPL;
   --T1:=0;
   TAX:=SAL*T1/100;
   DBMS_OUTPUT.PUT_line('SALARY:'||SAL);
   DBMS_OUTPUT.PUT_line('TAX:'||TAX);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END;
/
*/


-- Invocar el SP
set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
begin
  A:=120;
  B:=5;
  calc_tax(A,B);
end;
/

-- Parametros tipo OUT
/*
create or replace PROCEDURE CALC_TAX_OUT 
(EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    T1 IN NUMBER,
    R1 OUT NUMBER)
IS
  --TAX NUMBER:=0;
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;    
   SELECT SALARY INTO SAL FROM EMPLOYEES    WHERE EMPLOYEE_ID=EMPL;
   --T1:=0;
   R1:=SAL*T1/100;
   DBMS_OUTPUT.PUT_line('SALARY:'||SAL);
  -- DBMS_OUTPUT.PUT_line('TAX:'||TAX);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END;
/*/


set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
  R NUMBER;
begin
  A:=120;
  B:=10;
  R:=0;
 CALC_TAX_OUT(A,B,R);
 DBMS_OUTPUT.PUT_LINE('R='||R);
end;
/

-- Parametros tipo IN-OUT
/*
create or replace PROCEDURE CALC_TAX_IN_OUT 
(EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    T1 IN OUT NUMBER
   )
IS
  --TAX NUMBER:=0;
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;    
   SELECT SALARY INTO SAL FROM EMPLOYEES    WHERE EMPLOYEE_ID=EMPL;
   --T1:=0;
   DBMS_OUTPUT.PUT_LINE('T1='||T1);
   T1:=SAL*T1/100;
   DBMS_OUTPUT.PUT_line('SALARY:'||SAL);
  -- DBMS_OUTPUT.PUT_line('TAX:'||TAX);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END; */



set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
  R NUMBER;
begin
  A:=120;
  B:=10;
 -- R:=1000;
 CALC_TAX_IN_OUT(A,B);
 DBMS_OUTPUT.PUT_LINE('B='||B);
end;
/

-- Funciones
-- Las funciones son similares a los procedimientos, pero tienen algunas diferencias clave:
-- Las funciones deben devolver un valor utilizando la cláusula RETURN, mientras que los procedimientos no devuelven valores.
-- Las funciones se pueden utilizar en expresiones SQL, mientras que los procedimientos no se pueden utilizar en expresiones SQL.

/*CREATE OR REPLACE FUNCTION CALC_TAX_F
    (EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
      T1 IN NUMBER)
RETURN NUMBER
IS
  TAX NUMBER:=0;
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;
   SELECT SALARY INTO SAL FROM EMPLOYEES WHERE EMPLOYEE_ID=EMPL;
   --T1:=0;
   TAX:=SAL*T1/100;
   RETURN TAX;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END; */

set serveroutput on;
DECLARE
  A NUMBER;
  B NUMBER;
  R NUMBER;
begin
  A:=120;
  B:=10;
  R:=CALC_TAX_F(A,B);
 DBMS_OUTPUT.PUT_LINE('R='||R);
end;
/


-- Funciones en comandos SQL
-- Las funciones pueden ser utilizadas en comandos SQL, como SELECT, WHERE, etc., lo que
-- permite realizar cálculos o transformaciones directamente en la consulta SQL.
-- En este ejemplo, se utiliza la función CALC_TAX_F en una consulta SQL para calcular el impuesto para cada empleado en la tabla EMPLOYEES. La función se llama para cada

--empleado, pasando su EMPLOYEE_ID y un valor fijo de 10 para el porcentaje de impuesto. El resultado se muestra en la columna TAX_CALCULATED junto con el nombre del empleado.
-- Este es un ejemplo común de cómo las funciones pueden ser integradas en consultas SQL para realizar
--cálculos dinámicos basados en los datos de la tabla.    

set serveroutput on;
BEGIN
  FOR rec IN (SELECT first_name, CALC_TAX_F(employee_id, 10) AS tax_calculated
                FROM employees) LOOP        
    DBMS_OUTPUT.PUT_LINE('Employee: ' || rec.first_name || ', Tax Calculated: ' || rec.tax_calculated);
  END LOOP;
END;
/





-- Packages
-- Un package es un contenedor lógico que agrupa procedimientos, funciones, variables, tipos de datos y otros objetos relacionados.
-- Los packages permiten organizar el código de manera modular y facilitan la reutilaización de código.


-- Tiene dos componentes, el specification y el body  
-- Specification: Es la parte pública del package, donde se declaran los objetos que estarán disponibles para otros programas.
-- Aquí se definen los procedimientos, funciones, variables y tipos de datos que se pueden utilizar fuera del package.

-- Body: Es la parte privada del package, donde se implementan los objetos declarados en    la specification. 
--Aquí se escribe el código que realiza las operaciones definidas en los procedimientos y funciones, y se pueden declarar variables 
--y tipos de datos que solo son accesibles dentro del package.


-- Crear las especificacions de un paquete
CREATE OR REPLACE PACKAGE PACK1
IS
   V1 NUMBER;
   V2 VARCHAR2(100);
END;
/



-- Ejecutar el paquete
SET SERVEROUTPUT ON
BEGIN
 PACK1.V1:=100;
 PACK1.V2:='AAAAA';
 DBMS_OUTPUT.PUT_LINE(PACK1.V1);
 DBMS_OUTPUT.PUT_LINE(PACK1.V2);

END;
/

-- Ambito de las variables
-- Las variables que se declaran en el specification de un package son globales y pueden ser accedidas desde cualquier parte del sistema,
-- incluyendo otros packages y programas PL/SQL. En la session,  hasta que el usuario se sale de la session

CREATE OR REPLACE PACKAGE PACK1
IS
   V1 NUMBER:=10;
   V2 VARCHAR2(100);
END;
/


SET SERVEROUTPUT ON
BEGIN
 PACK1.V1:=PACK1.V1+10;
 DBMS_OUTPUT.PUT_LINE(PACK1.V1);
END;
/

-- Crear el body del paquete
CREATE OR REPLACE PACKAGE PACK1
IS
  PROCEDURE CONVERT (NAME VARCHAR2, CONVERSION_TYPE CHAR);
END;
/


-- En el cuerpo del paquete, si tengo funciones que no estan delcaradas en el spec
-- No seran publicas, solo sera visible dentro del paquete
-- Esas funciones se deben declarar al inicio del body del paquete


CREATE OR REPLACE PACKAGE BODY PACK1
IS
FUNCTION UP(NAME VARCHAR2)
RETURN VARCHAR2 
IS
BEGIN
    RETURN UPPER(NAME);
END UP;

FUNCTION DO(NAME VARCHAR2)
RETURN VARCHAR2 
IS
BEGIN
    RETURN LOWER(NAME);
END DO;

PROCEDURE CONVERT (NAME VARCHAR2, CONVERSION_TYPE CHAR)
 IS
 BEGIN
    IF CONVERSION_TYPE='U' THEN
       DBMS_OUTPUT.PUT_LINE(UP(NAME));
    ELSIF CONVERSION_TYPE='L' THEN
       DBMS_OUTPUT.PUT_LINE(DO(NAME));
    ELSE
       DBMS_OUTPUT.PUT_LINE('EL PARAMETRO DEBE SER U o L');
   END IF;
END CONVERT;

END PACK1;
/


SET SERVEROUTPUT ON
BEGIN
 PACK1.CONVERT('aaaa','U');
 
END;
/


-- Usar funciones de un paquete en comandos SQL

SET SERVEROUTPUT ON
DECLARE
  V1 VARCHAR2(100);
BEGIN
 V1:=PACK1.CONVERT('AAAAA','L');
 DBMS_OUTPUT.PUT_LINE(V1);
END;
/

SELECT
    first_name,PACK1.CONVERT(FIRST_NAME,'L'),PACK1.CONVERT(LAST_NAME,'U')
FROM
    employees;


-- Sobre carga de procedimientos
CREATE OR REPLACE 
PACKAGE PACK2 AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  FUNCTION COUNT_EMPLOYEES(ID NUMBER) RETURN NUMBER;
  FUNCTION COUNT_EMPLOYEES(ID VARCHAR2) RETURN NUMBER;
END PACK2;
/

CREATE OR REPLACE
PACKAGE BODY PACK2 AS

  FUNCTION COUNT_EMPLOYEES(ID NUMBER) RETURN NUMBER AS
  X NUMBER;
  BEGIN
    -- TODO: Implementation required for FUNCTION PACK2.COUNT_EMPLOYEES
    SELECT COUNT(*) INTO X FROM EMPLOYEES WHERE DEPARTMENT_ID=ID;
    RETURN X;
  END COUNT_EMPLOYEES;

  FUNCTION COUNT_EMPLOYEES(ID VARCHAR2) RETURN NUMBER AS
  X NUMBER;
  BEGIN
    -- TODO: Implementation required for FUNCTION PACK2.COUNT_EMPLOYEES
    SELECT COUNT(*) INTO X FROM EMPLOYEES A, DEPARTMENTS B
         WHERE DEPARTMENT_NAME=ID
         AND A.DEPARTMENT_ID=B.DEPARTMENT_ID;
       
    RETURN X;
  END COUNT_EMPLOYEES;

END PACK2;

/

set serveroutput on;
begin

  dbms_output.put_line(PACK2.COUNT_EMPLOYEES(10));
  dbms_output.put_line(PACK2.COUNT_EMPLOYEES('IT'));  

end;
/


-- Paquetes predefinidos de oracle

/*
  DBMS_OUTPUT: Permite mostrar mensajes en la consola de salida.
  DBMS_SQL: Proporciona funciones para ejecutar sentencias SQL dinámicas.
  DBMS_RANDOM: Permite generar números aleatorios.
  DBMS_UTILITY: Proporciona funciones para obtener información del sistema y realizar tareas de utilidad general.
  DBMS_JOB: Permite programar tareas para que se ejecuten en momentos específicos.
  DBMS_SCHEDULER: Proporciona una interfaz para programar y administrar tareas en la base de datos.
  UTL_FILE: Permite leer y escribir archivos en el sistema de archivos del servidor.
  UTL_MAIL: Permite enviar correos electrónicos desde la base de datos.
  DBMS_ALERT: Permite crear y administrar alertas para monitorear eventos en la base de datos.
  DBMS_LOCK: Proporciona funciones para manejar bloqueos en la base de datos. 
  DBMS_SESSION: Permite obtener información sobre la sesión actual y controlar ciertos aspectos de la sesión.
  DBMS_APPLICATION_INFO: Permite establecer y recuperar información de la aplicación para la sesión actual.
  HTTP: Proporciona funciones para realizar solicitudes HTTP desde la base de datos.
  

*/


-- Paquete UTL_FILE
-- Permite leer y escribir archivos en el sistema de archivos del servidor.
-- Para usar este paquete, el directorio donde se encuentran los archivos debe estar definido en la
-- base de datos como un objeto de tipo DIRECTORY, y el usuario debe tener los permisos adecuados para acceder a ese directorio.

-- Permisos
GRANT CREATE ANY DIRECTORY TO HR;
GRANT EXECUTE ON SYS.UTL_FILE TO HR;


-- Se debe crear un directorio en el sistema operativo del servidor y luego crear un objeto
-- DIRECTORY en la base de datos que apunte a ese directorio. Por ejemplo,
-- si el directorio en el sistema operativo es /u01/app/files, se puede crear el objeto DIRECTORY de la siguiente manera:
--CREATE OR REPLACE DIRECTORY EXERCISES AS '/u01/app/files';  

set serveroutput on
create or replace PROCEDURE read_file IS

string VARCHAR2(32767); 
Vfile UTL_FILE.FILE_TYPE; 

BEGIN 
-- Open FILE
Vfile := UTL_FILE.FOPEN('EXERCISES','f1.txt','R'); 
Loop
    begin
        --read line
        UTL_FILE.GET_LINE(Vfile,string); 
        INSERT INTO F1 VALUES(string);
     EXCEPTION
          WHEN NO_DATA_FOUND THEN EXIT; 
    end;
end loop;
-- close file
UTL_FILE.FCLOSE(Vfile);

END;
/

begin
    read_file;
    commit;
end;
/


-- Trigggers
-- Un trigger es un bloque de código PL/SQL que se ejecuta automáticamente 
--en respuesta a ciertos eventos en la base de datos, como inserciones, actualizaciones o eliminaciones en una tabla



-- Tipos y eventos en los triggers
-- BEFORE: El trigger se ejecuta antes de que ocurra el evento (INSERT, UPDATE, DELETE).
-- AFTER: El trigger se ejecuta después de que ocurra el evento.
-- INSTEAD OF: El trigger se ejecuta en lugar del evento, comúnmente utilizado

-- para vistas.
-- ON: Especifica la tabla o vista a la que se aplica el trigger.
-- FOR EACH ROW: Indica que el trigger se ejecuta para cada fila afectada por el evento, en lugar de ejecutarse una sola vez por la operación completa.
-- WHEN: Permite especificar una condición para que el trigger se ejecute solo cuando se cumpla esa condición.

-- Tipos              Eventos           Filas Afectadas
-- BEFORE             INSERT            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- BEFORE             UPDATE            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- BEFORE             DELETE            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- AFTER              INSERT            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- AFTER              UPDATE            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- AFTER              DELETE            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- INSTEAD OF         INSERT            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- INSTEAD OF         UPDATE            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)
-- INSTEAD OF         DELETE            FOR EACH ROW (Se dispara por cada fila), STATEMENT (Se dispara una sola vez por la operación completa)




-- Crear un trigger


-- Crear la tabla log_table con los campos (log_column VARCHAR2(200), user_name VARCHAR2(30))
CREATE TABLE LOG_TABLE (
  log_column VARCHAR2(200),
  user_name VARCHAR2(30)
);

-- Crear el trigger que registra las inserciones en la tabla REGIONS
CREATE OR REPLACE TRIGGER INS_EMPL 
AFTER INSERT ON REGIONS 
BEGIN
  INSERT INTO LOG_TABLE VALUES('INSERCION EN LA TABLA REGIONS',USER);
END;
/

insert into regions values(1001, 'REGION2');
COMMIT;

select * from regions;

select * from log_table;


-- Impedir inserciones en la tabla REGIONS

-- El trigger se ejecuta antes de que ocurra la inserción en la tabla REGIONS.
-- Si el usuario que intenta realizar la inserción no es 'HR', se lanza un error utilizando 
-- RAISE_APPLICATION_ERROR, lo que impide que la inserción se complete. Si el usuario es 'HR', el trigger permite que la inserción se realice normalmente.

CREATE OR REPLACE TRIGGER TR1_REGION 
BEFORE INSERT 
ON REGIONS 
BEGIN
  IF USER <>'HR' THEN
    RAISE_APPLICATION_ERROR(-20000,'SOLO HR PUEDE TRABAJAR EN REGIONS');
  END IF;
  
END;
/


-- Crear trigger con eventos multiples

CREATE OR REPLACE TRIGGER TR1_REGION 
BEFORE INSERT OR UPDATE OF REGION_NAME OR DELETE
ON REGIONS 
BEGIN
  IF USER <>'HR' THEN
    RAISE_APPLICATION_ERROR(-20000,'SOLO HR PUEDE TRABAJAR EN REGIONS');
  END IF;
  
END;
/


-- Controlar el tipo de evento


create or replace TRIGGER TR1_REGION 
BEFORE INSERT OR UPDATE OR DELETE
ON REGIONS 
BEGIN
   
   IF INSERTING THEN
     INSERT INTO LOG_TABLE VALUES ('INSERCION',USER);
   END IF;
   IF UPDATING('REGION_NAME') THEN
      INSERT INTO LOG_TABLE VALUES ('UPDATE DE REGION_NAME', USER);
   END IF;
   IF UPDATING('REGION_ID') THEN
      INSERT INTO LOG_TABLE VALUES ('UPDATE DE REGION_ID', USER);
   END IF;
   IF DELETING  THEN
      INSERT INTO LOG_TABLE VALUES ('DELETE', USER);
   END IF;
   
  /*IF USER <>'HR' THEN
    RAISE_APPLICATION_ERROR(-20000,'SOLO HR PUEDE TRABAJAR EN REGIONS');
  END IF;*/
  
END;
/


-- TRiggers de tipo row
-- En este tipo de trigger, se pueden utilizar las pseudorecords 
--:NEW y :OLD para acceder a los valores de las filas afectadas por el evento.
-- :NEW se utiliza para acceder a los valores de la fila después de la operación (INSERT  o UPDATE), mientras que 
-- :OLD se utiliza para acceder a los valores de la fila antes de la operación (UPDATE o DELETE).  


-- los triggers de tipo row se diferencia de los triggers de tipo statement 
-- en que se ejecutan una vez por cada fila afectada por el evento, 
-- mientras que los triggers de tipo statement se ejecutan una sola 
--vez por la operación completa, independientemente del número de filas afectadas.  

-- Crear un trigger de tipo row

create or replace TRIGGER TR1_REGION 
BEFORE INSERT OR UPDATE OR DELETE
ON REGIONS 
FOR EACH ROW
BEGIN 
   IF INSERTING THEN
    :NEW.REGION_NAME:=UPPER(:NEW.REGION_NAME);
     INSERT INTO LOG_TABLE VALUES ('INSERCION ' || :NEW.REGION_ID,USER);
   END IF;
   IF UPDATING('REGION_NAME') THEN
      :NEW.REGION_NAME:=UPPER(:NEW.REGION_NAME);
      INSERT INTO LOG_TABLE VALUES ('UPDATE DE REGION_NAME ' || :NEW.REGION_ID, USER);
   END IF;
   IF UPDATING('REGION_ID') THEN
      INSERT INTO LOG_TABLE VALUES ('UPDATE DE REGION_ID ' || :NEW.REGION_ID, USER);
   END IF;
   IF DELETING  THEN
      INSERT INTO LOG_TABLE VALUES ('DELETE ' || :NEW.REGION_ID, USER);
   END IF;
   
  /*IF USER <>'HR' THEN
    RAISE_APPLICATION_ERROR(-20000,'SOLO HR PUEDE TRABAJAR EN REGIONS');
  END IF;*/
  
END;
/

-- Asi configuramos para guardar registros de auditoria en la base de datos
AUDIT INSERT, UPDATE, DELETE ON regions;

-- ver los cambios
select * from USER_AUDIT_TRAIL;

-- COn esto podemos ver las versiones de la filas en el tiempo
SELECT *
FROM regions
VERSIONS BETWEEN TIMESTAMP
SYSTIMESTAMP - INTERVAL '10' MINUTE
AND SYSTIMESTAMP;


-- La clausula WHEN en los triggers
-- Permite especificar una condición para que el trigger se 
-- ejecute solo cuando se cumpla


create or replace TRIGGER TR1_REGION 
BEFORE INSERT OR UPDATE OR DELETE
ON REGIONS 
FOR EACH ROW
WHEN (NEW.REGION_ID> 1000)
BEGIN 
   IF INSERTING THEN
    :NEW.REGION_NAME:=UPPER(:NEW.REGION_NAME);
     INSERT INTO LOG_TABLE VALUES ('INSERCION',USER);
   END IF;
   IF UPDATING('REGION_NAME') THEN
      :NEW.REGION_NAME:=UPPER(:NEW.REGION_NAME);
      INSERT INTO LOG_TABLE VALUES ('UPDATE DE REGION_NAME', USER);
   END IF;
   IF UPDATING('REGION_ID') THEN
      INSERT INTO LOG_TABLE VALUES ('UPDATE DE REGION_ID', USER);
   END IF;
   IF DELETING  THEN
      INSERT INTO LOG_TABLE VALUES ('DELETE', USER);
   END IF;
   
  /*IF USER <>'HR' THEN
    RAISE_APPLICATION_ERROR(-20000,'SOLO HR PUEDE TRABAJAR EN REGIONS');
  END IF;*/
  
END;
/

-- Comprobar estado de los triggers

select * from user_triggers
where trigger_name='TR1_REGION';  



-- Trabajar triggers en modo comando

-- Desactivar un trigger
ALTER TRIGGER TR1_REGION DISABLE;

-- Activar un trigger
ALTER TRIGGER TR1_REGION ENABLE;

-- Compilar un trigger
ALTER TRIGGER TR1_REGION COMPILE;

-- Eliminar un trigger
DROP TRIGGER TR1_REGION;


-- Triggers tipo compound , compuestos
-- Un trigger compuesto es un tipo de trigger que puede manejar múltiples eventos (INSERT, UPDATE, DELETE) en una sola definición de trigger. 
-- Esto permite escribir un código más conciso y organizado, ya que se pueden manejar diferentes eventos relacionados con la misma tabla en un solo bloque de código PL/SQL. 
-- En un trigger compuesto, se pueden utilizar las pseudorecords :NEW y :OLD para acceder a los valores de las filas afectadas por los eventos,
--  y se pueden utilizar las condiciones IF para diferenciar el comportamiento según el tipo de evento que se esté manejando    

CREATE OR REPLACE TRIGGER trigger1 
FOR DELETE OR INSERT OR UPDATE ON regions
COMPOUND TRIGGER
    BEFORE STATEMENT IS BEGIN
        INSERT INTO LOG_TABLE VALUES('BEFORE STATEMENT',USER);
    END BEFORE STATEMENT;
    
    AFTER STATEMENT IS BEGIN
        INSERT INTO LOG_TABLE VALUES('AFTER STATEMENT',USER);
    END AFTER STATEMENT;
    
    BEFORE EACH ROW IS BEGIN
        INSERT INTO LOG_TABLE VALUES('BEFORE EACH ROW',USER);
    END BEFORE EACH ROW;
   
   AFTER EACH ROW IS BEGIN
        INSERT INTO LOG_TABLE VALUES('AFTER EACH ROW',USER);
    END AFTER EACH ROW;
END trigger1;
/

ALTER TRIGGER TR1_REGION DISABLE;
INSERT INTO REGIONS VALUES(9001,'REGION9001');
UPDATE REGIONS SET REGION_NAME='AAA';
COMMIT;

-- Trigger de tipo DDL
-- Un trigger de tipo DDL es un trigger que se ejecuta en respuesta a eventos de definición de datos (DDL), como CREATE, ALTER o DROP.
-- Estos triggers se utilizan para controlar y auditar cambios en la estructura de la base de datos

CREATE OR REPLACE TRIGGER TRIGGER_DDL 
BEFORE DROP ON HR.SCHEMA 
BEGIN
  RAISE_APPLICATION_ERROR(-20000,'NO SE PUEDE BORRAR TABLAS');
END;
/
-- Orientacion a objetos en PL/SQL

-- Asi se crea el spec de un tipo de objeto
create or replace TYPE PRODUCTO  AS OBJECT (

--Atributos
codigo number,
nombre varchar2(100),
precio number,

--Métodos
MEMBER FUNCTION ver_producto RETURN VARCHAR2 ,
MEMBER FUNCTION ver_precio  RETURN NUMBER,
MEMBER PROCEDURE cambiar_precio(pvp number)
);

-- Asi se crea el body del tipo de objeto
create or replace TYPE body PRODUCTO  AS 
MEMBER FUNCTION ver_producto RETURN VARCHAR2 as 
begin
    return nombre||' '||precio;

end ver_producto;

MEMBER FUNCTION ver_precio  RETURN NUMBER as
begin
  return precio;
end ver_precio;

MEMBER PROCEDURE cambiar_precio(pvp number) as
begin
  precio:=pvp;
end cambiar_precio;
end;
/


-- Probar el tipo de objeto

set serveroutput on format wrapped line 1000;
declare
  v1 producto:=producto(100,'manzanas',10);
begin

  dbms_output.put_line(v1.ver_producto());
  dbms_output.put_line(v1.ver_precio());
  v1.cambiar_precio(20);
  dbms_output.put_line(v1.ver_precio());

end;
/

-- SELF
-- En los métodos de un tipo de objeto, se puede utilizar la palabra clave SELF para referirse a la instancia actual del objeto.
-- Esto es útil para acceder a los atributos y métodos de la instancia dentro del propio método.
-- En el ejemplo del tipo de objeto PRODUCTO, se podría modificar el método ver_producto para utilizar SELF en lugar de referirse directamente a los atributos nombre y precio. 
-- Esto haría que el método sea más flexible y reutilizable, ya que se referiría a los atributos de la instancia actual del objeto, independientemente de cómo se llame al método.    


-- Ejemplo de uso de SELF en un método de un tipo de objeto
-- eñ self indica que se esta refiriendo a los atributos de la instancia actual del objeto, lo que hace que el método sea más genérico y pueda ser utilizado por cualquier instancia del tipo de objeto PRODUCTO sin necesidad de modificar el código del método.
create or replace TYPE body PRODUCTO  AS 
MEMBER FUNCTION ver_producto RETURN VARCHAR2 as 
begin
    return SELF.nombre||' '||SELF.precio;

end ver_producto;

MEMBER FUNCTION ver_precio  RETURN NUMBER as
begin
  return SELF.precio;
end ver_precio;

MEMBER PROCEDURE cambiar_precio(pvp number) as
begin
  SELF.precio:=pvp;
end cambiar_precio;
end;





-- Metodos estaticos
-- Un método estático es un método que pertenece a la clase en lugar de a una instancia específica de la clase. 
-- Esto significa que se puede llamar al método sin necesidad de crear un objeto de la clase. En PL/SQL, los métodos estáticos se definen utilizando la palabra clave STATIC en la declaración del método dentro del tipo de objeto. 
-- Los métodos estáticos son útiles para realizar operaciones que no dependen de los atributos de una instancia específica, como cálculos generales o funciones de utilidad.

drop table auditoria;

create table auditoria
(usuario varchar2(100),
fecha date);

-- Ejemplo de un método estático en un tipo de objeto
create or replace TYPE PRODUCTO  AS OBJECT (  
--Atributos
codigo number,
nombre varchar2(100),
precio number,  
--Métodos
MEMBER FUNCTION ver_producto RETURN VARCHAR2 ,
MEMBER FUNCTION ver_precio  RETURN NUMBER,
MEMBER PROCEDURE cambiar_precio(pvp number),
STATIC PROCEDURE auditoria
);             


create or replace TYPE body PRODUCTO  AS 
MEMBER FUNCTION ver_producto RETURN VARCHAR2 as 
begin
    return SELF.nombre||' '||SELF.precio;

end ver_producto;

MEMBER FUNCTION ver_precio  RETURN NUMBER as
begin
  return SELF.precio;
end ver_precio;

MEMBER PROCEDURE cambiar_precio(pvp number) as
begin
  SELF.precio:=pvp;
end cambiar_precio;

STATIC PROCEDURE auditoria
as
begin 
    
    insert into auditoria values(user,sysdate);

end;

end;
-- invocar el metodo estatico
set serveroutput on;
begin
  PRODUCTO.auditoria;
end;
/ 

select * from auditoria;


