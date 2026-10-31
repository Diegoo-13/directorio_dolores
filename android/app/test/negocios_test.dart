import 'package:flutter_test/flutter_test.dart';
import 'package:directorio_dolores/dominio/negocio.dart';

void main() {
  group('Ronda 2 - Modelo Negocio', () {
    //! Ronda 2 - Éxito: desdeJson lee todos los campos obligatorios y opcionales
    test('desdeJson lee todos los campos', () {
      final n = Negocio.desdeJson({
        'id': 1,
        'nombre': 'Nieves de la Plaza',
        'categoria': 'Nevería',
        'telefono': '418-100-0001',
        'favorito': true,
      });
      expect(n.id, 1);
      expect(n.nombre, 'Nieves de la Plaza');
      expect(n.favorito, true);
    });

    //! Ronda 2 - Fallo prevenido: si faltan campos opcionales en el JSON, asigna valores por defecto
    test('campos opcionales ausentes usan valores por omisión', () {
      final n = Negocio.desdeJson({'id': 2, 'nombre': 'X', 'categoria': 'Y'});
      expect(n.telefono, '');
      expect(n.favorito, false);
    });

    //! Ronda 2 - Éxito: aJson omite la propiedad 'id' si el objeto es un registro nuevo
    test('aJson no manda id cuando es nuevo', () {
      const n = Negocio(nombre: 'X', categoria: 'Y');
      expect(n.aJson().containsKey('id'), false);
    });

    //! Ronda 2 - Éxito: copiarCon crea una copia inmutable modificando solo el estado favorito
    test('copiarCon cambia solo el favorito', () {
      const n = Negocio(id: 3, nombre: 'X', categoria: 'Y');
      final f = n.copiarCon(favorito: true);
      expect(f.favorito, true);
      expect(f.nombre, 'X');
      expect(f.id, 3);
    });
  });
}