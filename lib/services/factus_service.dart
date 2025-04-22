import 'dart:convert';
import 'package:http/http.dart' as http;

class FactusService {
  static const _authUrl = 'https://api.factus.com.co/auth/realms/Factus/protocol/openid-connect/token';
  static const _facturaUrl = 'https://api.factus.com.co/api/v1/bills/validate';

  final String clientId;
  final String clientSecret;
  final String username;
  final String password;

  FactusService({
    required this.clientId,
    required this.clientSecret,
    required this.username,
    required this.password,
  });

  Future<String?> obtenerToken() async {
    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'client_id': clientId,
        'client_secret': clientSecret,
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      print('Error al autenticar: ${response.body}');
      return null;
    }
  }

  Future<void> enviarFactura(Map<String, dynamic> factura) async {
    final token = await obtenerToken();
    if (token == null) return;

    final response = await http.post(
      Uri.parse(_facturaUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(factura),
    );

    if (response.statusCode == 200) {
      print('Factura enviada correctamente: ${response.body}');
    } else {
      print('Error al enviar factura: ${response.body}');
    }
  }
}
