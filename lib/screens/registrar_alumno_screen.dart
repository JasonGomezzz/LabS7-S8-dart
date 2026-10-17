import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/alumno.dart';
import '../services/alumno_repository.dart';

/// PANTALLA 4: REGISTRAR ALUMNO
/// Formulario con nombre, apellido y nota (0 - 20). Al presionar GUARDAR
/// valida los datos, crea un Alumno, lo agrega al repositorio y regresa a
/// la pantalla anterior.
class RegistrarAlumnoScreen extends StatefulWidget {
  const RegistrarAlumnoScreen({super.key});

  @override
  State<RegistrarAlumnoScreen> createState() => _RegistrarAlumnoScreenState();
}

class _RegistrarAlumnoScreenState extends State<RegistrarAlumnoScreen> {
  // Llave para validar todo el formulario de una vez.
  final _formKey = GlobalKey<FormState>();

  // Un controller por campo para leer lo que escribio el usuario.
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _notaController = TextEditingController();

  /// Liberar los controllers al cerrar la pantalla.
  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  /// Se ejecuta al presionar GUARDAR.
  void _guardar() {
    // Si algun campo no pasa su validator, se muestran los errores y se corta aqui.
    if (!_formKey.currentState!.validate()) return;

    // Se arma el objeto Alumno con los datos del formulario.
    // int.parse es seguro porque el validator ya comprobo que es un numero.
    final alumno = Alumno(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      nota: int.parse(_notaController.text),
    );

    // Se guarda en el repositorio compartido: la pantalla Listar lo mostrara.
    AlumnoRepository.instancia.agregar(alumno);

    // Mensaje de confirmacion en la parte inferior.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${alumno.nombreCompleto} registrado correctamente')),
    );

    // NAVEGACION: pop regresa a la pantalla anterior (Menu o Listar).
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Flecha de regreso explicita, como en el mockup.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Registrar Alumno'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo NOMBRE
                TextFormField(
                  controller: _nombreController,
                  // Primera letra en mayuscula automaticamente.
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Nombre del alumno'),
                  validator: (valor) => (valor == null || valor.trim().isEmpty)
                      ? 'Ingresa el nombre'
                      : null,
                ),
                const SizedBox(height: 14),

                // Campo APELLIDO
                TextFormField(
                  controller: _apellidoController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Apellido'),
                  validator: (valor) => (valor == null || valor.trim().isEmpty)
                      ? 'Ingresa el apellido'
                      : null,
                ),
                const SizedBox(height: 14),

                // Campo NOTA: solo numeros enteros entre 0 y 20.
                TextFormField(
                  controller: _notaController,
                  keyboardType: TextInputType.number,
                  // inputFormatters impide escribir letras o simbolos.
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Nota (0 - 20)',
                    suffixIcon: Icon(Icons.school),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) return 'Ingresa la nota';
                    final nota = int.tryParse(valor);
                    if (nota == null || nota < 0 || nota > 20) {
                      return 'La nota debe estar entre 0 y 20';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Boton GUARDAR (estilo definido en AppTheme).
                ElevatedButton(
                  onPressed: _guardar,
                  child: const Text('GUARDAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
