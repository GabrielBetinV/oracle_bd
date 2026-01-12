--------------------------------------------------------------------------
-- TIPOS DE DATOS --------------------------------------------------------
--------------------------------------------------------------------------


/*

CHAR(N) 

Cadena de caracteres de longitud fija, tiene un tamaño DE
n bytes.
Si no se especifica el tamaño es de 1 byte.
El tamaño máximo en BD es 2000 bytes y el mínimo 1 byte.

VARCHAR2(N) 

Cadena de caracteres de longitud variable, tiene un tamaño
máximo de n bytes.
Es obligatorio especificar el tamaño.
El tamaño máximo en BD es 4000 bytes en la 11g 32767 en la
12
El mínimo 1 byte.
Usando VARCHAR2 en lugar de CHAR ahorramos espacio de
almacenamiento, ya que no ocupamos todo el espacio, sino
solo la longitud del texto

NUMBER(p,s) 

Número. Está compuesto por “p“ digitos de los cuales “s” son
decimales.
No es obligatorio especificar el tamaño.
El tamaño de la parte entera es de 1 a 38 y el la parte decimal
desde -84 a 127.


DATE 

Tipo fecha. En realidad es un DATETIME. Contiene fecha hasta el
segundo.
Se usa desde el 1 de Enero de -4712 hasta el 9999


LONG 

Para albergar caracteres de longitud variable. Hasta 2GB. No se
debería utilizar en la actualidad

CLOB 

Alberga caracteres multi-byte o single-byte. Hasta 4GB
*DB_BLOCK_SIZE.
Soporta distintos caracteres de idioma. Es el que deberíamos
usar para textos grandes


NCLOB

Igual que el CLOB, pero con caracteres Unicode. Permite
almacenar cadenas de caracteres de tipo nacional de distintos
lenguajes


RAW(tamaño) 

Datos binarios (raw). Tienes los mismos límites que el
VARCHAR2

LONG RAW 

Para albergar datos de tipo RAW (byte) de hasta 2 GB. No se
debería usar en la actualidad

BLOB

Objeto binario. Hasta 4GB*DB_BLOCK_SIZE

BFILE 

Contiene punteros a ficheros externos a la Base de Datos

ROWID 

Representa el ID único de una fila
AAAI8HAAEAAAAHPABD


TIMESTAMP 

Fecha que almacena fracciones de segundo. Hay alguna
variación como por ejemplo WITH TIMEZONE o WITH
LOCALTIMEZONE

INTERVAL YEAR TO
MONTH

Almacena tiempo como un intervalo de años y meses.
Normalmente se usa para representar la diferencia entre dos
valores de tipo DATE, donde solo importa el año y el mes

INTERVAL DAY TO
SECOND


Similar al anterior, almacena un intervalo de días, horas,
minutos y segundos


/*/



--------------------------------------------------------------------------
-- SELECT --------------------------------------------------------
--------------------------------------------------------------------------


-- Alias


select * from employees;


select first_name as primer_nombre,last_name as segundo_nombre,
       salary as  "Salario empleado"
from employees;


select  first_name || ' '  || last_name as "Nombre Empleados",
phone_number as "Numero Telefonico" from employees;


select  first_name || ' '  || last_name as nombre,
job_id as "Tipo de Trabajo" from employees;

select * from regions;

select * from countries;

select country_name from countries;

select * from locations;

select street_address as Direccion, city as Ciudad,
state_province as Estado from locations;


-- Operadores aritmeticos


-- Suma




--Resta
--Division
--Multiplicacion

  select first_name, salary, salary * 12 as "Salario por año" 
  from employees;


--Resto


--Realizar una SELECT para visualizar el siguiente resultado. El impuesto es el
--20% del salario.

  select first_name, salary as Bruto, salary * 0.20 as "Impuesto" ,
  salary - (salary * 0.20)   from employees;

