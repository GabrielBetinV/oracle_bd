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



-- CONVERSIONES

-- IMPLICITAS

--Oracle convierte los tipos de datos automáticamente, sin que tú lo pidas.

-- EXPLICITAS

-- Oracle convierte los tipos de datos automáticamente, sin que tú lo pidas.

-- TO_CHAR
-- TO_DATE
-- TO_NUMBER


-- Implicita
select '10' + 10 from dual;
select '10' || 10 from dual;

select 'HOY ES: ' || sysdate from dual;


-- TO_CHAR

--to_char(date/number, 'formato')

/*
 yyyy Año 4 numeros
 year año(ingles)
 mm mes 2 digitos
 month mes en texto
 mon abreviatura del mes
 dy abreviatura del dia
 day dia en texto
 dd numero del dia

*/

select sysdate, to_char(sysdate,'yyyy')from dual;
select sysdate, to_char(sysdate,'month')from dual;
select sysdate, to_char(sysdate,'year')from dual;
select sysdate, to_char(sysdate,'day')from dual;

/*

AM PM MERIDIAN
HH  FORMATO 12 HORAS
HH24 FORMATO 24 HORAS
MI MINUTO
SS SEGUNDOS


*/

select sysdate, to_char(sysdate,'hh')from dual;
select sysdate, to_char(sysdate,'hh24')from dual;
select sysdate, to_char(sysdate,'mi')from dual;
select sysdate, to_char(sysdate,'hh24:mi:ss')from dual;

select sysdate, to_char(sysdate,'yyyy/mm/dd hh24:mi:ss')from dual;

select sysdate, to_char(sysdate,'"Son las " hh24:mi:ss "del dia " yyyy/mm/dd ' )from dual;



/*
    9 numeros
    o visualiza cero
    $ dolar
    L moneda actual
    . punto decimal
    , separador de miles

*/

select first_name,salary from employees;

select first_name,salary, to_char(salary,'99999') from employees;

select first_name,salary, to_char(salary,'00009') from employees;


select first_name,salary, to_char(salary,'$00009') from employees;


select first_name,salary, to_char(salary,'L00009') from employees;

select first_name,salary, to_char(salary,'L00009.99') from employees;

select first_name,salary, to_char(salary,'L00009.99') from employees;

-- TO_DATE

--to_date(string, formato)

select to_date('10-01-09') from  dual;
select to_date('10-01-1990') from  dual;
select to_date('10-01-1990') from  dual;
select to_date('01-JUN-90') from  dual;


select to_date('12-22-90') from  dual;

select to_date('12-22-90', 'mm-dd-yy') from  dual;
select to_date('jun-22-90', 'mon-dd-yy') from  dual;

-- Formato RR, derterminar en que centuria estamos (siglo)
-- 0 al 40  es apartir del año 2000
-- del 50 al 99 asume del siglo 1900

-- por defecto trabaja con RR

select to_date('10-01-89')from dual;

-- coloca 1989 , por eso aplica el RR
select to_char( to_date('10-01-89'),  'DD-MM-YYYY' )from dual;

-- coloca 2039 , por eso aplica el RR
select to_char( to_date('10-01-39'),  'DD-MM-YYYY' )from dual;

-- Para que el 39 lo entienda de este siglo, se cooca el formado al to_date
select to_char( to_date('10-01-89', 'DD-MM-YY'),  'DD-MM-YYYY' )from dual;

select to_char( to_date('10-01-89', 'DD-MM-RR'),  'DD-MM-YYYY' )from dual;


-- YY ---> Oracle toma el año tal cual, usando el siglo actual.
-- RR ---> Oracle decide el siglo según una regla lógica alrededor del año actual.



-- TO_NUMBER

-- to_number(string, formato)


select to_number( '1000' )from dual;

select to_number( '1000.89' , '9999.99')from dual;


select to_number( '$1000.89' , 'L9999.99')from dual;





-- FUNCIONES SQL - NULOS

-- nvl(expresion, valor)


select nvl('Hola','Adios') from dual;

-- Si es nulo, entonces retorna el valor adio
select nvl(null,'Adios') from dual;

select first_name, commission_pct from employees;


select first_name, nvl(commission_pct,0) from employees;



-- nvl2(expression, varlor1, valor2)
-- Si la expresion no es null, devuelve el valor 1 , sino , devuekve el valor 2
select first_name, salary, commission_pct, nvl2(commission_pct,salary * commission_pct,salary * 0.1) from employees;



-- NULLIF
-- comparar dos valores
-- si los dos valores son iguales, devuelve null
-- si son diferentes devuelve el primer valor

select nullif(1,1) from dual;

select nullif(1,10) from dual;

select country_id, upper(substr(country_name, 1, 2)) from countries;

select country_id, upper(substr(country_name, 1, 2)),  nullif(country_id,upper(substr(country_name, 1, 2))),
nvl2( nullif(country_id,upper(substr(country_name, 1, 2))),'NO SON IGUALES', 'SON IGUALES')
from countries;


-- COALSESCE (V1,V2,V3, ...........)
-- Hasta que encuentre un valor no nulo, lo devuelve


select coalesce('valor1','valor2','valor3','','valor4') from dual;

select coalesce('','','valor3','','valor4') from dual;


select first_name, to_char(commission_pct), to_char(manager_id) from employees;


select first_name,  coalesce( to_char(commission_pct),  to_char(manager_id), 'No tiene jefe ni comision') from employees;


-- expresiones condicionales


-- CASE
/*
 v1
 case 10
      20
      etc

*/


select first_name, job_id from employees;


select first_name, job_id,
case job_id
    when 'SH_CLERK' then 'TIPO 1'
    when 'ST_MAN' then 'TIPO 2'
    when 'ST_CLERK' then 'TIPO 3'
    else 'Sin tipo'
end
from employees;


-- case searched
-- Es diferente al case normal, ya que coloca los valores a ,os que se van a comparar


select first_name, salary,
case 
    when salary between 0 and 3000 then 'Ganas pocos'
    when salary between 3001 and 5000 then 'Ganas MEdios'
    when salary > 5001  then 'Ganas Bastantes'
    else 'No ganas'
end
from employees;


-- Decode(expression,valor1, resultado, valor2, resultado, valor3, resultado)
select first_name, department_id,
decode(department_id,50,'INFORMATICA',10, 'VENTAS','OTRO TRABAJO')
from employees;


