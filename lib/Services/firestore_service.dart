import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';

// Autores: Santiago Lopez, Sebastian Castro

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static const _coleccion = 'avistamientos';

  /// Verifica si hay conexión a internet
  static Future<bool> hayInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Sube un avistamiento a Firestore por su ID local
  static Future<bool> sincronizarAvistamiento(Avistamiento av) async {
    try {
      await _db.collection(_coleccion).doc(av.id).set({
        'id':         av.id,
        'especie':    av.especie,
        'confianza':  av.confianza,
        'fotoPath':   av.fotoPath,
        'latitud':    av.latitud,
        'longitud':   av.longitud,
        'fecha':      av.fecha,
        'dispositivo': 'android',
        'creadoEn':   FieldValue.serverTimestamp(),
      });
      // Marcar como sincronizado en SQLite local
      await DatabaseService.marcarSincronizado(av.id);
      print('[FIRESTORE] ✓ Subido: ${av.especie} (${av.id})');
      return true;
    } catch (e) {
      print('[FIRESTORE] ✗ Error al subir ${av.id}: $e');
      return false;
    }
  }

  /// Sube todos los avistamientos pendientes (sincronizado = 0)
  static Future<void> sincronizarPendientes() async {
    if (!await hayInternet()) {
      print('[FIRESTORE] Sin internet, pendientes en cola.');
      return;
    }
    final pendientes = await DatabaseService.obtenerNosincronizados();
    if (pendientes.isEmpty) {
      print('[FIRESTORE] No hay pendientes.');
      return;
    }
    print('[FIRESTORE] Sincronizando ${pendientes.length} pendiente(s)...');
    for (final av in pendientes) {
      await sincronizarAvistamiento(av);
    }
  }
}