--Visualizar el salario anual de cada empleado, por 14 pagas. Debemos visualizar
--las columnas como Nombre, Salario y Salario Anual


  select first_name, salary, salary * 14 as "Salario por año" 
  from employees;



-- Literales



select 'NOMBRE: ' , first_name from  employees;


select 'NOMBRE: ' ||  first_name  || ' ' || last_name as "NOMBRE EMPLEADO" from  employees;

--Crear la consulta para visualizar los siguientes datos, usando el operador de
--concatenación


--El empleado Donald del departamento 50 tiene un salario de 2600



select 'El empleado ' || first_name  || ' del departamento ' ||
employee_id || ' tiene un salario de ' || salary
from  employees;

-- Crear la siguiente consulta


select 'La calle ' || street_address || ' pertenece a la ciudad: ' || city
from locations;


-- Tabla dual


select 4 + 3 as Resultado from dual;


-- null

-- Cual quier valor que tiene un null, va a  retornar null
-- Si  hay alguna comision null, el  salario total sera nulo

select first_name, salary , commission_pct,
salary * commission_pct "Salario Total"
from employees;


-- Distinct

select first_name, department_id from employees;

select department_id from employees;


-- Elimina los duplicados
select distinct department_id from employees;


select department_id , job_id  from employees;

select distinct department_id , job_id  from employees;


-- WHERE

select * from  employees
where department_id = 50;


-- OPeradores

/*
=
>
<
>=
<=
<>
*/

select * from employees
where salary > 5000;


select * from employees
where department_id <> 50;

-- Condiciones con literales

select * from employees
where first_name = 'John';



select * from employees
where first_name <> 'John';


-- Fechas

select * from employees
where hire_date <> '21-06-07';


select * from employees
where hire_date > '21-06-07';




-- between (entre)



select * from employees
where salary between 5000 and 6000;


select * from employees
where hire_Date between '01-01-07' and '01-01-09' ;

select * from employees
where first_name between 'Douglas' and 'Steven' ;


-- IN (valores,v1,v2, vn)

select * from employees
where department_id in (50,60) ;


select * from employees
where job_id in ('SH_CLERK','ST_CLERK','ST_MAN') ;


-- LIKE  'PATRON DE CARACTEROES'
-- %
-- _


-- Primera letra
select * from employees
where first_name like 'J%' ;


-- Segunda letra
select * from employees
where first_name like '_e%';


-- Palabras
select * from employees
where first_name like '%te%' ;



-- Ultima
select * from employees
where first_name like '%n' ;


-- IS NULL  , IS NOT NULL

select * from employees
where commission_pct is null ;


select * from employees
where commission_pct is not null ;






-- AND, OR Y NOT

-- AND  COND1  AND COND2 --> TRUE
-- OR   COND1  OR COND2 --> TRUE
-- NOT  COND1 --> TRUE



Select * from employees
where salary > 5000  and department_id =  50;

Select * from employees
where salary > 5000  or department_id =  50;

Select * from employees
where department_id not in (50,60);



/*

    C1 AND C2  TRUE TRUE --> TRUE
    C1 AND C2  TRUE FALSE --> FALSE
    C1 AND C2  FALSE FALSE --> FALSE
    
    C1 OR C2  TRUE TRUE --> TRUE
    C1 OR C2  TRUE FALSE --> TRUE
    C1 OR C2  FALSE FALSE --> FALSE
    
    
    MULTIPLES  ---------
    C1 OR C2 AND C3   -->  C1 OR C2 --> R1  AND C3
    
    TRUE  TRUE   FALSE       TRUE   AND FALSE   --> FALSE
    
    C1 AND C2 OR C3
    F      T      T -- > TRUE
    LO HACE DE IZQUIERDA A DERECHA
    
    POR ESO SE RECOMIENDA LOS PARENTESIS
    
    C1  AND (C2 OR C3)
    F        T      T    -->  FALSE
    
*/

    select first_name, salary, department_id, hire_date 
    from employees
    where salary > 5000 and department_id = 50 and hire_date > '01-01-05';
    
    
    select first_name, salary, department_id, hire_date 
    from employees
    where salary > 5000 and department_id = 50 or hire_date > '01-01-05';
    
    
    select first_name, salary, department_id, hire_date 
    from employees
    where salary > 5000 and (department_id = 50 or hire_date > '01-01-05');
    

