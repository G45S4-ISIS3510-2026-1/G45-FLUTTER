import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PqrRepository {
  final String baseUrl = "${ApiConfig.baseUrl}/pqrs";

  //-------------------------------------
  // CREATE PQR
  //-------------------------------------
  Future<void> createPqr({
    required String userId,
    required String type,
    required String description,
    String? sessionId,
  }) async {
    final url = Uri.parse(baseUrl);

    final body = {
      "userId": userId,
      "type": type,
      "description": description,
      "sessionId": sessionId,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("PQR RESPONSE: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception("Error creando PQR: ${response.statusCode}");
    }
  }

  //-------------------------------------
  // GET PQRS BY USER
  //-------------------------------------
  Future<List<dynamic>> getPqrsByUser(String userId) async {
    final url = Uri.parse("$baseUrl/by-author/$userId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data;
    }

    throw Exception("Error obteniendo PQRS: ${response.statusCode}");
  }
}