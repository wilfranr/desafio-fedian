import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'pages/facturacion_page.dart';

void main() {
  runApp(const FactusApp());
}

class FactusApp extends StatelessWidget {
  const FactusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factus App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/facturar': (context) => const FacturacionPage(),
      },
    );
  }
}