-- ORDER BY

 select * from employees order by salary;

 select * from employees order by salary asc;
 
  select * from employees order by salary desc;
  
    select * from employees order by first_name,last_name;
    
    
    
      -- La tercera columna,  solo se organizara  si en last_name, hay valores repetidos
     -- “Oracle ordena por la tercera columna solo si hay empate en las anteriores; 
     --de lo contrario, no se aprecia su efecto.”
      select * from employees 
      where first_name ='David'
      order by first_name,last_name,salary;
      
      
      select * from employees 
      where first_name ='David'
      order by first_name,salary;
      
      -- Agregar la posicion de las columnas
      
       select first_name, salary*12 from employees 
       where first_name ='David'
       order by 1,2;     
      
      --  Ordenar por alias
       select first_name, salary*12  as total from employees 
       where first_name ='David'
       order by total;     
      
      
        
-- CLAUSA FETCH, LIMITAR EL NUMERO PARA MOSTRAR

-- Las primeas N filas
select * from employees
fetch first 5 rows only;


-- Las 5 personas con 5 mejores salarios, primero ordena y luego lo limita 
select * from employees
order by salary desc
fetch first 5 rows only;


select * from employees
order by salary desc
fetch first 8 rows only;


-- Con with ties, si encuentra otras filas con la misma condicion la muestra
-- Y ano muestra 7 si no 8 por ejemplo
select * from employees
order by salary desc
fetch first 7 rows with ties;


-- offset, a apartir de un N de filas
select * from employees
order by salary desc
offset 5 rows fetch first 7 rows with ties;

-- Percent,  sacar el porciento % de las filas existentes
select * from employees fetch first 20 percent rows only;

select * from employees fetch first 20 percent rows with ties;

select * from employees fetch first 20 percent rows only;

-- Next , cumple la misma funcion que el first
SELECT *
FROM employees
ORDER BY salary DESC
OFFSET 5 ROWS
FETCH NEXT 7 ROWS WITH TIES;


-- FUNCIONES

-- UPPER, LOWWER, INITCAP

select lower(email) from employees;

select upper(first_name) from employees;

select initcap(email) from employees;

select initcap('ESTO ES UNA PRUEBA') from dual;

select * from employees
where upper(first_name)  = 'DAVID';


-- CONCAT Y ANIDAMIENTOS

-- el  || no es estandar, perooooooooooo el concat solo recibe dos parametros 
select first_name || ' ' || last_name  from employees;


select  concat(first_name, last_name)  from employees;



-- Esto no lo permite
select  concat(first_name, ' ', last_name)  from employees;

-- En ese caso se deberia anidar
select  concat(first_name, concat (' ' ,last_name))  from employees;

-- LENGTH, cantidad de caracteres


select first_name , length(first_name) from employees;


select * from employees
where length(first_name) = 6;


-- SUBSTR, extrae parte de una cadena
--(cadena, posicion, longitud)
--(cadena, posicion)

select first_name , substr(first_name,1,3) from employees;

select first_name , substr(first_name,3) from employees;


select first_name , substr(first_name,length(first_name),1) from employees;

-- INSTR, devuelve la posicion que ocupa la cadena dentro de otra cadena


-- encuentra en que posicion esta la a
select first_name, instr(first_name,'a') from employees;

-- Devuelve todos los que tienen  la letra a,, con la funcion lower
select * from employees
where instr(lower(first_name),'a')  <> 0;

