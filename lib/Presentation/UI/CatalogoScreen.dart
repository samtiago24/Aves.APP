import 'package:flutter/material.dart';
import 'package:aves_app/Data/catalogo_especies.dart';
import 'package:aves_app/Presentation/UI/DetalleEspecieScreen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  String _busqueda = '';

  List<EspecieInfo> get _filtradas => CatalogoEspecies.especies
      .where((e) =>
          e.nombre.toLowerCase().contains(_busqueda.toLowerCase()) ||
          e.nombreCientifico.toLowerCase().contains(_busqueda.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF2C3E50);
    final primaryGreen = const Color(0xFF80BA27);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CATÁLOGO DE ESPECIES'),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => _busqueda = v),
              decoration: InputDecoration(
                hintText: 'Buscar especie...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
            ),
          ),
          // Contador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filtradas.length} especie${_filtradas.length != 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          // Lista
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filtradas.length,
              itemBuilder: (context, i) {
                final especie = _filtradas[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        especie.imagePath,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: primaryGreen.withOpacity(0.15),
                          child: Icon(Icons.flutter_dash, color: primaryGreen, size: 30),
                        ),
                      ),
                    ),
                    title: Text(
                      especie.nombre,
                      style: TextStyle(fontWeight: FontWeight.bold, color: darkBlue, fontSize: 14),
                    ),
                    subtitle: Text(
                      especie.nombreCientifico,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                    trailing: Icon(Icons.chevron_right, color: primaryGreen),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetalleEspecieScreen(especie: especie)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
