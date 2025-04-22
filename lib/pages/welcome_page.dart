import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Ir a Facturar'),
              onPressed: () {
                Navigator.pushNamed(context, '/facturar');
              },
            ),
            const SizedBox(height: 32),
            const Divider(),
            const Text(
              'Desarrollado por:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Luis Orlando Martínez Pérez'),
            const Text('Wilfran Yoseth Rivera Rivera'),
            const Text('Jorge Andrés Moreno Gayón'),
            const Text('Valentina Sánchez Valverde'),
            const SizedBox(height: 24),
            const Text(
              'Proyecto académico:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Institución Universitaria Politécnico Grancolombiano\n'
              'Facultad de Diseño e Innovación\n'
              'Gerencia de Proyectos Informáticos\n'
              'Grupo B03 | Subgrupo 17',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Prof. Marcela Cascante Montoya',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
