import 'package:flutter/material.dart';

import '../screens/listar_alumnos_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/registrar_alumno_screen.dart';

/// Nombres de las rutas (pantallas) de la app.
/// Se usan como constantes para evitar errores de tipeo: en vez de escribir
/// '/menu' a mano en varios archivos, se escribe AppRoutes.menu.
class AppRoutes {
  static const String login = '/';
  static const String menu = '/menu';
  static const String alumnos = '/alumnos';
  static const String registrar = '/registrar';
  static const String perfil = '/perfil';

  /// Tabla de rutas: asocia cada nombre con la pantalla que debe construir.
  /// MaterialApp la recibe en el parametro `routes` y la usa cada vez que
  /// se llama a Navigator.pushNamed(context, nombreDeRuta).
  static Map<String, WidgetBuilder> get tabla => {
        login: (_) => const LoginScreen(),
        menu: (_) => const MenuScreen(),
        alumnos: (_) => const ListarAlumnosScreen(),
        registrar: (_) => const RegistrarAlumnoScreen(),
        perfil: (_) => const PerfilScreen(),
      };
}
