import 'package:google_maps_flutter/google_maps_flutter.dart';

// Autores: Santiago Lopez, Sebastian Castro
// Todas las ubicaciones dentro de Ibagué, Tolima, Colombia
// Centro de Ibagué: 4.4389, -75.2322

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
    // BLOQUE 1 — 16 especies originales — dentro de Ibagué
    // =========================================================
    EspecieUbicacion(
      especie: 'Avefría teroCSV',
      coordenadas: LatLng(4.4210, -75.2450),
      lugar: 'Humedal La Martinica - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Baltimore Oriole',
      coordenadas: LatLng(4.4523, -75.2187),
      lugar: 'Parque Centenario - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Bienteveo Común',
      coordenadas: LatLng(4.4389, -75.2322),
      lugar: 'Centro de Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Canario coronado',
      coordenadas: LatLng(4.4298, -75.2601),
      lugar: 'Barrio Piedrapintada - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Colibrí Cola Canela',
      coordenadas: LatLng(4.4612, -75.2156),
      lugar: 'Jardines zona norte - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Fiofío Silbón',
      coordenadas: LatLng(4.4478, -75.2489),
      lugar: 'Bosque de la Universidad del Tolima - Ibagué',
    ),
    EspecieUbicacion(
      especie: 'Garza dedos dorados',
      coordenadas: LatLng(4.4134, -75.2234),
      lugar: 'Río Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Jacana',
      coordenadas: LatLng(4.4189, -75.2567),
      lugar: 'Humedal zona sur - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Luis Pico Grueso',
      coordenadas: LatLng(4.4501, -75.2078),
      lugar: 'Bosque El Totumo - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Papamoscas rayado chico',
      coordenadas: LatLng(4.4312, -75.2698),
      lugar: 'Zona occidental - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Saltador Gris',
      coordenadas: LatLng(4.4556, -75.2345),
      lugar: 'Parque deportivo - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Saltador garganta ocre',
      coordenadas: LatLng(4.4623, -75.2289),
      lugar: 'Bosque alto Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Tangara Azulgris',
      coordenadas: LatLng(4.4401, -75.2310),
      lugar: 'Jardines urbanos - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Torcaza Colorada',
      coordenadas: LatLng(4.4267, -75.2412),
      lugar: 'Arbolado zona central - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Vireo Ojos Rojos',
      coordenadas: LatLng(4.4589, -75.2167),
      lugar: 'Bosque riberino - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Zorzal sabia',
      coordenadas: LatLng(4.4445, -75.2278),
      lugar: 'Parques urbanos - Ibagué, Tolima',
    ),

    // =========================================================
    // BLOQUE 2 — 16 especies BirdNET — dentro de Ibagué
    // =========================================================
    EspecieUbicacion(
      especie: 'Aburria aburri_Wattled Guan',
      coordenadas: LatLng(4.4712, -75.2089),
      lugar: 'Reserva Forestal El Totumo - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter bicolor_Bicolored Hawk',
      coordenadas: LatLng(4.4634, -75.2134),
      lugar: 'Bosque riberino Río Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Adelomyia melanogenys_Speckled Hummingbird',
      coordenadas: LatLng(4.4578, -75.2056),
      lugar: 'Zona cafetera norte - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Agelaioides badius_Grayish Baywing',
      coordenadas: LatLng(4.4223, -75.2534),
      lugar: 'Pastizales zona sur - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Agelaius phoeniceus_Red-winged Blackbird',
      coordenadas: LatLng(4.4156, -75.2456),
      lugar: 'Humedal La Martinica - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aglaiocercus kingii_Long-tailed Sylph',
      coordenadas: LatLng(4.4689, -75.2023),
      lugar: 'Cañón del Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Actitis macularius_Spotted Sandpiper',
      coordenadas: LatLng(4.4178, -75.2312),
      lugar: 'Orillas Río Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aegolius harrisii_Buff-fronted Owl',
      coordenadas: LatLng(4.4734, -75.1978),
      lugar: 'Bosque altoandino norte - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aeronautes montivagus_White-tipped Swift',
      coordenadas: LatLng(4.4656, -75.2045),
      lugar: 'Cañón del Combeima - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter striatus_Sharp-shinned Hawk',
      coordenadas: LatLng(4.4512, -75.2101),
      lugar: 'Reserva San Juan de la China - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Acropternis orthonyx_Ocellated Tapaculo',
      coordenadas: LatLng(4.4756, -75.1967),
      lugar: 'Bosque altoandino El Totumo - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter superciliosus_Tiny Hawk',
      coordenadas: LatLng(4.4601, -75.2178),
      lugar: 'Bosque húmedo occidental - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Aglaiocercus coelestis_Violet-tailed Sylph',
      coordenadas: LatLng(4.4667, -75.2012),
      lugar: 'Jardines zona norte - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter erythronemius_Rufous-thighed Hawk',
      coordenadas: LatLng(4.4345, -75.2589),
      lugar: 'Bosque zona occidente - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Accipiter poliogaster_Gray-bellied Hawk',
      coordenadas: LatLng(4.4423, -75.2623),
      lugar: 'Reserva forestal occidental - Ibagué, Tolima',
    ),
    EspecieUbicacion(
      especie: 'Acanthidops bairdi_Peg-billed Finch',
      coordenadas: LatLng(4.4778, -75.1945),
      lugar: 'Zona alta norte - Ibagué, Tolima',
    ),
  ];

  static List<EspecieUbicacion> getUbicaciones(String especie) {
    return _ubicaciones
        .where((u) => u.especie.toLowerCase() == especie.toLowerCase())
        .toList();
  }

  static List<EspecieUbicacion> getTodas() => _ubicaciones;
}