-- GRUPOS Y FUNCIONES DE GRUPOS

-- La funcion de grupo retorna una sola fila
-- las funciones simples varias filas

-- funciones de grupo
-- AVG, MAX, MIN

-- AVG, MEDIA DE UN VALOR NUMERICO
select avg(salary) from employees;

-- Maximo
select max(salary) from employees;



-- Mimino


select min(salary) from employees;

select min(salary),max(salary) , avg(salary) from employees;

-- no se puede mezclar funciones de grupos con no de grupos
select first_name ,min(salary),max(salary) , avg(salary) from employees;


select min(salary),max(salary) , avg(salary) from employees
where department_id > 50;


-- Se puede hacer con varios tipos de datos, max y min  
select max(hire_Date) from employees;
select min(hire_Date) from employees;

-- avg no permite con valores que no sean numericos
select avg(hire_Date) from employees;

-- COUNT Y OTROS

-- count, cuenta filas, cuenta todo pero no los nulos

select count(first_name) from employees;


--- Cuenta mas salarios que comisiones
select count(salary),  count(commission_pct) from employees;


select count(*) from employees;

select count(*) from employees;

select count(department_id) from employees
where department_id = 50;

-- Se puede incluir distintic dentro del count
select count(distinct first_name) from employees;
select count(distinct department_id) from employees;



-- SUM Y OTRAS
select sum(salary) as "Suma de salarios", count(*) as "Numero de empleado" from employees
where department_id = 50;


select sum(salary) as "Suma de salarios", sum(salary) * 12 as "Suma anual de salarios", count(*) as "Numero de empleado" from employees
where department_id = 50;



select max(salary) - min(salary) as "Diferencia entre el max y min" from employees
where department_id = 50;



-- GROUP BY

-- Agrupa por departamento
select department_id from employees
group by department_id ;


-- Cuantos empleados hay por departamento
select department_id , count(*) from employees
group by department_id 
order by department_id;

-- Se puede agrupar por varios campos
select department_id ,job_id, count(*) from employees
group by department_id ,job_id
order by department_id;


-- HAVING

-- Es como decir, el where del group by, para 
-- aplicar filtros

-- Los filtros solo pueden ser, funciones de grupos

select department_id ,job_id, count(*) from employees
group by department_id ,job_id
having count(job_id) > 10
order by department_id;

select department_id ,job_id, count(*) from employees
group by department_id ,job_id
having sum(salary) > 25000 and count(*) > 10
order by department_id;


-- JOINS  UNIONES

--  Natural joins

-- Sin indicar las columnas, orcale intenta
-- buscar las columnas con nomre igual
-- para asociarlas


-- la columna que se supone une las dos tables
-- no se puede indicar en el select de las columnas
-- ya que el natural joins la muestra automaticamente

select * 
from  regions r natural join countries;


select c.* 
from countries c;

select r.* 
from regions r;


-- Clausal using
-- A diferencia de natural joins, se deben 
-- colocar las columnas que las une

-- con el using, si encuentra dos columnas iguales
-- multiplcas las filas o muestra todo lo que las una

select department_name, first_name
from employees join departments d
   using (department_id);



-- Clausula on
-- es similar al usgin con las sgtes diferencias
--  se puede cambiar al igual, por cualquier otra condicion
-- no es obligatorio que se llamen igual las columnas, ya que tienen el alias de la tabla
-- se puede tener mas de una columna para unir 
-- Se puede unir varias tablas

select department_name, first_name
from employees e join departments d
   on (e.department_id = d.department_id);

select department_name, first_name
from employees e join departments d
   on (e.department_id <> d.department_id);
   

select department_name, first_name, l.city
from employees e 
join departments d on (e.department_id <> d.department_id)
join locations l on (d.location_id <> l.location_id);


select department_name, first_name, l.city
from employees e 
join departments d on (e.department_id = d.department_id)
join locations l on (d.location_id = l.location_id and l.location_id is not null);



-- joins con where
-- Tambien se puede unir por medio de where



select department_name, first_name
from employees e , departments d
where e.department_id = d.department_id;


select department_name, first_name, l.city
from employees e , departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id;


-- self-join
-- cuando hay union de las misma tabla
-- por ejemplo, el manager_id es foranea de la misma tabla
-- porque hay un empleado que es jefe

-- obtener el nombre del empleado y del jefe

select trabajador.first_name, jefe.first_name
from employees trabajador
join employees jefe on trabajador.manager_id = jefe.employee_id;




-- join sin igualdad, NON-EQUIJOINS
-- utiliza otra comparacion que el signo igual


-- Los departamentos que estan en la ciudad pero no en la localidad
select department_name
from departments d
join locations l on d.location_id <> l.location_id
and l.city = 'Seattle';



select department_name
from departments d
join locations l on d.location_id = l.location_id
and l.city = 'Seattle';


-- Outer joins
-- recuperan las filas que no cumplen la condicion
-- pero quiero que salgan


-- No salen todos los empleados
-- porque hay un emepleado que no tiene departamento asignado
select department_name, first_name
from departments d
join employees e on d.department_id = e.department_id;

-- son r 

-- left outer join
-- right outer join
-- full outer join

-- el join solo, es inner join

-- left join, right joins, full joins


-- el left, tendra  en cuenta todo lo de la tabla izquierda
-- es decir, departamentos que no tienen empleados
select department_name, first_name
from departments d
left join employees e on d.department_id = e.department_id;

-- el right, tendra  en cuenta todo lo de la tabla derecha
-- es decir, empleados que no tienen departamentos
select department_name, first_name
from departments d
right join employees e on d.department_id = e.department_id;


-- el full, tendra  en cuenta todo lo de las dos tablas
-- es decir, empleados que no tienen departamentos y los departamentos
-- que no tienen empleados
select department_name, first_name
from departments d
full join employees e on d.department_id = e.department_id;



-- cross join
-- son tablas cruzadas, producto carteciano 

-- MUltiplica la cantidad de cada tabla
select department_name, first_name
from departments ,employees ;

-- Es igual que hacer el cross join

select department_name, first_name
from departments 
cross join employees ;



-- Clausula with
--  simplifica el uso de subconsltas complejas

select department_id,department_name , sum(salary) as salario
from employees 
join departments using (department_id)
group by department_id , department_name
having sum(salary) > 20000;


