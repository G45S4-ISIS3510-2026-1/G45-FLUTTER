import 'dart:convert';
import 'package:g45_flutter/models/session.dart';
import 'package:http/http.dart' as http;

class SessionRepository {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<Session>> getSessionsByStudent(String studentId) async {
    final url = Uri.parse("$baseUrl/sessions/by-student/$studentId");
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((json) => Session.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo sesiones por estudiante: ${resp.statusCode}");
  }

}