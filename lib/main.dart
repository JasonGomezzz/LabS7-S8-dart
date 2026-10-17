import 'package:flutter/material.dart';

import 'navigation/app_routes.dart';
import 'theme/app_theme.dart';

/// PUNTO DE ENTRADA de toda app Flutter: lo primero que se ejecuta.
void main() {
  // runApp infla el widget raiz y lo dibuja en pantalla.
  runApp(const AlumnosApp());
}

/// Widget raiz de la aplicacion.
/// Configura el tema, la pantalla inicial y la tabla de rutas (navegacion).
class AlumnosApp extends StatelessWidget {
  const AlumnosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp activa Material Design y el sistema de navegacion (Navigator).
    return MaterialApp(
      title: 'Gestión de Alumnos',
      // Quita la cinta roja "DEBUG" de la esquina superior.
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,

      // Primera pantalla que se muestra al abrir la app: el Login.
      initialRoute: AppRoutes.login,

      // Mapa nombre-de-ruta -> pantalla. Con esto funcionan todos los
      // Navigator.pushNamed(context, AppRoutes.xxx) de las pantallas.
      routes: AppRoutes.tabla,
    );
  }
}
