import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import '../services/sesion.dart';
import '../theme/app_theme.dart';
import 'avatar_circular.dart';

/// LOGOUT compartido: lo usan la opcion "Logout" del Menu y la del panel lateral.
/// Pregunta confirmacion y, si el usuario acepta, vuelve al Login.
Future<void> cerrarSesion(BuildContext context) async {
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

/// PANEL LATERAL (Drawer): se desliza desde la izquierda al tocar el icono de
/// las tres rayas (hamburguesa) de la barra superior.
///
/// Se usa asi en el Scaffold de una pantalla:  drawer: const AppDrawer()
/// Cuando un Scaffold tiene `drawer`, Flutter pone el icono de hamburguesa
/// automaticamente en el AppBar y lo conecta para abrir este panel.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  /// Navega a una opcion del panel.
  void _ir(BuildContext context, String ruta) {
    // Se guarda el Navigator ANTES de cerrar el panel, porque despues de
    // cerrarlo el context de este item ya no es seguro de usar.
    final navegador = Navigator.of(context);
    final rutaActual = ModalRoute.of(context)?.settings.name;

    // Cierra el panel lateral (el drawer se cierra con pop).
    navegador.pop();

    // Si ya estamos en esa pantalla, no se apila otra igual encima.
    if (ruta == rutaActual) return;

    if (ruta == AppRoutes.menu) {
      // "Menu" es la pantalla base: popUntil quita pantallas de la pila
      // hasta llegar a ella, en vez de apilar un menu nuevo.
      navegador.popUntil(ModalRoute.withName(AppRoutes.menu));
    } else {
      navegador.pushNamed(ruta);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nombre de la ruta de la pantalla actual: sirve para resaltar su opcion.
    final rutaActual = ModalRoute.of(context)?.settings.name;
    final usuario = Sesion.usuarioActual;

    return Drawer(
      child: Column(
        children: [
          // Cabecera morada con la foto (imagen LOCAL), el nombre y el correo.
          Container(
            width: double.infinity,
            color: AppColors.primario,
            // SafeArea evita que la cabecera quede debajo de la hora/notch del iPhone.
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AvatarCircular(
                      rutaAsset: 'assets/images/avatar_perfil.png',
                      tamano: 64,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      usuario.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      usuario.email,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Opciones de navegacion. `selected` resalta la pantalla donde estamos.
          _OpcionDrawer(
            icono: Icons.home,
            titulo: 'Menú',
            seleccionada: rutaActual == AppRoutes.menu,
            onTap: () => _ir(context, AppRoutes.menu),
          ),
          _OpcionDrawer(
            icono: Icons.person_add_alt_1,
            titulo: 'Registrar Alumnos',
            seleccionada: rutaActual == AppRoutes.registrar,
            onTap: () => _ir(context, AppRoutes.registrar),
          ),
          _OpcionDrawer(
            icono: Icons.format_list_bulleted,
            titulo: 'Listar Alumnos',
            seleccionada: rutaActual == AppRoutes.alumnos,
            onTap: () => _ir(context, AppRoutes.alumnos),
          ),
          _OpcionDrawer(
            icono: Icons.person,
            titulo: 'Perfil',
            seleccionada: rutaActual == AppRoutes.perfil,
            onTap: () => _ir(context, AppRoutes.perfil),
          ),

          // Spacer empuja el Logout al final del panel.
          const Spacer(),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: _OpcionDrawer(
              icono: Icons.logout,
              titulo: 'Logout',
              colorIcono: AppColors.desaprobado,
              // El panel queda abierto debajo del dialogo: si el usuario cancela,
              // sigue en el panel; si confirma, se vacia toda la pila.
              onTap: () => cerrarSesion(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila reutilizable del panel lateral (icono + titulo).
class _OpcionDrawer extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final VoidCallback onTap;
  final bool seleccionada;
  final Color? colorIcono;

  const _OpcionDrawer({
    required this.icono,
    required this.titulo,
    required this.onTap,
    this.seleccionada = false,
    this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono, color: colorIcono),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
      // selected + selectedColor/selectedTileColor pintan la opcion actual en morado.
      selected: seleccionada,
      selectedColor: AppColors.primario,
      selectedTileColor: AppColors.primarioSuave,
      onTap: onTap,
    );
  }
}
