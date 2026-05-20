import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

// Autores: Santiago Lopez, Sebastian Castro

enum ModeloAves { original, birdnet }

class BirdClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  static const List<String> labels = [
    'Avefría teroCSV',
    'Baltimore Oriole',
    'Bienteveo Común',
    'Canario coronado',
    'Colibrí Cola Canela',
    'Fiofiío Silbón',
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
    'Avefría teroCSV': 'lib/assets/images/avefria_terocsv.jpg',
    'Baltimore Oriole': 'lib/assets/images/baltimore_oriole.jpg',
    'Bienteveo Común': 'lib/assets/images/bienteveo_comun.jpg',
    'Canario coronado': 'lib/assets/images/canario_coronado.jpg',
    'Colibrí Cola Canela': 'lib/assets/images/colibri_cola_canela.jpg',
    'Fiofiío Silbón': 'lib/assets/images/fiofio_silbon.jpg',
    'Garza dedos dorados': 'lib/assets/images/garza_dedos_dorados.jpg',
    'Jacana': 'lib/assets/images/jacana.jpg',
    'Luis Pico Grueso': 'lib/assets/images/luis_pico_grueso.jpg',
    'Papamoscas rayado chico': 'lib/assets/images/papamoscas_rayado_chico.jpg',
    'Saltador Gris': 'lib/assets/images/saltador_gris.jpg',
    'Saltador garganta ocre': 'lib/assets/images/saltador_garganta_ocre.jpg',
    'Tangara Azulgris': 'lib/assets/images/tangara_azulgris.jpg',
    'Torcaza Colorada': 'lib/assets/images/torcaza_colorada.jpg',
    'Vireo Ojos Rojos': 'lib/assets/images/vireo_ojos_rojos.jpg',
    'Zorzal sabia': 'lib/assets/images/zorzal_sabia.jpg',
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('lib/assets/models/model_aves.tflite');
      _isLoaded = true;
      print('[ORIGINAL] ✓ Modelo cargado.');
      print('[ORIGINAL]    Input : ${_interpreter!.getInputTensor(0).shape}');
      print('[ORIGINAL]    Output: ${_interpreter!.getOutputTensor(0).shape}');
    } catch (e) {
      _isLoaded = false;
      print('[ORIGINAL] ✗ Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) throw Exception('Modelo original no cargado.');
    final raw = img.decodeImage(await imageFile.readAsBytes())!;
    final resized = img.copyResize(raw, width: 380, height: 380);
    final input = List.generate(1, (_) => List.generate(380, (y) => List.generate(380, (x) {
      final p = resized.getPixel(x, y);
      return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
    })));
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    _interpreter!.run(input, output);
    final scores = List<double>.from(output[0] as List);
    final indexed = List.generate(scores.length, (i) => i)..sort((a, b) => scores[b].compareTo(scores[a]));
    final topIdx = indexed[0];
    final top3 = indexed.take(3).map((i) => {
      'label': labels[i],
      'confidence': scores[i],
      'confidenceText': '${(scores[i] * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[i]] ?? '',
    }).toList();
    return {
      'label': labels[topIdx],
      'confidence': scores[topIdx],
      'confidenceText': '${(scores[topIdx] * 100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[topIdx]] ?? '',
      'top3': top3,
      'allScores': scores,
    };
  }

  void dispose() => _interpreter?.close();
}

class BirdNetClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  static const int _inputSize = 144000;
  static const int _numClasses = 6362;
  static const int _side = 379;

  String infoInput = '';
  String infoOutput = '';
  String infoTop3 = '';
  String infoError = '';
  String infoStack = '';
  String infoDebug = '';
  String infoShapes = '';

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
    'Aburria aburri_Wattled Guan': 'lib/assets/images/aburria_aburri.jpg',
    'Accipiter bicolor_Bicolored Hawk': 'lib/assets/images/accipiter_bicolor.jpg',
    'Adelomyia melanogenys_Speckled Hummingbird': 'lib/assets/images/adelomyia_melanogenys.jpg',
    'Agelaioides badius_Grayish Baywing': 'lib/assets/images/agelaioides_badius.jpg',
    'Agelaius phoeniceus_Red-winged Blackbird': 'lib/assets/images/agelaius_phoeniceus.jpg',
    'Aglaiocercus kingii_Long-tailed Sylph': 'lib/assets/images/aglaiocercus_kingii.jpg',
    'Actitis macularius_Spotted Sandpiper': 'lib/assets/images/actitis_macularius.jpg',
    'Aegolius harrisii_Buff-fronted Owl': 'lib/assets/images/aegolius_harrisii.jpg',
    'Aeronautes montivagus_White-tipped Swift': 'lib/assets/images/aeronautes_montivagus.jpg',
    'Accipiter striatus_Sharp-shinned Hawk': 'lib/assets/images/accipiter_striatus.jpg',
    'Acropternis orthonyx_Ocellated Tapaculo': 'lib/assets/images/acropternis_orthonyx.jpg',
    'Accipiter superciliosus_Tiny Hawk': 'lib/assets/images/accipiter_superciliosus.jpg',
    'Aglaiocercus coelestis_Violet-tailed Sylph': 'lib/assets/images/aglaiocercus_coelestis.jpg',
    'Accipiter erythronemius_Rufous-thighed Hawk': 'lib/assets/images/accipiter_erythronemius.jpg',
    'Accipiter poliogaster_Gray-bellied Hawk': 'lib/assets/images/accipiter_poliogaster.jpg',
    'Acanthidops bairdi_Peg-billed Finch': 'lib/assets/images/acanthidops_bairdi.jpg',
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('lib/assets/models/BirdNET_6K_GLOBAL_MODEL.tflite');
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);
      final inShape = inputTensor.shape;
      final outShape = outputTensor.shape;

      infoInput = 'Input : $inShape  dtype: ${inputTensor.type}';
      infoOutput = 'Output: $outShape  dtype: ${outputTensor.type}';
      infoShapes = 'rankIn=${inShape.length} rankOut=${outShape.length}';
      infoDebug = 'loadModel ok';

      print('[BIRDNET] ✓ Modelo cargado.');
      print('[BIRDNET]    $infoInput');
      print('[BIRDNET]    $infoOutput');
      _isLoaded = true;
    } catch (e, st) {
      _isLoaded = false;
      infoError = '$e';
      infoStack = st.toString();
      infoDebug = 'falló loadModel';
      print('[BIRDNET] ✗ Error loadModel: $e');
      print('[BIRDNET]    $st');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      infoError = 'Modelo BirdNET no cargado';
      infoDebug = 'guard clause _isLoaded/interpreter';
      throw Exception('Modelo BirdNET no cargado.');
    }

    infoError = '';
    infoStack = '';
    infoTop3 = '';
    infoDebug = 'inicio classify';

    try {
      final bytes = await imageFile.readAsBytes();
      infoDebug = 'bytes leídos=${bytes.length}';

      final raw = img.decodeImage(bytes);
      if (raw == null) {
        infoError = 'decodeImage devolvió null';
        infoDebug = 'falló decodeImage';
        throw Exception('No se pudo decodificar la imagen.');
      }

      infoDebug = 'decode ok ${raw.width}x${raw.height}';
      final resized = img.copyResize(raw, width: _side, height: _side);
      infoDebug = 'resize ok ${resized.width}x${resized.height}';

      final flat = List<double>.filled(_inputSize, 0.0);
      int idx = 0;
      for (int y = 0; y < _side; y++) {
        for (int x = 0; x < _side; x++) {
          final p = resized.getPixel(x, y);
          flat[idx++] = (p.r * 0.299 + p.g * 0.587 + p.b * 0.114) / 255.0;
        }
      }

      final input = [flat];
      final output = List.filled(_numClasses, 0.0).reshape([1, _numClasses]);

      infoDebug = 'antes de run | inputType=${input.runtimeType} flatType=${flat.runtimeType} outputType=${output.runtimeType} idx=$idx';
      print('[BIRDNET] DEBUG: $infoDebug');
      print('[BIRDNET] DEBUG input[0] len=${(input[0] as List).length}');
      print('[BIRDNET] DEBUG output len=${(output[0] as List).length}');

      _interpreter!.run(input, output);
      infoDebug = 'run ok';
      print('[BIRDNET] ✓ Inference OK');

      final allScores = List<double>.from(output[0] as List);
      final n = _tolimalabels.length.clamp(0, allScores.length);
      final tolimaScores = <String, double>{
        for (int i = 0; i < n; i++) _tolimalabels[i]: allScores[i],
      };
      final sorted = tolimaScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      infoTop3 = sorted.take(3).toList().asMap().entries.map((e) =>
        '${e.key + 1}. ${e.value.key}\n   → ${(e.value.value * 100).toStringAsFixed(2)}%'
      ).join('\n');
      infoDebug = 'postproceso ok';

      final topLabel = sorted[0].key;
      final topScore = sorted[0].value;
      final top3 = sorted.take(3).map((e) => {
        'label': e.key,
        'confidence': e.value,
        'confidenceText': '${(e.value * 100).toStringAsFixed(1)}%',
        'referenceImage': referenceImages[e.key] ?? '',
      }).toList();

      return {
        'label': topLabel,
        'confidence': topScore,
        'confidenceText': '${(topScore * 100).toStringAsFixed(1)}%',
        'referenceImage': referenceImages[topLabel] ?? '',
        'top3': top3,
        'allScores': allScores,
      };
    } catch (e, st) {
      infoError = '$e';
      infoStack = st.toString();
      infoDebug = 'catch classify | errorType=${e.runtimeType}';
      print('[BIRDNET] ✗ Error en classify(): $e');
      print('[BIRDNET] ✗ Tipo error: ${e.runtimeType}');
      print('[BIRDNET] ✗ StackTrace: $st');
      rethrow;
    }
  }

  void dispose() => _interpreter?.close();
}
