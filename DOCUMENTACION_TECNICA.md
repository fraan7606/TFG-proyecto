# Documentación Técnica - RosTectic

**Sistema de Gestión de Citas para Salón de Estética**

---

## Características

- Multiplataforma: Web, Android e iOS con Flutter
- Autenticación dual: Login con email o teléfono
- Notificaciones inteligentes: Email o SMS según método de registro
- Gestión de citas: Calendario interactivo para reservas
- Sistema de reseñas: Valoraciones y comentarios de servicios
- Gestión de inventario: Control de productos y stock para administradores
- Panel de administración: Estadísticas, gestión de citas y visualización de stock

**Nota importante**: El sistema NO incluye pagos online. El pago de los servicios se realiza presencialmente en el salón.

---

## Índice

1. [Casos de Uso](#1-casos-de-uso)
2. [Requisitos del Sistema](#2-requisitos-del-sistema)
3. [Modelo Entidad-Relación](#3-modelo-entidad-relación)
4. [Normalización de Base de Datos](#4-normalización-de-base-de-datos)
5. [Diagrama de Gantt](#5-diagrama-de-gantt)
6. [Análisis DAFO](#6-análisis-dafo)

---

## 1. Casos de Uso

### 1.1. Diagrama General de Casos de Uso

```
                    ┌─────────────────────────────────────┐
                    │      Sistema RosTectic              │
                    │                                     │
    ┌──────────┐    │  ┌──────────────────────────────┐  │
    │          │<───┼──┤ Registrarse con Email        │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Registrarse con Teléfono     │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Iniciar Sesión               │  │
    │          │    │  └──────────────────────────────┘  │
    │ Cliente  │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Ver Servicios Disponibles    │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Reservar Cita                │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Ver Historial de Citas       │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Cancelar/Reprogramar Cita    │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │◄───┼──┤ Dejar Reseña                 │  │
    └──────────┘    │  └──────────────────────────────┘  │
                    │                                     │
    ┌──────────┐    │  ┌──────────────────────────────┐  │
    │          │<───┼──┤ Gestionar Servicios          │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │<───┼──┤ Gestionar Citas              │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │ Admin    │<───┼──┤ Gestionar Especialistas      │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │<───┼──┤ Gestionar Inventario         │  │
    │          │    │  └──────────────────────────────┘  │
    │          │    │  ┌──────────────────────────────┐  │
    │          │<───┼──┤ Ver Estadísticas             │  │
    └──────────┘    │  └──────────────────────────────┘  │
                    │                                     │
                    └─────────────────────────────────────┘
```

### 1.2. Descripción Detallada de Casos de Uso

#### CU-01: Registro de Usuario con Email

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-01 |
| **Nombre** | Registro de Usuario con Email |
| **Actor** | Cliente |
| **Precondiciones** | - El usuario no está registrado<br>- El email no está en uso |
| **Flujo Principal** | 1. El usuario accede a la pantalla de registro<br>2. Selecciona "Registro con Email"<br>3. Ingresa nombre, email y contraseña<br>4. El sistema valida los datos<br>5. El sistema crea la cuenta<br>6. El sistema envía email de confirmación<br>7. El usuario es redirigido a la pantalla principal |
| **Flujo Alternativo** | 4a. Email ya registrado<br>- El sistema muestra error<br>- Volver al paso 3<br><br>4b. Formato de email inválido<br>- El sistema muestra error<br>- Volver al paso 3 |
| **Postcondiciones** | - Usuario registrado en el sistema<br>- Email de bienvenida enviado |

#### CU-02: Registro de Usuario con Teléfono

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-02 |
| **Nombre** | Registro de Usuario con Teléfono |
| **Actor** | Cliente |
| **Precondiciones** | - El usuario no está registrado<br>- El teléfono no está en uso |
| **Flujo Principal** | 1. El usuario accede a la pantalla de registro<br>2. Selecciona "Registro con Teléfono"<br>3. Ingresa nombre, teléfono y contraseña<br>4. El sistema valida los datos<br>5. El sistema envía código SMS de verificación<br>6. El usuario ingresa el código<br>7. El sistema verifica y crea la cuenta<br>8. El usuario es redirigido a la pantalla principal |
| **Flujo Alternativo** | 4a. Teléfono ya registrado<br>- El sistema muestra error<br>- Volver al paso 3<br><br>6a. Código incorrecto<br>- Permitir 3 intentos<br>- Si falla, solicitar nuevo código |
| **Postcondiciones** | - Usuario registrado en el sistema<br>- SMS de bienvenida enviado |

#### CU-03: Iniciar Sesión

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-03 |
| **Nombre** | Iniciar Sesión |
| **Actor** | Cliente, Admin |
| **Precondiciones** | - El usuario está registrado |
| **Flujo Principal** | 1. El usuario accede a la pantalla de login<br>2. Selecciona método (Email o Teléfono)<br>3. Ingresa credenciales y contraseña<br>4. El sistema valida las credenciales<br>5. El sistema genera token JWT<br>6. El usuario accede al sistema según su rol |
| **Flujo Alternativo** | 4a. Credenciales incorrectas<br>- El sistema muestra error<br>- Permitir 5 intentos<br>- Si falla, bloquear temporalmente |
| **Postcondiciones** | - Sesión iniciada<br>- Token JWT generado y almacenado |

#### CU-04: Reservar Cita

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-04 |
| **Nombre** | Reservar Cita |
| **Actor** | Cliente |
| **Precondiciones** | - Usuario autenticado<br>- Existen servicios disponibles |
| **Flujo Principal** | 1. El usuario accede al calendario de citas<br>2. Selecciona un servicio<br>3. Selecciona fecha y hora disponible<br>4. Opcionalmente selecciona un especialista<br>5. Agrega notas si es necesario<br>6. Confirma la reserva<br>7. El sistema crea la cita con estado PENDING<br>8. El sistema envía confirmación por email/SMS |
| **Flujo Alternativo** | 3a. Horario no disponible<br>- Mostrar horarios alternativos<br>- Volver al paso 3<br><br>7a. Error al crear cita<br>- Mostrar mensaje de error<br>- Volver al paso 1 |
| **Postcondiciones** | - Cita creada en estado PENDING<br>- Notificación enviada al usuario |

#### CU-05: Ver Historial de Citas

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-05 |
| **Nombre** | Ver Historial de Citas |
| **Actor** | Cliente |
| **Precondiciones** | - Usuario autenticado |
| **Flujo Principal** | 1. El usuario accede a "Mis Citas"<br>2. El sistema muestra lista de citas (pasadas y futuras)<br>3. El usuario puede filtrar por estado<br>4. El usuario puede ver detalles de una cita |
| **Postcondiciones** | - Historial mostrado |

#### CU-06: Cancelar/Reprogramar Cita

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-06 |
| **Nombre** | Cancelar o Reprogramar Cita |
| **Actor** | Cliente |
| **Precondiciones** | - Usuario autenticado<br>- Cita existe y no está completada/cancelada<br>- Faltan al menos 24h para la cita |
| **Flujo Principal** | 1. El usuario accede a sus citas<br>2. Selecciona una cita pendiente<br>3. Elige "Cancelar" o "Reprogramar"<br>4. Si cancela: confirma la cancelación<br>5. Si reprograma: selecciona nueva fecha/hora<br>6. El sistema actualiza el estado<br>7. El sistema envía notificación |
| **Flujo Alternativo** | 3a. Cita en menos de 24h<br>- Mostrar advertencia<br>- Requiere confirmación adicional |
| **Postcondiciones** | - Cita actualizada (CANCELLED o RESCHEDULED)<br>- Notificación enviada |

#### CU-07: Dejar Reseña

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-07 |
| **Nombre** | Dejar Reseña |
| **Actor** | Cliente |
| **Precondiciones** | - Usuario autenticado<br>- Cita completada<br>- No ha dejado reseña previamente |
| **Flujo Principal** | 1. El usuario accede a una cita completada<br>2. Selecciona "Dejar Reseña"<br>3. Ingresa calificación (1-5 estrellas)<br>4. Opcionalmente agrega comentario<br>5. Confirma la reseña<br>6. El sistema guarda la reseña |
| **Postcondiciones** | - Reseña guardada<br>- Calificación del servicio actualizada |

#### CU-08: Gestionar Servicios (Admin)

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-08 |
| **Nombre** | Gestionar Servicios |
| **Actor** | Admin |
| **Precondiciones** | - Usuario autenticado como ADMIN |
| **Flujo Principal** | 1. El admin accede al panel de servicios<br>2. Puede crear nuevo servicio<br>3. Puede editar servicio existente<br>4. Puede activar/desactivar servicio<br>5. Puede ver lista de servicios y sus estadísticas |
| **Postcondiciones** | - Servicios actualizados |

#### CU-09: Gestionar Inventario (Admin)

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-09 |
| **Nombre** | Gestionar Inventario |
| **Actor** | Admin |
| **Precondiciones** | - Usuario autenticado como ADMIN |
| **Flujo Principal** | 1. El admin accede al módulo de inventario<br>2. Puede visualizar lista completa de productos<br>3. Puede agregar nuevos productos con nombre, descripción, cantidad y precio<br>4. Puede editar información de productos existentes<br>5. Puede ajustar cantidades de stock<br>6. Puede ver alertas de productos con stock bajo<br>7. Puede asociar productos a servicios (productos utilizados en cada servicio)<br>8. Puede eliminar productos obsoletos |
| **Postcondiciones** | - Inventario actualizado<br>- Stock ajustado |

#### CU-10: Ver Estadísticas (Admin)

| Campo | Descripción |
|-------|-------------|
| **ID** | CU-10 |
| **Nombre** | Ver Estadísticas |
| **Actor** | Admin |
| **Precondiciones** | - Usuario autenticado como ADMIN |
| **Flujo Principal** | 1. El admin accede al dashboard<br>2. Ve gráficos de citas por mes<br>3. Ve ingresos totales<br>4. Ve servicios más populares<br>5. Ve reseñas promedio<br>6. Ve estado del inventario |
| **Postcondiciones** | - Estadísticas visualizadas |

---

## 2. Requisitos del Sistema

### 2.1. Requisitos Funcionales

| ID | Requisito | Prioridad | Descripción |
|----|-----------|-----------|-------------|
| **RF-01** | Autenticación dual | Alta | El sistema debe permitir registro e inicio de sesión con email o teléfono |
| **RF-02** | Gestión de usuarios | Alta | El sistema debe diferenciar entre roles CLIENT y ADMIN |
| **RF-03** | Catálogo de servicios | Alta | El sistema debe mostrar servicios con nombre, descripción, duración y precio |
| **RF-04** | Reserva de citas | Alta | Los clientes deben poder reservar citas seleccionando servicio, fecha, hora y opcionalmente especialista |
| **RF-05** | Calendario interactivo | Alta | El sistema debe mostrar disponibilidad en tiempo real |
| **RF-06** | Gestión de citas | Alta | Los usuarios deben poder ver, cancelar y reprogramar sus citas |
| **RF-07** | Estados de citas | Alta | Las citas deben tener estados: PENDING, CONFIRMED, COMPLETED, CANCELLED, RESCHEDULED |
| **RF-08** | Sistema de reseñas | Media | Los usuarios deben poder calificar servicios después de completar una cita |
| **RF-09** | Notificaciones email | Media | El sistema debe enviar emails para confirmaciones y recordatorios |
| **RF-10** | Notificaciones SMS | Media | El sistema debe enviar SMS a usuarios registrados con teléfono |
| **RF-11** | Panel de administración | Alta | Los administradores deben tener acceso a todas las funcionalidades de gestión |
| **RF-12** | Gestión de especialistas | Media | El sistema debe permitir asignar especialistas a citas |
| **RF-13** | Gestión de inventario | Alta | Los administradores deben poder visualizar y controlar productos, stock y su asociación con servicios |
| **RF-14** | Alertas de stock | Media | El sistema debe alertar a los administradores cuando el stock esté bajo el mínimo configurado |
| **RF-15** | Historial de citas | Alta | Los usuarios deben poder ver su historial completo de citas |
| **RF-16** | Búsqueda y filtrado | Media | El sistema debe permitir buscar y filtrar servicios y citas |
| **RF-17** | Multi-plataforma | Alta | La aplicación debe funcionar en Web, Android e iOS |
| **RF-18** | Tokens JWT | Alta | El sistema debe usar JWT para mantener sesiones seguras |
| **RF-19** | Validación de datos | Alta | Todos los formularios deben validar datos antes de enviar al servidor |
| **RF-20** | Reportes y estadísticas | Media | El admin debe poder ver estadísticas de citas, ingresos y servicios populares |

### 2.2. Requisitos No Funcionales

| ID | Categoría | Requisito | Descripción |
|----|-----------|-----------|-------------|
| **RNF-01** | Rendimiento | Tiempo de respuesta | Las operaciones del sistema deben responder en menos de 2 segundos en el 95% de los casos |
| **RNF-02** | Rendimiento | Carga concurrente | El sistema debe soportar al menos 100 usuarios concurrentes sin degradación |
| **RNF-03** | Seguridad | Encriptación de contraseñas | Las contraseñas deben almacenarse usando bcrypt con factor de coste 10+ |
| **RNF-04** | Seguridad | Tokens seguros | Los tokens JWT deben tener expiración y usar claves seguras de 256 bits |
| **RNF-05** | Seguridad | HTTPS | Todas las comunicaciones deben usar conexiones seguras (HTTPS) |
| **RNF-06** | Seguridad | Protección CSRF/XSS | El sistema debe implementar protección contra ataques comunes |
| **RNF-07** | Usabilidad | Interfaz intuitiva | La aplicación debe ser usable sin entrenamiento previo |
| **RNF-08** | Usabilidad | Responsive design | La interfaz debe adaptarse a diferentes tamaños de pantalla |
| **RNF-09** | Usabilidad | Accesibilidad | La aplicación debe cumplir con estándares WCAG 2.1 nivel AA |
| **RNF-10** | Disponibilidad | Uptime | El sistema debe tener una disponibilidad del 99% |
| **RNF-11** | Disponibilidad | Backup | Se deben realizar backups diarios de la base de datos |
| **RNF-12** | Escalabilidad | Arquitectura modular | El código debe estar organizado en capas (controlador, servicio, modelo) |
| **RNF-13** | Escalabilidad | Base de datos | La base de datos debe estar normalizada y optimizada para crecimiento |
| **RNF-14** | Mantenibilidad | Código limpio | El código debe seguir principios SOLID y DRY |
| **RNF-15** | Mantenibilidad | Documentación | Todo el código debe estar documentado y comentado |
| **RNF-16** | Compatibilidad | Navegadores | Soporte para Chrome, Firefox, Safari, Edge (últimas 2 versiones) |
| **RNF-17** | Compatibilidad | Dispositivos móviles | Android 8.0+ e iOS 12.0+ |
| **RNF-18** | Portabilidad | Multiplataforma | El frontend debe funcionar en web y móviles con mismo código base |
| **RNF-19** | Fiabilidad | Gestión de errores | Todos los errores deben ser capturados y registrados (logging) |
| **RNF-20** | Fiabilidad | Validación cliente-servidor | La validación debe realizarse tanto en frontend como backend |

### 2.3. Restricciones

| ID | Restricción | Descripción |
|----|-------------|-------------|
| **RC-01** | Tecnología Backend | Uso obligatorio de Node.js + Express + PostgreSQL |
| **RC-02** | Tecnología Frontend | Uso obligatorio de Flutter/Dart |
| **RC-03** | ORM | Uso de Prisma para gestión de base de datos |
| **RC-04** | Servicios externos | Dependencia de SendGrid (email) y Twilio (SMS) |
| **RC-05** | Presupuesto | Proyecto académico sin presupuesto comercial |

---

## 3. Modelo Entidad-Relación

### 3.1. Diagrama ER

```
┌─────────────────────┐
│       USER          │
├─────────────────────┤
│ PK id (UUID)        │
│    name             │
│    email (unique)   │
│    phone (unique)   │
│    password_hash    │
│    auth_method      │◄──────────┐
│    role             │           │
│    created_at       │           │
│    updated_at       │           │ 1:N
└─────────────────────┘           │
         │ 1                      │
         │                        │
         │ 1:N                    │
         │                        │
         ▼                        │
┌─────────────────────┐           │
│    APPOINTMENT      │           │
├─────────────────────┤           │
│ PK id (UUID)        │           │
│ FK user_id          │───────────┘
│ FK service_id       │───────────┐
│ FK specialist_id    │───────┐   │
│    scheduled_at     │       │   │
│    status           │       │   │ N:1
│    notes            │       │   │
│    created_at       │       │   │
│    updated_at       │       │   ▼
└─────────────────────┘       │  ┌─────────────────────┐
         │ 1:1                │  │      SERVICE        │
         │                    │  ├─────────────────────┤
         ▼                    │  │ PK id (UUID)        │
┌─────────────────────┐       │  │    name             │
│       REVIEW        │       │  │    description      │
├─────────────────────┤       │  │    duration_minutes │
│ PK id (UUID)        │       │  │    price            │
│ FK user_id          │       │  │    active           │
│ FK service_id       │───────┘  │    created_at       │
│ FK appointment_id   │◄─────────│    updated_at       │
│    rating           │          └─────────────────────┘
│    comment          │                   │ N:M
│    created_at       │                   ▼
└─────────────────────┘          ┌─────────────────────┐
                                 │  SERVICE_PRODUCT    │
┌─────────────────────┐          ├─────────────────────┤
│    SPECIALIST       │          │ PK FK service_id    │
├─────────────────────┤          │ PK FK product_id    │◄──┐
│ PK id (UUID)        │          │    quantity_used    │   │
│    name             │          └─────────────────────┘   │
│    role             │                                    │
│    image_url        │          ┌─────────────────────┐   │ N:1
│    active           │          │      PRODUCT        │   │
│    created_at       │          ├─────────────────────┤   │
│    updated_at       │          │ PK id (UUID)        │───┘
└─────────────────────┘          │    name             │
         ▲                       │    description      │
         │ N:1                   │    stock_quantity   │
         └───────────────────────│    price            │
                                 │    min_stock_alert  │
                                 │    created_at       │
                                 │    updated_at       │
                                 └─────────────────────┘

LEYENDA:
─────  Relación
PK     Primary Key
FK     Foreign Key
1:1    Relación uno a uno
1:N    Relación uno a muchos
N:M    Relación muchos a muchos
```

### 3.2. Descripción de Entidades

#### USER (Usuarios)
- **Propósito**: Almacena información de usuarios del sistema (clientes y administradores)
- **Atributos principales**:
  - `id`: Identificador único (UUID)
  - `name`: Nombre completo
  - `email`: Email (opcional, único si presente)
  - `phone`: Teléfono (opcional, único si presente)
  - `password_hash`: Contraseña encriptada con bcrypt
  - `auth_method`: EMAIL o PHONE (indica método de registro)
  - `role`: CLIENT o ADMIN
- **Restricciones**: Al menos uno entre email o phone debe estar presente
- **Relaciones**:
  - 1:N con APPOINTMENT (un usuario puede tener múltiples citas)
  - 1:N con REVIEW (un usuario puede dejar múltiples reseñas)

#### SERVICE (Servicios)
- **Propósito**: Catálogo de servicios ofrecidos por el salón
- **Atributos principales**:
  - `id`: Identificador único (UUID)
  - `name`: Nombre del servicio
  - `description`: Descripción detallada
  - `duration_minutes`: Duración en minutos
  - `price`: Precio (Decimal 10,2)
  - `active`: Estado activo/inactivo
- **Relaciones**:
  - 1:N con APPOINTMENT (un servicio puede estar en múltiples citas)
  - 1:N con REVIEW (un servicio puede tener múltiples reseñas)
  - N:M con PRODUCT a través de SERVICE_PRODUCT

#### APPOINTMENT (Citas)
- **Propósito**: Registro de citas reservadas
- **Atributos principales**:
  - `id`: Identificador único (UUID)
  - `user_id`: Referencia al usuario
  - `service_id`: Referencia al servicio
  - `specialist_id`: Referencia al especialista (opcional)
  - `scheduled_at`: Fecha y hora programada
  - `status`: PENDING, CONFIRMED, COMPLETED, CANCELLED, RESCHEDULED
  - `notes`: Notas adicionales
- **Relaciones**:
  - N:1 con USER
  - N:1 con SERVICE
  - N:1 con SPECIALIST (opcional)
  - 1:1 con REVIEW

#### SPECIALIST (Especialistas)
- **Propósito**: Personal del salón que realiza los servicios
- **Atributos principales**:
  - `id`: Identificador único (UUID)
  - `name`: Nombre del especialista
  - `role`: Especialidad o cargo
  - `image_url`: URL de foto de perfil
  - `active`: Estado activo/inactivo
- **Relaciones**:
  - 1:N con APPOINTMENT

#### REVIEW (Reseñas)
- **Propósito**: Valoraciones y comentarios de servicios
- **Atributos principales**:
  - `id`: Identificador único (UUID)
  - `user_id`: Referencia al usuario
  - `service_id`: Referencia al servicio
  - `appointment_id`: Referencia a la cita (única)
  - `rating`: Calificación de 1 a 5
  - `comment`: Comentario opcional
- **Restricciones**: Una reseña por cita (appointment_id único)
- **Relaciones**:
  - N:1 con USER
  - N:1 con SERVICE
  - 1:1 con APPOINTMENT

#### PRODUCT (Productos)
- **Propósito**: Inventario de productos utilizados en servicios
- **Atributos principales**:
  - `id`: Identificador único (UUID)
  - `name`: Nombre del producto
  - `description`: Descripción
  - `stock_quantity`: Cantidad en stock
  - `price`: Precio unitario
  - `min_stock_alert`: Nivel mínimo antes de alerta
- **Relaciones**:
  - N:M con SERVICE a través de SERVICE_PRODUCT

#### SERVICE_PRODUCT (Tabla Intermedia)
- **Propósito**: Relaciona servicios con productos y su cantidad utilizada
- **Atributos**:
  - `service_id`: FK a Service
  - `product_id`: FK a Product
  - `quantity_used`: Cantidad utilizada del producto en el servicio
- **Clave primaria compuesta**: (service_id, product_id)

### 3.3. Cardinalidades

| Relación | Cardinalidad | Descripción |
|----------|--------------|-------------|
| USER - APPOINTMENT | 1:N | Un usuario puede tener múltiples citas |
| USER - REVIEW | 1:N | Un usuario puede dejar múltiples reseñas |
| SERVICE - APPOINTMENT | 1:N | Un servicio puede estar en múltiples citas |
| SERVICE - REVIEW | 1:N | Un servicio puede tener múltiples reseñas |
| SPECIALIST - APPOINTMENT | 1:N | Un especialista puede atender múltiples citas |
| APPOINTMENT - REVIEW | 1:1 | Una cita puede tener máximo una reseña |
| SERVICE - PRODUCT | N:M | Un servicio usa múltiples productos, un producto se usa en múltiples servicios |

---

## 4. Normalización de Base de Datos

### 4.1. Primera Forma Normal (1FN)

**Requisito**: Eliminación de grupos repetitivos y valores atómicos.

**Cumplimiento**:
- Todos los atributos contienen valores atómicos (no hay arrays ni listas)
- No existen campos repetitivos (ej: teléfono1, teléfono2)
- Cada tabla tiene una clave primaria única (UUID)
- No hay campos multivaluados

**Ejemplo**:
- Antes (violación): services: "Corte, Tinte, Manicure" (lista en un campo)
- Después: Tabla SERVICE con un registro por servicio

### 4.2. Segunda Forma Normal (2FN)

**Requisito**: Estar en 1FN y eliminar dependencias parciales (todos los atributos no-clave deben depender de la clave completa).

**Cumplimiento**:
- Todas las claves primarias son simples (UUID único), excepto SERVICE_PRODUCT
- En SERVICE_PRODUCT (clave compuesta: service_id + product_id):
  - `quantity_used` depende de ambas claves (correcto)
  - No hay dependencias parciales

**Ejemplo SERVICE_PRODUCT**:
- quantity_used depende de qué servicio Y qué producto (cumple 2FN)

### 4.3. Tercera Forma Normal (3FN)

**Requisito**: Estar en 2FN y eliminar dependencias transitivas (atributos no-clave no deben depender de otros atributos no-clave).

**Cumplimiento**:

**USER**: 
- Todos los atributos dependen directamente de id
- `role`, `name`, `email`, `phone` son propiedades directas del usuario

**APPOINTMENT**: 
- status, scheduled_at, notes dependen directamente de la cita
- Referencias a USER, SERVICE, SPECIALIST mediante FK (correcto)

**REVIEW**:
- rating y comment dependen de la reseña específica
- No hay dependencias transitivas

### 4.4. Forma Normal de Boyce-Codd (BCNF)

**Requisito**: Estar en 3FN y cada determinante debe ser clave candidata.

**Cumplimiento**:
- Todas las claves primarias son determinantes únicos
- No existen dependencias funcionales donde el determinante no sea clave

**Análisis**:
- USER: email y phone son UNIQUE (pueden ser claves candidatas)
- REVIEW: appointment_id es UNIQUE (clave candidata adicional)
- Todas las relaciones están correctamente normalizadas

### 4.5. Resumen de Normalización

| Tabla | 1FN | 2FN | 3FN | BCNF | Observaciones |
|-------|-----|-----|-----|------|---------------|
| USER | SI | SI | SI | SI | Email y phone son claves candidatas únicas |
| SERVICE | SI | SI | SI | SI | Sin dependencias transitivas |
| APPOINTMENT | SI | SI | SI | SI | Referencias via FK correctas |
| SPECIALIST | SI | SI | SI | SI | Tabla simple y atómica |
| REVIEW | SI | SI | SI | SI | appointment_id es clave candidata |
| PRODUCT | SI | SI | SI | SI | Sin dependencias transitivas |
| SERVICE_PRODUCT | SI | SI | SI | SI | Tabla intermedia correcta para N:M |

### 4.6. Ventajas de la Normalización Aplicada

1. **Integridad de datos**: No hay duplicación de información
2. **Mantenimiento**: Actualizaciones en un solo lugar
3. **Escalabilidad**: Fácil agregar nuevas entidades
4. **Consistencia**: Restricciones FK garantizan integridad referencial
5. **Rendimiento**: Índices en claves primarias y únicas optimizan consultas

---

## 5. Diagrama de Gantt

### 5.1. Cronograma del Proyecto

```
Proyecto: RosTectic - Sistema de Gestión de Citas
Duración Total: 16 semanas (4 meses)
Inicio: Semana 1 | Fin: Semana 16

FASE                            | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 |S10|S11|S12|S13|S14|S15|S16|
--------------------------------|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
1. ANÁLISIS Y DISEÑO            |████|████|████|    |    |    |    |    |    |    |    |    |    |    |    |    |
   1.1 Requisitos               |████|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
   1.2 Casos de Uso             |    |████|    |    |    |    |    |    |    |    |    |    |    |    |    |    |
   1.3 Diseño BD                |    |████|    |    |    |    |    |    |    |    |    |    |    |    |    |    |
   1.4 Arquitectura             |    |    |████|    |    |    |    |    |    |    |    |    |    |    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
2. CONFIGURACIÓN ENTORNO        |    |    |████|████|    |    |    |    |    |    |    |    |    |    |    |    |
   2.1 Backend Setup            |    |    |████|    |    |    |    |    |    |    |    |    |    |    |    |    |
   2.2 Base de Datos            |    |    |    |████|    |    |    |    |    |    |    |    |    |    |    |    |
   2.3 Frontend Setup           |    |    |    |████|    |    |    |    |    |    |    |    |    |    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
3. DESARROLLO BACKEND           |    |    |    |████|████|████|████|    |    |    |    |    |    |    |    |    |
   3.1 Auth (Email/Phone)       |    |    |    |████|████|    |    |    |    |    |    |    |    |    |    |    |
   3.2 Servicios                |    |    |    |    |    |████|    |    |    |    |    |    |    |    |    |    |
   3.3 Citas                    |    |    |    |    |    |████|████|    |    |    |    |    |    |    |    |    |
   3.4 Reseñas                  |    |    |    |    |    |    |████|    |    |    |    |    |    |    |    |    |
   3.5 Inventario               |    |    |    |    |    |    |████|    |    |    |    |    |    |    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
4. DESARROLLO FRONTEND          |    |    |    |    |████|████|████|████|████|    |    |    |    |    |    |    |
   4.1 UI/UX Design             |    |    |    |    |████|    |    |    |    |    |    |    |    |    |    |    |
   4.2 Auth Screens             |    |    |    |    |    |████|████|    |    |    |    |    |    |    |    |    |
   4.3 Servicios/Citas          |    |    |    |    |    |    |████|████|    |    |    |    |    |    |    |    |
   4.4 Perfil/Historial         |    |    |    |    |    |    |    |████|    |    |    |    |    |    |    |    |
   4.5 Admin Panel              |    |    |    |    |    |    |    |    |████|    |    |    |    |    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
5. INTEGRACIÓN                  |    |    |    |    |    |    |    |    |████|████|    |    |    |    |    |    |
   5.1 API Integration          |    |    |    |    |    |    |    |    |████|    |    |    |    |    |    |    |
   5.2 Notificaciones           |    |    |    |    |    |    |    |    |    |████|    |    |    |    |    |    |
   5.3 Testing                  |    |    |    |    |    |    |    |    |    |████|    |    |    |    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
6. PRUEBAS Y AJUSTES            |    |    |    |    |    |    |    |    |    |████|████|████|    |    |    |    |
   6.1 Unit Testing             |    |    |    |    |    |    |    |    |    |████|    |    |    |    |    |    |
   6.2 Integration Testing      |    |    |    |    |    |    |    |    |    |    |████|    |    |    |    |    |
   6.3 User Testing             |    |    |    |    |    |    |    |    |    |    |████|    |    |    |    |    |
   6.4 Bug Fixing               |    |    |    |    |    |    |    |    |    |    |    |████|    |    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
7. DOCUMENTACIÓN                |    |    |    |    |    |    |    |    |    |    |    |████|████|    |    |    |
   7.1 Documentación Técnica    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |    |    |
   7.2 Manual de Usuario        |    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |    |
   7.3 Manual de Despliegue     |    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
8. DESPLIEGUE                   |    |    |    |    |    |    |    |    |    |    |    |    |████|████|    |    |
   8.1 Configuración Servidor   |    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |    |
   8.2 Deploy Backend           |    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |    |
   8.3 Deploy Frontend          |    |    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |
   8.4 Pruebas en Producción    |    |    |    |    |    |    |    |    |    |    |    |    |    |████|    |    |
                                |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
9. ENTREGA Y PRESENTACIÓN       |    |    |    |    |    |    |    |    |    |    |    |    |    |    |████|████|
   9.1 Pulir detalles           |    |    |    |    |    |    |    |    |    |    |    |    |    |    |████|    |
   9.2 Preparar presentación    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |████|    |
   9.3 Defensa TFG              |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |████|

HITOS IMPORTANTES:
* S3  : Diseño completo
* S4  : Entorno configurado
* S7  : Backend funcional
* S9  : Frontend funcional
* S10 : Integración completa
* S12 : Testing completado
* S13 : Documentación finalizada
* S14 : Despliegue completado
* S16 : Defensa TFG
```

### 5.2. Desglose de Tareas por Fase

#### Fase 1: Análisis y Diseño (Semanas 1-3)
- Levantamiento de requisitos funcionales y no funcionales
- Definición de casos de uso
- Diseño del modelo entidad-relación
- Definición de arquitectura del sistema
- Selección de tecnologías

#### Fase 2: Configuración del Entorno (Semanas 3-4)
- Instalación de Node.js, PostgreSQL, Flutter
- Configuración de proyecto backend (Express + Prisma)
- Configuración de proyecto frontend (Flutter)
- Configuración de Git y CI/CD

#### Fase 3: Desarrollo Backend (Semanas 4-7)
- Implementación de autenticación (JWT)
- API de servicios (CRUD)
- API de citas (reserva, cancelación, reprogramación)
- API de reseñas
- API de inventario
- Middleware de validación y autenticación

#### Fase 4: Desarrollo Frontend (Semanas 5-9)
- Diseño de interfaz de usuario
- Pantallas de autenticación (login, registro)
- Pantalla de servicios y calendario
- Gestión de citas del usuario
- Panel de administración
- Integración con Provider para state management

#### Fase 5: Integración (Semanas 9-10)
- Conectar frontend con backend
- Implementar notificaciones (SendGrid, Twilio)
- Testing de integración
- Manejo de errores y casos edge

#### Fase 6: Pruebas y Ajustes (Semanas 10-12)
- Unit testing (backend y frontend)
- Integration testing
- User acceptance testing
- Corrección de bugs
- Optimización de rendimiento

#### Fase 7: Documentación (Semanas 12-13)
- Documentación técnica
- Manual de usuario
- Manual de instalación y despliegue
- Comentarios en código

#### Fase 8: Despliegue (Semanas 13-14)
- Configuración de servidor (Heroku, AWS, o similar)
- Despliegue del backend
- Despliegue del frontend (Web)
- Configuración de variables de entorno de producción
- Pruebas en entorno de producción

#### Fase 9: Entrega y Presentación (Semanas 15-16)
- Preparación de memoria del TFG
- Creación de presentación
- Ensayos de defensa
- Defensa del TFG

### 5.3. Recursos Asignados

| Fase | Desarrollador | Horas Estimadas |
|------|---------------|-----------------|
| Análisis y Diseño | 1 | 40h |
| Configuración | 1 | 20h |
| Backend | 1 | 80h |
| Frontend | 1 | 100h |
| Integración | 1 | 40h |
| Pruebas | 1 | 60h |
| Documentación | 1 | 40h |
| Despliegue | 1 | 20h |
| Presentación | 1 | 20h |
| **TOTAL** | | **420h** |

---

## 6. Análisis DAFO

### 6.1. Matriz DAFO

```
┌─────────────────────────────────┬─────────────────────────────────┐
│         FORTALEZAS              │         OPORTUNIDADES           │
│         (Strengths)             │         (Opportunities)         │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                 │
│ F1. Tecnología moderna y        │ O1. Creciente digitalización    │
│     escalable (Flutter, Node)   │     del sector belleza          │
│                                 │                                 │
│ F2. Aplicación multiplataforma  │ O2. Post-pandemia: preferencia  │
│     (Web, Android, iOS)         │     por reservas online         │
│                                 │                                 │
│ F3. Base de datos normalizada   │ O3. Posibilidad de expansión    │
│     y bien estructurada         │     a otros sectores (spa,      │
│                                 │     peluquerías, barbería)      │
│ F4. Sistema de notificaciones   │                                 │
│     dual (Email/SMS)            │ O4. Expansión a gestión de     │
│                                 │     clientes y fidelización     │
│ F5. Gestión de inventario       │                                 │
│     integrada                   │ O5. Potencial para agregar      │
│                                 │     funcionalidades (programas  │
│ F6. Interfaz intuitiva y        │     de fidelización, descuentos)│
│     responsive                  │                                 │
│                                 │ O6. Código abierto: comunidad   │
│ F7. Autenticación flexible      │     puede contribuir            │
│     (email o teléfono)          │                                 │
│                                 │ O7. Demanda de soluciones       │
│ F8. Sistema de reseñas para     │     económicas para PYMEs       │
│     feedback del cliente        │                                 │
│                                 │                                 │
├─────────────────────────────────┼─────────────────────────────────┤
│         DEBILIDADES             │         AMENAZAS                │
│         (Weaknesses)            │         (Threats)               │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                 │
│ D1. Proyecto académico: sin     │ A1. Competencia establecida     │
│     recursos financieros        │     (SimplyBook.me, Fresha)     │
│                                 │                                 │
│ D2. Desarrollado por una sola   │ A2. Dependencia de servicios    │
│     persona: limitaciones de    │     externos (SendGrid, Twilio) │
│     tiempo y alcance            │     con costos recurrentes      │
│                                 │                                 │
│ D3. Sin funcionalidad de        │ A3. Cambios constantes en       │
│     recordatorios automáticos   │     tecnologías web y móviles   │
│                                 │                                 │
│ D4. Dependencia de conexión     │ A4. Requisitos de seguridad     │
│     a internet                  │     cada vez más estrictos      │
│                                 │     (GDPR, LOPD)                │
│ D5. Sin funcionalidad offline   │                                 │
│                                 │ A5. Resistencia al cambio de    │
│ D6. Falta de testing            │     negocios tradicionales      │
│     automatizado completo       │                                 │
│                                 │ A6. Necesidad de mantenimiento  │
│ D7. Sin experiencia de usuario  │     constante (actualizaciones, │
│     real previa al lanzamiento  │     bugs, seguridad)            │
│                                 │                                 │
│ D8. Documentación limitada      │ A7. Ciberseguridad: posibles    │
│     a lo esencial               │     ataques o brechas de datos  │
│                                 │                                 │
└─────────────────────────────────┴─────────────────────────────────┘
```

### 6.2. Estrategias Derivadas del DAFO

#### Estrategias FO (Fortalezas - Oportunidades)
**Usar fortalezas para aprovechar oportunidades**

1. **F2 + O1**: Capitalizar la multiplataforma para captar el mercado de salones que buscan digitalización
2. **F1 + O3**: Adaptar fácilmente el sistema a otros sectores gracias a arquitectura modular
3. **F5 + O5**: Usar control de stock para optimizar gestión de servicios y productos
4. **F8 + O2**: Promover sistema de reseñas como diferenciador en marketing post-pandemia

#### Estrategias DO (Debilidades - Oportunidades)
**Superar debilidades aprovechando oportunidades**

1. **D1 + O7**: Posicionar como solución económica para PYMEs que no pueden pagar sistemas caros
2. **D3 + O4**: Implementar recordatorios automáticos y sistema de fidelización como siguiente fase
3. **D2 + O6**: Liberar como código abierto para recibir contribuciones de la comunidad
4. **D7 + O1**: Realizar pruebas piloto con salones reales interesados en digitalización

#### Estrategias FA (Fortalezas - Amenazas)
**Usar fortalezas para minimizar amenazas**

1. **F1 + A3**: Usar tecnologías modernas y actualizadas minimiza obsolescencia
2. **F3 + A7**: BD bien estructurada facilita implementar medidas de seguridad robustas
3. **F6 + A5**: Interfaz intuitiva reduce resistencia al cambio en negocios tradicionales
4. **F7 + A4**: Autenticación flexible cumple con estándares de seguridad modernos

#### Estrategias DA (Debilidades - Amenazas)
**Minimizar debilidades y evitar amenazas**

1. **D2 + A1**: Enfocarse en nicho específico (salones pequeños/medianos) en lugar de competir directamente
2. **D4 + A6**: Documentar bien para facilitar futuros mantenimientos
3. **D6 + A7**: Invertir en testing automatizado para prevenir brechas de seguridad
4. **D3 + A2**: Implementar recordatorios básicos en el sistema para reducir dependencias externas iniciales

### 6.3. Plan de Acción

#### Corto Plazo (0-3 meses)
- Completar desarrollo MVP con funcionalidades core
- Realizar testing exhaustivo de seguridad
- Buscar salón piloto para pruebas reales
- Documentar setup y configuración

#### Medio Plazo (3-6 meses)
- Añadir recordatorios automáticos de citas
- Añadir funcionalidad offline básica (PWA)
- Implementar testing automatizado (Jest, Flutter Test)
- Crear video demos y tutoriales

#### Largo Plazo (6-12 meses)
- Expandir a otros sectores (barberías, spas, gimnasios)
- Desarrollar programa de fidelización de clientes
- Añadir reportes avanzados y analytics
- Internacionalización (i18n)

### 6.4. Conclusiones del Análisis

**Viabilidad del Proyecto**: 4/5

El proyecto RosTectic presenta un balance favorable entre fortalezas y oportunidades. Los principales factores de éxito son:

1. **Tecnología adecuada**: Stack moderno y escalable
2. **Mercado en crecimiento**: Digitalización del sector belleza
3. **Propuesta de valor clara**: Sistema de reservas y gestión de stock para salones pequeños/medianos sin costos de transacción

Los principales riesgos a mitigar:

1. **Competencia**: Diferenciarse con precio y simplicidad
2. **Recursos limitados**: Priorizar funcionalidades core
3. **Dependencias externas**: Documentar y tener planes B

**Recomendación**: Proceder con el desarrollo enfocándose en MVP funcional, luego iterar basándose en feedback real de usuarios.

---

## Resumen Ejecutivo

Este documento presenta la documentación técnica completa del proyecto **RosTectic**, un sistema de gestión de citas para salones de estética desarrollado con tecnologías modernas (Flutter + Node.js + PostgreSQL).

### Aspectos Destacados:

1. Casos de Uso: 10 casos de uso principales cubriendo autenticación, gestión de citas, reseñas y panel administrativo

2. Requisitos: 20 requisitos funcionales y 20 no funcionales asegurando calidad, seguridad y escalabilidad

3. Modelo de Datos: Base de datos normalizada hasta BCNF con 7 entidades y relaciones bien definidas

4. Planificación: 16 semanas de desarrollo con 420 horas estimadas distribuidas en 9 fases

5. Análisis Estratégico: DAFO identifica oportunidades en la digitalización del sector belleza y estrategias para minimizar debilidades

El proyecto es **viable y prometedor**, con tecnología sólida y mercado receptivo, requiriendo enfoque en MVP y feedback temprano de usuarios reales.

---

**Fecha de elaboración**: Febrero 2026  
**Versión**: 1.0  
**Autor**: TFG - RosTectic