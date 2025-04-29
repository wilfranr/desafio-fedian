import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> productos = ['Mouse óptico', 'Teclado Mecánico'];
  final Set<String> seleccionados = {};

  void irAFacturar() {
    if (seleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Debes seleccionar al menos un producto')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/facturar',
      arguments: seleccionados.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Selecciona productos para facturar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...productos.map((producto) => CheckboxListTile(
                  title: Text(producto),
                  value: seleccionados.contains(producto),
                  onChanged: (bool? seleccionado) {
                    setState(() {
                      if (seleccionado == true) {
                        seleccionados.add(producto);
                      } else {
                        seleccionados.remove(producto);
                      }
                    });
                  },
                )),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ir a Facturar'),
              onPressed: irAFacturar,
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

