import 'package:google_maps_flutter/google_maps_flutter.dart';

class EspecieUbicacion {
  final String especie;
  final LatLng coordenadas;
  final String lugar;

  const EspecieUbicacion({
    required this.especie,
    required this.coordenadas,
    required this.lugar,
  });
}

class SpeciesLocations {
  // Ubicaciones predefinidas de avistamiento en el Tolima
  static const List<EspecieUbicacion> _ubicaciones = [
    // Zona 1: 4.482576, -75.249883
    EspecieUbicacion(
      especie: 'Avefría teroCSV',
      coordenadas: LatLng(4.482576, -75.249883),
      lugar: 'Zona Norte - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Baltimore Oriole',
      coordenadas: LatLng(4.482576, -75.249883),
      lugar: 'Zona Norte - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Bienteveo Común',
      coordenadas: LatLng(4.482576, -75.249883),
      lugar: 'Zona Norte - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Torcaza Colorada',
      coordenadas: LatLng(4.482576, -75.249883),
      lugar: 'Zona Norte - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Tangara Azulgris',
      coordenadas: LatLng(4.482576, -75.249883),
      lugar: 'Zona Norte - Tolima',
    ),

    // Zona 2: 4.467583, -75.258315
    EspecieUbicacion(
      especie: 'Canario coronado',
      coordenadas: LatLng(4.467583, -75.258315),
      lugar: 'Zona Centro-Oeste - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Colibrí Cola Canela',
      coordenadas: LatLng(4.467583, -75.258315),
      lugar: 'Zona Centro-Oeste - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Fiofío Silbón',
      coordenadas: LatLng(4.467583, -75.258315),
      lugar: 'Zona Centro-Oeste - Tolima',
    ),

    // Zona 3: 4.421926, -75.172571
    EspecieUbicacion(
      especie: 'Garza dedos dorados',
      coordenadas: LatLng(4.421926, -75.172571),
      lugar: 'Zona Centro - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Jacana',
      coordenadas: LatLng(4.421926, -75.172571),
      lugar: 'Zona Centro - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Luis Pico Grueso',
      coordenadas: LatLng(4.421926, -75.172571),
      lugar: 'Zona Centro - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Papamoscas rayado chico',
      coordenadas: LatLng(4.421926, -75.172571),
      lugar: 'Zona Centro - Tolima',
    ),

    // Zona 4: 4.423949, -75.141482
    EspecieUbicacion(
      especie: 'Saltador Gris',
      coordenadas: LatLng(4.423949, -75.141482),
      lugar: 'Zona Centro-Este - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Saltador garganta ocre',
      coordenadas: LatLng(4.423949, -75.141482),
      lugar: 'Zona Centro-Este - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Vireo Ojos Rojos',
      coordenadas: LatLng(4.423949, -75.141482),
      lugar: 'Zona Centro-Este - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Zorzal sabia',
      coordenadas: LatLng(4.423949, -75.141482),
      lugar: 'Zona Centro-Este - Tolima',
    ),
  ];

  /// Retorna las ubicaciones de una especie específica
  static List<EspecieUbicacion> getUbicaciones(String especie) {
    return _ubicaciones
        .where((u) => u.especie.toLowerCase() == especie.toLowerCase())
        .toList();
  }

  /// Retorna todas las ubicaciones
  static List<EspecieUbicacion> getTodas() => _ubicaciones;
}
