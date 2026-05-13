import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Asegúrate de que esta ruta sea la correcta donde guardaste tu BirdClassifier
import 'package:aves_app/Services/classifier_service.dart';

class IdentificarAveScreen extends StatefulWidget {
  const IdentificarAveScreen({super.key});

  @override
  State<IdentificarAveScreen> createState() => _IdentificarAveScreenState();
}

class _IdentificarAveScreenState extends State<IdentificarAveScreen> {
  File? _image;
  final _picker = ImagePicker();

  // CORRECCIÓN: Usar el nombre de la clase que definiste: BirdClassifier
  final _classifier = BirdClassifier();
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // RNF02: Carga el modelo al inicio para que la respuesta sea < 2s [cite: 20]
  Future<void> _loadModel() async {
    await _classifier.loadModel();
  }

  // RF01: Captura de imagen desde cámara o galería [cite: 4]
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 224, // Optimizado para el tamaño de entrada de tu modelo
      maxHeight: 224,
      imageQuality: 80, // RNF07: Optimización de almacenamiento
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _runInference();
    }
  }

  // RF02: Ejecutar el modelo localmente
  Future<void> _runInference() async {
    if (_image != null) {
      final result = await _classifier.classify(_image!);
      setState(() {
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // RNF04: Colores Institucionales UCC [cite: 23]
    final primaryGreen = const Color(0xFF80BA27);
    final darkBlue = const Color(0xFF2C3E50);

    return Scaffold(
      appBar: AppBar(
        title: const Text("IDENTIFICAR AVE"),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // RF03: Validación Visual - Mostrar la foto capturada [cite: 6]
            if (_image != null)
              Center(child: Image.file(_image!, height: 250))
            else
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(Icons.image_search, size: 100, color: Colors.grey),
              ),

            if (_result != null)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    Text(
                      "Especie Detectada:",
                      style: TextStyle(color: darkBlue, fontSize: 16),
                    ),
                    Text(
                      _result!['label'].toString().toUpperCase(),
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Confianza: ${_result!['confidenceText']}"),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("CÁMARA"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("GALERÍA"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
