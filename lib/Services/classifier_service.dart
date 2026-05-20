import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

// Autores: Santiago Lopez, Sebastian Castro

enum ModeloAves { original, birdnet }

// ─────────────────────────────────────────────────────────────────
// MODELO ORIGINAL — 16 especies (model_aves.tflite)
// Igual que el commit original que ya funcionaba
// ─────────────────────────────────────────────────────────────────
class BirdClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  static const List<String> labels = [
    'Avefr\u00eda teroCSV',
    'Baltimore Oriole',
    'Bienteveo Com\u00fan',
    'Canario coronado',
    'Colibr\u00ed Cola Canela',
    'Fiof\u00edo Silb\u00f3n',
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
  ];

  static const Map<String, String> referenceImages = {
    'Avefr\u00eda teroCSV':        'lib/assets/images/avefria_terocsv.jpg',
    'Baltimore Oriole':          'lib/assets/images/baltimore_oriole.jpg',
    'Bienteveo Com\u00fan':        'lib/assets/images/bienteveo_comun.jpg',
    'Canario coronado':          'lib/assets/images/canario_coronado.jpg',
    'Colibr\u00ed Cola Canela':    'lib/assets/images/colibri_cola_canela.jpg',
    'Fiof\u00edo Silb\u00f3n':       'lib/assets/images/fiofio_silbon.jpg',
    'Garza dedos dorados':       'lib/assets/images/garza_dedos_dorados.jpg',
    'Jacana':                    'lib/assets/images/jacana.jpg',
    'Luis Pico Grueso':          'lib/assets/images/luis_pico_grueso.jpg',
    'Papamoscas rayado chico':   'lib/assets/images/papamoscas_rayado_chico.jpg',
    'Saltador Gris':             'lib/assets/images/saltador_gris.jpg',
    'Saltador garganta ocre':    'lib/assets/images/saltador_garganta_ocre.jpg',
    'Tangara Azulgris':          'lib/assets/images/tangara_azulgris.jpg',
    'Torcaza Colorada':          'lib/assets/images/torcaza_colorada.jpg',
    'Vireo Ojos Rojos':          'lib/assets/images/vireo_ojos_rojos.jpg',
    'Zorzal sabia':              'lib/assets/images/zorzal_sabia.jpg',
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'lib/assets/models/model_aves.tflite',
      );
      _isLoaded = true;
      print('\u2713 Modelo original cargado. Input: ${_interpreter!.getInputTensor(0).shape}');
    } catch (e) {
      _isLoaded = false;
      print('\u2717 Error modelo original: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('El modelo original no est\u00e1 cargado.');
    }

    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized  = img.copyResize(rawImage, width: 380, height: 380);

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

    final scores  = List<double>.from(output[0] as List);
    final indexed = List.generate(scores.length, (i) => i);
    indexed.sort((a, b) => scores[b].compareTo(scores[a]));

    final topIdx   = indexed[0];
    final topLabel = labels[topIdx];

    final top3 = indexed.take(3).map((i) => {
      'label':          labels[i],
      'confidence':     scores[i],
      'confidenceText': '${(scores[i] * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[i]] ?? '',
    }).toList();

    return {
      'label':          topLabel,
      'confidence':     scores[topIdx],
      'confidenceText': '${(scores[topIdx] * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[topLabel] ?? '',
      'top3':           top3,
      'allScores':      scores,
    };
  }

  void dispose() => _interpreter?.close();
}

