Sí, Gabriel. **Sí puedes conectarte desde tu Mac con SQL Developer** a una base de datos que está en **una VM de Oracle Linux sobre VirtualBox en Windows**.
Es **totalmente normal en entornos profesionales**. Te explico **qué debe cumplirse y cómo configurarlo**, paso a paso.

![Image](https://techbeatly.com/images/tb-uploads/2019/07/VirtualBox-network-modes-how-the-NAT-mode-works.png)

![Image](https://docs.oracle.com/cd/A97385_01/network.920/a96580/net81128.gif)

![Image](https://i.sstatic.net/m5HOT.jpg)

---

## 🧠 ESCENARIO QUE TIENES (CORRECTO)

* **Host:** Windows
* **VM:** Oracle Linux en VirtualBox
* **DB:** Oracle Database dentro de la VM
* **Cliente:** Mac con Oracle SQL Developer

👉 **Funciona sin problema**, pero **la red es la clave**.

---

## ✅ CONDICIONES OBLIGATORIAS (LAS 4 CLAVES)

### 1️⃣ **La VM debe tener IP accesible**

Desde la **VM (Oracle Linux)**:

```bash
ip addr
```

Ejemplo:

```text
inet 192.168.1.120
```

Esa IP debe ser **visible desde tu Mac**.

---

### 2️⃣ **Tipo de red en VirtualBox (MUY IMPORTANTE)**

#### ✅ Opción recomendada: **Bridged Adapter**

En VirtualBox → *Settings → Network*:

* Adapter 1: **Bridged Adapter**
* Interface: tu tarjeta real (Wi-Fi o Ethernet)

📌 Resultado:

* La VM queda **en la misma red** que tu Mac
* Es la forma **más simple y profesional**

⚠️ **NAT solo NO sirve** para conectarte desde fuera.

---

### 3️⃣ **Oracle debe estar escuchando (LISTENER)**

En la VM:

```bash
lsnrctl status
```

Debes ver:

```text
Listening on port 1521
```

Si no:

```bash
lsnrctl start
```

---

### 4️⃣ **Firewall de Oracle Linux**

Permite el puerto 1521:

```bash
sudo firewall-cmd --add-port=1521/tcp --permanent
sudo firewall-cmd --reload
```

📌 Esto es **indispensable**.

---

## 🔌 CONFIGURAR SQL DEVELOPER EN TU MAC

En **New Connection**:

| Campo        | Valor                               |
| ------------ | ----------------------------------- |
| Username     | usuario_oracle                      |
| Password     | ******                              |
| Hostname     | **IP de la VM** (ej. 192.168.1.120) |
| Port         | 1521                                |
| Service Name | ORCLPDB1 (ejemplo)                  |

👉 Dale **Test** → debe decir **Success**.

---

## 🧪 PRUEBA RÁPIDA (ANTES DE SQL DEVELOPER)

Desde tu **Mac**:

```bash
ping 192.168.1.120
```

Si responde → la red está bien.
Si no → problema de red (no de Oracle).

---

## ⚠️ PROBLEMAS TÍPICOS Y SOLUCIÓN

| Problema   | Causa                   | Solución             |
| ---------- | ----------------------- | -------------------- |
| No conecta | NAT                     | Usa Bridged          |
| Timeout    | Firewall                | Abrir 1521           |
| ORA-12541  | Listener apagado        | `lsnrctl start`      |
| ORA-12514  | Service name incorrecto | Ver `lsnrctl status` |

---

## 🧠 NOTA DE ARQUITECTO / DBA

Esto que estás haciendo es **exactamente**:

* cómo se trabaja en empresas
* cómo se accede a servidores Oracle
* cómo se desarrolla desde Mac a Linux

👉 **Estás trabajando como entorno real**, no de laboratorio.

---

## 🎯 CONCLUSIÓN CLARA

✔️ Sí, puedes conectarte
✔️ Es totalmente soportado
✔️ No importa que el host sea Windows
✔️ No importa que la VM sea Oracle Linux
✔️ SQL Developer en Mac funciona perfecto

---

Si quieres, dime:

* ¿Tu red está en **NAT o Bridged** ahora?
* ¿Qué error exacto te sale (si alguno)?

Y lo dejamos **conectando en minutos**, como en producción 💪



Perfecto, Gabriel. Vamos **paso a paso, como DBA**, para instalar **Oracle Database** dentro de tu **máquina virtual con Oracle Linux** en **VirtualBox**, y dejarla **lista para conectarte desde tu Mac con SQL Developer**.

Voy a explicarlo **claro, sin saltos y sin suposiciones**.

![Image](https://media.geeksforgeeks.org/wp-content/uploads/20230211114343/Untitled-drawing_page-0001-%281%29-%281%29.jpg)

![Image](https://linuxiac.com/wp-content/uploads/2024/05/centos7-to-oracle8_12.jpg)

![Image](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/images/virtualbox-main-empty.png)

![Image](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/images/virtualbox-main.png)

---

## 🧠 ESCENARIO OBJETIVO (EL CORRECTO)

* **Host:** Windows
* **Virtualización:** VirtualBox
* **SO VM:** Oracle Linux (7 u 8)
* **Base de datos:** Oracle Database
* **Cliente:** Mac con SQL Developer

👉 Este es **exactamente** el stack que se usa en empresas.

---

# 🔴 DECISIÓN IMPORTANTE (ANTES DE INSTALAR)

### 👉 ¿QUÉ ORACLE INSTALAR?

Te recomiendo **Oracle Database XE 21c** si:

* Estás aprendiendo
* Quieres algo liviano
* No quieres lidiar con licencias
* Vas a desarrollar PL/SQL y SQL

✔ Gratis
✔ Completo para aprendizaje
✔ Soportado
✔ Ideal para SQL Developer

---

# 🟢 OPCIÓN RECOMENDADA: ORACLE DATABASE XE 21c

## 1️⃣ REQUISITOS MÍNIMOS DE LA VM

En VirtualBox:

* **RAM:** mínimo 4 GB (ideal 6–8 GB)
* **CPU:** 2 cores
* **Disco:** 40 GB
* **Red:** **Bridged Adapter** (muy importante)

---

## 2️⃣ PREPARAR ORACLE LINUX (EN LA VM)

Entra como `root` o usa `sudo`.

### 🔹 Actualizar sistema

```bash
sudo dnf update -y
```

### 🔹 Instalar paquetes necesarios

```bash
sudo dnf install -y oracle-database-preinstall-21c
```

📌 Este paquete:

* Crea usuarios
* Configura kernel
* Ajusta límites
* Evita el 90% de errores

👉 **Esto es buena práctica DBA**.

---

## 3️⃣ DESCARGAR ORACLE DATABASE XE 21c

Desde la VM (o copiar el archivo):

```bash
wget https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm
```

(Si falla, descárgalo desde la web de Oracle y cópialo a la VM).

---

## 4️⃣ INSTALAR ORACLE XE

```bash
sudo dnf install -y oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm
```

---

## 5️⃣ CONFIGURAR LA BASE DE DATOS

```bash
sudo /etc/init.d/oracle-xe-21c configure
```

Te pedirá:

* Password para SYS / SYSTEM
* Puerto (1521 → deja ese)
* Listener → YES

📌 **Guarda esa contraseña**.

---

## 6️⃣ VERIFICAR QUE ORACLE ESTÁ ARRIBA

```bash
ps -ef | grep pmon
```

Debes ver:

```text
ora_pmon_XE
```

Listener:

```bash
lsnrctl status
```

---

## 7️⃣ ABRIR PUERTO EN FIREWALL (CLAVE)

```bash
sudo firewall-cmd --add-port=1521/tcp --permanent
sudo firewall-cmd --reload
```

---

## 8️⃣ DATOS DE CONEXIÓN (ANÓTALOS)

| Dato         | Valor                      |
| ------------ | -------------------------- |
| Host         | IP de la VM                |
| Puerto       | 1521                       |
| Service Name | `XEPDB1`                   |
| Usuario      | `system` o `sys as sysdba` |

Obtén la IP:

```bash
ip addr
```

---

## 9️⃣ CONECTARTE DESDE TU MAC (SQL DEVELOPER)

En **New Connection**:

* Host: `IP_DE_LA_VM`
* Port: `1521`
* Service Name: `XEPDB1`
* User: `system`
* Password: (la que pusiste)

👉 **Test → Success** 🎉

---

## ⚠️ ERRORES COMUNES (Y SOLUCIÓN)

| Error     | Causa                   |
| --------- | ----------------------- |
| ORA-12541 | Listener apagado        |
| ORA-12514 | Service name incorrecto |
| Timeout   | Firewall / NAT          |
| No ping   | Red mal configurada     |

---

## 🧠 NOTA DE DBA SENIOR (IMPORTANTE)

> En producción **NUNCA** se instala Oracle “a mano”.
> Siempre se usa `oracle-database-preinstall`.

Tú ya estás aprendiendo **como se hace bien**.

---

## 🎯 CONCLUSIÓN

✔ Oracle Linux es el SO correcto
✔ Oracle XE es la versión correcta
✔ VirtualBox sirve perfectamente
✔ SQL Developer en Mac se conecta sin problema
✔ Estás montando **un entorno real de empresa**

---

## 🔜 SIGUIENTE PASO (TE PROPONGO)

Cuando termines dime:

* ✅ *Oracle ya está instalado*
* ❌ *Me falló en el paso X*

Luego seguimos con:
👉 creación de usuarios
👉 tablespaces
👉 esquema de prácticas
👉 PL/SQL real

Y lo llevamos **a nivel profesional completo** 💪
