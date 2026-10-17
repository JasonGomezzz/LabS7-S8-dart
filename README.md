# LabS7-S8-Gomez

App móvil en **Flutter / Dart** para gestionar alumnos (Laboratorio Semanas 7 y 8).
Implementa las 5 pantallas de la *Sección A* del mockup: Login, Menú, Listar Alumnos,
Registrar Alumno y Perfil, con navegación entre pantallas y código comentado.

## Pantallas y navegación

```
Login ──(LOGIN)──▶ Menú ──▶ Registrar Alumnos ──(GUARDAR)──▶ vuelve
                     │
                     ├────▶ Listar Alumnos ──(+)──▶ Registrar Alumno
                     │
                     ├────▶ Perfil
                     │
                     └────▶ Logout ──(confirmar)──▶ Login
```

| Método de `Navigator` | Dónde se usa | Qué hace |
|---|---|---|
| `pushReplacementNamed` | Login → Menú | Reemplaza el login; "atrás" no regresa a él |
| `pushNamed` | Menú → Registrar / Listar / Perfil, Listar → Registrar | Apila una pantalla encima |
| `pop` | Flechas de regreso, GUARDAR | Quita la pantalla actual |
| `pushNamedAndRemoveUntil` | Logout | Va al login y vacía toda la pila |

## Imágenes: local vs. red

`lib/widgets/avatar_circular.dart` muestra las dos formas:

- **Con local** (activa): `Image.asset('assets/images/avatar_alumno.png')`. Requiere declarar
  `assets/images/` en `pubspec.yaml`.
- **Sin local** (comentada): `Image.network('https://...')`, con `loadingBuilder` y `errorBuilder`.

## Estructura

```
lib/
├── main.dart                     # Punto de entrada, tema y rutas
├── models/                       # Alumno, Usuario
├── services/alumno_repository.dart   # Datos en memoria (ChangeNotifier)
├── navigation/app_routes.dart    # Nombres y tabla de rutas
├── screens/                      # Las 5 pantallas
├── widgets/avatar_circular.dart  # Avatar reutilizable
└── theme/app_theme.dart          # Colores y estilos globales
assets/images/                    # Avatares locales
test/widget_test.dart             # Pruebas del modelo y del flujo completo
```

## Ejecutar

```bash
flutter pub get
flutter run            # elige el dispositivo (iPhone, simulador, etc.)
flutter test           # pruebas
flutter analyze        # análisis estático
```

Para probar el login, cualquier email válido (con `@` y `.`) y una contraseña de 4+ caracteres.
