import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class PqrRepository {
  final String baseUrl = "${ApiConfig.baseUrl}/pqrs";

  //-------------------------------------
  // CREATE PQR
  //-------------------------------------
  Future<bool> createPqr({
    required String authorId,
    required String type,
    required String description,
    String? sessionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/pqrs"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "authorId": authorId,
          "createdAt": DateTime.now().toIso8601String(),
          "description": description,
          "relatedIncident": sessionId,
          "status": "Pending",
          "topic": description.substring(
            0,
            description.length.clamp(0, 50),
          ), //  resumen automático
          "type": type,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error backend: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error createPqr: $e");
      return false;
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
  //-------------------------------------
  // GET PQRS BY Authors
  //-------------------------------------
  Future<List<dynamic>> getPqrsByAuthor(String userId) async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/pqrs/by-author/$userId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //----------------------------------
      // GUARDAR CACHE
      //----------------------------------
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("pqrs_cache_$userId", jsonEncode(data));

      return data;
    } else {
      throw Exception();
    }
  } catch (e) {
    //----------------------------------
    // FALLBACK CACHE
    //----------------------------------
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString("pqrs_cache_$userId");

    if (cached != null) {
      return jsonDecode(cached);
    }

    return [];
  }
}
}