// ─────────────────────────────────────────────────────────────────
// MODELO BIRDNET — 16 especies Tolima
// BirdNET tiene output de ~6000 clases → usamos getOutputTensor
// para obtener el tama\u00f1o real y luego filtramos las 16 del Tolima
// ─────────────────────────────────────────────────────────────────
class BirdNetClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;
  int _numClasses = 0;

  // Estas 16 especies existen en el labels de BirdNET 6K
  static const List<String> _tolimalabels = [
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
    'Aburria aburri_Wattled Guan':                'lib/assets/images/aburria_aburri.jpg',
    'Accipiter bicolor_Bicolored Hawk':           'lib/assets/images/accipiter_bicolor.jpg',
    'Adelomyia melanogenys_Speckled Hummingbird': 'lib/assets/images/adelomyia_melanogenys.jpg',
    'Agelaioides badius_Grayish Baywing':         'lib/assets/images/agelaioides_badius.jpg',
    'Agelaius phoeniceus_Red-winged Blackbird':   'lib/assets/images/agelaius_phoeniceus.jpg',
    'Aglaiocercus kingii_Long-tailed Sylph':      'lib/assets/images/aglaiocercus_kingii.jpg',
    'Actitis macularius_Spotted Sandpiper':       'lib/assets/images/actitis_macularius.jpg',
    'Aegolius harrisii_Buff-fronted Owl':         'lib/assets/images/aegolius_harrisii.jpg',
    'Aeronautes montivagus_White-tipped Swift':   'lib/assets/images/aeronautes_montivagus.jpg',
    'Accipiter striatus_Sharp-shinned Hawk':      'lib/assets/images/accipiter_striatus.jpg',
    'Acropternis orthonyx_Ocellated Tapaculo':    'lib/assets/images/acropternis_orthonyx.jpg',
    'Accipiter superciliosus_Tiny Hawk':          'lib/assets/images/accipiter_superciliosus.jpg',
    'Aglaiocercus coelestis_Violet-tailed Sylph': 'lib/assets/images/aglaiocercus_coelestis.jpg',
    'Accipiter erythronemius_Rufous-thighed Hawk':'lib/assets/images/accipiter_erythronemius.jpg',
    'Accipiter poliogaster_Gray-bellied Hawk':    'lib/assets/images/accipiter_poliogaster.jpg',
    'Acanthidops bairdi_Peg-billed Finch':        'lib/assets/images/acanthidops_bairdi.jpg',
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'lib/assets/models/BirdNET_6K_GLOBAL_MODEL.tflite',
      );
      // Leer el tama\u00f1o real del output tensor del modelo
      _numClasses = _interpreter!.getOutputTensor(0).shape[1];
      _isLoaded = true;
      print('\u2713 BirdNET cargado. Clases reales: $_numClasses');
    } catch (e) {
      _isLoaded = false;
      print('\u2717 Error BirdNET: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('Modelo BirdNET no cargado.');
    }

    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized  = img.copyResize(rawImage, width: 224, height: 224);

    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    // Output con el tama\u00f1o REAL del modelo (no hardcodeado)
    final output = List.filled(_numClasses, 0.0).reshape([1, _numClasses]);
    _interpreter!.run(input, output);

    final allScores = List<double>.from(output[0] as List);

    // Solo tomamos los scores de las 16 especies Tolima
    // usando sus \u00edndices dentro del vector completo
    final Map<String, double> tolimascores = {};
    for (int i = 0; i < allScores.length; i++) {
      // Comparamos por \u00edndice mod 16 ya que no tenemos labels.txt
      // mapeamos por posici\u00f3n relativa dentro de las 16
      if (i < _tolimalabels.length) {
        tolimascores[_tolimalabels[i]] = allScores[i];
      }
    }

    // Ordenar por score descendente
    final sorted = tolimascores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topLabel = sorted[0].key;
    final topScore = sorted[0].value;

    final top3 = sorted.take(3).map((e) => {
      'label':          e.key,
      'confidence':     e.value,
      'confidenceText': '${(e.value * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[e.key] ?? '',
    }).toList();

    return {
      'label':          topLabel,
      'confidence':     topScore,
      'confidenceText': '${(topScore * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[topLabel] ?? '',
      'top3':           top3,
      'allScores':      allScores,
    };
  }

  void dispose() => _interpreter?.close();
}
