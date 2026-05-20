# 🦜 Aves.APP — Identificador de Aves con IA

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/TFLite-Model-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white"/>
  <img src="https://img.shields.io/badge/SQLite-Local%20DB-003B57?style=for-the-badge&logo=sqlite&logoColor=white"/>
  <img src="https://img.shields.io/badge/Google%20Maps-Avistamientos-4285F4?style=for-the-badge&logo=google-maps&logoColor=white"/>
</p>

> Aplicación móvil desarrollada en **Flutter** que permite identificar especies de aves mediante inteligencia artificial (TensorFlow Lite), registrar avistamientos con geolocalización y explorar un catálogo visual de especies.

---

## 📋 Tabla de Contenidos

- [Descripción General](#-descripción-general)
- [Características Principales](#-características-principales)
- [Arquitectura del Proyecto](#-arquitectura-del-proyecto)
- [Estructura de Carpetas](#-estructura-de-carpetas)
- [Especies Soportadas](#-especies-soportadas)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Configuración](#-instalación-y-configuración)
- [Uso de la Aplicación](#-uso-de-la-aplicación)
- [Servicios Internos](#-servicios-internos)
- [Base de Datos Local](#-base-de-datos-local)
- [Modelo de IA](#-modelo-de-ia)
- [Dependencias](#-dependencias)
- [Plataformas Soportadas](#-plataformas-soportadas)
- [Contribuir](#-contribuir)

---

## 📖 Descripción General

**Aves.APP** es una aplicación multiplataforma construida con Flutter que combina visión por computadora, geolocalización y almacenamiento local para ofrecer una experiencia completa de identificación y seguimiento de aves. El usuario puede tomar una foto o seleccionar una imagen de su galería, y la app clasifica la especie utilizando un modelo **TensorFlow Lite** (`model_aves.tflite`) entrenado específicamente para reconocer 16 especies de aves.

Los resultados incluyen el nombre de la especie, el porcentaje de confianza, las **Top 3 especies candidatas**, y una imagen de referencia. Además, cada identificación puede guardarse como un avistamiento geolocalizado en la base de datos local (SQLite), y visualizarse en un mapa interactivo con **Google Maps**.

---

## ✨ Características Principales

| Funcionalidad | Descripción |
|---|---|
| 📸 Identificación por cámara | Captura fotos directamente con la cámara del dispositivo |
| 🖼️ Identificación desde galería | Selecciona imágenes existentes para clasificar |
| 🤖 Clasificación con IA | Modelo TFLite con entrada 380×380px y 16 clases |
| 🥇 Top 3 resultados | Muestra las 3 especies más probables con su porcentaje |
| 📍 Geolocalización | Registra la ubicación GPS del avistamiento automáticamente |
| 🗺️ Mapa de avistamientos | Visualiza todos los avistamientos en Google Maps |
| 📚 Catálogo de especies | Explora información detallada de cada especie |
| 🌍 Distribución geográfica | Mapa de distribución natural por especie |
| 🌙 Tema claro/oscuro | Soporte completo para modo oscuro y claro (Material 3) |
| 💾 Almacenamiento local | Base de datos SQLite con UUID único por registro |

---

## 🏗️ Arquitectura del Proyecto

El proyecto sigue una arquitectura en **capas**, separando responsabilidades claramente:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (UI Screens — Flutter Widgets)         │
├─────────────────────────────────────────┤
│             Core Layer                  │
│  (Navegación principal, tema global)    │
├─────────────────────────────────────────┤
│            Services Layer               │
│  (Clasificación IA, BD, Ubicación)      │
├─────────────────────────────────────────┤
│              Data Layer                 │
│  (Catálogo estático, ubicaciones)       │
└─────────────────────────────────────────┘
```

- **Presentation**: Todas las pantallas visuales que el usuario ve e interactúa.
- **Core**: Lógica central de navegación y configuración global del tema.
- **Services**: Servicios reutilizables para IA, base de datos SQLite y GPS.
- **Data**: Datos estáticos del catálogo de especies y ubicaciones geográficas.

---

## 📁 Estructura de Carpetas

```
Aves.APP/
├── lib/
│   ├── main.dart                          # Punto de entrada, configuración de tema
│   ├── Core/
│   │   └── UI/
│   │       └── MainNavigationScreen.dart  # Barra de navegación principal
│   ├── Presentation/
│   │   └── UI/
│   │       ├── InicioScreen.dart          # Pantalla de bienvenida
│   │       ├── IdentificarAveScreen.dart  # Identificación con cámara/galería
│   │       ├── CatalogoScreen.dart        # Catálogo de especies
│   │       ├── DetalleEspecieScreen.dart  # Detalle de una especie
│   │       ├── MapaAvistamientosScreen.dart # Mapa Google Maps con avistamientos
│   │       └── DistribucionAveScreen.dart  # Mapa de distribución de especie
│   ├── Services/
│   │   ├── classifier_service.dart        # Clasificador TFLite (BirdClassifier)
│   │   ├── database_service.dart          # SQLite (avistamientos locales)
│   │   └── location_service.dart          # GPS y geolocalizacion
│   ├── Data/
│   │   ├── catalogo_especies.dart         # Datos estáticos del catálogo
│   │   └── species_locations.dart         # Coordenadas de distribución por especie
│   └── assets/
│       ├── models/
│       │   ├── model_aves.tflite          # Modelo de IA entrenado
│       │   └── labels.txt                 # Etiquetas de clases
│       └── images/
│           └── *.jpg                      # Imágenes de referencia por especie
├── android/                               # Configuración nativa Android
├── ios/                                   # Configuración nativa iOS
├── web/                                   # Configuración para web
├── windows/, linux/, macos/               # Configuración para escritorio
├── pubspec.yaml                           # Dependencias del proyecto
└── analysis_options.yaml                  # Reglas de análisis de código
```

---

## 🐦 Especies Soportadas

El modelo reconoce **16 especies de aves**:

| # | Especie | # | Especie |
|---|---------|---|---------|
| 1 | Avefría tero | 9 | Luis Pico Grueso |
| 2 | Baltimore Oriole | 10 | Papamoscas rayado chico |
| 3 | Bienteveo Común | 11 | Saltador Gris |
| 4 | Canario coronado | 12 | Saltador garganta ocre |
| 5 | Colibrí Cola Canela | 13 | Tangara Azulgris |
| 6 | Fiofío Silbón | 14 | Torcaza Colorada |
| 7 | Garza dedos dorados | 15 | Vireo Ojos Rojos |
| 8 | Jacana | 16 | Zorzal sabia |

---

## ✅ Requisitos Previos

Antes de clonar y ejecutar el proyecto, asegúrate de tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.x` (compatible con Dart `^3.11.4`)
- [Android Studio](https://developer.android.com/studio) o [VS Code](https://code.visualstudio.com/) con extensión Flutter
- Un dispositivo físico Android/iOS **o** un emulador configurado
- **Google Maps API Key** (necesaria para los mapas)
- Git

> ⚠️ **Nota:** El modelo TFLite y las imágenes de referencia deben estar presentes en `lib/assets/models/` y `lib/assets/images/` respectivamente. Estos archivos de gran tamaño pueden no estar incluidos en el repositorio.

---

## 🚀 Instalación y Configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/samtiago24/Aves.APP.git
cd Aves.APP
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar la API Key de Google Maps

#### Android
Abre `android/app/src/main/AndroidManifest.xml` y agrega tu clave dentro del bloque `<application>`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI"/>
```

#### iOS
Abre `ios/Runner/AppDelegate.swift` y agrega:

```swift
GMSServices.provideAPIKey("TU_API_KEY_AQUI")
```

### 4. Agregar permisos en Android

En `android/app/src/main/AndroidManifest.xml`, asegúrate de tener:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### 5. Agregar permisos en iOS

En `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Se necesita la cámara para identificar aves</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Se necesita la ubicación para registrar avistamientos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Se necesita acceso a fotos para identificar aves</string>
```

### 6. Verificar assets del modelo

Asegúrate de que los siguientes archivos existen:

```
lib/assets/models/model_aves.tflite
lib/assets/models/labels.txt
lib/assets/images/avefria_terocsv.jpg
lib/assets/images/baltimore_oriole.jpg
... (una imagen por cada especie)
```

### 7. Ejecutar la aplicación

```bash
# Verificar dispositivos disponibles
flutter devices

# Ejecutar en un dispositivo específico
flutter run

# Compilar APK de producción (Android)
flutter build apk --release

# Compilar para iOS
flutter build ios --release
```

---

## 📱 Uso de la Aplicación

### Pantalla de Inicio (`InicioScreen`)
La pantalla principal da la bienvenida al usuario con accesos directos a las funcionalidades principales. Desde aquí se puede navegar a cualquier sección de la app.

### Identificar un Ave (`IdentificarAveScreen`)
1. Toca el botón **"Cámara"** para tomar una foto en tiempo real, o **"Galería"** para seleccionar una imagen existente.
2. La imagen se procesa automáticamente: es redimensionada a **380×380 px** y normalizada (valores 0–1 por canal RGB).
3. El modelo TFLite ejecuta la inferencia y retorna los **scores** para las 16 clases.
4. Se muestran los **Top 3 resultados** con nombre de especie, porcentaje de confianza e imagen de referencia.
5. Si deseas guardar el avistamiento, toca **"Guardar"**. La app captura automáticamente las coordenadas GPS actuales y almacena el registro en la base de datos local con un ID UUID único.

### Catálogo de Especies (`CatalogoScreen` + `DetalleEspecieScreen`)
- Explora la lista completa de las 16 especies con imagen y nombre.
- Toca cualquier especie para ver su ficha detallada: descripción, hábitat, comportamiento y más.
- Desde el detalle, puedes acceder al mapa de **distribución geográfica** de la especie.

### Mapa de Avistamientos (`MapaAvistamientosScreen`)
- Visualiza en Google Maps todos los avistamientos guardados localmente.
- Cada pin representa un avistamiento con la especie identificada y la fecha.
- Toca un marcador para ver el detalle del avistamiento.

### Distribución del Ave (`DistribucionAveScreen`)
- Muestra en un mapa la distribución geográfica conocida de la especie seleccionada.
- Los datos de ubicación están definidos estáticamente en `lib/Data/species_locations.dart`.

### Cambiar Tema (Claro / Oscuro)
La app soporta **Material 3** con tema claro (fondo `#EEEEEE`, semilla `blueGrey`) y oscuro (fondo `#121212`). El `ValueNotifier<ThemeMode> themeNotifier` en `main.dart` gestiona el cambio de tema globalmente sin necesidad de reiniciar la app.

---

## ⚙️ Servicios Internos

### `BirdClassifier` (`classifier_service.dart`)

Gestiona la carga y ejecución del modelo TFLite:

```dart
final classifier = BirdClassifier();
await classifier.loadModel(); // Carga el modelo desde assets

final result = await classifier.classify(imageFile);
// result = {
//   'label': 'Tangara Azulgris',
//   'confidence': 0.92,
//   'confidenceText': '92.0%',
//   'referenceImage': 'lib/assets/images/tangara_azulgris.jpg',
//   'top3': [...],
//   'allScores': [...]
// }

classifier.dispose(); // Libera recursos del intérprete
```

**Pipeline de inferencia:**
1. Decodifica la imagen con el paquete `image`
2. Redimensiona a `380×380` px
3. Normaliza cada pixel a rango `[0.0, 1.0]` por canal R, G, B
4. Construye tensor de entrada `[1, 380, 380, 3]`
5. Ejecuta inferencia con `_interpreter.run(input, output)`
6. Ordena scores y extrae Top 3

---

### `DatabaseService` (`database_service.dart`)

CRUD local con SQLite para la tabla `avistamientos`:

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | TEXT (PK) | UUID v4 único |
| `especie` | TEXT | Nombre de la especie identificada |
| `confianza` | REAL | Score de confianza (0.0 – 1.0) |
| `fotoPath` | TEXT | Ruta local de la foto |
| `latitud` | REAL | Coordenada GPS |
| `longitud` | REAL | Coordenada GPS |
| `fecha` | TEXT | ISO 8601 timestamp |
| `sincronizado` | INTEGER | Flag de sincronización (0/1) |

**Métodos disponibles:**

```dart
// Guardar nuevo avistamiento
final id = await DatabaseService.guardarAvistamiento(
  especie: 'Jacana',
  confianza: 0.88,
  fotoPath: '/ruta/foto.jpg',
  latitud: 4.6097,
  longitud: -74.0817,
);

// Obtener todos los avistamientos
final lista = await DatabaseService.obtenerTodos();

// Obtener solo no sincronizados (para futura sincronización)
final pendientes = await DatabaseService.obtenerNosincronizados();

// Marcar como sincronizado
await DatabaseService.marcarSincronizado(id);

// Eliminar registro
await DatabaseService.eliminar(id);
```

---

### `LocationService` (`location_service.dart`)

Abstrae el acceso a GPS del dispositivo usando el paquete `geolocator`:

- Solicita permisos de ubicación al usuario
- Retorna latitud y longitud actuales
- Maneja errores si el GPS está desactivado o los permisos son denegados

---

## 💾 Base de Datos Local

La app utiliza **SQLite** (a través de `sqflite`) para persistir los avistamientos sin necesidad de conexión a internet. El archivo de base de datos se crea automáticamente en el primer uso con el nombre `aves.db` en el directorio de bases de datos del dispositivo.

El campo `sincronizado` permite implementar una futura sincronización con un servidor remoto: los registros marcados como `0` son los pendientes de subir.

---

## 🤖 Modelo de IA

| Parámetro | Valor |
|---|---|
| Framework | TensorFlow Lite |
| Archivo | `model_aves.tflite` |
| Tamaño de entrada | 380 × 380 × 3 (RGB) |
| Clases de salida | 16 |
| Normalización | Valores en rango [0.0, 1.0] |
| Tipo de tarea | Clasificación multiclase |

El modelo fue entrenado con imágenes de las 16 especies listadas. La inferencia se ejecuta **completamente en el dispositivo** (on-device), por lo que **no requiere conexión a internet** para clasificar.

---

## 📦 Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| `camera` | ^0.12.0+1 | Captura de fotos en tiempo real |
| `image_picker` | ^1.2.1 | Selección desde galería |
| `tflite_flutter` | ^0.12.1 | Inferencia con modelo TFLite |
| `image` | ^4.1.7 | Procesamiento y redimensionado de imágenes |
| `geolocator` | ^14.0.2 | GPS y geolocalización |
| `google_maps_flutter` | ^2.17.0 | Mapas interactivos |
| `sqflite` | ^2.4.2 | Base de datos SQLite local |
| `uuid` | ^4.5.3 | Generación de IDs únicos (UUID v4) |
| `path_provider` | ^2.1.5 | Acceso a rutas del sistema de archivos |
| `path` | ^1.9.1 | Manipulación de rutas |
| `url_launcher` | ^6.3.1 | Apertura de URLs externas |
| `cupertino_icons` | ^1.0.8 | Iconos estilo iOS |

---

## 🖥️ Plataformas Soportadas

| Plataforma | Estado |
|---|---|
| Android | ✅ Soportada (principal) |
| iOS | ✅ Soportada |
| Web | ⚠️ Parcial (cámara/GPS limitados) |
| Windows | ⚠️ Parcial (cámara/GPS limitados) |
| Linux | ⚠️ Parcial |
| macOS | ⚠️ Parcial |

> La experiencia completa (cámara, GPS, TFLite) está optimizada para **Android e iOS**.

---

## 🤝 Contribuir

1. Haz fork del repositorio
2. Crea una rama para tu feature: `git checkout -b feature/nueva-funcionalidad`
3. Realiza tus cambios y haz commit: `git commit -m "feat: descripción del cambio"`
4. Sube los cambios: `git push origin feature/nueva-funcionalidad`
5. Abre un **Pull Request** describiendo los cambios

---

<p align="center">
  Desarrollado con ❤️ y Flutter — 2025
</p>
