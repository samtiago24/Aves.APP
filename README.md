# 🦜 Aves App — Identificador de Aves del Tolima

Aplicación móvil Android desarrollada en **Flutter** para la identificación de especies de aves del departamento del Tolima, Colombia, usando modelos de inteligencia artificial (TensorFlow Lite y BirdNET).

> **Autores:** Santiago Lopez · Sebastian Castro  
> **Institución:** Universidad — Proyecto de grado  
> **Versión:** 1.0.0+1  
> **Plataforma:** Android (mínimo SDK 23 / Android 6.0)

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos previos](#-requisitos-previos)
- [Instalación paso a paso](#-instalación-paso-a-paso)
- [Configuración de Firebase](#-configuración-de-firebase)
- [Estructura del proyecto](#-estructura-del-proyecto)
- [Modelos de IA](#-modelos-de-ia)
- [Especies soportadas](#-especies-soportadas)
- [Permisos necesarios](#-permisos-necesarios)
- [Solución de problemas](#-solución-de-problemas)

---

## ✨ Características

| Función | Descripción |
|---|---|
| 🔍 Identificación por foto | Toma o sube una foto y la IA identifica el ave |
| 🤖 Doble modelo de IA | Modelo Original (16 aves) + BirdNET Tolima (16 aves) |
| 🗺️ Mapa de distribución | Ver dónde encontrar el ave dentro de Ibagué |
| 💾 Historial de avistamientos | Guarda fecha, especie, confianza y ubicación GPS |
| ☁️ Sincronización en la nube | Respaldo automático en Firebase Firestore |
| 📖 Catálogo de especies | Ficha completa de las 32 especies con hábitat y dieta |
| 📍 GPS integrado | Registra la ubicación exacta de cada avistamiento |

---

## 🛠️ Requisitos previos

Antes de clonar el proyecto asegúrate de tener instalado:

### 1. Flutter SDK
```bash
# Verificar instalación
flutter --version
# Se requiere Flutter 3.x o superior (SDK ^3.11.4)
```
👉 Descarga: https://docs.flutter.dev/get-started/install/windows

### 2. Android Studio
- Versión recomendada: **Android Studio Ladybug 2024** o superior
- Instalar durante la configuración:
  - Android SDK Platform 33 o superior
  - Android Virtual Device (AVD) o usar dispositivo físico

### 3. Java Development Kit (JDK)
```bash
java -version
# Se requiere JDK 17 o superior
```

### 4. Git
```bash
git --version
```

### 5. Verificar entorno Flutter completo
```bash
flutter doctor
# Todos los ítems deben mostrar ✓ (excepto Xcode si estás en Windows)
```

---

## 🚀 Instalación paso a paso

### Paso 1 — Clonar el repositorio
```bash
git clone https://github.com/samtiago24/Aves.APP.git
cd Aves.APP
```

### Paso 2 — Instalar dependencias
```bash
flutter pub get
```

### Paso 3 — Agregar los assets requeridos

Los archivos de modelo y las imágenes **no están en el repositorio** por su tamaño. Debes agregarlos manualmente:

#### 📁 Estructura de assets esperada:
```
lib/
└── assets/
    ├── models/
    │   ├── BirdNET_6K_GLOBAL_MODEL.tflite   ← Modelo BirdNET (requerido)
    │   ├── model_aves.tflite                ← Modelo original (opcional)
    │   └── labels.txt                       ← Etiquetas del modelo
    └── images/
        ├── avefria_terocsv.jpg
        ├── baltimore_oriole.jpg
        ├── bienteveo_comun.jpg
        ├── ... (32 imágenes de referencia)
```

> 💡 El modelo `BirdNET_6K_GLOBAL_MODEL.tflite` se puede obtener desde el repositorio oficial de BirdNET: https://github.com/kahst/BirdNET-Analyzer

### Paso 4 — Configurar Firebase

Ver sección [Configuración de Firebase](#-configuración-de-firebase) más abajo.

### Paso 5 — Conectar dispositivo o emulador

**Opción A — Dispositivo físico Android:**
1. Activar **Opciones de desarrollador** en el teléfono
2. Activar **Depuración USB**
3. Conectar el cable USB
4. Verificar conexión:
```bash
flutter devices
```

**Opción B — Emulador:**
```bash
# Listar emuladores disponibles
flutter emulators
# Iniciar un emulador
flutter emulators --launch <nombre_emulador>
```

### Paso 6 — Ejecutar la aplicación
```bash
# Modo debug (recomendado para desarrollo)
flutter run --debug

# Modo release (para pruebas de rendimiento)
flutter run --release
```

### Paso 7 — Generar APK para instalar en dispositivo
```bash
flutter build apk --release
# El APK quedará en: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔥 Configuración de Firebase

La app usa Firebase para sincronización en la nube. Sigue estos pasos:

### 1. Crear proyecto en Firebase Console
1. Ir a https://console.firebase.google.com
2. Crear nuevo proyecto → nombre: `aves-app-tolima`
3. Desactivar Google Analytics (opcional)

### 2. Registrar app Android
1. En Firebase Console → **Agregar app → Android**
2. Package name: `com.example.aves_app`
3. Descargar `google-services.json`

### 3. Colocar el archivo de configuración
```
android/
└── app/
    └── src/
        └── google-services.json   ← Aquí va el archivo descargado
```

### 4. Habilitar Firestore
1. En Firebase Console → **Firestore Database**
2. Crear base de datos → Modo de prueba
3. Región recomendada: `us-central1`

### 5. Reglas de Firestore (modo desarrollo)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

---

## 📁 Estructura del proyecto

```
aves_app/
├── android/                        # Configuración Android nativa
│   └── app/
│       ├── src/google-services.json
│       └── build.gradle.kts        # applicationId: com.example.aves_app
├── lib/
│   ├── main.dart                   # Punto de entrada
│   ├── assets/
│   │   ├── models/                 # Modelos TFLite
│   │   └── images/                 # Fotos de referencia de especies
│   ├── Data/
│   │   ├── catalogo_especies.dart  # Info de las 32 especies
│   │   └── species_locations.dart  # Coordenadas GPS en Ibagué
│   ├── Presentation/
│   │   └── UI/
│   │       ├── IdentificarAveScreen.dart   # Pantalla de identificación
│   │       ├── DistribucionAveScreen.dart  # Mapa de distribución
│   │       ├── CatalogoScreen.dart         # Catálogo de especies
│   │       └── HistorialScreen.dart        # Avistamientos guardados
│   └── Services/
│       ├── classifier_service.dart  # BirdClassifier + BirdNetClassifier
│       ├── database_service.dart    # SQLite local
│       ├── firestore_service.dart   # Firebase Firestore
│       └── location_service.dart   # GPS
├── pubspec.yaml                    # Dependencias del proyecto
└── README.md
```

---

## 🤖 Modelos de IA

La app soporta dos modelos de clasificación seleccionables desde la UI:

### Modelo Original (`model_aves.tflite`)
- **Clases:** 16 especies entrenadas manualmente
- **Input:** imagen 380×380 px RGB
- **Estado:** Opcional — se habilita solo si el archivo existe en assets

### BirdNET Tolima (`BirdNET_6K_GLOBAL_MODEL.tflite`)
- **Base:** BirdNET-Analyzer (Cornell Lab of Ornithology)
- **Clases:** 16 especies filtradas del Tolima
- **Input:** imagen 380×380 px RGB
- **Estado:** ✅ Modelo principal (siempre activo)

**Umbral de confianza:** `60%` — por debajo se muestra "No se detectó un ave".

---

## 🦅 Especies soportadas

### Modelo Original — 16 especies
| # | Nombre común | Nombre científico |
|---|---|---|
| 1 | Avefría teroCSV | *Vanellus chilensis* |
| 2 | Baltimore Oriole | *Icterus galbula* |
| 3 | Bienteveo Común | *Pitangus sulphuratus* |
| 4 | Canario coronado | *Sicalis flaveola* |
| 5 | Colibrí Cola Canela | *Amazilia tzacatl* |
| 6 | Fiofío Silbón | *Elaenia flavogaster* |
| 7 | Garza dedos dorados | *Egretta thula* |
| 8 | Jacana | *Jacana jacana* |
| 9 | Luis Pico Grueso | *Megarynchus pitangua* |
| 10 | Papamoscas rayado chico | *Pyrocephalus rubinus* |
| 11 | Saltador Gris | *Saltator coerulescens* |
| 12 | Saltador garganta ocre | *Saltator maximus* |
| 13 | Tangara Azulgris | *Thraupis episcopus* |
| 14 | Torcaza Colorada | *Patagioenas cayennensis* |
| 15 | Vireo Ojos Rojos | *Vireo olivaceus* |
| 16 | Zorzal sabia | *Turdus ignobilis* |

### BirdNET Tolima — 16 especies
| # | Nombre científico | Nombre en inglés |
|---|---|---|
| 1 | *Aburria aburri* | Wattled Guan |
| 2 | *Accipiter bicolor* | Bicolored Hawk |
| 3 | *Adelomyia melanogenys* | Speckled Hummingbird |
| 4 | *Agelaioides badius* | Grayish Baywing |
| 5 | *Agelaius phoeniceus* | Red-winged Blackbird |
| 6 | *Aglaiocercus kingii* | Long-tailed Sylph |
| 7 | *Actitis macularius* | Spotted Sandpiper |
| 8 | *Aegolius harrisii* | Buff-fronted Owl |
| 9 | *Aeronautes montivagus* | White-tipped Swift |
| 10 | *Accipiter striatus* | Sharp-shinned Hawk |
| 11 | *Acropternis orthonyx* | Ocellated Tapaculo |
| 12 | *Accipiter superciliosus* | Tiny Hawk |
| 13 | *Aglaiocercus coelestis* | Violet-tailed Sylph |
| 14 | *Accipiter erythronemius* | Rufous-thighed Hawk |
| 15 | *Accipiter poliogaster* | Gray-bellied Hawk |
| 16 | *Acanthidops bairdi* | Peg-billed Finch |

---

## 🔐 Permisos necesarios

Los siguientes permisos se declaran en `AndroidManifest.xml`:

| Permiso | Uso |
|---|---|
| `CAMERA` | Tomar fotos para identificación |
| `READ_EXTERNAL_STORAGE` | Seleccionar fotos de galería |
| `ACCESS_FINE_LOCATION` | GPS para registrar avistamientos |
| `ACCESS_COARSE_LOCATION` | Ubicación aproximada |
| `INTERNET` | Sincronización con Firebase |

---

## 🔧 Solución de problemas

### ❌ `No matching client found for package name`
```
Asegúrate de que el package name en google-services.json sea:
"package_name": "com.example.aves_app"
```

### ❌ `Unable to load asset: lib/assets/models/model_aves.tflite`
```
Este es el modelo opcional. La app funciona sin él usando BirdNET.
Si tienes el archivo, agrégalo a lib/assets/models/ y decláralo en pubspec.yaml.
```

### ❌ `Gradle task assembleDebug failed`
```bash
flutter clean
flutter pub get
flutter run --debug
```

### ❌ `flutter doctor` muestra errores de licencias
```bash
flutter doctor --android-licenses
# Aceptar todas las licencias con 'y'
```

### ❌ La app no encuentra el emulador
```bash
flutter devices          # Ver dispositivos conectados
adb devices              # Verificar con ADB
adb kill-server          # Reiniciar ADB si es necesario
adb start-server
```

### ❌ Error de versión de Java con Gradle
Asegúrate de tener **JDK 17** configurado en Android Studio:
> File → Project Structure → SDK Location → Gradle JDK → jbr-17

---

## 📦 Dependencias principales

```yaml
flutter: sdk
tflite_flutter: ^0.12.1       # Inferencia con modelos TFLite
image: ^4.1.7                 # Procesamiento de imágenes
image_picker: ^1.2.1          # Cámara y galería
google_maps_flutter: ^2.17.0  # Mapa de distribución
geolocator: ^14.0.2           # GPS
sqflite: ^2.4.2               # Base de datos local
firebase_core: ^3.6.0         # Firebase
cloud_firestore: ^5.4.4       # Base de datos en la nube
connectivity_plus: ^6.0.3     # Estado de conexión
```

---

## 📄 Licencia

Proyecto académico — Universidad del Tolima  
Todos los derechos reservados © 2025 Santiago Lopez, Sebastian Castro
