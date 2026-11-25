# Especificación Funcional y Técnica — Módulo de Registro (HoloWear)

## 1. Objetivo y Estrategia UX
El flujo de registro permite dar de alta usuarios en la colección `users` de MongoDB (`holowear_db`) mediante un formulario progresivo de **2 pasos**, evitando la saturación visual en dispositivos móviles y solicitando únicamente los datos estrictamente necesarios según el perfil operativo seleccionado (principio de minimización de datos).

## 2. Perfiles de Usuario (`role`)
* **Creador Autónomo (`creator`):** Diseñadores independientes o entusiastas del suprarreciclaje que escanean prendas, simulan cortes 3D, calculan cotizaciones y emiten pasaportes QR.
* **Taller Textil (`workshop`):** Sastrerías, costureros y talleres locales que reciben fichas técnicas de corte y confeccionan prendas bajo pedido.
* **Cliente Final (`client`):** Usuarios que desean transformar prendas propias en desuso conectando con talleres cercanos verificados.

## 3. Matriz de Campos, Validaciones y Mapeo a MongoDB (`User.js`)

| Paso | Pregunta en Interfaz | Campo BD (`User.js`) | Tipo | Regla de Validación | Mensaje de Error en UI |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | Nombre completo | `fullName` | `String` | Obligatorio, mínimo 3 caracteres, sin números. | *Ingresa tu nombre y apellido (mín. 3 caracteres).* |
| **1** | Correo electrónico | `email` | `String` | Obligatorio, formato válido (`usuario@dominio.com`), único en BD. | *Ingresa un correo electrónico válido.* |
| **1** | Contraseña | `passwordHash` | `String` | Obligatorio, mínimo 8 caracteres, al menos 1 letra y 1 número (se cifra con `bcrypt` en backend). | *Usa al menos 8 caracteres combinando letras y números.* |
| **1** | Tipo de perfil | `role` | `Enum` | Obligatorio: `'creator'`, `'workshop'` o `'client'`. | *Selecciona cómo deseas utilizar HoloWear.* |
| **2** | Ciudad de residencia | `city` | `String` | Obligatorio, mínimo 3 caracteres. | *Indica tu ciudad para ubicar talleres cercanos.* |
| **2** | Teléfono / WhatsApp | `phone` | `String` | Obligatorio si `role == 'workshop'`; opcional en otros roles (10 dígitos). | *Ingresa un número de contacto válido a 10 dígitos.* |
| **2** | Nombre del taller | `workshopProfile.workshopName` | `String` | Obligatorio solo si `role == 'workshop'` (mín. 3 caracteres). | *Escribe el nombre comercial de tu taller o sastrería.* |
| **2** | Dirección o zona | `workshopProfile.address` | `String` | Obligatorio solo si `role == 'workshop'` (mín. 5 caracteres). | *Indica la calle, colonia o zona de entrega del taller.* |
| **2** | Especialidades técnicas | `workshopProfile.specialties` | `[String]` | Obligatorio solo si `role == 'workshop'` (al menos 1 técnica seleccionada). | *Selecciona al menos una especialidad textil.* |
| **2** | Descripción del atelier | `workshopProfile.description` | `String` | Opcional (máx. 200 caracteres). | — |
| **2** | Consentimiento legal | *(Validación UI)* | `Boolean` | Debe aceptarse explícitamente antes de enviar. | *Debes aceptar los términos y el aviso de privacidad.* |

## 4. Estructura JSON Generada hacia la API (`POST /api/auth/register`)

### Ejemplo A: Registro de Creador o Cliente
```json
{
  "fullName": "Ana Sofía Herrera",
  "email": "anasofia@atelier.mx",
  "password": "********",
  "role": "creator",
  "city": "Valle de Santiago",
  "phone": "4561234567"
}
```

### Ejemplo B: Registro de Taller Textil
```json
{
  "fullName": "Roberto Méndez",
  "email": "contacto@sastreriamendez.mx",
  "password": "********",
  "role": "workshop",
  "city": "Valle de Santiago",
  "phone": "4569876543",
  "workshopProfile": {
    "workshopName": "Taller Textil Méndez",
    "address": "Calle Arteaga #114, Zona Centro",
    "description": "Especialistas en mezclilla pesada, patchwork y acabados industriales.",
    "specialties": ["Denim", "Patchwork", "Sastrería"],
    "isAvailable": true,
    "rating": 5.0
  }
}
```

## 5. Consideraciones Éticas y de Privacidad
* **Cifrado en tránsito y reposo:** La contraseña nunca se almacena en texto plano; el backend la transforma mediante `bcrypt` antes de persistirla en `passwordHash`.
* **Geolocalización no invasiva:** Se solicita únicamente la ciudad (`city`) durante el registro para filtrar talleres sin exigir rastreo GPS continuo en segundo plano.
* **Nota metodológica:** La estructura de validación y mapeo documental fue organizada con asistencia de IA como copiloto técnico y auditada manualmente conforme a los requerimientos de HoloWear.