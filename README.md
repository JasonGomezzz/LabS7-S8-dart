# LabS7-S8-Gomez — Gestión de Alumnos con Flutter

**Laboratorio Semanas 7 y 8 · Flutter / Dart**

| | |
|---|---|
| **Alumno** | Jason Gomez |
| **Repositorio** | https://github.com/JasonGomezzz/LabS7-S8-dart |
| **Tecnologías** | Flutter 3.47.1 · Dart 3.13.1 · Material 3 |
| **Dispositivo de prueba** | iPhone 17 Pro Max (iOS 27.0.1), compilado con Xcode 27.1 |

## 1. Objetivo

Desarrollar una aplicación móvil en Flutter que implemente las cinco pantallas de la
*Sección A* del mockup entregado por el profesor (Login, Menú, Listar Alumnos, Registrar Alumno
y Perfil), programando el **desplazamiento entre pantallas** y **comentando cada parte del código**
para explicar qué hace.

## 2. Requisitos pedidos por el profesor y dónde se cumplen

| Requisito (pizarra) | Cómo se cumple | Archivo |
|---|---|---|
| Código comentado: qué hace cada parte | Cada clase, método y bloque relevante lleva un comentario explicativo | todo `lib/` |
| Menú con sus opciones | Registrar Alumnos, Listar Alumnos, Perfil y Logout | `lib/screens/menu_screen.dart` |
| Registro de alumno | Formulario con validación (nombre, apellido, nota 0-20) | `lib/screens/registrar_alumno_screen.dart` |
| Listar alumnos | Lista con buscador, nota, etiqueta Aprobado/Desaprobado y eliminación | `lib/screens/listar_alumnos_screen.dart` |
| Perfil | Foto, nombre, correo, teléfono y rol | `lib/screens/perfil_screen.dart` |
| Logout | Diálogo de confirmación y regreso al Login limpiando la pila | `lib/widgets/app_drawer.dart` |
| Icono de las tres rayas (hamburguesa) | Abre un panel lateral (`Drawer`) con las opciones de la app | `lib/widgets/app_drawer.dart` |
| Cómo se programa el desplazamiento entre pantallas | Rutas con nombre y los 4 métodos de `Navigator` (sección 6) | `lib/navigation/app_routes.dart` |
| Imagen **local** y, en otro comentario, **sin local** | `Image.asset` activo y `Image.network` comentado (sección 7) | `lib/widgets/avatar_circular.dart` |
| Verlo en el teléfono iPhone | Compilado en modo release e instalado en el iPhone | — |

## 3. Instalación y ejecución

```bash
git clone https://github.com/JasonGomezzz/LabS7-S8-dart.git
cd LabS7-S8-dart
flutter pub get
flutter run                      # elige el dispositivo (iPhone, simulador, etc.)
flutter run --release -d <id>    # versión que se abre desde el ícono del iPhone
flutter test                     # pruebas
flutter analyze                  # análisis estático
```

Para ver los dispositivos disponibles: `flutter devices`.

**Credenciales de prueba:** el login valida solo el *formato* (email con `@` y `.`, y contraseña de
4 o más caracteres). Por ejemplo `maria@correo.com` / `1234`. No hay servidor, por lo que no se
comprueba que el usuario exista (ver sección 11).

## 4. Estructura del proyecto

```
lib/
├── main.dart                         # Punto de entrada: tema, ruta inicial y tabla de rutas
├── models/
│   ├── alumno.dart                   # Alumno (nombre, apellido, nota) y regla de aprobación
│   └── usuario.dart                  # Usuario del perfil
├── services/
│   ├── alumno_repository.dart        # Datos en memoria (ChangeNotifier, singleton)
│   └── sesion.dart                   # Usuario de la sesión (compartido por Perfil y Drawer)
├── navigation/
│   └── app_routes.dart               # Nombres de ruta y tabla ruta -> pantalla
├── screens/
│   ├── login_screen.dart             # 1. Login
│   ├── menu_screen.dart              # 2. Menú (+ Logout)
│   ├── listar_alumnos_screen.dart    # 3. Listar alumnos
│   ├── registrar_alumno_screen.dart  # 4. Registrar alumno
│   └── perfil_screen.dart            # 5. Perfil
├── widgets/
│   ├── app_drawer.dart               # Panel lateral (tres rayas) y logout compartido
│   └── avatar_circular.dart          # Avatar reutilizable (imagen local / de red)
└── theme/
    └── app_theme.dart                # Colores y estilos globales
assets/images/                        # Avatares locales (PNG)
test/widget_test.dart                 # Pruebas del modelo y del flujo completo
```