-- indicar desde donde se puede iniciar la busqueda
select first_name, instr(first_name,'a',4) from employees;


select * from employees
where instr(lower(first_name),'a',4)  <> 0;



-- cual concurrencia, si es kla segunda o primera aparcicion dela a
select * from employees
where instr(lower(first_name),'a',1,3)  <> 0;

-- cpn el -1 .... se empieza la busqued de derecha a izquierda

-- LPAD, RPAD

-- rellena cadenas con otras cadenas

select rpad(first_name,20,'*')   from employees;

select lpad(first_name,20,'*')   from employees;


-- REPLACE, LTRIM, RTRIM, TRIM

-- REPLACE, reemplaza las cadenas
--(cadena_original, cadena_sustituir)

select first_name,replace(first_name,'a','*')   from employees;

-- LTRIM, RTRIM, QUITAR CARACTERES 

select 'HOLA         ' || 'PEREZ' from dual;

select rtrim('HOLA         ') || ' ' ||  'PEREZ' from dual;


select ltrim('           HOLA') || ' ' ||  'PEREZ' from dual;

-- Si no se indica el caracter, se quitan lo espaciones en blanco
select first_name, rtrim(first_name,'n')   from employees;


select '     HOLA         ' || 'PEREZ' from dual;

-- el trim quita lso espacios d ela dereche e izquierda
select trim('     HOLA     SR.    ') || ' ' || 'PEREZ' from dual;


-- ROUND, TRUNC, MOD, POWER


-- ROUND
--( CANTIDAD, NIVEL DE REDONDEO DECIMALES)


select round(50.900,2) from dual;


select round(50.900) from dual;

select round(50.920909209,2) from dual;


-- TRUNCA, truncar

select trunc(50.920909209,2) from dual;

-- la diferencia entre truncar y redondear, es que el truncar no decide si sube o baja como elredondear

-- Aca redonde al 51
select round(50.900) from dual;

-- Aca quitar el dedimal como tal, queda en 50
select trunc(50.900) from dual;

-- MOD, l resto

select mod(10,3) from dual;


-- POWER, potencia

select power(10,2) from dual;


