import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aves_app/Data/species_locations.dart';

class DistribucionAveScreen extends StatefulWidget {
  final String especie;
  final double confianza;

  const DistribucionAveScreen({
    super.key,
    required this.especie,
    required this.confianza,
  });

  @override
  State<DistribucionAveScreen> createState() => _DistribucionAveScreenState();
}

class _DistribucionAveScreenState extends State<DistribucionAveScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  EspecieUbicacion? _selected;

  static const _colorVerde = Color(0xFF80BA27);
  static const _colorAzul = Color(0xFF2C3E50);

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  void _buildMarkers() {
    final ubicaciones = SpeciesLocations.getUbicaciones(widget.especie);
    final markers = ubicaciones.map((u) => Marker(
      markerId: MarkerId(u.lugar),
      position: u.coordenadas,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: u.especie,
        snippet: u.lugar,
      ),
      onTap: () => setState(() => _selected = u),
    )).toSet();

    setState(() => _markers = markers);

    // Centrar mapa en el primer marcador
    if (ubicaciones.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(ubicaciones.first.coordenadas, 13),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ubicaciones = SpeciesLocations.getUbicaciones(widget.especie);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.especie.toUpperCase(), style: const TextStyle(fontSize: 15)),
        backgroundColor: _colorAzul,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Mapa principal
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: ubicaciones.isNotEmpty
                  ? ubicaciones.first.coordenadas
                  : const LatLng(4.4500, -75.2000),
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (_) => setState(() => _selected = null),
          ),

          // Tarjeta superior con info del ave
          Positioned(
            top: 12, left: 12, right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _colorAzul.withOpacity(0.92),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: _colorVerde, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${ubicaciones.length} zona${ubicaciones.length != 1 ? 's' : ''} de avistamiento',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _colorVerde,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(widget.confianza * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Panel inferior si toca un marcador
          if (_selected != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place, color: _colorVerde),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_selected!.lugar,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _selected = null),
                        ),
                      ],
                    ),
                    Text(
                      'Especie: ${_selected!.especie}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      'Coordenadas: ${_selected!.coordenadas.latitude.toStringAsFixed(6)}, ${_selected!.coordenadas.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