-- Con el with, podriamos simular una tabla temporal
-- que almacenara la query y despues la consultamos
with suma_salario as
    (select department_id , sum(salary) as salario
    from employees 
    group by department_id)
select * from suma_salario where  salario > 20000;


with suma_salario as
    (select department_id , sum(salary) as salario
    from employees 
    group by department_id)
select department_id, department_name ,salario 
from suma_salario 
natural join  departments
where  salario > 20000;



--SUBCONSULTAS

select max(salary) from employees;

select first_name, salary from employees
where salary = 24000;


-- Vamos a realizar la subconsulta
select first_name, salary from employees
where salary = (select max(salary) 
                from employees);
                
    
-- se pueden utilizar en el 
-- where
-- from
-- having

-- las subconsultas debe devoler una sola fila
-- la subconsulta se ejecuta una sola vez y luego 
-- se compara con el query principal

-- Cuantos empleados trabajan en el departamento de douglas grant
select first_name, department_id
from employees
where department_id = (select department_id
                       from  employees
                       where first_name = 'Douglas' and last_name = 'Grant' );
                       
                       

-- Cuantos empleados ganan mas que el promedui
select first_name, last_name, salary
from employees
where salary > (select avg(salary)
                       from  employees);
 
-- Que esten en el departamento 50                      
select first_name, last_name, salary
from employees
where salary > (select avg(salary)
                       from  employees)
and department_id = 50;
       
       
-- Subconsultas en el having

-- vamos a consultar el promedio de salario 
-- por departamento
select department_id, round(avg(salary)) as promedio_departamento
from employees
group by department_id;


-- Ahora, validamos cuales departamento ganan mas que el promedio de sueldo de la empresa
select department_id, round(avg(salary)) promedio_departamento
from employees
group by department_id
having avg(salary) > (select avg(salary) from employees);

-- los departamentos que ganan menos
select department_id, round(avg(salary)) promedio_departamento
from employees
group by department_id
having avg(salary) < (select avg(salary) from employees);


-- Subconsultas con multiples filas (IN)

-- Ene ste caso si podremos utilizar subconsultas 
-- que retornen  multiples  filas
-- y se podran hacer con 

-- ANY
-- IN
-- ALL


-- IN

-- Obtener cuales empleados tienen el salary igual
-- al maximo de salario de cualquier departamento
select first_name, salary, department_id 
from employees
where salary in (select  max(salary) from employees group by department_id);


-- Ahora, si quieremos que este en la lista de los
-- maximos por departamento, 

-- POr eso se coloca mas de una columna en la
-- subconsulta del in

select first_name, salary, department_id 
from employees
where (department_id, salary) in (select department_id ,  max(salary) from employees group by department_id);

-- Obtendremos los empleados que trabajan en los
-- departamentos ubicado en una ciudad
select first_name, department_id
from employees 
where (department_id) in ( select d.department_id
                        from departments d
                        join locations l on (d.location_id = l.location_id) and city = 'Seattle'  
                        );


-- ANY, cualquiera que esten en las opciones
-- debe estar acompañado de > , < , = , <>

-- Que empleado ganan mas que algunos de los empleados programadores
select first_name, last_name, job_id, salary
from employees
where salary > any (select salary from employees where job_id = 'IT_PROG')
and job_id <> 'IT_PROG';


-- ALL, a diferecia del ANY, debe ser mayor que todos
-- cumple todos

select first_name, last_name, job_id, salary
from employees
where salary > all (select salary from employees where job_id = 'IT_PROG')
and job_id <> 'IT_PROG';

-- Subconsultas sincronizadas


-- Asi es como lo veniamos haciendo
-- Primero se ejecuta el subquery una vez, y luego se compara con el query principal
select first_name, last_name, job_id, salary
from employees
where (department_id, salary) in ( select department_id, max(salary)
                                  from employees
                                  group by department_id);

-- Sincronizadas 
-- Conoceremos los empleados con el salario igual al mayor salario de su departamento


-- En este caso, el subquery se eecuta por cada fila
select emp.first_name, emp.last_name, emp.job_id, emp.salary
from employees emp
where (emp.department_id, emp.salary) in ( select s.department_id, max(s.salary)
                                  from employees s
                                  where s.department_id = emp.department_id
                                  group by department_id);
                                  
                                  
                                  
-- EXISTS  ,  NOT EXISTS

-- valida si retorna o no datos
-- Retorna false o true

-- Departamento donde no existen empleados
select department_name 
from departments dept
where not exists ( select * from employees
                    where department_id = dept.department_id
                );


-- Departamento donde si existen empleados
select department_name 
from departments dept
where  exists ( select * from employees
                    where department_id = dept.department_id
                );


/*en SQL profesional:

EXISTS (select 1 ...) → estándar

EXISTS (select *) → se considera poco elegante*/

select department_name 
from departments dept
where  exists ( select 1 from employees
                    where department_id = dept.department_id
                );



-- OPERADORES DE CONJUNTO

-- Tambien conocidos como set operator

-- UNION
-- Une las tablas y elimina los duplicados


-- UNION ALL
-- Une las tablas y devuelve los duplicados




-- INTERSECT
-- Une las tablas, y devuelve los datos que son comunes en las dos tablas


-- MINUS
-- Une las tablas, pero retorna A - B, 
-- muestra todos los que estan en la tabla A menos lo de las tablas B


/*
CREATE TABLE REGIONS1
(
 REGION_ID NUMBER,
 REGION_NAME VARCHAR2(25)
 );
 
 INSERT INTO REGIONS1 VALUES (1,'Europe');
 INSERT INTO REGIONS1 VALUES (3,'Asia');
 INSERT INTO REGIONS1 VALUES (6,'Australia');
 INSERT INTO REGIONS1 VALUES (8,'Antartica');
 
 commit;*/
 
 
 -- Los tipos de las columnas sean iguales, no tiene que ser el mismo nombre como tal
 
 
 
 -- UNION
 -- Muestras los datos y elimina los duplicados
 SELECT REGION_ID,REGION_NAME FROM REGIONS
 UNION
 SELECT REGION_ID,REGION_NAME FROM REGIONS1;
 
 
 -- UNION ALL
 -- Muestras los datos y muestra los duplicados 
 
 SELECT REGION_ID,REGION_NAME FROM REGIONS
 UNION ALL
 SELECT REGION_ID,REGION_NAME FROM REGIONS1;
 
 
  
 -- INTERSECT
 -- Muestras los datos y muestra los que coinciden
 
 SELECT REGION_ID,REGION_NAME FROM REGIONS
 INTERSECT
 SELECT REGION_ID,REGION_NAME FROM REGIONS1;
 
 
   
 -- MINUS
