import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aves_app/Services/database_service.dart';

class MapaAvistamientosScreen extends StatefulWidget {
  const MapaAvistamientosScreen({super.key});

  @override
  State<MapaAvistamientosScreen> createState() => _MapaAvistamientosScreenState();
}

class _MapaAvistamientosScreenState extends State<MapaAvistamientosScreen> {
  GoogleMapController? _mapController;
  List<Avistamiento> _avistamientos = [];
  Set<Marker> _markers = {};
  Avistamiento? _selected;

  static const _initialPosition = CameraPosition(
    target: LatLng(4.3100, -74.8130), // Tolima, Colombia
    zoom: 8,
  );

  @override
  void initState() {
    super.initState();
    _loadAvistamientos();
  }

  Future<void> _loadAvistamientos() async {
    final data = await DatabaseService.obtenerTodos();
    final markers = data
        .where((a) => a.latitud != 0.0 && a.longitud != 0.0)
        .map((a) => Marker(
              markerId: MarkerId(a.id),
              position: LatLng(a.latitud, a.longitud),
              infoWindow: InfoWindow(
                title: a.especie,
                snippet: '${(a.confianza * 100).toStringAsFixed(1)}% • ${a.fecha.substring(0, 10)}',
              ),
              onTap: () => setState(() => _selected = a),
            ))
        .toSet();

    setState(() {
      _avistamientos = data;
      _markers = markers;
    });
  }

  // RF07: Abrir Google Maps con ruta al punto
  Future<void> _abrirGoogleMaps(Avistamiento a) async {
    final uri = Uri.parse('google.navigation:q=${a.latitud},${a.longitud}&mode=d');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Fallback a browser
      final fallback = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${a.latitud},${a.longitud}');
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  // RF07: Abrir Waze
  Future<void> _abrirWaze(Avistamiento a) async {
    final uri = Uri.parse('waze://?ll=${a.latitud},${a.longitud}&navigate=yes');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waze no está instalado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF2C3E50);
    final primaryGreen = const Color(0xFF80BA27);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MAPA DE AVISTAMIENTOS'),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAvistamientos,
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
          ),
          // Panel inferior si hay selección
          if (_selected != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selected!.especie.toUpperCase(),
                            style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _selected = null),
                        ),
                      ],
                    ),
                    Text('Confianza: ${(_selected!.confianza * 100).toStringAsFixed(1)}%',
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
                    Text('Fecha: ${_selected!.fecha.substring(0, 16).replaceAll('T', ' ')}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('GPS: ${_selected!.latitud.toStringAsFixed(5)}, ${_selected!.longitud.toStringAsFixed(5)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 12),
                    // RF07: Botones navegación externa
                    Row(
                      children: [
                        Expanded(child: ElevatedButton.icon(
                          onPressed: () => _abrirGoogleMaps(_selected!),
                          icon: const Icon(Icons.map),
                          label: const Text('Google Maps'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: ElevatedButton.icon(
                          onPressed: () => _abrirWaze(_selected!),
                          icon: const Icon(Icons.navigation),
                          label: const Text('Waze'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade700,
                            foregroundColor: Colors.white,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Contador de avistamientos
          Positioned(
            top: 10, left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: darkBlue.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_avistamientos.length} avistamiento${_avistamientos.length != 1 ? 's' : ''}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
