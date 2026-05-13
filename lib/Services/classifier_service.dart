import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class BirdClassifier {
  late Interpreter _interpreter;

  static const List<String> labels = [
    'Aguililla Cola Corta',
    'Chimachimá',
    'Chipe Peregrino',
    'Chipe Tropical',
    'Garza Nocturna Corona Negra',
    'Paloma Doméstica',
    'Papamoscas Verdoso',
    'Picogordo Degollado',
    'Sangretoro Encendido',
    'Titira Puerquito',
    'Trepatroncos Montano',
    'Trepatroncos Pardo',
    'Vencejo Collar Blanco',
    'Vireo Verdeamarillo',
    'Zopilote Aura',
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
    // 1. Decodificar y redimensionar a 224x224
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized = img.copyResize(rawImage, width: 224, height: 224);

    // 2. Normalizar a [0.0, 1.0] con forma [1, 224, 224, 3]
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

    // 3. Output con el número correcto de clases
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    _interpreter.run(input, output);

    // 4. Obtener top resultado
    final scores = List<double>.from(output[0] as List);
    final maxIdx = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));

    // 5. Retornar nombre + confianza
    return {
      'label': labels[maxIdx],
      'confidence': scores[maxIdx],
      'confidenceText': '${(scores[maxIdx] * 100).toStringAsFixed(1)}%',
      'allScores': scores,
    };
  }

  void dispose() => _interpreter.close();
}