## 5. Desarrollo por pantalla

### 5.1 Login — `login_screen.dart`

Pantalla inicial de la app. Es un `StatefulWidget` porque guarda estado que cambia en pantalla
(mostrar u ocultar la contraseña). Usa un `Form` con `TextFormField` y validadores: el email es
obligatorio y debe tener formato válido; la contraseña es obligatoria y de mínimo 4 caracteres.
Si todo es válido, entra al menú con `pushReplacementNamed`. Los `TextEditingController` se liberan
en `dispose()` para no dejar memoria ocupada.

![Login](docs/capturas/01-login.png)

*Validación de campos vacíos o inválidos:*

![Login con errores de validación](docs/capturas/02-login-validacion.png)

### 5.2 Menú — `menu_screen.dart`

Centro de navegación. Cada opción es un `_ItemMenu` (icono, título y flecha) que se reutiliza cuatro
veces en vez de repetir código. Registrar, Listar y Perfil usan `pushNamed`. **Logout** abre un
`AlertDialog` y espera la respuesta con `await`; si el usuario confirma, usa
`pushNamedAndRemoveUntil` para volver al Login y vaciar la pila de pantallas. Las tres rayas de la
barra superior abren el panel lateral (ver 5.6).

![Menú](docs/capturas/03-menu.png)

*Confirmación de Logout:*

![Confirmación de logout](docs/capturas/09-logout-confirmacion.png)

### 5.3 Registrar Alumno — `registrar_alumno_screen.dart`

Formulario con nombre, apellido y nota. La nota solo admite dígitos (`FilteringTextInputFormatter`)
y el validador exige un entero entre 0 y 20. Al presionar **GUARDAR** se crea un `Alumno`, se agrega
al repositorio compartido, se muestra un `SnackBar` de confirmación y se regresa con `pop`.

![Registrar alumno](docs/capturas/04-registrar.png)

*Validación de la nota fuera de rango y campos vacíos:*

![Registrar alumno con errores](docs/capturas/05-registrar-validacion.png)

### 5.4 Listar Alumnos — `listar_alumnos_screen.dart`

Muestra los alumnos del repositorio. Un `ListenableBuilder` escucha al repositorio: cuando se agrega
o elimina un alumno, la lista se redibuja sola. El buscador filtra por nombre completo sin distinguir
mayúsculas. Cada fila tiene la etiqueta **Aprobado** (verde) o **Desaprobado** (rojo), según la nota
mínima de 11, y un menú de tres puntos con la opción *Eliminar*. El botón **+** lleva a Registrar y
las tres rayas abren el panel lateral (ver 5.6).

![Listar alumnos](docs/capturas/06-listar.png)

*Búsqueda en acción:*

![Listar alumnos con búsqueda](docs/capturas/07-listar-busqueda.png)

### 5.5 Perfil — `perfil_screen.dart`

Muestra la foto local, el nombre, el correo, el teléfono y el rol del docente. Usa un `Stack` con
`Positioned` para colocar el círculo morado con el lápiz sobre la foto. Los datos son de ejemplo
(objeto `Usuario` fijo) porque no hay servidor.

![Perfil](docs/capturas/08-perfil.png)

### 5.6 Panel lateral (Drawer) — `app_drawer.dart`

Las tres rayas (hamburguesa) del Menú y de Listar Alumnos abren un panel que se desliza desde la
izquierda. Se activa agregando `drawer: const AppDrawer()` al `Scaffold`: cuando existe un `drawer`,
Flutter coloca el icono de hamburguesa en el `AppBar` y lo conecta solo. El panel muestra la foto
local, el nombre y el correo del usuario (datos de `Sesion`), y las opciones **Menú**, **Registrar
Alumnos**, **Listar Alumnos**, **Perfil** y **Logout**. La opción de la pantalla actual aparece
resaltada y, si se toca, no se apila una pantalla repetida. El logout del panel y el del menú
comparten la misma función `cerrarSesion`.

