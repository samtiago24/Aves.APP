import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aves_app/Services/classifier_service.dart';

class IdentificarAveScreen extends StatefulWidget {
  const IdentificarAveScreen({super.key});

  @override
  State<IdentificarAveScreen> createState() => _IdentificarAveScreenState();
}

class _IdentificarAveScreenState extends State<IdentificarAveScreen> {
  File? _image;
  final _picker = ImagePicker();
  final _classifier = BirdClassifier();
  Map<String, dynamic>? _result;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.loadModel();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cargando modelo: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 380,
      maxHeight: 380,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = null;
      });
      _runInference();
    }
  }

  Future<void> _runInference() async {
    if (_image == null) return;
    setState(() => _isLoading = true);
    try {
      final result = await _classifier.classify(_image!);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al clasificar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF80BA27);
    final darkBlue = const Color(0xFF2C3E50);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IDENTIFICAR AVE'),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (_image != null)
              Center(child: Image.file(_image!, height: 250))
            else
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(Icons.image_search, size: 100, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(color: primaryGreen),
                  const SizedBox(height: 8),
                  const Text('Analizando imagen...'),
                ],
              )
            else if (_result != null)
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
                      'Especie Detectada:',
                      style: TextStyle(color: darkBlue, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result!['label'].toString().toUpperCase(),
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Confianza: ${_result!["confidenceText"]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('CÁMARA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('GALERÍA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
