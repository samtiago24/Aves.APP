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

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/model_aves.tflite',
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
    final maxIdx = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));

    return {
      'label': labels[maxIdx],
      'confidence': scores[maxIdx],
      'confidenceText': '${(scores[maxIdx] * 100).toStringAsFixed(1)}%',
      'allScores': scores,
    };
  }

  void dispose() => _interpreter?.close();
}
