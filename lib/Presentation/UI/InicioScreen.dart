import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el esquema de colores actual del tema (Light o Dark)
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      // El fondo ahora se adapta automáticamente al tema definido en main.dart
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bird\nIdentifier",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                // onSurface detecta si el fondo es claro u oscuro y pone el contraste ideal
                color: colors.onSurface,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: colors.primary, // Usa el color principal del tema
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Análisis taxonómico avanzado.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Implementación de modelos Vision Transformer (ViT) y MobileNetV2 para detección local.",
              style: TextStyle(
                fontSize: 15,
                color: colors.onSurface.withOpacity(0.6),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
