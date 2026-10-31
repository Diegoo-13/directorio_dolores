import 'dart:io' show Platform;

/// Dirección de la API según dónde corre la app.
///  - Emulador Android: 10.0.2.2 es "la computadora anfitriona".
///  - Simulador iOS / escritorio: localhost.
///  - Celular real: pasa la IP de tu PC:
///      flutter run --dart-define=API_URL=http://192.168.1.50:3000
String urlBaseApi() {
  const manual = String.fromEnvironment('API_URL');
  if (manual.isNotEmpty) return manual;

  // Usa localhost para el celular físico mediante el túnel 'adb reverse'
  return 'http://localhost:3000';
}
