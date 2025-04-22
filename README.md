# desafio-fedian App
Sistema Móvil de Facturación Electrónica con Asistente Virtual para Pequeños Comerciantes

Aplicación móvil construida con Flutter, enfocada en la gestión y envío de facturas electrónicas mediante la API de Factus.

## Funcionalidades

- Pantalla de bienvenida
- Pantalla de facturación
- Envío de facturas (estructura de integración con API Factus)
- Preparado para agregar autenticación si es necesario en el futuro

## Tecnologías utilizadas

- Flutter 3.19+
- Dart 3.7+
- `http` para consumo de API REST
- Navegación nativa de Flutter

## Estructura del proyecto
lib/ ├── main.dart 
     ├── pages/ │ 
     ├── welcome_page.dart │ 
       └── facturacion_page.dart 
       └── services/ 
         └── factus_service.dart


## ⚙️ Configuración

1. Clona el repositorio:
   ```bash
   git clone https://github.com/wilfranr/desafio-fedian.git
   cd desafio-fedian

2. Instalar dependencias
   flutter pub get
3. Ejecutar
   flutter run



--------------------------------------------------------------------
Desarrollado por:
Luis Orlando Martínez Pérez
Wilfran Yoseth Rivera Rivera
Jorge Andrés Moreno Gayón
Valentina Sánchez Valverde

Para:
Institución Universitaria Politécnico Grancolombiano, Facultad de Diseño e Innovación 
Gerencia de Proyectos Informáticos | Grupo B03 | Subgrupo 17
Prof. Marcela Cascante Montoya
