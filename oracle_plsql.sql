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

set SERVEROUTPUT ON;
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


SET SERVEROUTPUT ON

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

SET SERVEROUTPUT ON
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
