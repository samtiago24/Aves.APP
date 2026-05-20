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
      print('[ORIGINAL] ✓ Modelo cargado.');
      print('[ORIGINAL]    Input : ${_interpreter!.getInputTensor(0).shape}');
      print('[ORIGINAL]    Output: ${_interpreter!.getOutputTensor(0).shape}');
    } catch (e) {
      _isLoaded = false;
      print('[ORIGINAL] ✗ Error al cargar: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('El modelo original no est\u00e1 cargado.');
    }
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized  = img.copyResize(rawImage, width: 380, height: 380);
    final input = List.generate(1, (_) =>
      List.generate(380, (y) =>
        List.generate(380, (x) {
          final p = resized.getPixel(x, y);
          return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
        })));
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    _interpreter!.run(input, output);
    final scores  = List<double>.from(output[0] as List);
    final indexed = List.generate(scores.length, (i) => i)
      ..sort((a, b) => scores[b].compareTo(scores[a]));
    final topIdx   = indexed[0];
    final topLabel = labels[topIdx];
    final top3 = indexed.take(3).map((i) => {
      'label': labels[i], 'confidence': scores[i],
      'confidenceText': '${(scores[i]*100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[labels[i]] ?? '',
    }).toList();
    return {
      'label': topLabel, 'confidence': scores[topIdx],
      'confidenceText': '${(scores[topIdx]*100).toStringAsFixed(1)}%',
      'referenceImage': referenceImages[topLabel] ?? '',
      'top3': top3, 'allScores': scores,
    };
  }

  void dispose() => _interpreter?.close();
}

// ─────────────────────────────────────────────────────────────────
// MODELO BIRDNET — 16 especies Tolima
// ─────────────────────────────────────────────────────────────────
class BirdNetClassifier {
  Interpreter? _interpreter;
  bool _isLoaded  = false;
  int  _inputH    = 224;
  int  _inputW    = 224;
  int  _inputC    = 3;
  int  _numClasses = 0;
  List<int> _rawInShape  = [];
  List<int> _rawOutShape = [];

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

      _rawInShape  = _interpreter!.getInputTensor(0).shape;
      _rawOutShape = _interpreter!.getOutputTensor(0).shape;

      print('[BIRDNET] ✓ Modelo cargado.');
      print('[BIRDNET]    Num inputs      : ${_interpreter!.getInputTensors().length}');
      print('[BIRDNET]    Num outputs     : ${_interpreter!.getOutputTensors().length}');
      print('[BIRDNET]    Input  shape    : $_rawInShape');
      print('[BIRDNET]    Input  dtype    : ${_interpreter!.getInputTensor(0).type}');
      print('[BIRDNET]    Output shape    : $_rawOutShape');
      print('[BIRDNET]    Output dtype    : ${_interpreter!.getOutputTensor(0).type}');

      // Parsear input shape
      if (_rawInShape.length == 4) {
        // [1, H, W, C]
        _inputH = _rawInShape[1];
        _inputW = _rawInShape[2];
        _inputC = _rawInShape[3];
        print('[BIRDNET]    Modo            : imagen [H=$_inputH W=$_inputW C=$_inputC]');
      } else if (_rawInShape.length == 2) {
        // [1, N] → flat (espectrograma aplanado)
        _inputH = _rawInShape[1];
        _inputW = 1;
        _inputC = 1;
        print('[BIRDNET]    Modo            : flat vector [N=${_rawInShape[1]}]');
      } else {
        print('[BIRDNET]    ADVERTENCIA     : shape desconocido $_rawInShape');
      }

      _numClasses = _rawOutShape.length > 1 ? _rawOutShape[1] : _rawOutShape[0];
      print('[BIRDNET]    Clases totales  : $_numClasses');
      _isLoaded = true;

    } catch (e, stack) {
      _isLoaded = false;
      print('[BIRDNET] ✗ Error al cargar: $e');
      print('[BIRDNET]    StackTrace: $stack');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('Modelo BirdNET no cargado.');
    }

    print('[BIRDNET] --- Iniciando clasificaci\u00f3n ---');
    print('[BIRDNET]    Archivo     : ${imageFile.path}');
    print('[BIRDNET]    Input shape : $_rawInShape');
    print('[BIRDNET]    Output shape: $_rawOutShape');
    print('[BIRDNET]    H=$_inputH W=$_inputW C=$_inputC clases=$_numClasses');

    try {
      final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
      print('[BIRDNET]    Imagen original : ${rawImage.width}x${rawImage.height}');

      dynamic input;

      if (_rawInShape.length == 2) {
        // Modelo espera vector plano [1, N]
        // Redimensionamos a NxN escala de grises y aplanamos
        final side   = (_rawInShape[1] as num).toDouble();
        final sqSide = side.isFinite ? side.ceil() : 144;
        final resized = img.copyResize(rawImage, width: sqSide, height: 1);
        final flat = List.generate(_rawInShape[1], (x) {
          if (x < resized.width) {
            final p = resized.getPixel(x, 0);
            return (p.r * 0.299 + p.g * 0.587 + p.b * 0.114) / 255.0;
          }
          return 0.0;
        });
        input = [flat];
        print('[BIRDNET]    Input construido: flat vector [${flat.length}]');

      } else {
        // Modelo espera imagen [1, H, W, C]
        final resized = img.copyResize(rawImage, width: _inputW, height: _inputH);
        if (_inputC == 1) {
          input = List.generate(1, (_) =>
            List.generate(_inputH, (y) =>
              List.generate(_inputW, (x) {
                final p    = resized.getPixel(x, y);
                final gray = (p.r * 0.299 + p.g * 0.587 + p.b * 0.114) / 255.0;
                return [gray];
              })));
          print('[BIRDNET]    Input construido: [$_inputH x $_inputW x 1] grayscale');
        } else {
          input = List.generate(1, (_) =>
            List.generate(_inputH, (y) =>
              List.generate(_inputW, (x) {
                final p = resized.getPixel(x, y);
                return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
              })));
          print('[BIRDNET]    Input construido: [$_inputH x $_inputW x 3] RGB');
        }
      }

      final output = List.filled(_numClasses, 0.0).reshape([1, _numClasses]);
      print('[BIRDNET]    Ejecutando inference...');
      _interpreter!.run(input, output);
      print('[BIRDNET]    ✓ Inference OK');

      final allScores = List<double>.from(output[0] as List);
      final n = _tolimalabels.length < allScores.length
          ? _tolimalabels.length
          : allScores.length;

      final Map<String, double> tolimaScores = {
        for (int i = 0; i < n; i++) _tolimalabels[i]: allScores[i],
      };

      final sorted = tolimaScores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      print('[BIRDNET]    Top 3 resultados:');
      for (int i = 0; i < 3 && i < sorted.length; i++) {
        print('[BIRDNET]      ${i+1}. ${sorted[i].key} → ${(sorted[i].value*100).toStringAsFixed(2)}%');
      }

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

    } catch (e, stack) {
      print('[BIRDNET] ✗ Error en classify(): $e');
      print('[BIRDNET]    StackTrace: $stack');
      rethrow;
    }
  }

  void dispose() => _interpreter?.close();
}
