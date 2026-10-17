import 'package:flutter/material.dart';

import '../services/sesion.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_circular.dart';

/// PANTALLA 5: PERFIL
/// Muestra los datos del usuario que inicio sesion: foto, nombre, correo,
/// telefono y rol. No tiene estado propio (solo muestra datos), por eso es Stateless.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Flecha para regresar a la pantalla anterior (el menu).
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Perfil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Stack apila widgets uno encima de otro: la foto abajo y el
              // circulo morado con el lapiz (editar) en la esquina inferior derecha.
              Stack(
                children: [
                  // Foto de perfil LOCAL (assets/images/avatar_perfil.png).
                  const AvatarCircular(
                    rutaAsset: 'assets/images/avatar_perfil.png',
                    tamano: 96,
                  ),
                  // Positioned ubica el hijo respecto a las esquinas del Stack.
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primario,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                Sesion.usuarioActual.nombre,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                Sesion.usuarioActual.email,
                style: const TextStyle(color: AppColors.textoSecundario),
              ),
              const SizedBox(height: 20),
              const Divider(),

              // Filas de datos: icono + etiqueta a la izquierda, valor a la derecha.
              _FilaDato(icono: Icons.person, etiqueta: 'Nombre', valor: Sesion.usuarioActual.nombre),
              _FilaDato(icono: Icons.email, etiqueta: 'Email', valor: Sesion.usuarioActual.email),
              _FilaDato(icono: Icons.phone, etiqueta: 'Teléfono', valor: Sesion.usuarioActual.telefono),
              _FilaDato(icono: Icons.settings, etiqueta: 'Roles', valor: Sesion.usuarioActual.rol),
              const SizedBox(height: 20),

              // Boton con borde (OutlinedButton, estilo en AppTheme).
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edición de perfil próximamente')),
                  );
                },
                child: const Text('EDITAR PERFIL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fila reutilizable de la lista de datos del perfil.
class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _FilaDato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icono, size: 20, color: Colors.black54),
              const SizedBox(width: 12),
              Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.w600)),
              // Spacer empuja el valor hacia el extremo derecho de la fila.
              const Spacer(),
              Flexible(
                child: Text(
                  valor,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textoSecundario),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