-- Muestras los datos y quita lo que esta en la segunda tabla
 
  SELECT REGION_ID,REGION_NAME FROM REGIONS
 MINUS
 SELECT REGION_ID,REGION_NAME FROM REGIONS1;

SELECT REGION_ID,REGION_NAME FROM REGIONS1
 MINUS
 SELECT REGION_ID,REGION_NAME FROM REGIONS;


-- DML Data Manipulation Lenguage

-- Insert

-- Permite guardar datos

-- insert into table (c1,c2) values (v1,v2);

insert into regions (region_id, region_name) 
values (5,'PRUEBA1');

select * from regions;

-- Se puede omitir el nombre de  las columnas
-- si se colocan los valores en el mismo  orden
insert into regions values (6,'PRUEBA1');


-- Es importante realizar el commit, de lo contrario los demas usuarios, no 
-- podran ver los nuevos datos

commit;
-- indicando las columnas, se puede insertar en cualquier orden

-- Insert multiples

CREATE TABLE DEPT2
(CODIGO NUMBER,
NOMBRE VARCHAR2(100),
JEFE NUMBER
);

INSERT INTO DEPT2 VALUES (1,UPPER('informatica'),100); 


-- Insertar multiples filas de otra tabla con el select
INSERT INTO DEPT2 (CODIGO,NOMBRE,JEFE)
                  SELECT DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID FROM DEPARTMENTS
                  WHERE LOCATION_ID=1700;
                  
commit;

select * from DEPT2;

-- Update
-- Modificar filas

/*update table
set columna = valor, columna2 = valor=2
where condicion*/

update dept2
set jefe = 100
where codigo = 120;
commit;


update dept2
set jefe =200
where jefe is null;
commit;

-- se puede colocar subconsultas
update dept2
set jefe = (select manager_id from departments where department_id= 30)
where codigo = 100;
commit;

-- Delete

/*
delete from table
where condicion
*/

-- es importante colocar la condicion en el delete y el update

delete from dept2 where codigo = 1;
commit;


-- se puede colocar una subconsulta para eliminar

delete from regions where region_id in (5,6,7);
commit;


delete from regions1 where region_id in (select region_id
                                     from regions where region_id in (1,3));
commit;

select * from regions1;

-- Truncate
-- truncate tabla nomnbre de table

-- A diferencia del delete, es que mientras no haya commit, se puede recuperar
-- pero en el truncate, no lo puedes recuperar

truncate table regions1;
rollback;


commit;


-- Transacciones

-- Commit
-- se confirman las transacciones
-- una transaccion comienza cuando se termina la anterior,
-- no es como en otras base de datos que se debe indicar cuando inicia y cuando termina

/*
  insert ....... trnsaccion 1
  
  update ......... transaccion 2
  
  
  delete .......

*/

-- Rollback
-- se rechazan las transacciones
-- Los datos desaperecen, y tiene la misma logica explicada commit

-- Es importante tener en cuenta que los comandos DDL
-- create table, , alter ........
-- Tienen un commit por defecto
-- Tambien los DCL


-- Cuando hay un fall, oracle hace rollback automaticamente.

-- Hay herramientas que tiene commit configurada, de forma automatica
-- es importante valdarlo antes de trabajar

-- Aunque no se haga commit, el usuario que esta transaccionando si podran ver los cambios
-- el resto de usuario no lo ven, hasta que o se validen

insert into regions1 (region_id, region_name) 
values (5,'PRUEBA1');

select * from regions1;
commit;

-- Savepoint
-- HAce rollback parciales

-- Hace rolllback hasta un punto en el tiempo

-- savepoint A => Se coloca el punto para rollback 
-- Insert, .......etc

-- al colocar rollback to savepoint A, se hace el rollback de los
-- salvados 




-- Bloqueos
-- Si realizo un update sobre un registro de la tabla y no hago commit
-- si otro usuario va a realizar un update sobre ese registro
-- se bloque a la base de datos

-- DDL Data Definition Lenguage

/*

create
alter
drop

*/


/*
tablas --> datos
indices --> rendimiento
vistas  -->  select guardada
inonimos  --> Alias de tablas
...
...
*/


-- Crear tablas
/*
create table nombre
(
    c1 tipo,
    c2 tipo
    c3 tipo
)
*/

-- forma basica
create table prueba
(
 codigo number,
 nombre varchar2(100)
);


desc prueba;

-- con default, 
create table prueba1
(
 codigo number,
 nombre varchar2(100) default 'TOMAS',
 fecha_entrada date default sysdate
);

desc prueba1;

select * from prueba1;

-- al realizar el insert solo con el codigo,  guardara el valor por defecto
insert into prueba1(codigo) values (1);
commit;


-- constraints

-- restricciones
/*

not null
unique
primary key
foreign key
check


*/

-- Primary key - not null
-- LLaves primaria y columnas no nulas

-- LAs llaves primarias no permiten escribir valores repetidos en las tablas
-- y los not null, no permite realizar el insert si el campo nombre no tiene valor


create table prueba3
(
  codigo number primary key,
  nombre varchar2(100) not null
);

-- esto generaria error
insert into prueba3(codigo) values (1);
commit;


insert into prueba3(codigo, nombre) values (1,'TOMAS');
commit;

select * from prueba3;

-- llaves primarias compuestas (mas de una columna)
create table prueba4
(
  codigo1 number,
  codigo2 number,
  nombre varchar2(100) not null,
  primary key (codigo1,codigo2)
);

insert into prueba4(codigo1, codigo2, nombre) values (1,1,'TOMAS');
commit;

select * from prueba4;

-- esto no lo permite
insert into prueba4(codigo1, codigo2, nombre) values (1,1,'TOMAS');
commit;


insert into prueba4(codigo1, codigo2, nombre) values (1,2,'TOMAS');
commit;



-- constrains UNIQUE
-- a diferencia de la primary key, es que puede ser null



create table prueba5
(
  codigo number primary key,
  nombre varchar2(100) unique
);



select * from prueba5;

insert into prueba5(codigo, nombre) values (1,'TOMAS');
commit;


-- esto si lo permite, aunque el valor sea nulo
insert into prueba5(codigo, nombre) values (2,null);
commit;

