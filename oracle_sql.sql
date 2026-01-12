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
