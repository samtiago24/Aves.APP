import 'package:flutter/material.dart';
import 'package:aves_app/Data/catalogo_especies.dart';
import 'package:aves_app/Presentation/UI/DistribucionAveScreen.dart';

class DetalleEspecieScreen extends StatelessWidget {
  final EspecieInfo especie;

  const DetalleEspecieScreen({super.key, required this.especie});

  static const _darkBlue = Color(0xFF2C3E50);
  static const _primaryGreen = Color(0xFF80BA27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con imagen
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _darkBlue,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                especie.nombre,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    especie.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _primaryGreen.withOpacity(0.2),
                      child: const Icon(Icons.flutter_dash, size: 80, color: _primaryGreen),
                    ),
                  ),
                  // Gradiente para legibilidad del título
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre científico
                  Text(
                    especie.nombreCientifico,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripción general
                  _buildSeccion(
                    icono: Icons.info_outline,
                    titulo: 'Descripción',
                    contenido: especie.descripcion,
                  ),
                  _buildSeccion(
                    icono: Icons.forest,
                    titulo: 'Hábitat',
                    contenido: especie.habitat,
                  ),
                  _buildSeccion(
                    icono: Icons.restaurant,
                    titulo: 'Dieta',
                    contenido: especie.dieta,
                  ),
                  _buildSeccion(
                    icono: Icons.map_outlined,
                    titulo: 'Distribución en el Tolima',
                    contenido: especie.distribucion,
                  ),

                  const SizedBox(height: 20),

                  // Botón ver en mapa
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DistribucionAveScreen(
                            especie: especie.nombre,
                            confianza: 1.0,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.location_on),
                      label: const Text('VER ZONAS DE AVISTAMIENTO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required IconData icono,
    required String titulo,
    required String contenido,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: _primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  color: _darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              contenido,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
