import 'package:aves_app/Core/UI/MainNavigationScreen.dart';
import 'package:aves_app/Services/sync_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Notificador global para el tema
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase (RF09)
  await Firebase.initializeApp();

  // Escuchar cambios de conectividad para sincronización automática (RF09)
  SyncService.escucharConectividad();

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