![Panel lateral abierto](docs/capturas/14-drawer.png)

## 6. Navegación entre pantallas

Las pantallas se registran por nombre en `AppRoutes.tabla` y `MaterialApp` las usa con
`initialRoute` y `routes`.

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
| `pushNamed` | Menú → Registrar / Listar / Perfil; Listar → Registrar | Apila una pantalla encima |
| `pop` | Flechas de regreso, GUARDAR; también cierra el panel lateral | Quita la pantalla actual y vuelve a la anterior |
| `popUntil` | Drawer → Menú | Quita pantallas de la pila hasta llegar al menú, sin apilar uno nuevo |
| `pushNamedAndRemoveUntil` | Logout | Va al login y vacía toda la pila |

```dart
// Login -> Menú (reemplaza el login)
Navigator.pushReplacementNamed(context, AppRoutes.menu);

// Menú -> Registrar (apila encima del menú)
Navigator.pushNamed(context, AppRoutes.registrar);

// Logout: va al login y borra todas las pantallas anteriores
Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (ruta) => false);
```

![Código de navegación en VS Code](docs/capturas/10-codigo-navegacion.png)

## 7. Imágenes: con local y sin local

En `lib/widgets/avatar_circular.dart` se muestran las dos formas de cargar una imagen:

| | Con local | Sin local |
|---|---|---|
| Widget | `Image.asset(...)` | `Image.network(...)` |
| Origen | Archivo dentro de la app (`assets/images/`) | URL en internet |
| Internet | No necesita | Necesita |
| Estado en el código | **Activo** | Comentado |
| Requisito | Declarar `assets/images/` en `pubspec.yaml` | `loadingBuilder` y `errorBuilder` para carga y error |

```dart
// CON LOCAL (activo)
Image.asset('assets/images/avatar_alumno.png', fit: BoxFit.cover)

// SIN LOCAL (comentado en el código)
// Image.network('https://i.pravatar.cc/150?img=5', fit: BoxFit.cover, ...)
```

![Código de imagen local y de red](docs/capturas/11-codigo-imagen-local-red.png)

## 8. Pruebas

`test/widget_test.dart` contiene 4 pruebas:

1. La nota 11 aprueba y la 10 desaprueba.
2. La nota se formatea con dos dígitos (`9` → `09`).
3. **Flujo completo:** login vacío muestra errores → login válido → menú → registrar a "Rosa Vega"
   con nota 8 → aparece en la lista como *Desaprobado* → el buscador filtra → regreso al menú
   desde el panel lateral → logout con confirmación → vuelve al Login.
4. **Panel lateral:** cerrado no está en pantalla; las tres rayas lo abren con el usuario y las
   opciones; "Perfil" navega y cierra el panel; el logout del panel pide confirmación y vuelve al Login.

Resultado: `flutter analyze` sin problemas y `flutter test` con las 4 pruebas en verde.

![Resultado de flutter analyze y flutter test](docs/capturas/12-tests.png)

## 9. Control de versiones

El historial usa commits pequeños y atómicos con Conventional Commits, de las capas base hacia la
interfaz (assets → tema → modelos → servicio → widgets → pantallas → navegación → pruebas → documentación).

![Historial de commits](docs/capturas/13-git-log.png)

## 10. Problemas encontrados y cómo se resolvieron

| Problema | Causa | Solución |
|---|---|---|
| Las tres rayas del menú no hacían nada (el ícono era solo decorativo) y en Listar solo volvían atrás | El mockup las dibuja, pero se había puesto un `Icon` sin acción y un `IconButton` con `pop` | Agregar un `Drawer` (`AppDrawer`) al `Scaffold`: Flutter conecta solo el icono de hamburguesa para abrirlo |
| Aviso del test: "ListTile background color or ink splashes may be invisible" | El fondo del ítem destacado del menú se pintaba con un `Container`, que tapa el efecto de toque del `ListTile` | Usar la propiedad `tileColor` del propio `ListTile` |
| Error al lanzar con `flutter run` en el iPhone ("Failed to find project Runner") | El depurador de Xcode no se pudo adjuntar por conexión inalámbrica en iOS 27 | Compilar en modo `--release`, que no necesita depurador, e instalar la app con `xcrun devicectl` |
| iOS no abría la app: "profile has not been explicitly trusted by the user" | El certificado de desarrollador no estaba confiado en el teléfono | Ajustes → General → VPN y gestión de dispositivos → Confiar |
| Aviso "En iOS 14+, las apps Flutter en modo debug solo pueden lanzarse desde herramientas de Flutter" | Una app en modo debug no se puede abrir desde el ícono | Instalar la versión release (o profile), que sí abre desde la pantalla de inicio |

