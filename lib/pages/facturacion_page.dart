import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/factus_service.dart';

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
  final productoCtrl = TextEditingController();
  final precioCtrl = TextEditingController();

  void enviarFactura() async {
    if (!_formKey.currentState!.validate()) return;

    final factus = FactusService();

    try {
      final factura = 
      {
        "numbering_range_id": 8, // Se consume del endpoint es de rango de numeracion
        "reference_code": "12345931AT", // referencia de la venta
        "observation": "Esta es la descripción general de la venta",
        "payment_method_code": 10, // metodo de pago se consume por tabla, en documentacion
        "customer": {
          "identification": "123456789",
          "dv": 3, // Digito de verificacion. se envia si es nit
          "company": "",
          "trade_name": "",
          "names": "Alan Turing 29 Oct",
          "address": "calle 1 # 2-68",
          "email": "alanturing@enigmasas.com",
          "phone": "1234567890",
          "legal_organization_id": 2, //Tipo de organizacion, persona natural o juridica. se consume de tabla
          "tribute_id": 21, // Si aplica o no aplica iva. se consume de tabla
          "identification_document_id": 3, // Tipo de identificacion se consume de tabla
          "municipality_id": 980 // municipio del cliente, se consume del endpoint municipios
        },
        "items": [
        {
          "code_reference": "12345",
          "name": "producto de prueba",
          "quantity": 1, //requerido
          "discount_rate": 20, // valor del porcentaje de descuento
          "price": 50000,
          "tax_rate": "19.00", // valor del descuento aplicado
          "unit_measure_id": 70, // se consume del endpoint unidad de medida
          "standard_code_id": 1, // codigo para productos o serviciois se consume de tabla
          "is_excluded": 0, // excluido de iva o no
          "tribute_id": 1, // Tributo aplicado, se consume de endpoint tributo productos
          "withholding_taxes": [
            // array de las tasas de retención se cosume del endpoint tribuos
          {
            "code": "06",
            "withholding_tax_rate": 7.38
          },
          {
            "code": "05",
            "withholding_tax_rate": 15.12
          }
          ]
        },
        {
          "code_reference": "12345",
          "name": "producto de prueba 2",
          "quantity": 1, // requerido
          "discount": 0, //requerido, si no tiene descuento debe ir en 0
          "discount_rate": 0,
          "price": 50000,
          "tax_rate": "5.00",
          "unit_measure_id": 70, // requerido por defecto 70
          "standard_code_id": 1,
          "is_excluded": 0,
          "tribute_id": 1,
          "withholding_taxes": []
        }
        ]
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
              const Divider(),
              TextFormField(
                controller: productoCtrl,
                decoration: const InputDecoration(labelText: 'Descripción del producto'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: enviarFactura,
                icon: const Icon(Icons.send),
                label: const Text('Enviar Factura'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