-- tambien se puede coloca al final, y se puede nombrar las constraint

create table prueba6
(
  codigo number primary key,
  nombre varchar2(100),
  constraint nombre_i unique (nombre)
);



-- constrains FOREIGN KEY
-- claves ajenas
-- tablas maestros detalle

-- relacion 1 ...... n

-- tabla maestra

create table cursos
(
     codigo number primary key,
     nombre varchar2(100) not null
);

-- tabla detalle  (reference) es la llave foranea
create table alumnos
(
     cod_alumno number primary key,
     nombre varchar2(100) not null,
     apellidos varchar2(100) not null,
     cod_curso number references cursos(codigo)
);

insert into cursos values (1, 'web');
commit;

insert into alumnos values (1, 'Gabriel','Betin',1);
commit;


-- esto no se puede, porque no existe el curso 2
insert into alumnos values (1, 'Gabriel','Betin',2);
commit;


-- tambien se puede colocar al final de la tabla

create table alumnos1
(
     cod_alumno number primary key,
     nombre varchar2(100) not null,
     apellidos varchar2(100) not null,
     cod_curso number,
     constraint curso_alumno foreign key(cod_curso) references cursos(codigo)
);

-- cuando se coloca la constraint se coloca directamente en la coumna se llamda restriccion de columna
-- si se coloca al final de la tabla, se llama restriccion de tabla


-- constrains CHECK
-- se utilizan para colocar condiciones en las tablas

-- no se permitira grabar empleados con salarios que sean menor que 1000
create table empleado
(
     codigo number primary key,
     nombre varchar2(100) not null,
     salario number check (salario > 1000)
);

-- Esto no se puede
insert into empleado values(1, 'Alberto', 900);
commit;


insert into empleado values(1, 'Alberto', 10000);
commit;

select * from empleado;


-- Otra idea, que no permita grabar si no es en mayusculca
create table empleado1
(
     codigo number primary key,
     nombre varchar2(100) not null check(nombre = upper(nombre)),
     salario number check (salario > 1000)
);


-- Esto no se puede
insert into empleado1 values(1, 'Alberto', 10000);
commit;


insert into empleado1 values(1, 'ALBERTO', 10000);
commit;

select * from empleado1;



-- crear tablas de otras tablas

-- se crea la tabla a partir de otra, y llna los datos
-- hay un problema, no crear las constrains no null (primary key, foreing key, not null etc)
create table empleados
  as select * from employees;

select * from empleados;

-- tambien se pueden elegir las columnas a crear

create table empleados2
  as select first_name || ' ' || last_name as nombres, salary, salary * 12 neto
  from employees;



-- modificar tablas add y modify
-- alter table

/*
    añadir columnas
    modificar columnas
    definir defaul value
    borrar una columna
    read  only

*/


-- añadir columnas

alter table cursos
add (profesor varchar2(100));


-- para añadir una columna vacia, no se puede colocar not null
-- Porque ya tiene filas


-- Esto no se puede
alter table cursos
add (duracion number not null);



-- modificar columnas (nombre, tipo , tamaño y valor por defecto)

-- Se modifica el tamaño del varchar2
alter table cursos
modify (profesor varchar2(200)); 

-- Se modifica el tipo de dato
alter table cursos      
modify (profesor number);


-- Se puede cambiar el valor por defecto
alter table cursos
modify (profesor varchar2(200) default 'Sin profesor');

-- agregar valor por defecto a una columna ya existente
alter table cursos      
modify (profesor varchar2(200) default 'Sin profesor');


-- modificar tablas drop, read only

-- Borrar las columnas

alter table cursos  
drop(profesor);


-- Colocar  tabla como solo lectura,
-- No permite inserts, updates ni deletes 
alter table cursos read only;


-- para permitir modificaciones
alter table cursos read write;

-- borrar tablas drop table


drop table prueba;

-- Si la llave primaria esta referenciada en otra tabla
-- no se puede borrar la tabla

-- Si se quiere borrar la tabla y todas las referencias
-- se coloca cascade constraints
-- Borra la tabla cursos y todas las referencias en otras tablas
-- elimina las foreign key que la referencian   
drop table cursos cascade constraints;



-- crear vistas
-- Son objetos que almacenan consultas select
-- son como tablas virtuales
-- guardan informacion


create view vista_empleados as
select * from employees;


-- Consultar la vista
-- realiza la consulta por debajo
select * from vista_empleados;


-- Una vista con condicion
create view vista_empleados_50 as
select * from employees
where department_id = 50;


-- consultar la vista, con cualquier condicion
-- como si fuera el select original
select * from vista_empleados_50
where salary > 5000;

select job_id, avg(salary) 
from vista_empleados_50
group by job_id
having avg(salary) > 6000;  


-- Crear vistas con algunas columnas
create view vista_empleados_nombres as
select first_name, last_name, salary from employees;

-- Borrar vista
drop view vista_empleados_nombres;



-- inserts, updates y deletes sobre views


-- Las vistas estan basadas en tablas reales
-- por lo tanto se pueden realizar operaciones DML
-- sobre las vistas, y estas afectaran a las tablas reales


CREATE VIEW REGIONS_V AS SELECT * FROM REGIONS;

SELECT  * FROM REGIONS_V;

INSERT INTO REGIONS_V VALUES(5,'XXX');

SELECT * FROM REGIONS;

INSERT INTO REGIONS_V (REGION_NAME) VALUES('ZZZ');

UPDATE REGIONS_V SET REGION_NAME='TTTTT' WHERE REGION_NAME='XXX';

CREATE VIEW REGIONES_PAISES AS SELECT * FROM REGIONS NATURAL JOIN COUNTRIES;
DROP VIEW REGIONES_PAISES;

SELECT * FROM REGIONES_PAISES;


-- cuando las vistas son basadas en joins, no se pueden realizar
-- inserts, updates o deletes, porque no sabe a que tabla   
INSERT INTO REGIONES_PAISES VALUES(10,'REGION10','XX','PAIS FICTIOCIO');




-- crear indices 
-- Son estructuras que mejoran el rendimiento
-- de las consultas select  
-- Mejoran el rendimiento de las consultas
-- especialmente en tablas grandes          

create index idx_lastname on employees(last_name);


-- Esto ayuda a mejorar el rendimiento de las consultas
-- Sabiendo la estructura de datos , como administrador
-- debo analizar cuales columnas son las mas consultadas


