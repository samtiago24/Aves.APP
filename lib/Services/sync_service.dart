import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';

/// RF09 - Sincronización Automática con Firebase Firestore
/// Detecta conexión a internet y sube los avistamientos pendientes.
class SyncService {
  static final _firestore = FirebaseFirestore.instance;

  /// Verifica conectividad y sincroniza todos los registros no sincronizados.
  static Future<void> sincronizarPendientes() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('Sin conexión. Sincronización omitida.');
      return;
    }

    final pendientes = await DatabaseService.obtenerNosincronizados();

    if (pendientes.isEmpty) {
      print('No hay avistamientos pendientes de sincronizar.');
      return;
    }

    print('Sincronizando ${pendientes.length} avistamiento(s)...');

    for (final avistamiento in pendientes) {
      try {
        await _firestore
            .collection('avistamientos')
            .doc(avistamiento.id)
            .set({
          'id': avistamiento.id,
          'especie': avistamiento.especie,
          'confianza': avistamiento.confianza,
          'latitud': avistamiento.latitud,
          'longitud': avistamiento.longitud,
          'fecha': avistamiento.fecha,
          'sincronizado': true,
        });

        // Marcar como sincronizado en la BD local
        await DatabaseService.marcarSincronizado(avistamiento.id);
        print('✓ Sincronizado: ${avistamiento.especie} (${avistamiento.id})');
      } catch (e) {
        print('✗ Error sincronizando ${avistamiento.id}: $e');
        // Continúa con el siguiente, no interrumpe el loop
      }
    }
  }

  /// Escucha cambios de conectividad en tiempo real y sincroniza automáticamente.
  static void escucharConectividad() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        print('Conexión detectada. Iniciando sincronización...');
        sincronizarPendientes();
      }
    });
  }
}
