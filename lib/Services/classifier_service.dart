import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class BirdClassifier {
  late Interpreter _interpreter;

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
    _interpreter = await Interpreter.fromAsset(
      'assets/models/model_aves.tflite',
    );
    print(
      '✓ Modelo cargado. Input shape: ${_interpreter.getInputTensor(0).shape}',
    );
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    // 1. Decodificar y redimensionar a 380x380 (EfficientNet-B4)
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized = img.copyResize(rawImage, width: 380, height: 380);

    // 2. Normalizar a [0.0, 1.0] con forma [1, 380, 380, 3]
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

    // 3. Output: 16 clases
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    _interpreter.run(input, output);

    // 4. Top resultado
    final scores = List<double>.from(output[0] as List);
    final maxIdx = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));

    return {
      'label': labels[maxIdx],
      'confidence': scores[maxIdx],
      'confidenceText': '${(scores[maxIdx] * 100).toStringAsFixed(1)}%',
      'allScores': scores,
    };
  }

  void dispose() => _interpreter.close();
}
