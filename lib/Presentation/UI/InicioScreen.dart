import 'package:flutter/material.dart';

// Autores: Santiago Lopez, Sebastian Castro
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
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
                color: colors.onSurface,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: colors.primary,
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
            // Créditos de autores
            Divider(color: colors.onSurface.withOpacity(0.15)),
            const SizedBox(height: 16),
            Text(
              "Desarrollado por",
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurface.withOpacity(0.45),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Santiago Lopez",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Sebastian Castro",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
