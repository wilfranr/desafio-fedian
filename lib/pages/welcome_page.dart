import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Ir a Facturar'),
          onPressed: () {
            Navigator.pushNamed(context, '/facturar');
          },
        ),
      ),
    );
  }
}