## 11. Decisiones y limitaciones

- **Imagen local / sin local:** se interpretó la indicación de la pizarra como `Image.asset` (con
  local, activo) e `Image.network` (sin local, en comentario). Los avatares PNG del proyecto se
  generaron para este laboratorio con el estilo del mockup.
- **Nota aprobatoria = 11:** el mockup muestra 12 como *Aprobado* y 09 como *Desaprobado*, y en la
  escala 0-20 el mínimo aprobatorio es 11.
- **Datos en memoria:** los alumnos viven en `AlumnoRepository` y se pierden al cerrar la app. Se
  evitó una base de datos porque el laboratorio se centra en pantallas y navegación.
- **Login simulado:** valida el formato de los campos, pero no verifica credenciales contra un
  servidor ni guarda sesión. Cualquier email válido con contraseña de 4+ caracteres entra.
- **Perfil de ejemplo:** el usuario "María González" es un dato fijo. El botón *Editar perfil* solo
  muestra un aviso.

## 12. Índice de capturas

| # | Archivo | Qué muestra |
|---|---|---|
| 01 | `docs/capturas/01-login.png` | Pantalla de Login en el iPhone |
| 02 | `docs/capturas/02-login-validacion.png` | Login con errores de validación |
| 03 | `docs/capturas/03-menu.png` | Menú principal |
| 04 | `docs/capturas/04-registrar.png` | Formulario Registrar Alumno |
| 05 | `docs/capturas/05-registrar-validacion.png` | Registrar con errores de validación |
| 06 | `docs/capturas/06-listar.png` | Lista de alumnos con el alumno nuevo |
| 07 | `docs/capturas/07-listar-busqueda.png` | Lista filtrada con el buscador |
| 08 | `docs/capturas/08-perfil.png` | Perfil |
| 09 | `docs/capturas/09-logout-confirmacion.png` | Diálogo de confirmación de Logout |
| 10 | `docs/capturas/10-codigo-navegacion.png` | Código de navegación comentado en VS Code |
| 11 | `docs/capturas/11-codigo-imagen-local-red.png` | Código de imagen local y de red en VS Code |
| 12 | `docs/capturas/12-tests.png` | Salida de `flutter analyze` y `flutter test` |
| 13 | `docs/capturas/13-git-log.png` | Salida de `git log --oneline` |
| 14 | `docs/capturas/14-drawer.png` | Panel lateral abierto desde las tres rayas |

## 13. Conclusiones

<!-- BORRADOR: edítalas con tus propias palabras antes de entregar. -->

1. Las rutas con nombre (`AppRoutes`) concentran la navegación en un solo archivo y evitan errores de
   tipeo. Elegir bien el método de `Navigator` cambia el comportamiento: con `pushReplacementNamed`
   el botón "atrás" no vuelve al login, y con `pushNamedAndRemoveUntil` el logout deja la pila vacía.
2. Separar el repositorio de alumnos de las pantallas permitió que Registrar y Listar compartan datos
   sin pasarse parámetros: Registrar agrega y la lista se actualiza sola gracias a `ChangeNotifier`.
3. Una imagen local (`Image.asset`) es más rápida y funciona sin internet, pero hay que declararla en
   `pubspec.yaml`. Una imagen de red (`Image.network`) no pesa en la app, pero depende de la conexión y
   obliga a manejar los estados de carga y error.
4. Probar en un iPhone real mostró cosas que el código no muestra: confiar en el certificado de
   desarrollador, y que una app en modo debug no se puede abrir desde el ícono. La prueba automática
   del flujo completo también detectó un problema visual real (el fondo del `ListTile` en el menú).
