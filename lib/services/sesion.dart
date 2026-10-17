import '../models/usuario.dart';

/// Datos de la sesion actual.
/// Se centralizan aqui para que el Perfil y el panel lateral (Drawer) muestren
/// el MISMO usuario sin repetir los datos en dos archivos.
class Sesion {
  // Datos de ejemplo (mock) del docente. En una app real vendrian del
  // backend o de la sesion guardada al hacer login.
  static const Usuario usuarioActual = Usuario(
    nombre: 'María González',
    email: 'maria.gonzalez@correo.com',
    telefono: '912345678',
    rol: 'Docente',
  );
}
