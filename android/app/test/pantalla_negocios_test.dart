import 'dart:convert';
import 'package:directorio_dolores/datos/negocios_api.dart';
import 'package:directorio_dolores/presentacion/negocios_viewmodel.dart';
import 'package:directorio_dolores/presentacion/pantalla_negocios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('Ronda 5 - UI y Pruebas de Widgets', () {
    //! Ronda 5 - Éxito: renderiza los elementos en pantalla cuando el ViewModel pasa a estado listo
    testWidgets('Muestra la lista de negocios en pantalla', (WidgetTester tester) async {
      final api = NegociosApi(
        MockClient((_) async => http.Response(
          jsonEncode([{'id': 1, 'nombre': 'Nieves de la Plaza', 'categoria': 'Nevería'}]),
          200,
        )),
        'http://prueba',
      );
      final vm = NegociosViewModel(api);

      await tester.pumpWidget(MaterialApp(home: PantallaNegocios(vm: vm)));
      await tester.pumpAndSettle();

      expect(find.text('Nieves de la Plaza'), findsOneWidget);
    });

    //! Ronda 5 - Fallo prevenido: muestra el mensaje informativo cuando la lista está vacía
    testWidgets('Muestra el estado vacio cuando no hay elementos', (WidgetTester tester) async {
      final api = NegociosApi(
        MockClient((_) async => http.Response('[]', 200)),
        'http://prueba',
      );
      final vm = NegociosViewModel(api);

      await tester.pumpWidget(MaterialApp(home: PantallaNegocios(vm: vm)));
      await tester.pumpAndSettle();

      expect(find.text('Aún no hay negocios. ¡Agrega el primero!'), findsOneWidget);
    });
  });
}