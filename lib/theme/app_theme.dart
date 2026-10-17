import 'package:flutter/material.dart';

/// Paleta de colores de la app, tomada del mockup del profesor.
/// Se centralizan aqui para no repetir codigos hexadecimales en cada pantalla:
/// si queremos cambiar el color principal, se cambia en un solo lugar.
class AppColors {
  // Color principal (morado/indigo): barras superiores, botones y acentos.
  static const Color primario = Color(0xFF5B48C8);

  // Fondo suave del item seleccionado en el menu ("Registrar Alumnos").
  static const Color primarioSuave = Color(0xFFE9E6FA);

  // Colores de las etiquetas de estado en la lista de alumnos.
  static const Color aprobado = Color(0xFF2E9E5B);
  static const Color aprobadoFondo = Color(0xFFE6F6EC);
  static const Color desaprobado = Color(0xFFE5484D);
  static const Color desaprobadoFondo = Color(0xFFFDECEC);

  // Color de bordes y separadores de las listas y campos de texto.
  static const Color borde = Color(0xFFDDDDE5);

  // Gris de los textos secundarios (subtitulos, hints).
  static const Color textoSecundario = Color(0xFF6B6B7B);
}

/// Tema global (ThemeData) que se asigna al MaterialApp en main.dart.
/// Define una sola vez el estilo de AppBar, botones y campos de texto
/// para que todas las pantallas se vean iguales sin repetir estilos.
class AppTheme {
  static ThemeData get claro {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primario),
      scaffoldBackgroundColor: Colors.white,

      // Barra superior morada con texto e iconos blancos (como en el mockup).
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Botones principales (LOGIN, GUARDAR): morado, ancho completo y esquinas redondeadas.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primario,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Boton con borde (EDITAR PERFIL): texto morado y contorno morado.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primario,
          minimumSize: const Size.fromHeight(44),
          side: const BorderSide(color: AppColors.primario),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // Campos de texto: borde gris fino que se vuelve morado al enfocarse.
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textoSecundario),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primario, width: 1.5),
        ),
      ),
    );
  }
}
