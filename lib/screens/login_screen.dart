import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import '../theme/app_theme.dart';

/// PANTALLA 1: LOGIN
/// Es la pantalla inicial de la app. Pide email y contrasena y, si los datos
/// son validos, navega al Menu.
///
/// Es un StatefulWidget porque tiene estado que cambia en pantalla:
/// si la contrasena se ve u oculta (el icono del ojo).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // La llave del formulario permite ejecutar todas las validaciones juntas
  // con _formKey.currentState!.validate().
  final _formKey = GlobalKey<FormState>();

  // Controllers: objetos que permiten leer lo que el usuario escribio.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // true = la contrasena se muestra como puntos; false = se ve el texto.
  bool _ocultarPassword = true;

  /// Los controllers consumen memoria: hay que liberarlos cuando la pantalla
  /// se destruye (por ejemplo, al hacer login y reemplazarla por el menu).
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Se ejecuta al presionar el boton LOGIN.
  void _iniciarSesion() {
    // validate() corre el validator de cada campo; si alguno devuelve un
    // mensaje de error, lo muestra en rojo y retorna false.
    if (!_formKey.currentState!.validate()) return;

    // NAVEGACION: pushReplacementNamed REEMPLAZA la pantalla actual por el menu.
    // Asi el login sale de la pila de pantallas y, si el usuario presiona
    // "atras" estando en el menu, NO vuelve al login (tendria que usar Logout).
    Navigator.pushReplacementNamed(context, AppRoutes.menu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea evita que el contenido quede debajo del notch/Dynamic Island del iPhone.
      body: SafeArea(
        // SingleChildScrollView permite hacer scroll cuando aparece el teclado,
        // para que no salga el error de "overflow" amarillo y negro.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Icono de birrete (graduacion) que hace de logo.
                const Icon(Icons.school, size: 72, color: AppColors.primario),
                const SizedBox(height: 12),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tus credenciales para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textoSecundario),
                ),
                const SizedBox(height: 28),

                // Campo EMAIL
                TextFormField(
                  controller: _emailController,
                  // Muestra el teclado con la tecla "@" a la mano.
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  // Regla: obligatorio y con formato basico de correo.
                  validator: (valor) {
                    final email = valor?.trim() ?? '';
                    if (email.isEmpty) return 'Ingresa tu email';
                    if (!email.contains('@') || !email.contains('.')) {
                      return 'Ingresa un email válido';
                    }
                    return null; // null = el campo es valido
                  },
                ),
                const SizedBox(height: 14),

                // Campo PASSWORD con boton de ojo para mostrar/ocultar.
                TextFormField(
                  controller: _passwordController,
                  obscureText: _ocultarPassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      // setState avisa a Flutter que redibuje la pantalla
                      // con el nuevo valor de _ocultarPassword.
                      onPressed: () =>
                          setState(() => _ocultarPassword = !_ocultarPassword),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    if (valor.length < 4) return 'Mínimo 4 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Boton LOGIN (estilo definido en AppTheme).
                ElevatedButton(
                  onPressed: _iniciarSesion,
                  child: const Text('LOGIN'),
                ),
                const SizedBox(height: 14),

                // Enlace de recuperacion: aun no hay backend, solo muestra un aviso.
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recuperación de contraseña no disponible'),
                      ),
                    );
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
