import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aves_app/Services/classifier_service.dart';
import 'package:aves_app/Services/database_service.dart';
import 'package:aves_app/Services/firestore_service.dart';
import 'package:aves_app/Services/location_service.dart';
import 'package:aves_app/Presentation/UI/DistribucionAveScreen.dart';

// Autores: Santiago Lopez, Sebastian Castro

class IdentificarAveScreen extends StatefulWidget {
  const IdentificarAveScreen({super.key});
  @override
  State<IdentificarAveScreen> createState() => _IdentificarAveScreenState();
}

class _IdentificarAveScreenState extends State<IdentificarAveScreen>
    with SingleTickerProviderStateMixin {

  File? _image;
  final _picker = ImagePicker();

  final _classifierOriginal = BirdClassifier();
  final _classifierBirdNet  = BirdNetClassifier();

  ModeloAves _modeloSeleccionado = ModeloAves.original;
  bool _modeloOriginalListo = false;
  bool _modeloBirdNetListo  = false;
  bool _modeloOriginalError = false;

  Map<String, dynamic>? _result;
  bool _isLoading = false;
  bool _isSaving  = false;
  bool _noEsAve   = false;

  static const double _umbralConfianza = 0.40;
  static const _green = Color(0xFF80BA27);
  static const _blue  = Color(0xFF1565C0);
  static const _dark  = Color(0xFF2C3E50);

  @override
  void initState() {
    super.initState();
    _loadModels();
    FirestoreService.sincronizarPendientes();
  }

  Future<void> _loadModels() async {
    _classifierOriginal.loadModel().then((_) {
      if (mounted) setState(() => _modeloOriginalListo = true);
    }).catchError((_) {
      if (mounted) setState(() => _modeloOriginalError = true);
    });
    _classifierBirdNet.loadModel().then((_) {
      if (mounted) setState(() => _modeloBirdNetListo = true);
    }).catchError((e) {
      if (mounted) _showSnack('Error BirdNET: $e', Colors.red);
    });
  }

  bool get _modeloActualListo => _modeloSeleccionado == ModeloAves.original
      ? _modeloOriginalListo : _modeloBirdNetListo;

  Future<Map<String, dynamic>> _clasificar(File image) =>
      _modeloSeleccionado == ModeloAves.original
          ? _classifierOriginal.classify(image)
          : _classifierBirdNet.classify(image);

  void _cambiarModelo(ModeloAves nuevo) {
    if (nuevo == ModeloAves.original && _modeloOriginalError) {
      _showSnack('Modelo original no disponible.', Colors.orange);
      return;
    }
    setState(() {
      _modeloSeleccionado = nuevo;
      _result = null;
      _noEsAve = false;
      _image = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source, maxWidth: 600, maxHeight: 600,
      imageQuality: 92, preferredCameraDevice: CameraDevice.rear,
    );
    if (picked != null) {
      setState(() { _image = File(picked.path); _result = null; _noEsAve = false; });
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
      final result  = await _clasificar(_image!);
      final top3    = result['top3'] as List<Map<String, dynamic>>;
      final topConf = top3.first['confidence'] as double;
      if (topConf < _umbralConfianza) {
        setState(() { _result = null; _noEsAve = true; _isLoading = false; });
      } else {
        setState(() { _result = result; _noEsAve = false; _isLoading = false; });
      }
      if (_modeloSeleccionado == ModeloAves.birdnet && mounted) _mostrarDialogoDiagnostico();
    } catch (e) {
      setState(() => _isLoading = false);
      if (_modeloSeleccionado == ModeloAves.birdnet && mounted) {
        _mostrarDialogoDiagnostico();
      } else {
        _showSnack('Error: $e', Colors.red);
      }
    }
  }

  void _mostrarDialogoDiagnostico() {
    final bn = _classifierBirdNet;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: const [
          Icon(Icons.bug_report_rounded, color: Color(0xFF80BA27), size: 20),
          SizedBox(width: 8),
          Text('Diagnóstico BirdNET',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ]),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Shapes ─────────────────────────────────────
              _monoText('ℹ️  ${bn.infoInput}', Colors.white70),
              _monoText('ℹ️  ${bn.infoOutput}', Colors.white70),
              _monoText('🔎 ${bn.infoShapes}', Colors.white54),
              const Divider(color: Colors.white24, height: 16),

              // ── Estado interno paso a paso ──────────────────
              _monoText('🟡 DEBUG: ${bn.infoDebug}', Colors.yellowAccent),
              const SizedBox(height: 8),

              // ── Top 3 (si hubo éxito) ─────────────────────
              if (bn.infoTop3.isNotEmpty) ..._top3Widgets(bn.infoTop3),

              // ── Error ─────────────────────────────────────
              if (bn.infoError.isNotEmpty) ...[  
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '✗ Error:\n${bn.infoError}',
                    style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontFamily: 'monospace'),
                  ),
                ),
              ],

              // ── StackTrace completo ────────────────────────
              if (bn.infoStack.isNotEmpty) ...[  
                const SizedBox(height: 8),
                const Text('📎 StackTrace:',
                    style: TextStyle(color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    // Mostrar solo las primeras 20 líneas para que quepa
                    bn.infoStack.split('\n').take(20).join('\n'),
                    style: const TextStyle(
                        color: Colors.orange, fontSize: 9, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(color: Color(0xFF80BA27))),
          ),
        ],
      ),
    );
  }

  Widget _monoText(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace')),
  );

  List<Widget> _top3Widgets(String raw) {
    final lines = raw.split('\n');
    return [
      const Text('🏆 Top 3:', style: TextStyle(color: Colors.white60, fontSize: 11)),
      const SizedBox(height: 4),
      ...lines.map((l) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(l, style: TextStyle(
          color: l.contains('%') ? const Color(0xFF80BA27) : Colors.white,
          fontSize: 10, fontFamily: 'monospace',
        )),
      )),
      const SizedBox(height: 6),
    ];
  }

  Future<void> _guardarAvistamiento() async {
    if (_result == null || _image == null) return;
    setState(() => _isSaving = true);
    try {
      final position  = await LocationService.getCurrentPosition();
      final lat       = position?.latitude  ?? 0.0;
      final lng       = position?.longitude ?? 0.0;
      final top3      = _result!['top3'] as List<Map<String, dynamic>>;
      final especie   = top3.first['label'].toString();
      final confianza = top3.first['confidence'] as double;

      final id = await DatabaseService.guardarAvistamiento(
        especie: especie, confianza: confianza,
        fotoPath: _image!.path, latitud: lat, longitud: lng,
      );

      final tieneInternet = await FirestoreService.hayInternet();
      String extra = '';
      if (tieneInternet) {
        final todos  = await DatabaseService.obtenerTodos();
        final av     = todos.firstWhere((a) => a.id == id);
        final subido = await FirestoreService.sincronizarAvistamiento(av);
        extra = subido ? ' ☁️ Firebase ✓' : ' (Firebase falló)';
      } else {
        extra = ' 📵 Sin internet, solo local';
      }

      setState(() => _isSaving = false);
      _showSnack(
        position != null ? '✓ Guardado: $especie$extra' : '✓ Guardado sin GPS$extra',
        tieneInternet ? _green : Colors.orange,
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
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _classifierOriginal.dispose();
    _classifierBirdNet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('IDENTIFICAR AVE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: _dark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModelSelector(),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _image != null
                    ? Image.file(_image!, height: 240, fit: BoxFit.cover)
                    : Container(
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text('Toca para seleccionar una foto',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                        ]),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _actionBtn(
                icon: Icons.camera_alt_rounded, label: 'CÁMARA', color: _green,
                onTap: _isLoading ? null : () => _pickImage(ImageSource.camera))),
              const SizedBox(width: 10),
              Expanded(child: _actionBtn(
                icon: Icons.photo_library_rounded, label: 'GALERÍA', color: _dark,
                onTap: _isLoading ? null : () => _pickImage(ImageSource.gallery))),
            ]),
            const SizedBox(height: 16),
            if (_isLoading)           _buildLoading()
            else if (_noEsAve)        _buildNoEsAve()
            else if (_result != null) ..._buildResults(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelector() => Row(children: [
    Expanded(child: _modeloChip(
      label: 'Modelo Original', sub: '16 aves del Tolima',
      activo: _modeloSeleccionado == ModeloAves.original,
      listo: _modeloOriginalListo, error: _modeloOriginalError, color: _green,
      onTap: () => _cambiarModelo(ModeloAves.original),
    )),
    const SizedBox(width: 10),
    Expanded(child: _modeloChip(
      label: 'BirdNET', sub: 'Tolima 16 aves',
      activo: _modeloSeleccionado == ModeloAves.birdnet,
      listo: _modeloBirdNetListo, error: false, color: _blue,
      onTap: () => _cambiarModelo(ModeloAves.birdnet),
    )),
  ]);

  Widget _modeloChip({
    required String label, required String sub,
    required bool activo, required bool listo, required bool error,
    required Color color, required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: error ? () => _showSnack('Modelo no disponible.', Colors.orange) : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: error ? Colors.grey.shade100 : activo ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: error ? Colors.grey.shade300 : activo ? color : Colors.grey.shade300,
            width: activo ? 2 : 1,
          ),
          boxShadow: activo
              ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(children: [
          Icon(
            error ? Icons.block : activo ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: error ? Colors.grey.shade400 : color, size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(
              fontWeight: activo ? FontWeight.bold : FontWeight.w500,
              color: error ? Colors.grey.shade400 : activo ? color : _dark,
              fontSize: 13,
            )),
            Text(error ? 'No disponible' : sub,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ])),
          if (!error)
            listo
                ? Icon(Icons.check_circle, color: color, size: 16)
                : SizedBox(width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: color)),
        ]),
      ),
    );
  }

  Widget _actionBtn({required IconData icon, required String label, required Color color, VoidCallback? onTap}) =>
    ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );

  Widget _buildLoading() => Container(
    padding: const EdgeInsets.symmetric(vertical: 24),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(children: [
      CircularProgressIndicator(
          color: _modeloSeleccionado == ModeloAves.original ? _green : _blue),
      const SizedBox(height: 12),
      Text(
        _modeloSeleccionado == ModeloAves.original
            ? 'Analizando con Modelo Original...' : 'Analizando con BirdNET...',
        style: TextStyle(color: _dark, fontSize: 13),
      ),
    ]),
  );

  Widget _buildNoEsAve() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.red.shade50, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.red.shade200),
    ),
    child: Column(children: [
      Icon(Icons.sentiment_dissatisfied_rounded, color: Colors.red.shade400, size: 52),
      const SizedBox(height: 10),
      Text('No se detectó un ave',
          style: TextStyle(color: Colors.red.shade700, fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(
        'La imagen no coincide con ninguna de las 16 especies.\nIntenta con mejor iluminación o más cerca del ave.',
        style: TextStyle(color: Colors.red.shade500, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ]),
  );

  List<Widget> _buildResults() {
    final top3      = _result!['top3'] as List<Map<String, dynamic>>;
    final topResult = top3.first;
    final refImage  = topResult['referenceImage'] as String;
    final activeColor = _modeloSeleccionado == ModeloAves.original ? _green : _blue;

    return [
      Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Especie detectada',
                  style: TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  _modeloSeleccionado == ModeloAves.original ? '🧪 Original' : '🌎 BirdNET',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Column(children: [
                Text('Tu foto', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(10),
                    child: Image.file(_image!, height: 120, fit: BoxFit.cover)),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(children: [
                Text('Referencia', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(10),
                    child: refImage.isNotEmpty
                        ? Image.asset(refImage, height: 120, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _noRefImage())
                        : _noRefImage()),
              ])),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(children: [
              Text(topResult['label'].toString().toUpperCase(),
                  style: TextStyle(color: activeColor, fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.bar_chart_rounded, color: activeColor, size: 18),
                const SizedBox(width: 4),
                Text('Confianza: ${topResult['confidenceText']}',
                    style: TextStyle(color: _dark, fontSize: 14, fontWeight: FontWeight.w500)),
              ]),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Top 3 probabilidades',
              style: TextStyle(color: _dark, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          ...List.generate(top3.length, (i) {
            final item = top3[i];
            final conf = item['confidence'] as double;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: i == 0 ? activeColor : Colors.grey.shade300,
                  child: Text('${i+1}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['label'].toString(),
                      style: TextStyle(
                          fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12, color: _dark)),
                  const SizedBox(height: 3),
                  LinearProgressIndicator(
                    value: conf,
                    backgroundColor: Colors.grey.shade200,
                    color: i == 0 ? activeColor : Colors.grey.shade400,
                    minHeight: 5, borderRadius: BorderRadius.circular(4),
                  ),
                ])),
                const SizedBox(width: 8),
                Text(item['confidenceText'].toString(),
                    style: TextStyle(
                        color: i == 0 ? activeColor : Colors.grey.shade500,
                        fontWeight: FontWeight.bold, fontSize: 12)),
              ]),
            );
          }),
        ]),
      ),
      const SizedBox(height: 12),
      _actionBtn(icon: Icons.map_outlined, label: 'VER DÓNDE ENCONTRARLA',
          color: _blue, onTap: _verDistribucion),
      const SizedBox(height: 8),
      _actionBtn(
        icon: Icons.save_alt_rounded,
        label: _isSaving ? 'Guardando...' : 'GUARDAR AVISTAMIENTO',
        color: Colors.orange.shade700,
        onTap: (_isSaving || _isLoading) ? null : _guardarAvistamiento,
      ),
    ];
  }

  Widget _noRefImage() => Container(
    height: 120,
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
    child: Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade400, size: 36)),
  );
}
