import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab_s7_s8_gomez/main.dart';
import 'package:lab_s7_s8_gomez/models/alumno.dart';

void main() {
  group('Alumno', () {
    test('aprueba desde la nota 11', () {
      expect(const Alumno(nombre: 'A', apellido: 'B', nota: 11).aprobado, isTrue);
      expect(const Alumno(nombre: 'A', apellido: 'B', nota: 10).aprobado, isFalse);
    });

    test('formatea la nota con dos digitos', () {
      expect(const Alumno(nombre: 'A', apellido: 'B', nota: 9).notaFormateada, '09');
    });
  });

  testWidgets('flujo: login, menu, registrar alumno, listar y logout',
      (tester) async {
    await tester.pumpWidget(const AlumnosApp());

    // 1. LOGIN: sin datos muestra errores y no navega.
    await tester.tap(find.text('LOGIN'));
    await tester.pump();
    expect(find.text('Ingresa tu email'), findsOneWidget);

    // Con datos validos pasa al menu.
    await tester.enterText(find.byType(EditableText).at(0), 'maria@correo.com');
    await tester.enterText(find.byType(EditableText).at(1), '1234');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    expect(find.text('Menú'), findsOneWidget);

    // 2. MENU -> 4. REGISTRAR ALUMNO
    await tester.tap(find.text('Registrar Alumnos'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Rosa');
    await tester.enterText(find.byType(EditableText).at(1), 'Vega');
    await tester.enterText(find.byType(EditableText).at(2), '8');
    await tester.tap(find.text('GUARDAR'));
    await tester.pumpAndSettle();

    // 3. LISTAR ALUMNOS: el alumno nuevo aparece como Desaprobado.
    await tester.tap(find.text('Listar Alumnos'));
    await tester.pumpAndSettle();
    expect(find.text('Rosa Vega'), findsOneWidget);
    expect(find.text('Nota: 08'), findsOneWidget);
    expect(find.text('Desaprobado'), findsNWidgets(2)); // María López y Rosa Vega

    // El buscador filtra la lista.
    await tester.enterText(find.byType(EditableText), 'ana');
    await tester.pumpAndSettle();
    expect(find.text('Ana Torres'), findsOneWidget);
    expect(find.text('Rosa Vega'), findsNothing);

    // Regresa al menu y hace LOGOUT.
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión').last);
    await tester.pumpAndSettle();
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
