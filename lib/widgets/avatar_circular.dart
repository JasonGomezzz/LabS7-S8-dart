import 'package:flutter/material.dart';

/// Avatar redondo reutilizable (alumnos en la lista y foto de perfil).
///
/// Aqui se muestran las DOS formas de cargar una imagen en Flutter,
/// que es lo que pidio el profesor:
///   1) CON LOCAL  -> Image.asset(...)   : el archivo viaja dentro de la app
///                                         (carpeta assets/ declarada en pubspec.yaml).
///   2) SIN LOCAL  -> Image.network(...) : la imagen se descarga de internet por URL.
class AvatarCircular extends StatelessWidget {
  /// Ruta del archivo local, ej: 'assets/images/avatar_alumno.png'.
  final String rutaAsset;

  /// Diametro del circulo en pixeles logicos.
  final double tamano;

  const AvatarCircular({
    super.key,
    required this.rutaAsset,
    this.tamano = 44,
  });

  @override
  Widget build(BuildContext context) {
    // ClipOval recorta cualquier hijo en forma de circulo.
    return ClipOval(
      child: SizedBox(
        width: tamano,
        height: tamano,

        // ============ OPCION 1: IMAGEN LOCAL (la que usamos) ============
        // Image.asset lee el PNG desde la carpeta assets/images del proyecto.
        // - Funciona sin internet.
        // - Carga instantanea porque la imagen ya esta empaquetada en la app.
        // - BoxFit.cover hace que la imagen llene el circulo sin deformarse.
        child: Image.asset(
          rutaAsset,
          fit: BoxFit.cover,
        ),

        // ============ OPCION 2: IMAGEN SIN LOCAL (de internet) ============
        // Image.network descarga la imagen desde una URL cuando se muestra.
        // - Necesita conexion a internet.
        // - Mientras descarga hay que mostrar algo (loadingBuilder) y si falla
        //   (sin red o URL mala) mostramos un icono (errorBuilder).
        // Para probarla: comenta la opcion 1 y descomenta este bloque.
        //
        // child: Image.network(
        //   'https://i.pravatar.cc/150?img=5',
        //   fit: BoxFit.cover,
        //   loadingBuilder: (context, child, progreso) {
        //     // progreso == null significa que la imagen ya termino de cargar.
        //     if (progreso == null) return child;
        //     return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        //   },
        //   errorBuilder: (context, error, stackTrace) =>
        //       const Icon(Icons.person, color: Colors.grey),
        // ),
      ),
    );
  }
}
