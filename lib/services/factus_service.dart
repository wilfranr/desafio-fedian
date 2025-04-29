import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FactusService {
  // Endpoints (sandbox)
  static const _authUrl = 'https://api-sandbox.factus.com.co/oauth/token';
  static const _facturaUrl = 'https://api-sandbox.factus.com.co/v1/bills/validate';

  Future<String?> obtenerToken() async {
    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'client_id': '9e890e97-579e-4786-9ea8-41a064d03a55',
        'client_secret':'s987d833u9hg7lDbkh6JnFa74y3i4RfPhtNzna0H',
        'username': 'sandbox@factus.com.co',
        'password': 'sandbox2024%'
        },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      print('❌ Error al autenticar: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<String> enviarFactura(Map<String, dynamic> factura) async {
    final token = await obtenerToken();
    if (token == null) return '❌ Error al obtener token.';

    final response = await http.post(
      Uri.parse(_facturaUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(factura),
    );

    if (response.statusCode == 201) {
      return '✅ Factura validada correctamente.\n${response.body}';
    } else if (response.statusCode == 422) {
      return '⚠️ Error 422 - Contenido no procesable:\n${response.body}';
    } else {
       return '✅ Factura validada correctamente.\n${response.body}';
    }
  }
}

