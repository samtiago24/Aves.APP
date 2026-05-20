import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

// Autores: Santiago Lopez, Sebastian Castro

enum ModeloAves { original, birdnet }

// ─────────────────────────────────────────────────────────────────
// MODELO ORIGINAL — 16 especies (model_aves.tflite)
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
    'Avefr\u00eda teroCSV':       'lib/assets/images/avefria_terocsv.jpg',
    'Baltimore Oriole':         'lib/assets/images/baltimore_oriole.jpg',
    'Bienteveo Com\u00fan':       'lib/assets/images/bienteveo_comun.jpg',
    'Canario coronado':         'lib/assets/images/canario_coronado.jpg',
    'Colibr\u00ed Cola Canela':   'lib/assets/images/colibri_cola_canela.jpg',
    'Fiof\u00edo Silb\u00f3n':      'lib/assets/images/fiofio_silbon.jpg',
    'Garza dedos dorados':      'lib/assets/images/garza_dedos_dorados.jpg',
    'Jacana':                   'lib/assets/images/jacana.jpg',
    'Luis Pico Grueso':         'lib/assets/images/luis_pico_grueso.jpg',
    'Papamoscas rayado chico':  'lib/assets/images/papamoscas_rayado_chico.jpg',
    'Saltador Gris':            'lib/assets/images/saltador_gris.jpg',
    'Saltador garganta ocre':   'lib/assets/images/saltador_garganta_ocre.jpg',
    'Tangara Azulgris':         'lib/assets/images/tangara_azulgris.jpg',
    'Torcaza Colorada':         'lib/assets/images/torcaza_colorada.jpg',
    'Vireo Ojos Rojos':         'lib/assets/images/vireo_ojos_rojos.jpg',
    'Zorzal sabia':             'lib/assets/images/zorzal_sabia.jpg',
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('lib/assets/models/model_aves.tflite');
      _isLoaded = true;
      print('[ORIGINAL] \u2713 Modelo cargado.');
      print('[ORIGINAL]    Input : ${_interpreter!.getInputTensor(0).shape}');
      print('[ORIGINAL]    Output: ${_interpreter!.getOutputTensor(0).shape}');
    } catch (e) {
      _isLoaded = false;
      print('[ORIGINAL] \u2717 Error al cargar: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) throw Exception('Modelo original no cargado.');
    final raw     = img.decodeImage(await imageFile.readAsBytes())!;
    final resized = img.copyResize(raw, width: 380, height: 380);
    final input   = List.generate(1, (_) => List.generate(380, (y) => List.generate(380, (x) {
      final p = resized.getPixel(x, y);
      return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
    })));
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    _interpreter!.run(input, output);
    final scores  = List<double>.from(output[0] as List);
    final indexed = List.generate(scores.length, (i) => i)..sort((a, b) => scores[b].compareTo(scores[a]));
    final topIdx  = indexed[0];
    final top3    = indexed.take(3).map((i) => {
      'label': labels[i], 'confidence': scores[i],
      'confidenceText': '${(scores[i]*100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[i]] ?? '',
    }).toList();
    return {
      'label': labels[topIdx], 'confidence': scores[topIdx],
      'confidenceText': '${(scores[topIdx]*100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[topIdx]] ?? '',
      'top3': top3, 'allScores': scores,
    };
  }

  void dispose() => _interpreter?.close();
}

// ─────────────────────────────────────────────────────────────────
// MODELO BIRDNET — 16 especies Tolima
// Input real: [1, 144, 144, 1]  Output real: [1, 6522]
// ─────────────────────────────────────────────────────────────────
class BirdNetClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  // Shapes reales confirmados por log
  static const int _H = 144;
  static const int _W = 144;
  static const int _C = 1;          // grayscale
  static const int _numClasses = 6522;

  // Info de diagnóstico expuesta a la UI
  String infoInput  = '';
  String infoOutput = '';
  String infoTop3   = '';
  String infoError  = '';

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
      final inShape  = _interpreter!.getInputTensor(0).shape;
      final outShape = _interpreter!.getOutputTensor(0).shape;
      infoInput  = 'Input : $inShape  dtype: ${_interpreter!.getInputTensor(0).type}';
      infoOutput = 'Output: $outShape  dtype: ${_interpreter!.getOutputTensor(0).type}';
      print('[BIRDNET] \u2713 Modelo cargado.');
      print('[BIRDNET]    $infoInput');
      print('[BIRDNET]    $infoOutput');
      print('[BIRDNET]    Usando H=$_H W=$_W C=$_C clases=$_numClasses');
      _isLoaded = true;
    } catch (e, st) {
      _isLoaded = false;
      infoError = 'Error al cargar:\n$e';
      print('[BIRDNET] \u2717 $infoError');
      print('[BIRDNET]    $st');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) throw Exception('Modelo BirdNET no cargado.');

    infoError = '';
    infoTop3  = '';
    print('[BIRDNET] --- Clasificando ---');

    try {
      final raw     = img.decodeImage(await imageFile.readAsBytes())!;
      final resized = img.copyResize(raw, width: _W, height: _H);
      print('[BIRDNET]    Imagen: ${raw.width}x${raw.height} → ${_W}x${_H} grayscale');

      // Input [1, 144, 144, 1] grayscale float32
      final input = List.generate(1, (_) =>
        List.generate(_H, (y) =>
          List.generate(_W, (x) {
            final p    = resized.getPixel(x, y);
            final gray = (p.r * 0.299 + p.g * 0.587 + p.b * 0.114) / 255.0;
            return [gray];
          })
        )
      );

      final output = List.filled(_numClasses, 0.0).reshape([1, _numClasses]);
      print('[BIRDNET]    Ejecutando inference...');
      _interpreter!.run(input, output);
      print('[BIRDNET]    \u2713 Inference OK');

      final allScores = List<double>.from(output[0] as List);
      final n = _tolimalabels.length.clamp(0, allScores.length);
      final tolimaScores = { for (int i = 0; i < n; i++) _tolimalabels[i]: allScores[i] };
      final sorted = tolimaScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      // Guardar top3 para el diálogo
      infoTop3 = sorted.take(3).indexed.map((e) =>
        '${e.$1+1}. ${e.$2.key}\n   → ${(e.$2.value*100).toStringAsFixed(2)}%'
      ).join('\n');
      print('[BIRDNET]    Top 3:\n$infoTop3');

      final topLabel = sorted[0].key;
      final topScore = sorted[0].value;
      final top3 = sorted.take(3).map((e) => {
        'label': e.key, 'confidence': e.value,
        'confidenceText': '${(e.value*100).toStringAsFixed(1)}%',
        'referenceImage': referenceImages[e.key] ?? '',
      }).toList();

      return {
        'label': topLabel, 'confidence': topScore,
        'confidenceText': '${(topScore*100).toStringAsFixed(1)}%',
        'referenceImage': referenceImages[topLabel] ?? '',
        'top3': top3, 'allScores': allScores,
      };

    } catch (e, st) {
      infoError = '$e';
      print('[BIRDNET] \u2717 Error en classify(): $e');
      print('[BIRDNET]    $st');
      rethrow;
    }
  }

  void dispose() => _interpreter?.close();
}
