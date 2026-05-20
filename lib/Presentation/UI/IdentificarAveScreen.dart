import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aves_app/Services/classifier_service.dart';
import 'package:aves_app/Services/database_service.dart';
import 'package:aves_app/Services/location_service.dart';
import 'package:aves_app/Presentation/UI/DistribucionAveScreen.dart';

// Autores: Santiago Lopez, Sebastian Castro

class IdentificarAveScreen extends StatefulWidget {
  const IdentificarAveScreen({super.key});

  @override
  State<IdentificarAveScreen> createState() => _IdentificarAveScreenState();
}

class _IdentificarAveScreenState extends State<IdentificarAveScreen> {
  File? _image;
  final _picker = ImagePicker();

  // Clasificadores
  final _classifierOriginal = BirdClassifier();
  final _classifierBirdNet  = BirdNetClassifier();

  // Modelo activo
  ModeloAves _modeloSeleccionado = ModeloAves.original;
  bool _modeloOriginalListo  = false;
  bool _modeloBirdNetListo   = false;

  Map<String, dynamic>? _result;
  bool _isLoading  = false;
  bool _isSaving   = false;
  bool _noEsAve    = false;

  static const double _umbralConfianza = 0.60;

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    // Carga ambos modelos en paralelo
    await Future.wait([
      _classifierOriginal.loadModel().then((_) {
        if (mounted) setState(() => _modeloOriginalListo = true);
      }).catchError((e) {
        if (mounted) _showSnack('Error modelo original: $e', Colors.red);
      }),
      _classifierBirdNet.loadModel().then((_) {
        if (mounted) setState(() => _modeloBirdNetListo = true);
      }).catchError((e) {
        if (mounted) _showSnack('Error modelo BirdNET: $e', Colors.red);
      }),
    ]);
  }

  bool get _modeloActualListo => _modeloSeleccionado == ModeloAves.original
      ? _modeloOriginalListo
      : _modeloBirdNetListo;

  Future<Map<String, dynamic>> _clasificar(File image) =>
      _modeloSeleccionado == ModeloAves.original
          ? _classifierOriginal.classify(image)
          : _classifierBirdNet.classify(image);

  int get _cantidadEspecies => _modeloSeleccionado == ModeloAves.original ? 16 : 16;
  String get _nombreModelo  => _modeloSeleccionado == ModeloAves.original
      ? 'Modelo Original (16 aves)'
      : 'BirdNET Tolima (16 aves)';

  void _cambiarModelo(ModeloAves nuevo) {
    setState(() {
      _modeloSeleccionado = nuevo;
      _result  = null;
      _noEsAve = false;
      _image   = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 380,
      maxHeight: 380,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (pickedFile != null) {
      setState(() { _image = File(pickedFile.path); _result = null; _noEsAve = false; });
      _runInference();
    }
  }

  Future<void> _runInference() async {
    if (_image == null) return;
    if (!_modeloActualListo) {
      _showSnack('El modelo aún se está cargando...', Colors.orange);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final result = await _clasificar(_image!);
      final top3 = result['top3'] as List<Map<String, dynamic>>;
      final topConfianza = top3.first['confidence'] as double;
      if (topConfianza < _umbralConfianza) {
        setState(() { _result = null; _noEsAve = true; _isLoading = false; });
      } else {
        setState(() { _result = result; _noEsAve = false; _isLoading = false; });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Error al analizar: $e', Colors.red);
    }
  }

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
      if (mounted) _showSnack(
        position != null
            ? '\u2713 Guardado: ${top3.first['label']} (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})'
            : '\u2713 Guardado sin GPS',
        const Color(0xFF80BA27),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      _showSnack('Error al guardar: $e', Colors.red);
    }
  }

  void _verDistribucion() {
    if (_result == null) return;
    final top3 = _result!['top3'] as List<Map<String, dynamic>>;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => DistribucionAveScreen(
        especie: top3.first['label'].toString(),
        confianza: top3.first['confidence'] as double,
      ),
    ));
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _classifierOriginal.dispose();
    _classifierBirdNet.dispose();
    super.dispose();
  }

  // ─── UI ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF80BA27);
    const darkBlue     = Color(0xFF2C3E50);

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

            // ── Selector de modelo ──────────────────────────
            _buildModelSelector(primaryGreen, darkBlue),
            const SizedBox(height: 14),

            // ── Imagen ──────────────────────────────────────
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

            // ── Resultado ───────────────────────────────────
            if (_isLoading)
              Column(children: [
                CircularProgressIndicator(color: primaryGreen),
                const SizedBox(height: 8),
                Text('Analizando con $_nombreModelo...', textAlign: TextAlign.center),
              ])
            else if (_noEsAve)
              _buildNoEsAveCard(_cantidadEspecies)
            else if (_result != null)
              ..._buildResults(primaryGreen, darkBlue),

            const SizedBox(height: 16),

            // ── Botones cámara / galería ────────────────────
            Row(children: [
              Expanded(child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('CÁMARA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('GALERÍA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )),
            ]),

            if (_result != null && !_noEsAve) ...[
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _verDistribucion,
                icon: const Icon(Icons.map_outlined),
                label: const Text('VER DÓNDE ENCONTRARLA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: (_isSaving || _isLoading) ? null : _guardarAvistamiento,
                icon: _isSaving
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_alt),
                label: Text(_isSaving ? 'Guardando...' : 'GUARDAR AVISTAMIENTO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white,
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

  // ── Selector de modelo ──────────────────────────────────────
  Widget _buildModelSelector(Color primaryGreen, Color darkBlue) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: darkBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: darkBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.model_training, color: darkBlue, size: 18),
            const SizedBox(width: 6),
            Text('Modelo de identificación',
                style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold, fontSize: 13)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            // Opción: Modelo Original
            Expanded(child: _modeloBtn(
              label: 'Modelo Original',
              sublabel: '16 aves',
              icon: Icons.science,
              activo: _modeloSeleccionado == ModeloAves.original,
              listo: _modeloOriginalListo,
              color: primaryGreen,
              onTap: () => _cambiarModelo(ModeloAves.original),
            )),
            const SizedBox(width: 10),
            // Opción: BirdNET
            Expanded(child: _modeloBtn(
              label: 'BirdNET',
              sublabel: 'Tolima 16 aves',
              icon: Icons.travel_explore,
              activo: _modeloSeleccionado == ModeloAves.birdnet,
              listo: _modeloBirdNetListo,
              color: const Color(0xFF1565C0),
              onTap: () => _cambiarModelo(ModeloAves.birdnet),
            )),
          ]),
        ],
      ),
    );
  }

  Widget _modeloBtn({
    required String label,
    required String sublabel,
    required IconData icon,
    required bool activo,
    required bool listo,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: activo ? color.withOpacity(0.12) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: activo ? color : Colors.grey.shade300,
            width: activo ? 2 : 1,
          ),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: activo ? color : Colors.grey, size: 18),
            const SizedBox(width: 4),
            if (!listo)
              SizedBox(width: 14, height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color))
            else
              Icon(Icons.check_circle, color: color, size: 14),
          ]),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                color: activo ? color : Colors.grey.shade600,
                fontWeight: activo ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center),
          Text(sublabel,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  // ── No es ave ───────────────────────────────────────────────
  Widget _buildNoEsAveCard(int nEspecies) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(children: [
        Icon(Icons.do_not_disturb_alt_rounded, color: Colors.red.shade400, size: 52),
        const SizedBox(height: 10),
        Text('No se detectó un ave',
            style: TextStyle(color: Colors.red.shade700, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
          'La imagen no corresponde a ninguna de las $nEspecies especies del modelo activo.\nIntenta con una foto más clara o desde otro ángulo.',
          style: TextStyle(color: Colors.red.shade600, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }

  // ── Resultados ──────────────────────────────────────────────
  List<Widget> _buildResults(Color primaryGreen, Color darkBlue) {
    final top3      = _result!['top3'] as List<Map<String, dynamic>>;
    final topResult = top3.first;
    final refImage  = topResult['referenceImage'] as String;

    return [
      // Badge del modelo usado
      Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _modeloSeleccionado == ModeloAves.original
                ? const Color(0xFF80BA27).withOpacity(0.15)
                : const Color(0xFF1565C0).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _modeloSeleccionado == ModeloAves.original ? '🧪 Modelo Original' : '🌎 BirdNET Tolima',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _modeloSeleccionado == ModeloAves.original
                  ? const Color(0xFF80BA27)
                  : const Color(0xFF1565C0),
            ),
          ),
        ),
      ),
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
              style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold),
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
        final item       = top3[i];
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
              child: Text('${i + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(item['label'].toString(),
                style: TextStyle(
                    fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal, fontSize: 13))),
            Text(item['confidenceText'].toString(),
                style: TextStyle(
                    color: i == 0 ? primaryGreen : Colors.grey.shade600,
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