-- No se  recomienda crear indices en tablas pequeñas
-- porque el overhead de mantenimiento es mayor
-- que la mejora en el rendimiento      

-- ya que cada vez que se hace un insert, update o delete
-- se debe actualizar el indice 
 
-- como se actualizan los indices
-- cada vez que se hace un insert, update o delete  
-- ejemplo
-- insert into employees values(........);
-- se debe actualizar el indice idx_lastname    

-- valor_indexado  →  ROWID (dirección física de la fila)
-- curso_id = 10  →  fila #AAABkLAAEAAAAF3AAA
-- Se actualiza el rowid de la fila insertada

-- Al colocar los indices, se mejora el rendimiento de las consultas select
-- al buscar por la columna indexada
-- select * from employees where last_name = 'Smith';   
-- No buscara en toda la tabla, sino que buscara en el indice
-- valor_indexado  →  ROWID (dirección física de la fila)   

-- Asi es mas rapido


-- Borrar indice
drop index idx_lastname;

-- crear secuencias
-- Recuperar un valor unico
-- para llaves primarias

-- Parecidos al campo numerico autoincrementables
-- de otras bases de datos


--create sequence sequence1 increment by 1 maxvalue 9999 minvalue 20 cache 20;

-- Crear secuencia
create sequence sequence1 increment by 1 maxvalue 9999 minvalue 20 cache 20;   


-- Obtener el siguiente valor de la secuencia
select sequence1.nextval from dual;


-- Obtener el valor actual de la secuencia
select sequence1.currval from dual;


select * from regions1;

insert into regions1 (region_id, region_name) 
values (sequence1.nextval,'NUEVA REGION');  

-- Eliminar secuencia
drop sequence sequence1;

-- Reiniciar secuencia
-- No se puede reiniciar una secuencia  

-- Modificar secuencia
-- No se puede modificar una secuencia  

-- crear sinonimos

-- Son para crear alias a tablas, vistas, secuencias
-- para simplificar el acceso a los objetos 

-- crear sinonimo
create synonym departamentos for departments;   

-- consultar el sinonimo
select * from departamentos;

-- borrar sinonimo
drop synonym departamentos;

-- crear sinónimo con privilegios de otro usuario
-- create synonym dept_usuario2 for usuario2.departments;   


-- De esta manera, el usuario1 puede acceder a la tabla departments
-- del usuario2 sin necesidad de colocar el nombre del usuario2 

-- El query de abajo indica que el usuario plasticosta
-- tiene un sinónimo publico llamado PK_WA_MRP y por lo tanto
-- cualquier usuario puede acceder a la tabla plasticosta.PK_WA_MRP 


--create or replace public synonym PK_WA_MRP    for plasticosta.PK_WA_MRP  ;

-- comando para dar permisos a todos los usuarios
-- sobre las tablas de otro usuario

grant select on departments to prueba;

-- de esta manera, el usuario prueba puede consultar la tabla departments
select * from hr.departments;

-- para no indicar el usuario hr, se puede crear un sinonimo
create public synonym  departmentos for hr.departments;


select * from departments;


-- comando para quitar permisos a todos los usuarios
revoke select on departments from prueba;


-- Hay usuarios de base de datos que no tienen permisos para crear sinonimos
-- en ese caso, se debe crear un sinonimo publico
-- create or replace public synonym nombre_sinonimo for usuario.tabla;

-- o, se le da el poder para crear sinonimos 
-- grant create synonym to usuario;

-- Tablas en indices particionados
--Son tablas que se dividen en segmentos fìsicos
-- para mejorar el rendimiento y la gestión de grandes volúmenes de datos.  

-- Hay de 3 tipos
-- Rangos
-- Listas
-- Hash


-- Tablas particionadas por rangos
-- Se dividen los datos en rangos basados en valores de una columna específica.


-- En esta  tabla, se particiona por rangos de codigo
-- Los códigos menores a 100 van a la partición p1
-- Los códigos entre 100 y 199 van a la partición p2  
-- Los códigos 200 y superiores van a la partición p3


create table Rango
(
  codigo number not null,
  datos varchar2(100)
)
partition by range (codigo)
(
  partition p1 values less than (100),
  partition p2 values less than (200),
  partition p3 values less than (500)
);



-- Como saber las tablas particionadas
select * from user_part_tables
where table_name = 'RANGO'; 

-- Como saber las particiones de una tabla
select partition_name, high_value, tablespace_name
from user_tab_partitions
where table_name = 'RANGO'; 



-- Insert y select en la tabla particionada por rangos

-- Insertar datos en la tabla particionada por rangos
insert into Rango (codigo, datos) values (50, 'Dato en partición p1');
insert into Rango (codigo, datos) values (150, 'Dato en partición p 2');
insert into Rango (codigo, datos) values (250, 'Dato en partición p 3');
commit;


-- Seleccionar datos de la tabla particionada
select * from Rango;  

-- Seleccionar por partición específica
select * from Rango partition (p2);
select * from Rango partition (p1);
select * from Rango partition (p3);


-- consultar con where
select * from Rango
where codigo = 21;


-- con el boton de explain plan del sql developer
-- se puede ver que particion se esta utilizando


-- MAXVALUE

-- Si intento insertar una fila que sobrepase
-- el rango de la particion, no lo permitira
insert into Rango (codigo, datos) values (669, 'Dato en partición p 3');
commit;


-- Para eso se agrega  el maxvalue en una particion

alter table Rango
add partition p4 values less than (maxvalue);

insert into Rango (codigo, datos) values (669, 'Dato en partición p 3');
commit;


select * from Rango partition (p4);



-- Modificar una fila particion

select * from rango;

-- En este caso lo actualiza sin problema porque esta en el mismo rango
update rango set codigo = 51 where codigo = 50;
commit;

-- Pero en este caso genera error
update rango set codigo = 200 where codigo = 51;
commit;

-- Para permitir que se pueda cambiar las particiones
-- se debe activar esa funcionalidad en la tabla
alter table rango enable row movement;

-- Ahora si lo permite
update rango set codigo = 200 where codigo = 51;
commit;

-- Pero esto afecta el rendimiento de la base de datos, no es recomendable


-- Fusionar particiones


select partition_name, high_value, tablespace_name
from user_tab_partitions
where table_name = 'RANGO'; 

-- Puedo fusionar particiones adyacentes, que esta una detras del otro
-- no puede haber nada en la mitada

