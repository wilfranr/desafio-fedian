import 'package:flutter/material.dart';
import '../services/factus_service.dart';

class FacturacionPage extends StatelessWidget {
  const FacturacionPage({super.key});

  void enviarFacturaDemo(BuildContext context) async {
    final factus = FactusService(
      clientId: 'demo',
      clientSecret: 'demo',
      username: 'demo@example.com',
      password: '123456',
    );

    final factura = {
      "numbering_range_id": 999,
      "reference_code": "FACT-0001",
      "customer": {
        "name": "Cliente de Ejemplo",
        "email": "cliente@example.com",
        "identification_number": "123456789",
        "phone": "3101234567",
        "address": {
          "city_code": "11001",
          "line1": "Cra 123 # 45-67",
        }
      },
      "items": [
        {
          "description": "Producto de prueba",
          "quantity": 1,
          "price": 100000,
          "taxes": [
            {"id": 1}
          ]
        }
      ]
    };

    await factus.enviarFactura(factura);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura enviada (ver consola para respuesta)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facturación')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('Enviar Factura de Prueba'),
          onPressed: () => enviarFacturaDemo(context),
        ),
      ),
    );
  }
}
