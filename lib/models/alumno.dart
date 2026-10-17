/// Modelo de datos de un Alumno.
/// Representa lo que el formulario "Registrar Alumno" captura
/// y lo que la pantalla "Listar Alumnos" muestra en cada fila.
class Alumno {
  /// Nota minima para aprobar en la escala 0 - 20.
  /// Segun el mockup: 12 figura como "Aprobado" y 09 como "Desaprobado",
  /// por eso el limite es 11.
  static const int notaMinimaAprobatoria = 11;

  final String nombre;
  final String apellido;
  final int nota;

  const Alumno({
    required this.nombre,
    required this.apellido,
    required this.nota,
  });

  /// Nombre completo que se muestra en la lista (ej: "Ana Torres").
  String get nombreCompleto => '$nombre $apellido';

  /// true si la nota alcanza el minimo aprobatorio.
  /// La pantalla usa este valor para pintar la etiqueta verde o roja.
  bool get aprobado => nota >= notaMinimaAprobatoria;

  /// Nota con dos digitos, como en el mockup ("09" en vez de "9").
  String get notaFormateada => nota.toString().padLeft(2, '0');
}