/*

P1	100	USERS
P2	200	USERS
P3	500	USERS
P4	MAXVALUE	USERS
Se puede fusionar la p1 con la p2, la p2 con la p3, pero no la p1 con la pr
*/

-- Esto no se puede
alter table rango merge partitions p1,p3 into partition p1_3;

-- Este si es permitido
alter table rango merge partitions p1,p2 into partition p1_2;

-- Ahora ya no esta la p1 y l P2,  sino una que tiene la fusion
-- toma el valor mayor

/*

P1_2	200	USERS
P3	500	USERS
P4	MAXVALUE	USERS

*/

-- Tambien se puede fusionar una hasta n.....
-- pero debe estar adyacente
alter table rango merge partitions p5 to p7 into partition p5_6_7;

-- Tablas particionadas por listas
-- son similares a las particiones por rangos
-- pero en este caso se definen listas de valores específicos
-- para cada partición.


create table LISTA
    (
        codigo number not null,
        pais varchar2(100),
        cliente varchar2(100)
    )
    partition by list (pais)
    (
        partition europa values ('ESPAÑA','FRANCIA','ALEMANIA'),
        partition latinoamerica values ('COLOMBIA','ARGENTINA','CHILE'),
        partition asia values ('MALASIA','CHINA','INDONESIA')  
    );
    


select *
from user_tab_partitions
where table_name = 'LISTA';

-- Insertar
insert into lista values (1,'FRANCIA', 'CLIENTE1' );
COMMIT;

insert into lista values (1,'COLOMBIA', 'CLIENTE1' );
COMMIT;

select * from lista partition (EUROPA);



-- Añadir particiones a la listas, clausula default

-- Esto no va a poder insertar, porque no esta en la lista
insert into lista values (2,'USA', 'CLIENTE1' );
commit;

alter table lista add partition AMERICA_NORTE VALUES ('USA','CANADA');

-- ahora si lo va a permitir
insert into lista values (2,'USA', 'CLIENTE1' );
commit;

select * from lista partition (AMERICA_NORTE);

-- Se puede crear una particion de tipo default, par que entren los demas
-- que no estan en la lista

alter table lista add partition OTROS VALUES (DEFAULT);

insert into lista values (2,'NIGERIA', 'CLIENTE1' );
commit;

select * from lista partition (OTROS);

-- Fusion de particiones a nivel de lista
-- A diferencia de las de rangos, no es obligacion de que esten adyacentes

select *
from user_tab_partitions
where table_name = 'LISTA';


alter table lista merge partitions LATINOAMERICA, AMERICA_NORTE into partition america;

select *
from user_tab_partitions
where table_name = 'LISTA';

-- Tablas particionadas por has
-- En este caso, las filas se distribuyen en particiones
-- basadas en un valor hash calculado a partir de una o más columnas.
-- Esto ayuda a distribuir uniformemente los datos
-- y es útil para tablas con grandes volúmenes de datos.


-- no se necesita particionar por un valor cocreto
-- no se identifica o coloca el value por el cual se va a paerticionar

-- Se coloca el numero de partiticiones, para que la base de datos distribuya uniformemente
create table tabla_hash
(
    codigo number not null,
    datos varchar2(100)
)
partition by hash(codigo)
partitions 3;


select *
from user_tab_partitions
where table_name = 'TABLA_HASH';


-- NO SE PUEDE HACER FUSIONES DE TABLAS HASH


-- Borrar particiones

-- Aca vemos cuales tables estan particionadas
select *
from user_part_tables;

-- Aca bemos el detalle de las particiones 
select *
from user_tab_partitions;

-- Ver una en particular
select *
from user_tab_partitions
where table_name = 'RANGO';


-- Borrar particion, ya no se  puede recuperar los datos
-- OJO, si borra los datos
alter table rango
drop partition p4;

select * from rango;

-- Particiones compuestas, rango-hash

-- Se combinan dos métodos de particionamiento
-- Primero se particiona por rangos
-- y luego cada partición de rango se subdivide en subparticiones
-- utilizando un hash.  

-- Ejemplo
-- Primero se particiona por trimestres del año
-- y luego cada trimestre se subdivide en 3 subparticiones
-- basadas en el código del cliente.    



create table rango_sub
(
    codigo number not null,
    datos varchar2(100),
    fecha date,
    cod_cliente number
)
partition by range (fecha)
    subpartition by hash(cod_cliente) subpartitions 3
(
    partition trimestre1 values less than (to_date('01-04-2023','dd-mm-yyyy')),
    partition trimestre2 values less than (to_date('01-07-2023','dd-mm-yyyy')),
    partition trimestre3 values less than (to_date('01-10-2023','dd-mm-yyyy')),
    partition trimestre4 values less than (to_date('01-01-2024','dd-mm-yyyy'))
);

-- particiones
select *
from user_tab_partitions
where table_name = 'RANGO_SUB';

-- Subparticiones
select *
from user_tab_subpartitions
where table_name = 'RANGO_SUB';


-- Particiones compuestas, rango-lista
-- Se combinan dos métodos de particionamiento
-- Primero se particiona por rangos
-- utilizando una lista de valores específicos.   


create table rango_lista
(
    codigo number not null,
    datos varchar2(100),
    fecha date,
    pais varchar2(50)
)
partition by range (fecha)
    subpartition by list(pais)
    (
        partition trimestre1 values less than (to_date('01-04-2023','dd-mm-yyyy'))
        (
            subpartition T1_P1 values ('ESPAÑA','FRANCIA','ALEMANIA'),
            subpartition T1_P2 values ('ARGENTINA','COLOMBIA','CHILE'),
            subpartition T1_P3 values ('USA','CANADA','MEXICO'),
            subpartition T1_P4 values (default)
        ),
        partition trimestre2 values less than (to_date('01-07-2023','dd-mm-yyyy'))  
        (
            subpartition T2_P1 values ('ESPAÑA','FRANCIA','ALEMANIA'),
            subpartition T2_P2 values ('ARGENTINA','COLOMBIA','CHILE'),
            subpartition T2_P3 values ('USA','CANADA','MEXICO'),
            subpartition T2_P4 values (default)
        ),
        partition trimestre3 values less than (to_date('01-10-2023','dd-mm-yyyy'))
        (
            subpartition T3_P1 values ('ESPAÑA','FRANCIA','ALEMANIA'),
            subpartition T3_P2 values ('ARGENTINA','COLOMBIA','CHILE'),
            subpartition T3_P3 values ('USA','CANADA','MEXICO'),
            subpartition T3_P4 values (default)
        ),
        partition trimestre4 values less than (to_date('01-01-2024','dd-mm-yyyy'))
        (
            subpartition T4_P1 values ('ESPAÑA','FRANCIA','ALEMANIA'),
            subpartition T4_P2 values ('ARGENTINA','COLOMBIA','CHILE'),
            subpartition T4_P3 values ('USA','CANADA','MEXICO   '),     
            subpartition T4_P4 values (default)
        )     
    );      
    
    
