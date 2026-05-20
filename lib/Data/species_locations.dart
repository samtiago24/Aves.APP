import 'package:google_maps_flutter/google_maps_flutter.dart';

// Autores: Santiago Lopez, Sebastian Castro
// Coordenadas de distribución de 32 especies en Ibagué - Tolima, Colombia

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
  static const List<EspecieUbicacion> _ubicaciones = [

    // =========================================================
    // BLOQUE 1 — 16 especies originales
    // =========================================================
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

    // =========================================================
    // BLOQUE 2 — 16 especies BirdNET Tolima
    // =========================================================
    EspecieUbicacion(
      especie: 'Aburria aburri_Wattled Guan',
      coordenadas: LatLng(4.3587, -75.4021),
      lugar: 'Reserva Forestal Río Toche - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter bicolor_Bicolored Hawk',
      coordenadas: LatLng(4.3812, -75.1543),
      lugar: 'Cuenca Río Coello - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Adelomyia melanogenys_Speckled Hummingbird',
      coordenadas: LatLng(4.4378, -75.2012),
      lugar: 'Zona Cafetera - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Agelaioides badius_Grayish Baywing',
      coordenadas: LatLng(4.1521, -74.9034),
      lugar: 'Valle del Magdalena - Espinal, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Agelaius phoeniceus_Red-winged Blackbird',
      coordenadas: LatLng(3.8623, -74.9312),
      lugar: 'Humedales de Purificación - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aglaiocercus kingii_Long-tailed Sylph',
      coordenadas: LatLng(4.5123, -75.2876),
      lugar: 'Cañón del Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Actitis macularius_Spotted Sandpiper',
      coordenadas: LatLng(5.2012, -74.7431),
      lugar: 'Río Magdalena - Honda, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aegolius harrisii_Buff-fronted Owl',
      coordenadas: LatLng(5.0643, -75.1987),
      lugar: 'Páramo de Herveo - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aeronautes montivagus_White-tipped Swift',
      coordenadas: LatLng(4.5234, -75.2934),
      lugar: 'Cañón del Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter striatus_Sharp-shinned Hawk',
      coordenadas: LatLng(4.4521, -75.1678),
      lugar: 'Reserva San Juan de la China - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Acropternis orthonyx_Ocellated Tapaculo',
      coordenadas: LatLng(4.8712, -75.1543),
      lugar: 'Bosques Altoandinos de Murillo - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter superciliosus_Tiny Hawk',
      coordenadas: LatLng(3.1987, -75.6234),
      lugar: 'Bosques Húmedos de Planadas - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aglaiocercus coelestis_Violet-tailed Sylph',
      coordenadas: LatLng(3.2143, -75.6012),
      lugar: 'Vertiente Húmeda Planadas - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter erythronemius_Rufous-thighed Hawk',
      coordenadas: LatLng(3.6234, -75.2876),
      lugar: 'Cuenca Río Saldaña - Ataco, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter poliogaster_Gray-bellied Hawk',
      coordenadas: LatLng(3.5187, -75.7234),
      lugar: 'Bosques de Rioblanco - Tolima',
    ),
    EspecieUbicacion(
      especie: 'Acanthidops bairdi_Peg-billed Finch',
      coordenadas: LatLng(4.2987, -75.5123),
      lugar: 'Páramo de Anaime - Cajamarca, Tolima',
    ),
  ];

  static List<EspecieUbicacion> getUbicaciones(String especie) {
    return _ubicaciones
        .where((u) => u.especie.toLowerCase() == especie.toLowerCase())
        .toList();
  }

  static List<EspecieUbicacion> getTodas() => _ubicaciones;
}
