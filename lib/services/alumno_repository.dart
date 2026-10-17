import 'package:flutter/foundation.dart';

import '../models/alumno.dart';

/// Repositorio de alumnos EN MEMORIA (no usa base de datos ni internet).
///
/// Es la "fuente unica de datos" de la app: la pantalla "Registrar Alumno"
/// agrega aqui y la pantalla "Listar Alumnos" lee de aqui.
/// Extiende ChangeNotifier para avisar a la lista cuando los datos cambian
/// y que se redibuje sola, sin tener que pasar datos entre pantallas.
class AlumnoRepository extends ChangeNotifier {
  // Singleton: siempre se usa la MISMA instancia en toda la app.
  // Si cada pantalla creara su propio repositorio, no compartirian los datos.
  AlumnoRepository._();
  static final AlumnoRepository instancia = AlumnoRepository._();

  // Datos iniciales: los mismos 4 alumnos que aparecen en el mockup.
  final List<Alumno> _alumnos = [
    const Alumno(nombre: 'Ana', apellido: 'Torres', nota: 18),
    const Alumno(nombre: 'Luis', apellido: 'García', nota: 12),
    const Alumno(nombre: 'María', apellido: 'López', nota: 9),
    const Alumno(nombre: 'Carlos', apellido: 'Ruiz', nota: 15),
  ];

  /// Lista de solo lectura: las pantallas no pueden modificarla directamente,
  /// deben pasar por agregar() / eliminar() para que se notifique el cambio.
  List<Alumno> get alumnos => List.unmodifiable(_alumnos);

  /// Agrega un alumno al final de la lista y avisa a los oyentes (la lista).
  void agregar(Alumno alumno) {
    _alumnos.add(alumno);
    notifyListeners();
  }

  /// Elimina un alumno (se usa desde el menu de tres puntos de cada fila).
  void eliminar(Alumno alumno) {
    _alumnos.remove(alumno);
    notifyListeners();
  }

  /// Filtra por nombre completo ignorando mayusculas (para la barra "Buscar alumno...").
  /// Si el texto esta vacio devuelve todos los alumnos.
  List<Alumno> buscar(String texto) {
    final consulta = texto.trim().toLowerCase();
    if (consulta.isEmpty) return alumnos;
    return _alumnos
        .where((a) => a.nombreCompleto.toLowerCase().contains(consulta))
        .toList();
  }
}
