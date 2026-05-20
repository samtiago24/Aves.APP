// Autores: Santiago Lopez, Sebastian Castro
// 32 especies de aves del Tolima, Colombia

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

    // =========================================================
    // BLOQUE 1 — 16 especies originales
    // =========================================================
    EspecieInfo(
      nombre: 'Avefría teroCSV',
      nombreCientifico: 'Vanellus chilensis',
      habitat: 'Pastizales abiertos, orillas de ríos, humedales y zonas agrícolas inundadas del valle del Magdalena.',
      dieta: 'Insectos, gusanos, larvas y pequeños invertebrados que encuentra en el suelo húmedo.',
      distribucion: 'Ampliamente distribuida en el Tolima, especialmente en zonas bajas del valle del Magdalena. Común en municipios como Espinal, Guamo y El Lilán.',
      descripcion: 'Ave de tamaño mediano con cresta negra característica. Reconocida por su llamado estridente “tero-tero”. Muy territorial durante la reproducción.',
      imagePath: 'lib/assets/images/avefria_terocsv.jpg',
    ),
    EspecieInfo(
      nombre: 'Baltimore Oriole',
      nombreCientifico: 'Icterus galbula',
      habitat: 'Bordes de bosque, jardines arbolados, riberas de ríos con árboles frutales y zonas semi-abiertas.',
      dieta: 'Néctar de flores, frutas maduras, insectos y artrópodos.',
      distribucion: 'Ave migratoria norteamericana que visita el Tolima entre octubre y abril. Registrada en zonas de bosque seco tropical del norte del departamento.',
      descripcion: 'Macho con brillante plumaje naranja y negro. Hembra con tonos amarillo-oliva. Una de las aves migratorias más vistosas que visita Colombia.',
      imagePath: 'lib/assets/images/baltimore_oriole.jpg',
    ),
    EspecieInfo(
      nombre: 'Bienteveo Común',
      nombreCientifico: 'Pitangus sulphuratus',
      habitat: 'Bordes de ríos, jardines urbanos, zonas abiertas con árboles dispersos y cultivos.',
      dieta: 'Omnívoro. Come insectos, frutas, pequeños reptiles, ranas y peces pequeños.',
      distribucion: 'Una de las aves más comunes del Tolima. Presente en todo el departamento desde el nivel del mar hasta los 1.800 m.',
      descripcion: 'Fácilmente reconocible por su llamado “bien-te-veo”. Pecho amarillo brillante y corona rufa oculta. Muy adaptable a ambientes urbanos.',
      imagePath: 'lib/assets/images/bienteveo_comun.jpg',
    ),
    EspecieInfo(
      nombre: 'Canario coronado',
      nombreCientifico: 'Sicalis flaveola',
      habitat: 'Zonas abiertas, pastizales, bordes de cultivos, jardines y áreas urbanas con vegetación baja.',
      dieta: 'Principalmente semillas de gramíneas y plantas silvestres. Ocasionalmente insectos pequeños.',
      distribucion: 'Distribuido en zonas bajas y medias del Tolima. Común en el valle del Magdalena y piedemonte andino.',
      descripcion: 'Macho con llamativo plumaje amarillo intenso y corona dorada. Hembra con tonos más opacos. Cantor activo en horas de la mañana.',
      imagePath: 'lib/assets/images/canario_coronado.jpg',
    ),
    EspecieInfo(
      nombre: 'Colibrí Cola Canela',
      nombreCientifico: 'Amazilia tzacatl',
      habitat: 'Bordes de bosque, jardines con flores, cultivos de plátano y café, y zonas de rastrojos.',
      dieta: 'Néctar de flores principalmente. Complementa su dieta con pequeños insectos y arácnidos.',
      distribucion: 'Uno de los colibríes más comunes del Tolima. Presente desde el nivel del mar hasta 1.500 m.',
      descripcion: 'Colibrí de tamaño mediano con cola de color canela-rojizo muy característica. Pecho verde iridiscente. Vuelo muy rápido y territorial.',
      imagePath: 'lib/assets/images/colibri_cola_canela.jpg',
    ),
    EspecieInfo(
      nombre: 'Fiofío Silbón',
      nombreCientifico: 'Elaenia flavogaster',
      habitat: 'Bordes de bosque secundario, matorrales, jardines arbolados y zonas de rastrojos.',
      dieta: 'Frutas pequeñas y bayas de arbustos. Complementa con insectos capturados en vuelo.',
      distribucion: 'Común en zonas bajas y medias del Tolima hasta 1.600 m.',
      descripcion: 'Pequeño atrapamoscas con notable cresta que eriza cuando se alarma. Su canto es un silbido suave y melodioso repetitivo.',
      imagePath: 'lib/assets/images/fiofio_silbon.jpg',
    ),
    EspecieInfo(
      nombre: 'Garza dedos dorados',
      nombreCientifico: 'Egretta thula',
      habitat: 'Orillas de ríos, lagunas, humedales, arrozales y zonas inundadas del valle del Magdalena.',
      dieta: 'Peces pequeños, ranas, camarones, insectos acuáticos e invertebrados.',
      distribucion: 'Presente en humedales y cuerpos de agua del Tolima. Abundante en ciénagas del norte del departamento.',
      descripcion: 'Garza completamente blanca de tamaño mediano. Patas negras con dedos amarillos característicos.',
      imagePath: 'lib/assets/images/garza_dedos_dorados.jpg',
    ),
    EspecieInfo(
      nombre: 'Jacana',
      nombreCientifico: 'Jacana jacana',
      habitat: 'Plantas flotantes en lagunas y humedales, especialmente sobre taruya y lirios acuáticos.',
      dieta: 'Insectos acuáticos, semillas de plantas acuáticas, pequeños moluscos y crustáceos.',
      distribucion: 'Común en humedales del valle del Magdalena en el Tolima.',
      descripcion: 'Reconocible por sus enormes patas y dedos que le permiten caminar sobre plantas flotantes. Escudo frontal rojo-anaranjado.',
      imagePath: 'lib/assets/images/jacana.jpg',
    ),
    EspecieInfo(
      nombre: 'Luis Pico Grueso',
      nombreCientifico: 'Megarynchus pitangua',
      habitat: 'Doseles de bosque, bordes de bosque alto, riberas arboladas y zonas con árboles grandes.',
      dieta: 'Frutas grandes, insectos, lagartijas pequeñas y ocasionalmente huevos de otras aves.',
      distribucion: 'Presente en bosques del Tolima hasta 1.200 m. Más común en bosques riberinos del Magdalena.',
      descripcion: 'Similar al Bienteveo pero de mayor tamaño con pico notablemente más grueso y ganchudo.',
      imagePath: 'lib/assets/images/luis_pico_grueso.jpg',
    ),
    EspecieInfo(
      nombre: 'Papamoscas rayado chico',
      nombreCientifico: 'Pyrocephalus rubinus',
      habitat: 'Zonas abiertas áridas, bordes de ríos, pastizales secos y jardines con arbustos bajos.',
      dieta: 'Exclusivamente insectos que captura en vuelo desde perchas bajas.',
      distribucion: 'Presente en zonas secas del valle del Magdalena en el Tolima. Común entre Girardot y Honda.',
      descripcion: 'El macho es inconfundible con su brillante plumaje rojo carmsí en cabeza y pecho sobre alas y dorso negros.',
      imagePath: 'lib/assets/images/papamoscas_rayado_chico.jpg',
    ),
    EspecieInfo(
      nombre: 'Saltador Gris',
      nombreCientifico: 'Saltator coerulescens',
      habitat: 'Bordes de bosque, matorrales densos, jardines arbolados y zonas de rastrojo.',
      dieta: 'Frutas, bayas, semillas y brotes tiernos. Ocasionalmente insectos y artrópodos.',
      distribucion: 'Ampliamente distribuido en el Tolima desde el nivel del mar hasta 1.500 m.',
      descripcion: 'Ave robusta de plumaje gris azulado con garganta blanca bordeada de negro. Canto melodioso y variado.',
      imagePath: 'lib/assets/images/saltador_gris.jpg',
    ),
    EspecieInfo(
      nombre: 'Saltador garganta ocre',
      nombreCientifico: 'Saltator maximus',
      habitat: 'Interior y bordes de bosque húmedo, zonas de bosque secundario y áreas con densa vegetación.',
      dieta: 'Frutas, semillas, brotes y flores. Complementa con insectos durante la época de cría.',
      distribucion: 'Presente en bosques húmedos del Tolima, principalmente en vertientes de la cordillera Central hasta 1.800 m.',
      descripcion: 'Saltador con garganta color ante-ocre muy característica bordeada de negro. Dorso verde oliva.',
      imagePath: 'lib/assets/images/saltador_garganta_ocre.jpg',
    ),
    EspecieInfo(
      nombre: 'Tangara Azulgris',
      nombreCientifico: 'Thraupis episcopus',
      habitat: 'Bordes de bosque, jardines urbanos, parques, zonas agrícolas y áreas semi-abiertas.',
      dieta: 'Frutas, bayas, néctar y ocasionalmente insectos.',
      distribucion: 'Una de las aves más abundantes del Tolima. Presente en todo el departamento hasta 2.000 m.',
      descripcion: 'Plumaje azul-gris uniforme con hombros azul intenso muy vistosos. Muy adaptable a ambientes urbanos.',
      imagePath: 'lib/assets/images/tangara_azulgris.jpg',
    ),
    EspecieInfo(
      nombre: 'Torcaza Colorada',
      nombreCientifico: 'Patagioenas cayennensis',
      habitat: 'Bosques abiertos, bordes de bosque, zonas arboladas en pastizales y palmas nativas.',
      dieta: 'Semillas, granos, frutas pequeñas y bayas. Frecuenta cultivos de maíz y sorgo.',
      distribucion: 'Común en zonas bajas del Tolima hasta 1.000 m. Abundante en el valle del Magdalena.',
      descripcion: 'Paloma de tamaño mediano con plumaje vino-rosado en el pecho. Parche iridiscente en el cuello.',
      imagePath: 'lib/assets/images/torcaza_colorada.jpg',
    ),
    EspecieInfo(
      nombre: 'Vireo Ojos Rojos',
      nombreCientifico: 'Vireo olivaceus',
      habitat: 'Doseles y bordes de bosque, jardines arbolados y zonas de bosque secundario.',
      dieta: 'Insectos y larvas del follaje. En migración consume frutas pequeñas.',
      distribucion: 'Ave migratoria que visita el Tolima entre agosto y abril.',
      descripcion: 'Vireo de tamaño mediano con iris rojo-vino característico en adultos. Canta incesantemente incluso en días calurosos.',
      imagePath: 'lib/assets/images/vireo_ojos_rojos.jpg',
    ),
    EspecieInfo(
      nombre: 'Zorzal sabia',
      nombreCientifico: 'Turdus ignobilis',
      habitat: 'Bosques secundarios, jardines arbolados, parques urbanos y bordes de bosque.',
      dieta: 'Frutas, lombrices, insectos y otros invertebrados del suelo.',
      distribucion: 'Uno de los tordos más comunes del Tolima. Presente hasta 2.200 m. Muy abundante en Ibagué.',
      descripcion: 'Tordo de dorso pardo-oliva y pecho manchado. Canto muy melodioso al amanecer. Pico amarillo-anaranjado.',
      imagePath: 'lib/assets/images/zorzal_sabia.jpg',
    ),

    // =========================================================
    // BLOQUE 2 — 16 especies BirdNET Tolima
    // =========================================================
    EspecieInfo(
      nombre: 'Aburria aburri_Wattled Guan',
      nombreCientifico: 'Aburria aburri',
      habitat: 'Bosques húmedos montanos y submontanos de la cordillera Central, entre 1.000 y 2.500 m s.n.m.',
      dieta: 'Frutas, bayas, semillas y hojas tiernas de árboles del dosel boscoso.',
      distribucion: 'Presente en bosques húmedos del flanco occidental de la cordillera Central. Registrada en reservas de Planadas, Rioblanco y cuenca del río Toche.',
      descripcion: 'Gran ave negra brillante con prominente barbilla roja colgante. Habita en el dosel de bosques primarios. En peligro por deforestación.',
      imagePath: 'lib/assets/images/aburria_aburri.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter bicolor_Bicolored Hawk',
      nombreCientifico: 'Accipiter bicolor',
      habitat: 'Interior y bordes de bosques húmedos y semihúmedos desde el nivel del mar hasta 2.000 m.',
      dieta: 'Aves pequeñas, lagartijas, insectos grandes y ocasionalmente murciélagos en vuelo.',
      distribucion: 'Distribuido en bosques del Tolima. Registrado en bosques riberinos del Magdalena y cuenca del Coello.',
      descripcion: 'Halcón mediano con partes superiores grises y partes inferiores blanquecinas con flancos color canela.',
      imagePath: 'lib/assets/images/accipiter_bicolor.jpg',
    ),
    EspecieInfo(
      nombre: 'Adelomyia melanogenys_Speckled Hummingbird',
      nombreCientifico: 'Adelomyia melanogenys',
      habitat: 'Bosques andinos, bordes de bosque con flores y jardines de zonas cafeteras entre 1.200 y 2.800 m.',
      dieta: 'Néctar de flores de Heliconia, bromelias y Salvia. Complementa con insectos.',
      distribucion: 'Uno de los colibríes más comunes del Tolima en zonas de altura. Abundante en la zona cafetera de Ibagué y Cajamarca.',
      descripcion: 'Colibrí de tamaño mediano con pecho finamente moteado. Uno de los colibríes más fáciles de observar en los Andes colombianos.',
      imagePath: 'lib/assets/images/adelomyia_melanogenys.jpg',
    ),
    EspecieInfo(
      nombre: 'Agelaioides badius_Grayish Baywing',
      nombreCientifico: 'Agelaioides badius',
      habitat: 'Pastizales abiertos, sabanas, bordes de cultivos y zonas agrícolas con árboles dispersos.',
      dieta: 'Semillas de gramíneas, insectos y larvas del suelo. Forrajea en grupos.',
      distribucion: 'Presente en zonas bajas del valle del Magdalena. Registrado en pastizales de Espinal y Flandes.',
      descripcion: 'Ave de tamaño mediano con plumaje pardo-grisáceo y hombros color baíano. Vive en grupos en zonas abiertas.',
      imagePath: 'lib/assets/images/agelaioides_badius.jpg',
    ),
    EspecieInfo(
      nombre: 'Agelaius phoeniceus_Red-winged Blackbird',
      nombreCientifico: 'Agelaius phoeniceus',
      habitat: 'Cénagas, humedales con totoras, bordes de ríos y zonas agrícolas inundables.',
      dieta: 'Semillas, granos de cereal, insectos y larvas acuáticas.',
      distribucion: 'Ave migrante visitante. Registrada en humedales del valle del Magdalena y ciénagas de Purificación.',
      descripcion: 'Macho negro brillante con llamativas hombreras rojo-anaranjadas bordeadas de amarillo.',
      imagePath: 'lib/assets/images/agelaius_phoeniceus.jpg',
    ),
    EspecieInfo(
      nombre: 'Aglaiocercus kingii_Long-tailed Sylph',
      nombreCientifico: 'Aglaiocercus kingii',
      habitat: 'Bordes de bosque andino, jardines y zonas de matorral entre 1.500 y 3.000 m s.n.m.',
      dieta: 'Néctar de flores de Fuchsia, Palicourea y otras plantas andinas de flores tubulares.',
      distribucion: 'Presente en zonas de altura del Tolima. Frecuente en el corredor Ibagué-Cajamarca sobre los 1.800 m.',
      descripcion: 'El macho es inconfundible por su extraordinariamente larga cola azul iridiscente. Uno de los colibríes más espectaculares de los Andes.',
      imagePath: 'lib/assets/images/aglaiocercus_kingii.jpg',
    ),
    EspecieInfo(
      nombre: 'Actitis macularius_Spotted Sandpiper',
      nombreCientifico: 'Actitis macularius',
      habitat: 'Orillas de ríos, playas de grava, embalses y humedales con bordes despejados.',
      dieta: 'Insectos acuáticos, crustáceos pequeños, gusanos y peces muy pequeños.',
      distribucion: 'Ave migratoria muy común en el Tolima entre agosto y abril. Registrada en el río Magdalena, Coello y embalse de Prado.',
      descripcion: 'Chorlito mediano que camina balanceando constantemente la cola hacia abajo. Vuela con aleteos rápidos y rígidos.',
      imagePath: 'lib/assets/images/actitis_macularius.jpg',
    ),
    EspecieInfo(
      nombre: 'Aegolius harrisii_Buff-fronted Owl',
      nombreCientifico: 'Aegolius harrisii',
      habitat: 'Bosques andinos húmedos y borde de páramo entre 2.000 y 3.500 m s.n.m.',
      dieta: 'Ratones, insectos grandes, lagartijas pequeñas y ocasionalmente pequeños pájaros nocturnos.',
      distribucion: 'Búho poco común del Tolima. Registrado en bosques altoandinos de Herveo, Murillo y páramos del norte.',
      descripcion: 'Búho pequeño con llamativa frente y cejas color ante-amarillento. Hábitos estrictamente nocturnos y muy difícil de observar.',
      imagePath: 'lib/assets/images/aegolius_harrisii.jpg',
    ),
    EspecieInfo(
      nombre: 'Aeronautes montivagus_White-tipped Swift',
      nombreCientifico: 'Aeronautes montivagus',
      habitat: 'Cielos abiertos sobre bosques andinos, cañones y paredes rocosas entre 1.000 y 3.000 m.',
      dieta: 'Insectos voladores capturados en vuelo: mosquitos, moscos, hormigas aladas y escarabajos.',
      distribucion: 'Vencejo común en zonas andinas del Tolima. Observado regularmente sobre el cañón del Combeima.',
      descripcion: 'Vencejo andino negro con notorias puntas blancas en la cola. La punta blanca lo distingue de otros vencejos.',
      imagePath: 'lib/assets/images/aeronautes_montivagus.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter striatus_Sharp-shinned Hawk',
      nombreCientifico: 'Accipiter striatus',
      habitat: 'Bosques densos, bordes de bosque y zonas arboladas desde el nivel del mar hasta 3.000 m.',
      dieta: 'Principalmente aves pequeñas capturadas en vuelo. Ocasionalmente lagartijas e insectos grandes.',
      distribucion: 'Gavilán migratorio que visita el Tolima entre septiembre y abril. Registrado en bosques de Ibagué y cuenca del Coello.',
      descripcion: 'El gavilán más pequeño de Colombia. Adulto con dorso gris pizarra y pecho finamente barrado.',
      imagePath: 'lib/assets/images/accipiter_striatus.jpg',
    ),
    EspecieInfo(
      nombre: 'Acropternis orthonyx_Ocellated Tapaculo',
      nombreCientifico: 'Acropternis orthonyx',
      habitat: 'Sotobosque de bosques andinos húmedos entre 2.200 y 3.500 m s.n.m.',
      dieta: 'Insectos, artrópodos e invertebrados del suelo entre la hojarasca.',
      distribucion: 'Especie de alta montaña en el Tolima. Registrada en bosques altoandinos de Herveo, Murillo y cuenca del Toche.',
      descripcion: 'Plumaje negro con grandes manchas blancas oceladas en el pecho. Muy secretivo aunque su canto es potente.',
      imagePath: 'lib/assets/images/acropternis_orthonyx.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter superciliosus_Tiny Hawk',
      nombreCientifico: 'Accipiter superciliosus',
      habitat: 'Interior de bosques húmedos tropicales y subtropicales hasta 1.500 m s.n.m.',
      dieta: 'Colibríes y aves muy pequeñas que caza con gran agilidad entre la vegetación densa.',
      distribucion: 'El gavilán más raro del Tolima. Registros esporádicos en bosques húmedos de Planadas y Rioblanco.',
      descripcion: 'El gavilán más pequeño del mundo. Especializado en cazar colibríes en pleno vuelo.',
      imagePath: 'lib/assets/images/accipiter_superciliosus.jpg',
    ),
    EspecieInfo(
      nombre: 'Aglaiocercus coelestis_Violet-tailed Sylph',
      nombreCientifico: 'Aglaiocercus coelestis',
      habitat: 'Bordes de bosque húmedo, jardines y zonas de matorral entre 800 y 2.200 m s.n.m.',
      dieta: 'Néctar de flores de Heliconia, Palicourea y otras plantas con flores tubulares.',
      distribucion: 'Colibrí presente en vertientes húmedas del Tolima. Registrado en bosques de Planadas y Chaparral.',
      descripcion: 'Macho con cola violeta-azulada muy larga y brillante. Similar al Silfo coliazul pero con cola violeta.',
      imagePath: 'lib/assets/images/aglaiocercus_coelestis.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter erythronemius_Rufous-thighed Hawk',
      nombreCientifico: 'Accipiter erythronemius',
      habitat: 'Bordes de bosque tropical húmedo y semihúmedo hasta 1.500 m s.n.m.',
      dieta: 'Aves pequeñas, lagartijas y grandes insectos. Caza con emboscada desde perchas ocultas.',
      distribucion: 'Gavilán poco frecuente del Tolima. Registrado en el sur del departamento, cuenca del río Saldaña y Ataco.',
      descripcion: 'Gavilán mediano con muslos y flancos color rufo-canela muy característicos. Dorso gris pizarra.',
      imagePath: 'lib/assets/images/accipiter_erythronemius.jpg',
    ),
    EspecieInfo(
      nombre: 'Accipiter poliogaster_Gray-bellied Hawk',
      nombreCientifico: 'Accipiter poliogaster',
      habitat: 'Interior de bosques húmedos tropicales y subtropicales hasta 1.200 m s.n.m.',
      dieta: 'Aves medianas, murciélagos y lagartijas grandes que captura dentro del bosque.',
      distribucion: 'Uno de los gavilanes más raros del Tolima. Registros escasos en bosques de Planadas y Rioblanco.',
      descripcion: 'Gavilán grande con partes superiores negras y partes inferiores blancas sin barrado. Una de las rapaces menos conocidas de los Andes.',
      imagePath: 'lib/assets/images/accipiter_poliogaster.jpg',
    ),
    EspecieInfo(
      nombre: 'Acanthidops bairdi_Peg-billed Finch',
      nombreCientifico: 'Acanthidops bairdi',
      habitat: 'Páramo y bordes de bosque altoandino entre 2.800 y 3.800 m s.n.m. con bambú y bromelias.',
      dieta: 'Semillas de gramíneas de páramo, brotes de bambú y artrópodos.',
      distribucion: 'Especie de alta montaña registrada en páramos del norte del Tolima: Anaime, Viejo Caldas y cordillera Central sobre los 2.800 m.',
      descripcion: 'Pinzón andino con pico córneo muy corto y curvado, único en su género. Especializado en extraer semillas de bambú de páramo.',
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
