import 'dart:convert';

import 'package:directorio_dolores/datos/negocios_api.dart';
import 'package:directorio_dolores/dominio/negocio.dart';
import 'package:directorio_dolores/presentacion/negocios_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

NegociosViewModel vmCon(Future<http.Response> Function(http.Request) h) =>
    NegociosViewModel(NegociosApi(MockClient(h), 'http://prueba'));

void main() {
  group('Ronda 4 - ViewModel y Gestión de Estados', () {
    //! Ronda 4 - Éxito: la carga inicial pasa de Estado.cargando a Estado.listo
    test('cargar con datos termina en listo', () async {
      final vm = vmCon((_) async => http.Response(
          jsonEncode([{'id': 1, 'nombre': 'A', 'categoria': 'X'}]), 200));
      final estados = <Estado>[];
      vm.addListener(() => estados.add(vm.estado));
      await vm.cargar();
      expect(estados, [Estado.cargando, Estado.listo]);
      expect(vm.negocios.length, 1);
    });
    //! Ronda 4 - Fallo prevenido: si el backend responde vacio [], asigna Estado.vacio
    test('cargar con lista vacía termina en vacio', () async {
      final vm = vmCon((_) async => http.Response('[]', 200));
      await vm.cargar();
      expect(vm.estado, Estado.vacio);
    });
    //! Ronda 4 - Fallo prevenido: error 500 cambia a Estado.error y captura el mensaje
    test('cargar con error de servidor termina en error con mensaje', () async {
      final vm = vmCon((_) async => http.Response('', 500));
      await vm.cargar();
      expect(vm.estado, Estado.error);
      expect(vm.mensajeError, contains('500'));
    });
    //! Ronda 4 - Éxito: eliminar un negocio actualiza inmediatamente la lista local
    test('eliminar quita el negocio de la lista', () async {
      final vm = vmCon((req) async => req.method == 'DELETE'
          ? http.Response('', 204)
          : http.Response(
              jsonEncode([
                {'id': 1, 'nombre': 'A', 'categoria': 'X'},
                {'id': 2, 'nombre': 'B', 'categoria': 'Y'},
              ]),
              200));
      await vm.cargar();
      await vm.eliminar(vm.negocios.first);
      expect(vm.negocios.map((n) => n.id), [2]);
    });
    //! Ronda 4 - Éxito: alternarFavorito actualiza el estado del modelo según la respuesta
    test('alternarFavorito actualiza con la respuesta del servidor', () async {
      final vm = vmCon((req) async {
        if (req.method == 'PUT') {
          return http.Response(
              jsonEncode({'id': 1, 'nombre': 'A', 'categoria': 'X', 'favorito': true}), 200);
        }
        return http.Response(jsonEncode([{'id': 1, 'nombre': 'A', 'categoria': 'X'}]), 200);
      });
      await vm.cargar();
      await vm.alternarFavorito(vm.negocios.first);
      expect(vm.negocios.first.favorito, true);
    });
  });
}