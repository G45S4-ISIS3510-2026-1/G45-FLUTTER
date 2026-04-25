import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class PqrRepository {
  final String baseUrl = ApiConfig.baseUrl;

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
      final url = "$baseUrl/pqrs/"; // endpoint correcto

      print("====== CREATE PQR ======");
      print("POST URL: $url");

      final body = {
        "authorId": authorId,
        "createdAt": DateTime.now().toIso8601String(),
        "description": description,
        "status": "Pendiente",
        "topic": description.substring(0, description.length.clamp(0, 50)),
        "type": type,
      };

      if (sessionId != null && sessionId != "0") {
        body["relatedIncident"] = sessionId;
      }

      print("BODY SENT: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("CREATE PQR SUCCESS");
        return true;
      } else {
        print("ERROR BACKEND: ${response.body}");
        return false;
      }
    } catch (e) {
      print("EXCEPTION createPqr: $e");
      throw Exception("Sin conexión o error de red");
    }
  }

  //-------------------------------------
  // GET PQRS BY AUTHOR (DIRECTO)
  //-------------------------------------
  Future<List<dynamic>> getPqrsByUser(String userId) async {
    final url = "$baseUrl/pqrs/by-author/$userId";

    print("====== GET PQRS USER ======");
    print("GET URL: $url");

    final response = await http.get(Uri.parse(url));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data;
    }

    throw Exception("Error obteniendo PQRS: ${response.statusCode}");
  }

  //-------------------------------------
  // GET PQRS BY AUTHOR + CACHE
  //-------------------------------------
  Future<List<dynamic>> getPqrsByAuthor(String userId) async {
    try {
      final url = "$baseUrl/pqrs/by-author/$userId";

      print("====== GET PQRS (CACHEABLE) ======");
      print("GET URL: $url");

      final response = await http.get(Uri.parse(url));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        //----------------------------------
        // GUARDAR CACHE
        //----------------------------------
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("pqrs_cache_$userId", jsonEncode(data));

        print("CACHE SAVED");

        return data;
      } else {
        throw Exception("Error status ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR GET PQRS → usando cache: $e");

      //----------------------------------
      // FALLBACK CACHE
      //----------------------------------
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString("pqrs_cache_$userId");

      if (cached != null) {
        print("CACHE LOADED");
        return jsonDecode(cached);
      }

      print("CACHE EMPTY");
      return [];
    }
  }
}
