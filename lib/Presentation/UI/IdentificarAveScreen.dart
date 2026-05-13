import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aves_app/Services/classifier_service.dart';
import 'package:aves_app/Services/database_service.dart';
import 'package:aves_app/Services/location_service.dart';

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
  bool _isSaving = false;

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
          SnackBar(content: Text('Error cargando modelo: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source, maxWidth: 380, maxHeight: 380, imageQuality: 90,
    );
    if (pickedFile != null) {
      setState(() { _image = File(pickedFile.path); _result = null; });
      _runInference();
    }
  }

  Future<void> _runInference() async {
    if (_image == null) return;
    setState(() => _isLoading = true);
    try {
      final result = await _classifier.classify(_image!);
      setState(() { _result = result; _isLoading = false; });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // RF05 + RF08: Guardar con GPS
  Future<void> _guardarAvistamiento() async {
    if (_result == null || _image == null) return;
    setState(() => _isSaving = true);
    try {
      final position = await LocationService.getCurrentPosition();
      final lat = position?.latitude ?? 0.0;
      final lng = position?.longitude ?? 0.0;
      final top3 = _result!['top3'] as List<Map<String, dynamic>>;
      await DatabaseService.guardarAvistamiento(
        especie: top3.first['label'].toString(),
        confianza: top3.first['confidence'] as double,
        fotoPath: _image!.path,
        latitud: lat,
        longitud: lng,
      );
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(position != null
              ? '\u2713 Guardado: ${top3.first['label']} (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})'
              : '\u2713 Guardado sin GPS (permiso denegado)'),
          backgroundColor: const Color(0xFF80BA27),
        ));
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _image != null
                  ? Image.file(_image!, height: 220, fit: BoxFit.cover)
                  : Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.image_search, size: 80, color: Colors.grey)),
                    ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              Column(children: [
                CircularProgressIndicator(color: primaryGreen),
                const SizedBox(height: 8),
                const Text('Analizando imagen...', textAlign: TextAlign.center),
              ])
            else if (_result != null)
              ..._buildResults(primaryGreen, darkBlue),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('C\u00c1MARA'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('GALER\u00cdA'),
                  style: ElevatedButton.styleFrom(backgroundColor: darkBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                )),
              ],
            ),
            if (_result != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: (_isSaving || _isLoading) ? null : _guardarAvistamiento,
                icon: _isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_alt),
                label: Text(_isSaving ? 'Guardando...' : 'GUARDAR AVISTAMIENTO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResults(Color primaryGreen, Color darkBlue) {
    final top3 = _result!['top3'] as List<Map<String, dynamic>>;
    final topResult = top3.first;
    final refImage = topResult['referenceImage'] as String;

    return [
      Text('Especie Detectada',
          style: TextStyle(color: darkBlue, fontSize: 13, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: Column(children: [
          const Text('Tu foto', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          ClipRRect(borderRadius: BorderRadius.circular(8),
              child: Image.file(_image!, height: 130, fit: BoxFit.cover)),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(children: [
          const Text('Referencia', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          ClipRRect(borderRadius: BorderRadius.circular(8),
              child: refImage.isNotEmpty
                  ? Image.asset(refImage, height: 130, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _noRefImage())
                  : _noRefImage()),
        ])),
      ]),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryGreen),
        ),
        child: Column(children: [
          Text(topResult['label'].toString().toUpperCase(),
              style: TextStyle(color: primaryGreen, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Text('Confianza: ${topResult['confidenceText']}',
              style: TextStyle(color: darkBlue, fontSize: 15)),
        ]),
      ),
      const SizedBox(height: 12),
      Text('Ranking de probabilidades',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold, fontSize: 14)),
      const SizedBox(height: 6),
      ...List.generate(top3.length, (i) {
        final item = top3[i];
        final confidence = item['confidence'] as double;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: i == 0 ? primaryGreen.withOpacity(0.08) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: i == 0 ? primaryGreen : Colors.grey.shade300),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: i == 0 ? primaryGreen : Colors.grey.shade400,
              child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(item['label'].toString(),
                style: TextStyle(fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 13))),
            Text(item['confidenceText'].toString(),
                style: TextStyle(color: i == 0 ? primaryGreen : Colors.grey.shade600,
                    fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(width: 8),
            SizedBox(width: 60, child: LinearProgressIndicator(
              value: confidence,
              backgroundColor: Colors.grey.shade200,
              color: i == 0 ? primaryGreen : Colors.grey.shade400,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            )),
          ]),
        );
      }),
    ];
  }

  Widget _noRefImage() => Container(
    height: 130,
    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
    child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40)),
  );
}
