import 'package:flutter/material.dart';
import 'package:aves_app/main.dart';
import 'package:aves_app/Presentation/UI/IdentificarAveScreen.dart';
import 'package:aves_app/Presentation/UI/InicioScreen.dart';
import 'package:aves_app/Presentation/UI/MapaAvistamientosScreen.dart';
import 'package:aves_app/Presentation/UI/CatalogoScreen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InicioScreen(),
    const IdentificarAveScreen(),
    const MapaAvistamientosScreen(),
    const CatalogoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: themeColors.onSurface, size: 28),
        title: Text(
          'IDENTIFICADOR DE AVES',
          style: TextStyle(
            color: themeColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: themeColors.primaryContainer),
              child: Center(
                child: Text(
                  'MEN\u00da PRINCIPAL',
                  style: TextStyle(
                    color: themeColors.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_filled, color: themeColors.primary),
              title: const Text('Inicio'),
              onTap: () { setState(() => _selectedIndex = 0); Navigator.pop(context); },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_rounded, color: themeColors.primary),
              title: const Text('Identificar Ave'),
              onTap: () { setState(() => _selectedIndex = 1); Navigator.pop(context); },
            ),
            ListTile(
              leading: Icon(Icons.map, color: themeColors.primary),
              title: const Text('Mapa de Avistamientos'),
              onTap: () { setState(() => _selectedIndex = 2); Navigator.pop(context); },
            ),
            ListTile(
              leading: Icon(Icons.menu_book_rounded, color: themeColors.primary),
              title: const Text('Catálogo de Especies'),
              onTap: () { setState(() => _selectedIndex = 3); Navigator.pop(context); },
            ),
            const Spacer(),
            const Divider(indent: 20, endIndent: 20),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (_, mode, __) {
                final isDark = mode == ThemeMode.dark;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 20),
                        const SizedBox(width: 10),
                        const Text('Modo Oscuro', style: TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                      Switch(
                        value: isDark,
                        onChanged: (value) {
                          themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