/*
 Tambien hay estas funciones
 
 SIGN
 SIN
 SINH
 SQRT
 TAN
 TANH

Perfecto 👍
Estas funciones pertenecen al **grupo matemático** de **Oracle SQL / PL-SQL**.
Te las explico **una por una**, con **qué hacen**, **ejemplos claros** y **cuándo se usan en la vida real**.

---

## 🔢 `SIGN`

👉 Indica **el signo de un número**

```sql
SIGN(número)
```

### Resultado:

* `-1` → número negativo
* `0`  → cero
* `1`  → número positivo

### Ejemplo

```sql
SELECT SIGN(-10), SIGN(0), SIGN(25)
FROM dual;
```

Resultado:

```
-1   0   1
```

📌 **Uso real**: validaciones, reglas de negocio, comparaciones.

---

## 📐 `SIN`

👉 Calcula el **seno** de un ángulo
⚠️ El ángulo debe estar en **radianes**, no en grados.

```sql
SIN(radianes)
```

### Ejemplo

```sql
SELECT SIN(0) FROM dual;
```

Resultado:

```
0
```

Si tienes grados:

```sql
SELECT SIN(30 * ACOS(-1) / 180) FROM dual;
```

📌 **Uso real**: cálculos científicos, ingeniería, gráficos.

---

## 📐 `SINH`

👉 Calcula el **seno hiperbólico**

```sql
SINH(número)
```

### Ejemplo

```sql
SELECT SINH(1) FROM dual;
```

📌 **Uso real**: matemáticas avanzadas, física, estadística.

---

## 📏 `SQRT`

👉 Calcula la **raíz cuadrada**

```sql
SQRT(número)
```

### Ejemplo

```sql
SELECT SQRT(25) FROM dual;
```

Resultado:

```
5
```

⚠️ Si el número es negativo → error.

📌 **Uso real**: distancias, fórmulas, desviación estándar.

---

## 📐 `TAN`

👉 Calcula la **tangente** de un ángulo
⚠️ También usa **radianes**.

```sql
TAN(radianes)
```

### Ejemplo

```sql
SELECT TAN(0) FROM dual;
```

Resultado:

```
0
```

📌 **Uso real**: trigonometría, pendientes, cálculos técnicos.

---

## 📐 `TANH`

👉 Calcula la **tangente hiperbólica**

```sql
TANH(número)
```

### Ejemplo

```sql
SELECT TANH(1) FROM dual;
```

📌 **Uso real**: matemáticas avanzadas, modelos científicos.

---

## 📊 Tabla resumen rápida

| Función | Qué hace             | Tipo           |
| ------- | -------------------- | -------------- |
| `SIGN`  | Devuelve -1, 0 o 1   | Comparación    |
| `SIN`   | Seno                 | Trigonométrica |
| `SINH`  | Seno hiperbólico     | Hiperbólica    |
| `SQRT`  | Raíz cuadrada        | Matemática     |
| `TAN`   | Tangente             | Trigonométrica |
| `TANH`  | Tangente hiperbólica | Hiperbólica    |

---

## 🧠 Detalles importantes (entrevista)

* `SIN` y `TAN` usan **radianes**
* `SINH` y `TANH` **no usan grados**
* `SIGN` es muy común en validaciones
* `SQRT` **no acepta negativos**

---

## 🎯 Resumen final

✔ Todas son funciones matemáticas
✔ Usadas en SQL y PL/SQL
✔ Trigonométricas usan radianes
✔ Hiperbólicas son más avanzadas

---

Si quieres, seguimos con:

* Conversión **grados → radianes**
* Ejercicios reales en Oracle
* Diferencias con SQL Server
* Preguntas típicas de entrevista

Dime 👌


*/



-- FUNCIONES PARA FECHAS

-- Fecha en la que el empleado ingreso a la empresa
select first_name, hire_date from employees;


-- El formato de la fecha, dependera de el formato que este configurado 

-- Con el sysdate, podemos ver cual es el formato de la fecha
select sysdate from dual;



-- Aritmetica con fechas

-- Sumar un numero

select sysdate + 2  from dual;


-- Restar un numero 

select sysdate - 1  from dual;

-- Restar fechas
-- Calcular dias

-- Cuantos dias lleva el empleado en la empresa
select first_name, hire_date ,sysdate - hire_date  from employees;

-- NUmero de semanas
select first_name, hire_date ,(sysdate - hire_date) / 7  from employees;

-- NUmero de años
select first_name, hire_date ,(sysdate - hire_date) / 365 from employees;


-- MONTHS_BETWEEN, NEXT_DAY, ADD_MONTS

--MONTHS_BETWEEN, numero de meses entre dos fechas
select first_name, hire_date , months_between(sysdate , hire_date)  from employees;


--ADD_MONTS, añadir meses
select sysdate , add_months(sysdate,3) from dual;

--NEXT_DAY, nos va a decir que fecha es tal dia de la semana (HAY QUE COMPROBAR EL FORMATO DE IDIOMA DENTRO DE LA FECHA EN LA BASE DE DATOS)
select sysdate , next_day(sysdate,'DOMINGO') from dual;

-- COMO SABER EL IDIOMA
SELECT value
FROM nls_session_parameters
WHERE parameter = 'NLS_DATE_LANGUAGE';

--LAST_DAY, ROUND, TRUNC



--LAST_DAY, devuelve el ultimo dia del mes
select sysdate , last_day(sysdate) from dual;

-- ROUND, redondea acorde a mes o año
select sysdate , round(sysdate, 'MONTH') from dual;

--TRUNC, como el trunca, coloca entonces el primer dia del mes 
select sysdate , trunc(sysdate, 'MONTH') from dual;




