import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class IdentificarAveScreen extends StatefulWidget {
  const IdentificarAveScreen({super.key});

  @override
  State<IdentificarAveScreen> createState() => _IdentificarAveScreenState();
}

class _IdentificarAveScreenState extends State<IdentificarAveScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  // Método para encender la cámara
  Future<void> _initializeCamera() async {
    // 1. Obtener lista de cámaras disponibles
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // 2. Configurar el controlador (usamos la cámara trasera)
    _controller = CameraController(
      cameras[0],
      ResolutionPreset
          .medium, // Resolución 224x224 ideal para tu modelo después
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Error al inicializar cámara: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Muy importante cerrar la cámara al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_enhance_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _initializeCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "ACTIVAR CÁMARA",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Muestra el feed de la cámara
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_controller!),
        ),

        // Botón para capturar (lógica de IA irá aquí)
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: () {
                // Aquí llamaremos al UseCase para identificar
                debugPrint("Capturando ave...");
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera, color: Colors.black, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}
