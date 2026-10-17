import 'package:flutter/material.dart';

import '../models/alumno.dart';
import '../navigation/app_routes.dart';
import '../services/alumno_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_circular.dart';

/// PANTALLA 3: LISTAR ALUMNOS
/// Muestra todos los alumnos del repositorio con su nota y una etiqueta
/// verde (Aprobado) o roja (Desaprobado). Tiene buscador y boton "+" para
/// ir a registrar un alumno nuevo.
///
/// Es StatefulWidget porque guarda el texto que se escribe en el buscador.
class ListarAlumnosScreen extends StatefulWidget {
  const ListarAlumnosScreen({super.key});

  @override
  State<ListarAlumnosScreen> createState() => _ListarAlumnosScreenState();
}

class _ListarAlumnosScreenState extends State<ListarAlumnosScreen> {
  // Texto actual del buscador "Buscar alumno...".
  String _busqueda = '';

  // Atajo a la unica instancia del repositorio (singleton).
  final _repo = AlumnoRepository.instancia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Hamburguesa: vuelve al menu (pop = quitar esta pantalla de la pila).
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Alumnos'),
        actions: [
          // Boton "+": abre la pantalla Registrar Alumno.
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.registrar),
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------- Buscador ----------
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar alumno...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFF1F1F5),
              ),
              // onChanged se dispara con cada letra escrita; con setState
              // guardamos el texto y la lista se redibuja filtrada.
              onChanged: (texto) => setState(() => _busqueda = texto),
            ),
          ),

          // ---------- Lista ----------
          Expanded(
            // ListenableBuilder escucha al repositorio: cuando se agrega o
            // elimina un alumno (notifyListeners), este builder se vuelve a
            // ejecutar y la lista se actualiza sola.
            child: ListenableBuilder(
              listenable: _repo,
              builder: (context, _) {
                final alumnos = _repo.buscar(_busqueda);

                // Estado vacio: ningun alumno coincide con la busqueda.
                if (alumnos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron alumnos',
                      style: TextStyle(color: AppColors.textoSecundario),
                    ),
                  );
                }

                // ListView.separated construye solo las filas visibles
                // (eficiente) y dibuja una linea divisoria entre ellas.
                return ListView.separated(
                  itemCount: alumnos.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, indice) =>
                      _FilaAlumno(alumno: alumnos[indice]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Una fila de la lista: avatar, nombre, nota, etiqueta de estado y menu "⋮".
class _FilaAlumno extends StatelessWidget {
  final Alumno alumno;

  const _FilaAlumno({required this.alumno});

  @override
  Widget build(BuildContext context) {
    // Segun el estado se eligen los colores de la etiqueta.
    final colorTexto =
        alumno.aprobado ? AppColors.aprobado : AppColors.desaprobado;
    final colorFondo =
        alumno.aprobado ? AppColors.aprobadoFondo : AppColors.desaprobadoFondo;

    return ListTile(
      // Imagen LOCAL del alumno (ver AvatarCircular para la version de red).
      leading: const AvatarCircular(rutaAsset: 'assets/images/avatar_alumno.png'),
      title: Text(
        alumno.nombreCompleto,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Nota: ${alumno.notaFormateada}'),
      // trailing con Row mainAxisSize.min: etiqueta + tres puntos juntos a la derecha.
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Etiqueta Aprobado / Desaprobado.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colorFondo,
              border: Border.all(color: colorTexto),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              alumno.aprobado ? 'Aprobado' : 'Desaprobado',
              style: TextStyle(color: colorTexto, fontSize: 11),
            ),
          ),
          // Menu desplegable de tres puntos con la opcion Eliminar.
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (opcion) {
              if (opcion == 'eliminar') {
                AlumnoRepository.instancia.eliminar(alumno);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${alumno.nombreCompleto} eliminado')),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
    );
  }
}
