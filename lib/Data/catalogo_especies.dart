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
      dieta: 'Néctar de flores, frutas maduras, insectos y artrópodos. Visitante frecuente de árboles en flor.',
      distribucion: 'Ave migratoria norteamericana que visita el Tolima entre octubre y abril. Registrada en zonas de bosque seco tropical del norte del departamento.',
      descripcion: 'Macho con brillante plumaje naranja y negro. Hembra con tonos amarillo-oliva. Una de las aves migratorias más vistosas que visita Colombia.',
      imagePath: 'lib/assets/images/baltimore_oriole.jpg',
    ),
    EspecieInfo(
      nombre: 'Bienteveo Común',
      nombreCientifico: 'Pitangus sulphuratus',
      habitat: 'Bordes de ríos, jardines urbanos, zonas abiertas con árboles dispersos y cultivos.',
      dieta: 'Omnívoro. Come insectos, frutas, pequeños reptiles, ranas y peces pequeños que captura en el agua.',
      distribucion: 'Una de las aves más comunes del Tolima. Presente en todo el departamento desde el nivel del mar hasta los 1.800 m. Abundante en Ibagué y municipios aledaños.',
      descripcion: 'Fácilmente reconocible por su llamado que suena como “bien-te-veo”. Pecho amarillo brillante y corona rufa oculta. Muy adaptable a ambientes urbanos.',
      imagePath: 'lib/assets/images/bienteveo_comun.jpg',
    ),
    EspecieInfo(
      nombre: 'Canario coronado',
      nombreCientifico: 'Sicalis flaveola',
      habitat: 'Zonas abiertas, pastizales, bordes de cultivos, jardines y áreas urbanas con vegetación baja.',
      dieta: 'Principalmente semillas de gramíneas y plantas silvestres. Ocasionalmente insectos pequeños.',
      distribucion: 'Distribuido en zonas bajas y medias del Tolima. Común en el valle del Magdalena y piedemonte andino. Frecuente en zonas agrícolas de Espinal y Coello.',
      descripcion: 'Macho con llamativo plumaje amarillo intenso y corona dorada. Hembra con tonos más opacos. Cantor activo en horas de la mañana.',
      imagePath: 'lib/assets/images/canario_coronado.jpg',
    ),
    EspecieInfo(
      nombre: 'Colibrí Cola Canela',
      nombreCientifico: 'Amazilia tzacatl',
      habitat: 'Bordes de bosque, jardines con flores, cultivos de plátano y café, y zonas de rastrojos con flores nectaríferas.',
      dieta: 'Néctar de flores principalmente. Complementa su dieta con pequeños insectos y arácnidos para obtener proteínas.',
      distribucion: 'Uno de los colibríes más comunes del Tolima. Presente desde el nivel del mar hasta 1.500 m. Frecuente en zonas cafeteras del norte y centro del departamento.',
      descripcion: 'Colibrí de tamaño mediano con cola de color canela-rojizo muy característica. Pecho verde iridiscente. Vuelo muy rápido y territorial.',
      imagePath: 'lib/assets/images/colibri_cola_canela.jpg',
    ),
    EspecieInfo(
      nombre: 'Fiofío Silbón',
      nombreCientifico: 'Elaenia flavogaster',
      habitat: 'Bordes de bosque secundario, matorrales, jardines arbolados y zonas de rastrojos con árboles frutales.',
      dieta: 'Frutas pequeñas y bayas de arbustos. Complementa con insectos capturados en vuelo o en follaje.',
      distribucion: 'Común en zonas bajas y medias del Tolima hasta 1.600 m. Presente en todo el departamento, con mayor abundancia en zonas de bosque seco tropical.',
      descripcion: 'Pequeño atrapamoscas con notable cresta que eriza cuando se alarma. Su canto es un silbido suave y melodioso repetitivo. Plumaje verde-oliva y vientre amarillento.',
      imagePath: 'lib/assets/images/fiofio_silbon.jpg',
    ),
    EspecieInfo(
      nombre: 'Garza dedos dorados',
      nombreCientifico: 'Egretta thula',
      habitat: 'Orillas de ríos, lagunas, humedales, arrozales y zonas inundadas del valle del Magdalena.',
      dieta: 'Peces pequeños, ranas, camarones, insectos acuáticos e invertebrados que captura vadeando el agua.',
      distribucion: 'Presente en humedales y cuerpos de agua del Tolima. Abundante en ciénagas del norte del departamento y en el río Magdalena entre Ambalema y Honda.',
      descripcion: 'Garza completamente blanca de tamaño mediano. Durante la época reproductiva desarrolla penachos nupciales muy vistosos. Patas negras con dedos amarillos característicos.',
      imagePath: 'lib/assets/images/garza_dedos_dorados.jpg',
    ),
    EspecieInfo(
      nombre: 'Jacana',
      nombreCientifico: 'Jacana jacana',
      habitat: 'Plantas flotantes en lagunas y humedales, especialmente sobre taruya (buchón de agua) y lirios acuáticos.',
      dieta: 'Insectos acuáticos, semillas de plantas acuáticas, pequeños moluscos y crustáceos.',
      distribucion: 'Común en humedales del valle del Magdalena en el Tolima. Registrada en la ciénaga de Paramera, humedales de Purificación y zonas inundadas de Saldaña.',
      descripcion: 'Reconocible por sus enormes patas y dedos que le permiten caminar sobre plantas flotantes. Plumaje castaño con cabeza y cuello negros. Escudo frontal rojo-anaranjado.',
      imagePath: 'lib/assets/images/jacana.jpg',
    ),
    EspecieInfo(
      nombre: 'Luis Pico Grueso',
      nombreCientifico: 'Megarynchus pitangua',
      habitat: 'Doseles de bosque, bordes de bosque alto, riberas arboladas y zonas con árboles grandes frutales.',
      dieta: 'Frutas grandes, insectos, lagartijas pequeñas y ocasionalmente huevos de otras aves.',
      distribucion: 'Presente en bosques del Tolima hasta 1.200 m. Más común en bosques riberinos del Magdalena y afluentes. Registrado en reservas forestales de Ibagué.',
      descripcion: 'Similar al Bienteveo pero de mayor tamaño con pico notablemente más grueso y ganchudo. No tiene el llamado característico del Bienteveo. Corona amarilla oculta.',
      imagePath: 'lib/assets/images/luis_pico_grueso.jpg',
    ),
    EspecieInfo(
      nombre: 'Papamoscas rayado chico',
      nombreCientifico: 'Pyrocephalus rubinus',
      habitat: 'Zonas abiertas áridas, bordes de ríos, pastizales secos y jardines con arbustos bajos.',
      dieta: 'Exclusivamente insectos que captura en vuelo desde perchas bajas. Especialista en vuelos cortos de caza.',
      distribucion: 'Presente en zonas secas del valle del Magdalena en el Tolima. Común entre Girardot y Honda. Registrado en municipios de clima cálido seco como Armero y Ambalema.',
      descripcion: 'El macho es inconfundible con su brillante plumaje rojo carmesí en cabeza y pecho sobre alas y dorso negros. Hembra con tonos marrón y rosado. Muy activo en perchas expuestas.',
      imagePath: 'lib/assets/images/papamoscas_rayado_chico.jpg',
    ),
    EspecieInfo(
      nombre: 'Saltador Gris',
      nombreCientifico: 'Saltator coerulescens',
      habitat: 'Bordes de bosque, matorrales densos, jardines arbolados y zonas de rastrojo con arbustos frutales.',
      dieta: 'Frutas, bayas, semillas y brotes tiernos. Ocasionalmente insectos y artrópodos.',
      distribucion: 'Ampliamente distribuido en el Tolima desde el nivel del mar hasta 1.500 m. Común en municipios del norte y centro del departamento.',
      descripcion: 'Ave robusta de plumaje gris azulado con garganta blanca bordeada de negro. Pico grueso y fuerte. Canto melodioso y variado. Frecuentemente en parejas.',
      imagePath: 'lib/assets/images/saltador_gris.jpg',
    ),
    EspecieInfo(
      nombre: 'Saltador garganta ocre',
      nombreCientifico: 'Saltator maximus',
      habitat: 'Interior y bordes de bosque húmedo, zonas de bosque secundario y áreas con densa vegetación.',
      dieta: 'Frutas, semillas, brotes y flores. Complementa con insectos durante la época de cría.',
      distribucion: 'Presente en bosques húmedos del Tolima, principalmente en vertientes de la cordillera Central hasta 1.800 m. Registrado en reservas de Planadas y Rioblanco.',
      descripcion: 'Saltador con garganta color ante-ocre muy característica bordeada de negro. Dorso verde oliva. Pico muy fuerte. Más húmedo en hábitat que el Saltador Gris.',
      imagePath: 'lib/assets/images/saltador_garganta_ocre.jpg',
    ),
    EspecieInfo(
      nombre: 'Tangara Azulgris',
      nombreCientifico: 'Thraupis episcopus',
      habitat: 'Bordes de bosque, jardines urbanos, parques, zonas agrícolas y áreas semi-abiertas con árboles.',
      dieta: 'Frutas, bayas, néctar y ocasionalmente insectos. Muy aficionada a frutas de higo y mora.',
      distribucion: 'Una de las aves más abundantes y visibles del Tolima. Presente en todo el departamento hasta 2.000 m. Común en Ibagué, Espinal y todos los municipios del valle.',
      descripcion: 'Plumaje azul-gris uniforme con hombros azul intenso muy vistosos. Una de las tangaras más comunes de Colombia. Muy adaptable a ambientes urbanos y suburbanos.',
      imagePath: 'lib/assets/images/tangara_azulgris.jpg',
    ),
    EspecieInfo(
      nombre: 'Torcaza Colorada',
      nombreCientifico: 'Patagioenas cayennensis',
      habitat: 'Bosques abiertos, bordes de bosque, zonas arboladas en pastizales y palmas nativas.',
      dieta: 'Semillas, granos, frutas pequeñas y bayas. Frecuenta cultivos de maiz y sorgo.',
      distribucion: 'Común en zonas bajas del Tolima hasta 1.000 m. Abundante en el valle del Magdalena. Registrada en municipios de Mariquita, Honda, Armero y Ambalema.',
      descripcion: 'Paloma de tamaño mediano con plumaje vino-rosado en el pecho y dorso pardo-rojizo. Parche iridiscente en el cuello. Vuelo rápido y directo.',
      imagePath: 'lib/assets/images/torcaza_colorada.jpg',
    ),
    EspecieInfo(
      nombre: 'Vireo Ojos Rojos',
      nombreCientifico: 'Vireo olivaceus',
      habitat: 'Doseles y bordes de bosque, jardines arbolados y zonas de bosque secundario con árboles altos.',
      dieta: 'Insectos y larvas que recoge meticulosamente del follaje. En migración consume frutas pequeñas.',
      distribucion: 'Ave migratoria que visita el Tolima entre agosto y abril. Registrada en bosques del norte y centro del departamento. Frecuente en bosques riberinos del Magdalena.',
      descripcion: 'Vireo de tamaño mediano con iris rojo-vino característico en adultos. Plumaje verde oliva uniforme con cejas blancas. Canta incesantemente incluso en días calurosos.',
      imagePath: 'lib/assets/images/vireo_ojos_rojos.jpg',
    ),
    EspecieInfo(
      nombre: 'Zorzal sabia',
      nombreCientifico: 'Turdus ignobilis',
      habitat: 'Bosques secundarios, jardines arbolados, parques urbanos y bordes de bosque con sotobosque denso.',
      dieta: 'Frutas, lombrices, insectos y otros invertebrados del suelo. Busca alimento en el suelo entre hojarasca.',
      distribucion: 'Uno de los tordos más comunes del Tolima. Presente en todo el departamento hasta 2.200 m. Muy abundante en Ibagué y zonas cafeteras del norte del Tolima.',
      descripcion: 'Tordo de dorso pardo-oliva y pecho con manchas en forma de gota sobre fondo blanco-crema. Canto muy melodioso y variado al amanecer. Pico amarillo-anaranjado.',
      imagePath: 'lib/assets/images/zorzal_sabia.jpg',
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
