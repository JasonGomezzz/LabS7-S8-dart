import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import '../theme/app_theme.dart';

/// PANTALLA 2: MENU
/// Es el centro de navegacion: desde aqui se llega a Registrar Alumnos,
/// Listar Alumnos, Perfil y se cierra la sesion (Logout).
/// No tiene estado propio, por eso es un StatelessWidget.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  /// LOGOUT: pregunta confirmacion y, si acepta, vuelve al Login.
  Future<void> _cerrarSesion(BuildContext context) async {
    // showDialog muestra una ventana emergente y espera (await) la respuesta:
    // devuelve true si el usuario presiono "Cerrar sesión", false/null si cancelo.
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas salir de la aplicación?'),
        actions: [
          TextButton(
            // Navigator.pop(contexto, valor) cierra el dialogo y devuelve "valor".
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    // Despues de un await hay que comprobar que la pantalla siga viva
    // (context.mounted) antes de usar el context otra vez.
    if (confirmar == true && context.mounted) {
      // NAVEGACION: pushNamedAndRemoveUntil va al login y BORRA toda la pila
      // de pantallas anteriores (el "(ruta) => false" significa "no conserves ninguna").
      // Asi, tras el logout, el boton "atras" no regresa al menu.
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (ruta) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Icono de hamburguesa decorativo, igual que en el mockup.
        leading: const Icon(Icons.menu),
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
            onTap: () => _cerrarSesion(context),
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
