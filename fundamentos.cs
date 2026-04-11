using System;

class ProgramaCompleto
{
    static void Main()
    {
        // =====================================================
        // 🔢 TIPOS DE DATOS
        // =====================================================

        // 🔴 ENTEROS CON SIGNO (permiten negativos)
        sbyte numeroSByte = -100;     // (-128 a 127)
        short numeroShort = -32000;   // Entero corto
        int numeroInt = -100000;      // Más usado
        long numeroLong = -10000000000; // Entero grande

        // 🔵 ENTEROS SIN SIGNO (solo positivos)
        byte numeroByte = 200;        // (0 a 255)
        ushort numeroUShort = 65000;  // Entero corto positivo
        uint numeroUInt = 4000000000; // Entero grande positivo
        ulong numeroULong = 10000000000; // Muy grande positivo

        // 🟡 DECIMALES
        float numeroFloat = 1.75f;    // Precisión simple
        double numeroDouble = 3.1416; // Más preciso
        decimal numeroDecimal = 99.99m; // Dinero (alta precisión)

        // 🔤 TEXTO
        char letra = 'G';             // Un carácter
        string texto = "Hola mundo";  // Cadena de texto

        // 🔘 BOOLEANO
        bool esActivo = true;         // true o false

        // 📅 FECHA
        DateTime fecha = DateTime.Now; // Fecha actual

        // 📦 GENÉRICO
        object cualquierCosa = 123;   // Puede ser cualquier tipo

        // ❓ NULLABLE
        int? numeroOpcional = null;   // Puede ser null

        // =====================================================
        // 🧾 MOSTRAR TIPOS DE DATOS
        // =====================================================
        Console.WriteLine("===== TIPOS DE DATOS =====");
        Console.WriteLine("int: " + numeroInt);
        Console.WriteLine("double: " + numeroDouble);
        Console.WriteLine("string: " + texto);
        Console.WriteLine("bool: " + esActivo);
        Console.WriteLine("Fecha: " + fecha);



using System;

class EstructurasDeControl
{
    static void Main()
    {
        // =====================================================
        // 🔀 CONDICIONALES (DECISIONES)
        // =====================================================

        int numero = 10;

        // 🔹 IF → ejecuta si la condición es verdadera
        if (numero > 5)
        {
            Console.WriteLine("El número es mayor que 5");
        }

        // 🔹 IF - ELSE → dos caminos posibles
        if (numero % 2 == 0)
        {
            Console.WriteLine("Es par");
        }
        else
        {
            Console.WriteLine("Es impar");
        }

        // 🔹 ELSE IF → múltiples condiciones
        int nota = 85;

        if (nota >= 90)
        {
            Console.WriteLine("Excelente");
        }
        else if (nota >= 70)
        {
            Console.WriteLine("Aprobado");
        }
        else
        {
            Console.WriteLine("Reprobado");
        }

        // 🔹 SWITCH → múltiples opciones más ordenadas
        int opcion = 2;

        switch (opcion)
        {
            case 1:
                Console.WriteLine("Opción 1: Atacar");
                break;

            case 2:
                Console.WriteLine("Opción 2: Defender");
                break;

            default:
                Console.WriteLine("Opción inválida");
                break;
        }

        // =====================================================
        // 🔁 BUCLES (REPETICIÓN)
        // =====================================================

        // 🔹 WHILE → se ejecuta mientras la condición sea verdadera
        int contadorWhile = 0;

        while (contadorWhile < 3)
        {
            Console.WriteLine("While: " + contadorWhile);
            contadorWhile++;
        }

        // 🔹 DO WHILE → se ejecuta al menos una vez
        int contadorDo = 0;

        do
        {
            Console.WriteLine("Do While: " + contadorDo);
            contadorDo++;
        } while (contadorDo < 3);

        // 🔹 FOR → se usa cuando sabes cuántas veces repetir
        for (int i = 0; i < 3; i++)
        {
            Console.WriteLine("For: " + i);
        }

        // 🔹 FOREACH → recorre colecciones (arrays, listas)
        string[] nombres = { "Ana", "Luis", "Carlos" };

        foreach (string nombre in nombres)
        {
            Console.WriteLine("Nombre: " + nombre);
        }

        // =====================================================
        // 🛑 CONTROL DE FLUJO
        // =====================================================

        // 🔹 BREAK → termina el ciclo completamente
        for (int i = 0; i < 5; i++)
        {
            if (i == 3)
                break; // sale del ciclo

            Console.WriteLine("Break: " + i);
        }

        // 🔹 CONTINUE → salta la iteración actual
        for (int i = 0; i < 5; i++)
        {
            if (i == 2)
                continue; // salta el 2

            Console.WriteLine("Continue: " + i);
        }

        // 🔹 RETURN → termina el método
        Console.WriteLine("Antes del return");
        return;
        // Console.WriteLine("Esto nunca se ejecuta");

        // =====================================================
        // 🔹 GOTO (NO RECOMENDADO)
        // =====================================================
        // Permite saltar a otra parte del código (malas prácticas)
        /*
        inicio:
        Console.WriteLine("Usando goto");
        goto fin;

        fin:
        Console.WriteLine("Fin");
        */
    }
}

// =====================================================
// 📦 ESTRUCTURAS DE DATOS
// =====================================================

// 🧠 ¿Qué es una estructura de datos?
// Es una forma de guardar varios datos juntos

// 🔹 ARRAY (lista fija)
int[] numeros = { 1, 2, 3, 4 };
// Guarda varios números en una sola variable

Console.WriteLine("Array posición 0: " + numeros[0]);

// 🔹 LIST (lista dinámica)
using System.Collections.Generic;

List<string> nombres = new List<string>();

nombres.Add("Gabriel");
nombres.Add("Luis");

// Puede crecer dinámicamente
Console.WriteLine("Nombre en lista: " + nombres[1]);

// 🔹 DICCIONARIO (clave - valor)
Dictionary<string, int> edades = new Dictionary<string, int>();

edades["Gabriel"] = 25;
edades["Luis"] = 30;

// Acceso por clave
Console.WriteLine("Edad Gabriel: " + edades["Gabriel"]);



// =====================================================
// 🧱 PROGRAMACIÓN ORIENTADA A OBJETOS (POO)
// =====================================================

// 🔹 CLASE → molde
class Jugador
{
    // 📦 Propiedades (datos del jugador)
    public string nombre;
    public int vida;

    // 🎯 Método (acción)
    public void Atacar()
    {
        Console.WriteLine(nombre + " está atacando!");
    }
}

// =====================================================
// 🚀 USO DE LA CLASE
// =====================================================

// Crear objeto (instancia)
Jugador jugador1 = new Jugador();

// Asignar valores
jugador1.nombre = "Gabriel";
jugador1.vida = 100;

// Usar método
jugador1.Atacar();

// Mostrar datos
Console.WriteLine("Jugador: " + jugador1.nombre);
Console.WriteLine("Vida: " + jugador1.vida);



        // =====================================================
        // 🎮 JUEGO → ESTRUCTURAS DE CONTROL
        // =====================================================

        int vidaJugador = 100;
        int vidaEnemigo = 100;

        Console.WriteLine("\n🔥 Comienza la batalla 🔥");

        // 🔁 WHILE → se repite mientras la condición sea verdadera
        while (vidaJugador > 0 && vidaEnemigo > 0)
        {
            Console.WriteLine("\nTu vida: " + vidaJugador);
            Console.WriteLine("Vida enemigo: " + vidaEnemigo);

            Console.WriteLine("1. Atacar");
            Console.WriteLine("2. Defender");

            string opcion = Console.ReadLine();

            // 🔀 IF → toma decisiones
            if (opcion == "1")
            {
                vidaEnemigo -= 20;
                Console.WriteLine("Atacaste al enemigo!");
            }
            else if (opcion == "2")
            {
                vidaJugador += 10;
                Console.WriteLine("Te defendiste!");
            }
            else
            {
                Console.WriteLine("Opción inválida");
                continue; // ⏭ CONTINUE → salta esta iteración
            }

            // Turno enemigo
            vidaJugador -= 15;
            Console.WriteLine("El enemigo te atacó!");

            // 🛑 BREAK → termina el ciclo si el enemigo muere
            if (vidaEnemigo <= 0)
            {
                Console.WriteLine("Enemigo derrotado!");
                break;
            }
        }

        // 🔀 IF final → resultado del juego
        if (vidaJugador > 0)
            Console.WriteLine("🎉 Ganaste!");
        else
            Console.WriteLine("💀 Perdiste!");

        Console.ReadKey();
    }
}