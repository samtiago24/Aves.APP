import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class BirdClassifier {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  static const List<String> labels = [
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
  ];

  static const Map<String, String> referenceImages = {
    'Avefría teroCSV': 'lib/assets/images/avefria_terocsv.jpg',
    'Baltimore Oriole': 'lib/assets/images/baltimore_oriole.jpg',
    'Bienteveo Común': 'lib/assets/images/bienteveo_comun.jpg',
    'Canario coronado': 'lib/assets/images/canario_coronado.jpg',
    'Colibrí Cola Canela': 'lib/assets/images/colibri_cola_canela.jpg',
    'Fiofío Silbón': 'lib/assets/images/fiofio_silbon.jpg',
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
      _interpreter = await Interpreter.fromAsset(
        'lib/assets/models/model_aves.tflite',
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
      throw Exception('El modelo no está cargado. Llama loadModel() primero.');
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

    // RF04: Top 3 especies
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
      'referenceImage': referenceImages[topLabel] ?? '', // RF03
      'top3': top3,
      'allScores': scores,
    };
  }

  void dispose() => _interpreter?.close();
}
