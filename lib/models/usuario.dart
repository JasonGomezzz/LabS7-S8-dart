/// Modelo del usuario que inicia sesion (docente).
/// Sus datos se muestran en la pantalla "Perfil".
class Usuario {
  final String nombre;
  final String email;
  final String telefono;
  final String rol;

  const Usuario({
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.rol,
  });
}
