import 'package:google_maps_flutter/google_maps_flutter.dart';

// Autores: Santiago Lopez, Sebastian Castro
// Coordenadas de distribución de 16 especies en Ibagué - Tolima, Colombia

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

    // Pava de monte - Bosques húmedos cuenca río Toche
    EspecieUbicacion(
      especie: 'Aburria aburri_Wattled Guan',
      coordenadas: LatLng(4.3587, -75.4021),
      lugar: 'Reserva Forestal Río Toche - Ibagué, Tolima',
    ),

    // Gavilán bicolor - Bosques riberinos del Coello
    EspecieUbicacion(
      especie: 'Accipiter bicolor_Bicolored Hawk',
      coordenadas: LatLng(4.3812, -75.1543),
      lugar: 'Cuenca Río Coello - Tolima',
    ),

    // Colibrí jaspeado - Zona cafetera de Ibagué
    EspecieUbicacion(
      especie: 'Adelomyia melanogenys_Speckled Hummingbird',
      coordenadas: LatLng(4.4378, -75.2012),
      lugar: 'Zona Cafetera - Ibagué, Tolima',
    ),

    // Pecho amarillo - Pastizales del valle del Magdalena
    EspecieUbicacion(
      especie: 'Agelaioides badius_Grayish Baywing',
      coordenadas: LatLng(4.1521, -74.9034),
      lugar: 'Valle del Magdalena - Espinal, Tolima',
    ),

    // Sargento - Humedales de Purificación
    EspecieUbicacion(
      especie: 'Agelaius phoeniceus_Red-winged Blackbird',
      coordenadas: LatLng(3.8623, -74.9312),
      lugar: 'Humedales de Purificación - Tolima',
    ),

    // Silfo colilargo - Cañón Combeima
    EspecieUbicacion(
      especie: 'Aglaiocercus kingii_Long-tailed Sylph',
      coordenadas: LatLng(4.5123, -75.2876),
      lugar: 'Cañón del Combeima - Ibagué, Tolima',
    ),

    // Andarríos manchado - Río Magdalena
    EspecieUbicacion(
      especie: 'Actitis macularius_Spotted Sandpiper',
      coordenadas: LatLng(5.2012, -74.7431),
      lugar: 'Río Magdalena - Honda, Tolima',
    ),

    // Búho frente ante - Páramo de Herveo
    EspecieUbicacion(
      especie: 'Aegolius harrisii_Buff-fronted Owl',
      coordenadas: LatLng(5.0643, -75.1987),
      lugar: 'Páramo de Herveo - Tolima',
    ),

    // Vencejo puntablanca - Cañón del Combeima
    EspecieUbicacion(
      especie: 'Aeronautes montivagus_White-tipped Swift',
      coordenadas: LatLng(4.5234, -75.2934),
      lugar: 'Cañón del Combeima - Ibagué, Tolima',
    ),

    // Gavilán pajarero - Reserva San Juan de la China
    EspecieUbicacion(
      especie: 'Accipiter striatus_Sharp-shinned Hawk',
      coordenadas: LatLng(4.4521, -75.1678),
      lugar: 'Reserva San Juan de la China - Ibagué, Tolima',
    ),

    // Tapaculo ocelado - Bosques altoandinos Murillo
    EspecieUbicacion(
      especie: 'Acropternis orthonyx_Ocellated Tapaculo',
      coordenadas: LatLng(4.8712, -75.1543),
      lugar: 'Bosques Altoandinos de Murillo - Tolima',
    ),

    // Gavilán enano - Bosques de Planadas
    EspecieUbicacion(
      especie: 'Accipiter superciliosus_Tiny Hawk',
      coordenadas: LatLng(3.1987, -75.6234),
      lugar: 'Bosques Húmedos de Planadas - Tolima',
    ),

    // Silfo colivioleta - Planadas
    EspecieUbicacion(
      especie: 'Aglaiocercus coelestis_Violet-tailed Sylph',
      coordenadas: LatLng(3.2143, -75.6012),
      lugar: 'Vertiente Húmeda Planadas - Tolima',
    ),

    // Gavilán muslorufo - Sur del Tolima
    EspecieUbicacion(
      especie: 'Accipiter erythronemius_Rufous-thighed Hawk',
      coordenadas: LatLng(3.6234, -75.2876),
      lugar: 'Cuenca Río Saldaña - Ataco, Tolima',
    ),

    // Gavilán vientre gris - Bosques de Rioblanco
    EspecieUbicacion(
      especie: 'Accipiter poliogaster_Gray-bellied Hawk',
      coordenadas: LatLng(3.5187, -75.7234),
      lugar: 'Bosques de Rioblanco - Tolima',
    ),

    // Pinzón pico cuerno - Páramo de Anaime
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
