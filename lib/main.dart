import 'package:aves_app/Core/UI/MainNavigationScreen.dart';
import 'package:flutter/material.dart';

// Notificador global para el tema
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Identificador de Aves',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // Tema Claro (Gris neutro)
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blueGrey,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFEEEEEE),
          ),
          // Tema Oscuro (Gris profundo)
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blueGrey,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
