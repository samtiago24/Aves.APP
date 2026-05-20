// Autores: Santiago Lopez, Sebastian Castro
// 16 especies de aves presentes en Ibagué - Tolima, Colombia
// Fuente: BirdNET_6K_GLOBAL_MODEL + registros eBird/Biota Colombiana

class EspecieInfo {
  final String nombre;
  final String nombreCientifico;
  final String habitat;
  final String dieta;
  final String distribucion;
  final String descripcion;
  final String imagePath;

  const EspecieInfo({
    required this.nombre,
    required this.nombreCientifico,
    required this.habitat,
    required this.dieta,
    required this.distribucion,
    required this.descripcion,
    required this.imagePath,
  });
}

class CatalogoEspecies {
  static const List<EspecieInfo> especies = [
    EspecieInfo(
      nombre: 'Aburria aburri_Wattled Guan',
      nombreCientifico: 'Aburria aburri',
      habitat: 'Bosques húmedos montanos y submontanos de la cordillera Central, entre 1.000 y 2.500 m s.n.m.',
      dieta: 'Frutas, bayas, semillas y hojas tiernas de árboles del dosel boscoso.',
      distribucion: 'Presente en bosques húmedos del flanco occidental de la cordillera Central en el Tolima. Registrada en reservas de Planadas, Rioblanco y cuenca del río Toche.',
      descripcion: 'Gran ave negra brillante con una prominente barbilla roja colgante (wattle). Habita en el dosel de bosques primarios. En peligro por la deforestación. Emite llamados potentes y profundos.',
      imagePath: 'lib/assets/images/aburria_aburri.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter bicolor_Bicolored Hawk',
      nombreCientifico: 'Accipiter bicolor',
      habitat: 'Interior y bordes de bosques húmedos y semihúmedos desde el nivel del mar hasta 2.000 m.',
      dieta: 'Aves pequeñas, lagartijas, insectos grandes y ocasionalmente murciélagos en vuelo.',
      distribucion: 'Distribuido en bosques del Tolima. Registrado en bosques riberinos del Magdalena, cuenca del Coello y reservas boscosas de Ibagué.',
      descripcion: 'Halcón mediano con partes superiores grises y partes inferiores blanquecinas con ancos color canela. Vuelo rápido y ágil entre la vegetación. Poco frecuente de observar.',
      imagePath: 'lib/assets/images/accipiter_bicolor.jpg',
    ),
    EspecieInfo(
      nombre: 'Adelomyia melanogenys_Speckled Hummingbird',
      nombreCientifico: 'Adelomyia melanogenys',
      habitat: 'Bosques andinos, bordes de bosque con flores y jardines de zonas cafeteras entre 1.200 y 2.800 m.',
      dieta: 'Néctar de flores de Heliconia, bromelias, Salvia y otras plantas andinas. Complementa con insectos.',
      distribucion: 'Uno de los colibríes más comunes del Tolima en zonas de altura. Abundante en la zona cafetera de Ibagué, Cajamarca y municipios del norte del Tolima.',
      descripcion: 'Colibrí de tamaño mediano con pecho finamente moteado (speckled). Partes superiores verde-bronce. Uno de los colibríes más fáciles de observar en los Andes colombianos.',
      imagePath: 'lib/assets/images/adelomyia_melanogenys.jpg',
    ),
    EspecieInfo(
      nombre: 'Agelaioides badius_Grayish Baywing',
      nombreCientifico: 'Agelaioides badius',
      habitat: 'Pastizales abiertos, sabanas, bordes de cultivos y zonas agrícolas con árboles dispersos.',
      dieta: 'Semillas de gramíneas, insectos y larvas del suelo. Forrajea en grupos en el suelo.',
      distribucion: 'Presente en zonas bajas del valle del Magdalena en el Tolima. Registrado en pastizales de Espinal, Flandes y zonas agrícolas del norte del departamento.',
      descripcion: 'Tórtola de tamaño mediano con plumaje pardo-grisáceo. Hombros color baíano característicos. Vive en grupos y frecuenta zonas abiertas. Canto simple y repetitivo.',
      imagePath: 'lib/assets/images/agelaioides_badius.jpg',
    ),
    EspecieInfo(
      nombre: 'Agelaius phoeniceus_Red-winged Blackbird',
      nombreCientifico: 'Agelaius phoeniceus',
      habitat: 'Cénagas, humedales con totoras, bordes de ríos y zonas agrícolas inundables.',
      dieta: 'Semillas, granos de cereal, insectos y larvas acuáticas. Muy adaptable en alimentación.',
      distribucion: 'Ave migrante visitante del Tolima. Registrada en humedales del valle del Magdalena, especialmente en cénagas de Purificación, Ortega y zonas inundables de Saldaña.',
      descripcion: 'Macho negro brillante con llamativos hombreras rojo-anaranjadas bordeadas de amarillo. Hembra parda rayada. Uno de los pájaros más abundantes de Norteamérica que visita Colombia.',
      imagePath: 'lib/assets/images/agelaius_phoeniceus.jpg',
    ),
    EspecieInfo(
      nombre: 'Aglaiocercus kingii_Long-tailed Sylph',
      nombreCientifico: 'Aglaiocercus kingii',
      habitat: 'Bordes de bosque andino, jardines y zonas de matorral entre 1.500 y 3.000 m s.n.m.',
      dieta: 'Néctar de flores de Fuchsia, Palicourea, Centropogon y otras plantas andinas de flores tubulares.',
      distribucion: 'Presente en zonas de altura del Tolima, especialmente en el corredor de Ibagué-Cajamarca. Frecuente en jardines de fincas cafeteras sobre los 1.800 m.',
      descripcion: 'El macho es inconfundible por su extraordinariamente larga cola azul iridiscente que duplica su tamaño. Considerado uno de los colibríes más espectaculares de los Andes.',
      imagePath: 'lib/assets/images/aglaiocercus_kingii.jpg',
    ),
    EspecieInfo(
      nombre: 'Actitis macularius_Spotted Sandpiper',
      nombreCientifico: 'Actitis macularius',
      habitat: 'Orillas de ríos, playas de grava, embalses y humedales con bordes despejados.',
      dieta: 'Insectos acuáticos, crustáceos pequeños, gusanos y peces muy pequeños que captura en el borde del agua.',
      distribucion: 'Ave migratoria norteamericana muy común en el Tolima entre agosto y abril. Registrada en el río Magdalena, Coello, Saldaña y embalse de Prado.',
      descripcion: 'Chorlito mediano que camina balanceando constantemente la cola hacia abajo (teetering). En plumaje reproductivo tiene manchas redondas negras en el pecho. Vuela con aleteos rápidos y rígidos.',
      imagePath: 'lib/assets/images/actitis_macularius.jpg',
    ),
    EspecieInfo(
      nombre: 'Aegolius harrisii_Buff-fronted Owl',
      nombreCientifico: 'Aegolius harrisii',
      habitat: 'Bosques andinos húmedos y borde de páramo entre 2.000 y 3.500 m s.n.m.',
      dieta: 'Ratones, insectos grandes, lagartijas pequeñas y ocasionalmente pequeños pájaros nocturnos.',
      distribucion: 'Búho poco común del Tolima. Registrado en bosques altoandinos de la cordillera Central, sectores de Herveo, Murillo y zonas de páramo del norte del Tolima.',
      descripcion: 'Búho pequeño con llamativa frente y cejas color ante-amarillento (buff). Partes superiores café con manchas blancas. De hábitos estrictamente nocturnos y muy difícil de observar.',
      imagePath: 'lib/assets/images/aegolius_harrisii.jpg',
    ),
    EspecieInfo(
      nombre: 'Aeronautes montivagus_White-tipped Swift',
      nombreCientifico: 'Aeronautes montivagus',
      habitat: 'Cielos abiertos sobre bosques andinos, cañones y paredes rocosas entre 1.000 y 3.000 m.',
      dieta: 'Insectos voladores capturados en vuelo: mosquitos, moscos, hormigas aladas y escarabajos.',
      distribucion: 'Vencejo común en zonas andinas del Tolima. Observado regularmente sobre el cañón del Combeima, serranías de Ibagué y cañón del Cocora.',
      descripcion: 'Vencejo andino negro con notorias puntas blancas en la cola. Vuelo rápido y acrobático en grupos. La punta blanca de la cola lo distingue de otros vencejos. Muy común sobre Ibagué.',
      imagePath: 'lib/assets/images/aeronautes_montivagus.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter striatus_Sharp-shinned Hawk',
      nombreCientifico: 'Accipiter striatus',
      habitat: 'Bosques densos, bordes de bosque y zonas arboladas desde el nivel del mar hasta 3.000 m.',
      dieta: 'Principalmente aves pequeñas capturadas en vuelo. Ocasionalmente lagartijas e insectos grandes.',
      distribucion: 'Gavilán migratorio que visita el Tolima entre septiembre y abril. Registrado en bosques de Ibagué, reserva forestal de San Juan de la China y cuenca del Coello.',
      descripcion: 'El gavilán más pequeño de Colombia. Adulto con dorso gris pizarra y pecho finamente barrado. Vuelo rápido con aleteos cortos y planeadas. Especialista cazador de aves.',
      imagePath: 'lib/assets/images/accipiter_striatus.jpg',
    ),
    EspecieInfo(
      nombre: 'Acropternis orthonyx_Ocellated Tapaculo',
      nombreCientifico: 'Acropternis orthonyx',
      habitat: 'Sotobosque de bosques andinos húmedos entre 2.200 y 3.500 m s.n.m.',
      dieta: 'Insectos, artrópodos e invertebrados del suelo que encuentra entre la hojarasca.',
      distribucion: 'Especie de alta montaña en el Tolima. Registrada en bosques altoandinos de la cordillera Central en Herveo, Murillo y sectores altos de la cuenca del Toche.',
      descripcion: 'Uno de los tapaculos más llamativos: plumaje negro con grandes manchas blancas oceladas en el pecho y flancos. Muy secretivo y difícil de ver aunque su canto es potente.',
      imagePath: 'lib/assets/images/acropternis_orthonyx.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter superciliosus_Tiny Hawk',
      nombreCientifico: 'Accipiter superciliosus',
      habitat: 'Interior de bosques húmedos tropicales y subtropicales hasta 1.500 m s.n.m.',
      dieta: 'Colibríes y aves muy pequeñas que caza con gran agilidad entre la vegetación densa.',
      distribucion: 'El gavilán más raro del Tolima. Registros esporádicos en bosques húmedos de Planadas, Rioblanco y la Reserva Natural de La Macarena en zonas de transición.',
      descripcion: 'El gavilán más pequeño del mundo. Tamaño de un gorrión grande. Especializado en cazar colibríes en pleno vuelo. Extremadamente difícil de observar por su tamaño y rapidez.',
      imagePath: 'lib/assets/images/accipiter_superciliosus.jpg',
    ),
    EspecieInfo(
      nombre: 'Aglaiocercus coelestis_Violet-tailed Sylph',
      nombreCientifico: 'Aglaiocercus coelestis',
      habitat: 'Bordes de bosque húmedo, jardines y zonas de matorral entre 800 y 2.200 m s.n.m.',
      dieta: 'Néctar de flores de Heliconia, Palicourea y otras plantas con flores tubulares.',
      distribucion: 'Colibrí presente en vertientes húmedas del Tolima. Registrado en bosques de Planadas, Chaparral y zonas de bosque húmedo del flanco occidental de la cordillera Central.',
      descripcion: 'Macho con cola violeta-azulada muy larga y brillante. Similar al Silfo coliazul pero de cola violeta en lugar de azul. Vuelo espectacular durante el cortejo. Hembra con garganta moteada.',
      imagePath: 'lib/assets/images/aglaiocercus_coelestis.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter erythronemius_Rufous-thighed Hawk',
      nombreCientifico: 'Accipiter erythronemius',
      habitat: 'Bordes de bosque tropical húmedo y semihúmedo hasta 1.500 m s.n.m.',
      dieta: 'Aves pequeñas, lagartijas y grandes insectos. Caza con emboscada desde perchas ocultas.',
      distribucion: 'Gavilán poco frecuente del Tolima. Registrado en bosques semihúmedos del sur del departamento, cuenca del río Saldaña y zonas boscosas de Ataco y Planadas.',
      descripcion: 'Gavilán mediano con muslos y flancos color rufo-canela muy característicos. Dorso gris pizarra. Menos común que otros Accipiter del país. Difícil de distinguir en campo.',
      imagePath: 'lib/assets/images/accipiter_erythronemius.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter poliogaster_Gray-bellied Hawk',
      nombreCientifico: 'Accipiter poliogaster',
      habitat: 'Interior de bosques húmedos tropicales y subtropicales hasta 1.200 m s.n.m.',
      dieta: 'Aves medianas, murciélagos y lagartijas grandes que captura dentro del bosque.',
      distribucion: 'Uno de los gavilanes más raros del Tolima. Registros escasos en bosques de Planadas y Rioblanco. Especie poco estudiada en Colombia.',
      descripcion: 'Gavilán grande con partes superiores negras y partes inferiores blancas sin barrado. Recuerda a un halcón por su vientre limpio. Una de las rapaces menos conocidas de los Andes.',
      imagePath: 'lib/assets/images/accipiter_poliogaster.jpg',
    ),
    EspecieInfo(
      nombre: 'Acanthidops bairdi_Peg-billed Finch',
      nombreCientifico: 'Acanthidops bairdi',
      habitat: 'Páramo y bordes de bosque altoandino entre 2.800 y 3.800 m s.n.m. en zonas con bambú y bromelias.',
      dieta: 'Semillas de gramíneas de páramo, brotesde bambú y artrópodos que encuentra entre la vegetación.',
      distribucion: 'Especie de alta montaña registrada en páramos del norte del Tolima: páramo de Anaime, Viejo Caldas y páramos de la cordillera Central sobre los 2.800 m.',
      descripcion: 'Pinzón andino con pico córneo muy corto y curvado, único en su género. Macho gris oscuro, hembra pardo-olivácea. Especializado en extraer semillas de inflorescencias de bambú de páramo.',
      imagePath: 'lib/assets/images/acanthidops_bairdi.jpg',
    ),
  ];

  static EspecieInfo? buscar(String nombre) {
    try {
      return especies.firstWhere(
        (e) => e.nombre.toLowerCase() == nombre.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
