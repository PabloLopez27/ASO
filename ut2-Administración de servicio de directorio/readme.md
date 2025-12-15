# Resumen de actividades – UT2 ASO

Este proyecto recoge el trabajo realizado en la **Unidad 2 de Administración de Sistemas Operativos (ASO)**, donde se ha configurado un entorno de red con dominio Windows, firewall pfSense y administración de usuarios y grupos.

---

## 📌 Actividad 1: Creación de un dominio Windows

En esta actividad se realizó la configuración inicial de un **controlador de dominio** y la unión de equipos clientes.

- Configuración de todas las máquinas en una **LAN segmentada** para permitir la comunicación.
- Asignación de **dirección IP estática** al servidor.
- Cambio del **nombre del equipo servidor**.
- Creación del **dominio Windows**.
- Configuración del **SID** del dominio.
- Configuración de los equipos clientes:
  - Dirección IP dentro del rango del dominio.
  - DNS apuntando a la IP del servidor.
  - Unión al dominio desde las propiedades del sistema.
- Detección y análisis de errores durante la unión de los clientes.
- Revisión del **script generado automáticamente** al crear el dominio.

---

## 📌 Actividad 2: Configuración de pfSense y red

En esta actividad se integró **pfSense** como firewall y gestor de red.

- Creación del escenario de red con:
  - Servidor Windows
  - pfSense
  - Cliente Windows 11
- Modificación de la **configuración por defecto** de pfSense.
- Configuración de:
  - Interfaces **WAN** y **LAN**.
  - Rango de direcciones IP.
  - Servicio **DHCP**.
  - Nombre de dominio.
  - Servidores **DNS**.
- Cambio de la **contraseña del usuario administrador**.
- Activación de **reenviadores DNS** apuntando a pfSense.
- Pruebas de conectividad entre:
  - Servidor de dominio y pfSense.
  - Cliente y servidor.
- Detección de problemas en la unión del cliente al dominio.

---

## 📌 Actividad 4: Administración de Active Directory

En esta actividad se trabajó con la **gestión de usuarios, grupos y unidades organizativas**.

- Creación de **Unidades Organizativas (OU)**.
- Creación de usuarios dentro de las OU:
  - Configuración para que cambien la contraseña en el primer inicio de sesión.
- Creación de un **usuario delegado**.
- Creación de un **grupo de usuarios**.
- Asignación de los usuarios al grupo correspondiente.

---

## ✅ Conclusión

Con estas actividades se ha configurado un entorno completo de red con:
- Dominio Windows funcional.
- Firewall y servicios de red mediante pfSense.
- Administración centralizada de usuarios y grupos con Active Directory.

Este trabajo permite comprender el funcionamiento básico de un entorno real de administración de sistemas.