-- particiones
select *
from user_tab_partitions
where table_name = UPPER('rango_lista');

-- Subparticiones
select *
from user_tab_subpartitions
where table_name = UPPER('rango_lista');
    
    
-- inserts y update en subparticiones

select sysdate - 830 from dual;

insert into rango_lista values (1,'AAAA', sysdate - 830, 'USA');
insert into rango_lista values (2,'BBBB', sysdate - 830, 'COLOMBIA');
commit;

select * from rango_lista;
select * from rango_lista partition(trimestre4);
select * from rango_lista subpartition(T2_P2);
select * from rango_lista subpartition(T4_P3);
select * from rango_lista subpartition(T4_P2);


-- Indices particionados
-- Son índices que se crean sobre tablas particionadas
-- y se dividen en particiones que corresponden a las particiones
-- de la tabla subyacente.  


-- Hay dos tipos de índices particionados

-- Locales: Cada partición del índice corresponde a una partición de la tabla.  
--  La tabla esta particionada y cad particion tiene un indice
-- Se utilizan para tipo data warehouse o inteligencia de negocio

-- Globales: El índice se divide en particiones independientes  a la tabla
-- Tengo una tabla que no quiero particionar, pero siquiero particionar el indice
-- Se utilizan para aplicaciones de tipos transaccional (OLTP)
      


-- Tabla normal e índice particionado

drop table t1;

create table t1
(codigo number,
datos varchar2(50));

-- Ejemplo 1 Global
-- Global particionado
-- La tabla no esta particionada, pero el indice si
create index g1_t1 on t1 (codigo) global partition by hash(codigo) partitions 4;

select * from user_ind_partitions where index_name='G1_T1';


-- Ejemplo 2
-- Tabla particionada e índice normal
-- La tabla esta particionada, pero el indice no  


drop table t2;
create table t2
(codigo number,
datos varchar2(50))
PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
     
     create index t2_i1 on t2(datos);
     
--  Ejemplo     
-- Tabla particionada e índice global particionado
-- La tabla no esta particionada por datos si no por codigo, pero el indice si esta particionado por datos

drop table t3;
create table t3
(codigo number,
datos varchar2(50))
PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
        
     create index g1_t3 on t3 (datos) global partition by hash(datos) partitions 4;


     
-- indices particionados locales
-- La tabla esta particionada y cad particion tiene un indice
-- Se utilizan para tipo data warehouse o inteligencia de negocio 
-- Ejemplo 2

drop table t4;
create table t4
(codigo number,
datos varchar2(50))
PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
     create index t4_i1 on t4(codigo) local ;
     
     
     select * from user_ind_partitions where index_name='T4_I1';


-- Clausalas SQL orientadas a DataWareHouse y trabajos masivos

-- Vistas inline
-- INLINE VIEWS

-- Son vistas que se definen dentro de una consulta SQL
-- No se crean como objetos separados en la base de datos
-- Se utilizan para simplificar consultas complejas
-- o para mejorar la legibilidad del código SQL   


-- Esta es una vista normal
CREATE VIEW VISTA_EMPLE AS SELECT * FROM EMPLOYEES ORDER BY SALARY DESC;

SELECT * FROM VISTA_EMPLE WHERE SALARY > 5000;

-- esta es una vista inline, 
-- que se define dentro del select
-- A diferencia de la vista normal
-- que se crea como un objeto separado    
-- La vista inline solo existe durante la ejecución de la consulta

SELECT FIRST_NAME,SALARY 
   FROM (SELECT * FROM EMPLOYEES ORDER BY SALARY DESC)
WHERE SALARY > 5000;


-- Crear una nueva tabla a partir de otra
CREATE TABLE REGIONES1 AS SELECT * FROM REGIONS;

SELECT * FROM REGIONES1;


-- Crear vista de la nueva tabla
CREATE VIEW VIEW_REGIONES AS SELECT * FROM REGIONES1;

-- Se puede hacer insert en la vista, y esta afecta la original
INSERT INTO VIEW_REGIONES VALUES(5,'ANTARTICA');
commit;

-- Para vista inline, tambien se puede realizar insert  y update
-- Tambien afecta a la tabla original
INSERT INTO (SELECT * FROM REGIONES1) VALUES(6,'AUSTRALIA');

UPDATE (SELECT * FROM REGIONES1 WHERE REGION_ID> 3)  SET REGION_NAME=LOWER(REGION_NAME);


-- Hay 4 formas para insertar de forma masiva
-- Insert all => Sin condicion
-- Insert all condicional
-- Insert first =>  Primera condicion que se cumple
--  pivoting Insert => Insertar datos en tablas pivoteadas  


-- Insert all, insertar datos en multiples tablas al mismo tiempo, sin condicion


DROP TABLE NOM_EMPLES;
DROP TABLE SALARIOS;

CREATE TABLE NOM_EMPLES (COD_EMPLE NUMBER, FIRST_NAME VARCHAR2(100));

CREATE TABLE SALARIOS (COD_EMPLE NUMBER, SALARY NUMBER);

-- Insert all sin condicion
INSERT ALL
   INTO NOM_EMPLES VALUES (EMPLOYEE_ID,FIRST_NAME)
   INTO SALARIOS VALUES (EMPLOYEE_ID,SALARY)
SELECT * FROM EMPLOYEES;

SELECT * FROM NOM_EMPLES;
SELECT * FROM SALARIOS;


-- Insert all con valores fijos
INSERT ALL
   INTO NOM_EMPLES VALUES (1,'HOLA')
   INTO SALARIOS VALUES (1,100)
SELECT 1 FROM DUAL;

-- Insert all condicional

-- Insert First

-- Operador with

-- Operador Rollup

-- Operador Grouping

-- Grouping Set

-- Pivot

-- Unpivot













