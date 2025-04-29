import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../services/factus_service.dart';
import 'dart:convert';
import 'dart:html' as html;

class FacturacionPage extends StatefulWidget {
  const FacturacionPage({super.key});

  @override
  State<FacturacionPage> createState() => _FacturacionPageState();
}

class _FacturacionPageState extends State<FacturacionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final nombreCtrl = TextEditingController();
  final idCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  List<String> productosSeleccionados = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<String>) {
      productosSeleccionados = args;
    }
  }

  void enviarFactura() async {
    if (!_formKey.currentState!.validate()) return;

    final factus = FactusService();
    try {
      final items = productosSeleccionados.map((producto) {
        return {
          "code_reference": producto,
          "name": producto,
          "quantity": 1,
          "discount_rate": 0,
          "price": 50000,
          "tax_rate": "19.00",
          "unit_measure_id": 70,
          "standard_code_id": 1,
          "is_excluded": 0,
          "tribute_id": 1,
          "withholding_taxes": [],
        };
      }).toList();

      final referenceCode = "FACT-${DateTime.now().millisecondsSinceEpoch}";
      final factura = {
        "numbering_range_id": 8,
        "reference_code": referenceCode,
        "observation": "Esta es la descripción general de la venta",
        "payment_method_code": 10,
        "customer": {
          "identification": idCtrl.text,
          "dv": 3,
          "company": "",
          "trade_name": "",
          "names": nombreCtrl.text,
          "address": direccionCtrl.text,
          "email": correoCtrl.text,
          "phone": telefonoCtrl.text,
          "legal_organization_id": 2,
          "tribute_id": 21,
          "identification_document_id": 3,
          "municipality_id": 980,
        },
        "items": items,
      };

      final resultado = await factus.enviarFactura(factura);
      print('🟢 Resultado: $resultado');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado, maxLines: 6),
            backgroundColor: resultado.startsWith('✅') ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al procesar la factura.')),
        );
      }
      print('🔴 Exception en enviarFactura: $e');
    }
  }


void descargarFactura() async {
  final token = await FactusService().obtenerToken(); 
  if (token == null) {
    print('❌ No se pudo obtener token');
    return;
  }

  const facturaNumber = 'SETP990012797';
  final url = 'https://api-sandbox.factus.com.co/v1/bills/download-pdf/$facturaNumber';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data']['pdf_base_64_encoded'] != null) {
        final base64PDF = data['data']['pdf_base_64_encoded'];
        final bytes = base64Decode(base64PDF);

        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', '${data['data']['file_name']}.pdf')
          ..click();

        print('✅ Factura descargada correctamente');
      } else {
        print('❌ No se encontró PDF en la respuesta.');
      }
    } else {
      print('❌ Error descargando factura: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('🔴 Exception en descargarFactura: $e');
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facturación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre del cliente'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Identificación'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: correoCtrl,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: telefonoCtrl,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: direccionCtrl,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text('Productos seleccionados:'),
              ...productosSeleccionados.map((p) => ListTile(title: Text(p))),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: enviarFactura,
                icon: const Icon(Icons.send),
                label: const Text('Enviar Factura'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: descargarFactura,
                icon: const Icon(Icons.download),
                label: const Text('Descargar Factura'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

