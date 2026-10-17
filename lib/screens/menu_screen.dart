import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';

/// PANTALLA 2: MENU
/// Es el centro de navegacion: desde aqui se llega a Registrar Alumnos,
/// Listar Alumnos, Perfil y se cierra la sesion (Logout).
/// No tiene estado propio, por eso es un StatelessWidget.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Panel lateral: al tener `drawer`, el AppBar muestra solo el icono de
      // hamburguesa (tres rayas) y al tocarlo se desliza el panel desde la izquierda.
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Menú'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          // Cada opcion es un _ItemMenu: icono + titulo + flecha.
          _ItemMenu(
            icono: Icons.person_add_alt_1,
            titulo: 'Registrar Alumnos',
            destacado: true, // fondo morado suave, como en el mockup
            // pushNamed APILA la pantalla nueva encima del menu;
            // al volver con "atras" se regresa al menu.
            onTap: () => Navigator.pushNamed(context, AppRoutes.registrar),
          ),
          _ItemMenu(
            icono: Icons.format_list_bulleted,
            titulo: 'Listar Alumnos',
            onTap: () => Navigator.pushNamed(context, AppRoutes.alumnos),
          ),
          _ItemMenu(
            icono: Icons.person,
            titulo: 'Perfil',
            onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
          ),
          _ItemMenu(
            icono: Icons.logout,
            titulo: 'Logout',
            colorIcono: AppColors.desaprobado,
            // cerrarSesion (en app_drawer.dart) pregunta confirmacion y vuelve al Login.
            onTap: () => cerrarSesion(context),
          ),
        ],
      ),
    );
  }
}

/// Fila reutilizable del menu. Se separa en su propio widget para no repetir
/// el mismo codigo 4 veces: solo cambian el icono, el titulo y la accion.
class _ItemMenu extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final VoidCallback onTap; // funcion que se ejecuta al tocar la fila
  final bool destacado;
  final Color colorIcono;

  const _ItemMenu({
    required this.icono,
    required this.titulo,
    required this.onTap,
    this.destacado = false,
    this.colorIcono = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor pinta el fondo SIN tapar el efecto de toque (ripple).
      // Si usaramos un Container con color, taparia ese efecto visual.
      // Si esta destacado se pinta el fondo; si no, queda transparente.
      tileColor: destacado ? AppColors.primarioSuave : null,
      leading: Icon(icono, color: colorIcono),
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
