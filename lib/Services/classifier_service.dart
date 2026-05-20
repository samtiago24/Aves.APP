import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

// Autores: Santiago Lopez, Sebastian Castro
class BirdClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  static const List<String> labels = [
    // === 16 especies originales ===
    'Avefría teroCSV',
    'Baltimore Oriole',
    'Bienteveo Común',
    'Canario coronado',
    'Colibrí Cola Canela',
    'Fiofío Silbón',
    'Garza dedos dorados',
    'Jacana',
    'Luis Pico Grueso',
    'Papamoscas rayado chico',
    'Saltador Gris',
    'Saltador garganta ocre',
    'Tangara Azulgris',
    'Torcaza Colorada',
    'Vireo Ojos Rojos',
    'Zorzal sabia',
    // === 16 especies BirdNET Tolima ===
    'Aburria aburri_Wattled Guan',
    'Accipiter bicolor_Bicolored Hawk',
    'Adelomyia melanogenys_Speckled Hummingbird',
    'Agelaioides badius_Grayish Baywing',
    'Agelaius phoeniceus_Red-winged Blackbird',
    'Aglaiocercus kingii_Long-tailed Sylph',
    'Actitis macularius_Spotted Sandpiper',
    'Aegolius harrisii_Buff-fronted Owl',
    'Aeronautes montivagus_White-tipped Swift',
    'Accipiter striatus_Sharp-shinned Hawk',
    'Acropternis orthonyx_Ocellated Tapaculo',
    'Accipiter superciliosus_Tiny Hawk',
    'Aglaiocercus coelestis_Violet-tailed Sylph',
    'Accipiter erythronemius_Rufous-thighed Hawk',
    'Accipiter poliogaster_Gray-bellied Hawk',
    'Acanthidops bairdi_Peg-billed Finch',
  ];

  static const Map<String, String> referenceImages = {
    // === 16 especies originales ===
    'Avefría teroCSV':           'lib/assets/images/avefria_terocsv.jpg',
    'Baltimore Oriole':           'lib/assets/images/baltimore_oriole.jpg',
    'Bienteveo Común':           'lib/assets/images/bienteveo_comun.jpg',
    'Canario coronado':           'lib/assets/images/canario_coronado.jpg',
    'Colibrí Cola Canela':        'lib/assets/images/colibri_cola_canela.jpg',
    'Fiofío Silbón':             'lib/assets/images/fiofio_silbon.jpg',
    'Garza dedos dorados':        'lib/assets/images/garza_dedos_dorados.jpg',
    'Jacana':                     'lib/assets/images/jacana.jpg',
    'Luis Pico Grueso':           'lib/assets/images/luis_pico_grueso.jpg',
    'Papamoscas rayado chico':    'lib/assets/images/papamoscas_rayado_chico.jpg',
    'Saltador Gris':              'lib/assets/images/saltador_gris.jpg',
    'Saltador garganta ocre':     'lib/assets/images/saltador_garganta_ocre.jpg',
    'Tangara Azulgris':           'lib/assets/images/tangara_azulgris.jpg',
    'Torcaza Colorada':           'lib/assets/images/torcaza_colorada.jpg',
    'Vireo Ojos Rojos':           'lib/assets/images/vireo_ojos_rojos.jpg',
    'Zorzal sabia':               'lib/assets/images/zorzal_sabia.jpg',
    // === 16 especies BirdNET Tolima ===
    'Aburria aburri_Wattled Guan':              'lib/assets/images/aburria_aburri.jpg',
    'Accipiter bicolor_Bicolored Hawk':         'lib/assets/images/accipiter_bicolor.jpg',
    'Adelomyia melanogenys_Speckled Hummingbird': 'lib/assets/images/adelomyia_melanogenys.jpg',
    'Agelaioides badius_Grayish Baywing':       'lib/assets/images/agelaioides_badius.jpg',
    'Agelaius phoeniceus_Red-winged Blackbird':  'lib/assets/images/agelaius_phoeniceus.jpg',
    'Aglaiocercus kingii_Long-tailed Sylph':     'lib/assets/images/aglaiocercus_kingii.jpg',
    'Actitis macularius_Spotted Sandpiper':      'lib/assets/images/actitis_macularius.jpg',
    'Aegolius harrisii_Buff-fronted Owl':        'lib/assets/images/aegolius_harrisii.jpg',
    'Aeronautes montivagus_White-tipped Swift':  'lib/assets/images/aeronautes_montivagus.jpg',
    'Accipiter striatus_Sharp-shinned Hawk':     'lib/assets/images/accipiter_striatus.jpg',
    'Acropternis orthonyx_Ocellated Tapaculo':   'lib/assets/images/acropternis_orthonyx.jpg',
    'Accipiter superciliosus_Tiny Hawk':         'lib/assets/images/accipiter_superciliosus.jpg',
    'Aglaiocercus coelestis_Violet-tailed Sylph': 'lib/assets/images/aglaiocercus_coelestis.jpg',
    'Accipiter erythronemius_Rufous-thighed Hawk': 'lib/assets/images/accipiter_erythronemius.jpg',
    'Accipiter poliogaster_Gray-bellied Hawk':   'lib/assets/images/accipiter_poliogaster.jpg',
    'Acanthidops bairdi_Peg-billed Finch':       'lib/assets/images/acanthidops_bairdi.jpg',
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'lib/assets/models/BirdNET_6K_GLOBAL_MODEL.tflite',
      );
      _isLoaded = true;
      print('\u2713 Modelo cargado. Input shape: ${_interpreter!.getInputTensor(0).shape}');
    } catch (e) {
      _isLoaded = false;
      print('\u2717 Error cargando modelo: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('El modelo no est\u00e1 cargado. Llama loadModel() primero.');
    }

    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized = img.copyResize(rawImage, width: 380, height: 380);

    final input = List.generate(
      1,
      (_) => List.generate(
        380,
        (y) => List.generate(380, (x) {
          final pixel = resized.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    _interpreter!.run(input, output);

    final scores = List<double>.from(output[0] as List);
    final indexed = List.generate(scores.length, (i) => i);
    indexed.sort((a, b) => scores[b].compareTo(scores[a]));

    final topIdx = indexed[0];
    final topLabel = labels[topIdx];

    final top3 = indexed.take(3).map((i) => {
      'label': labels[i],
      'confidence': scores[i],
      'confidenceText': '${(scores[i] * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[i]] ?? '',
    }).toList();

    return {
      'label': topLabel,
      'confidence': scores[topIdx],
      'confidenceText': '${(scores[topIdx] * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[topLabel] ?? '',
      'top3': top3,
      'allScores': scores,
    };
  }

  void dispose() => _interpreter?.close();
}
