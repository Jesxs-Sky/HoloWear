import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const HoloWearApp());
}

class HoloWearApp extends StatelessWidget {
  const HoloWearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoloWear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Configuración de colores globales de HoloWear (Light Mode)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Azul primario
          primary: const Color(0xFF3B82F6),
          background: const Color(0xFFF4F5F7), // Gris/blanco de fondo
        ),
        fontFamily: 'Roboto', // Tipografía base del sistema
      ),
      home: const LoginScreen(),
    );
  }
}