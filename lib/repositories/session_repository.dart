import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/session.dart';

class SessionRepository {
  final String baseUrl = "${ApiConfig.baseUrl}/sessions";

  // POST createSession
  Future<Session> createSession(Session session) async {
    final url = Uri.parse(baseUrl);
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(session.toJson()),
    );

    if (resp.statusCode != 201) {
      print("ERROR CREANDO SESION: ${resp.body}");
      throw Exception("Error creando sesión en backend: ${resp.statusCode}");
    }

    return Session.fromJson(jsonDecode(resp.body));
  }

  // GET getSessionById
  Future<Session> getSessionById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Error obteniendo sesión: ${resp.statusCode}");
    }

    return Session.fromJson(jsonDecode(resp.body));
  }

  // GET getAllSessions
  Future<List<Session>> getAllSessions() async {
    final url = Uri.parse(baseUrl);
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((json) => Session.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo sesiones: ${resp.statusCode}");
  }

  // GET getByStudent
  Future<List<Session>> getByStudent(String studentId) async {
    final url = Uri.parse("$baseUrl/by-student/$studentId");
    try {
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body);
        final sessions = data.map((json) => Session.fromJson(json)).toList();
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("agenda_student_$studentId", jsonEncode(data));
        
        return sessions;
      }
      throw Exception("Error obteniendo sesiones por estudiante: ${resp.statusCode}");
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString("agenda_student_$studentId");
      if (cached != null) {
        final List data = jsonDecode(cached);
        return data.map((json) => Session.fromJson(json)).toList();
      }
      return [];
    }
  }

  // GET getByTutor
  Future<List<Session>> getByTutor(String tutorId) async {
    final url = Uri.parse("$baseUrl/by-tutor/$tutorId");
    try {
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body);
        final sessions = data.map((json) => Session.fromJson(json)).toList();
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("agenda_tutor_$tutorId", jsonEncode(data));
        
        return sessions;
      }
      throw Exception("Error obteniendo sesiones por tutor: ${resp.statusCode}");
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString("agenda_tutor_$tutorId");
      if (cached != null) {
        final List data = jsonDecode(cached);
        return data.map((json) => Session.fromJson(json)).toList();
      }
      return [];
    }
  }

  // UPDATE? cancelSession
  Future<Session> cancelSession(Session session, String participantId) async {
    final url = Uri.parse("$baseUrl/${session.id}/$participantId/cancel");
    final resp = await http.patch(url);

    if (resp.statusCode != 200) {
      throw Exception("Error cancelando sesión: ${resp.statusCode}");
    }

    return Session.fromJson(jsonDecode(resp.body));
  }

  // UPDATE? confirmSession
  Future<Session> confirmSession(Session session, String participantId, String verifCode) async {
    final url = Uri.parse(
      "$baseUrl/${session.id}/$participantId/confirm?verif_code=$verifCode",
    );
    final resp = await http.patch(url);

    if (resp.statusCode != 200) {
      throw Exception("Error confirmando sesión: ${resp.body}");
    }

    return Session.fromJson(jsonDecode(resp.body));
  }
}
