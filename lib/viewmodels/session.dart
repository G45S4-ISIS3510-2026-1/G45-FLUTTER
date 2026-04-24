import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:g45_flutter/repositories/session_repository.dart';
import 'package:g45_flutter/services/conection_service.dart';
import '../models/session.dart';

class SessionViewModel extends ChangeNotifier {
  final repository = SessionRepository();

  static final SessionViewModel instance = SessionViewModel.internal();
  factory SessionViewModel() => instance;
  SessionViewModel.internal();

  List<Session> studentSessions = [];
  List<Session> tutorSessions = [];
  Session? session;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSessionsByStudent(String studentId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (ConnectionService().hasConnection) {
      try {
        studentSessions = await repository.getByStudent(studentId);
        await saveSessionsCache('student_sessions', studentSessions);
      } catch (e) {
        errorMessage = "Error cargando sesiones";
        await loadSessionsFromCache('student_sessions', isStudent: true);
      }
    } else {
      await loadSessionsFromCache('student_sessions', isStudent: true);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadSessionsByTutor(String tutorId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (ConnectionService().hasConnection) {
      try {
        tutorSessions = await repository.getByTutor(tutorId);
        await saveSessionsCache('tutor_sessions', tutorSessions);
      } catch (e) {
        errorMessage = "Error cargando sesiones";
        await loadSessionsFromCache('tutor_sessions', isStudent: false);
      }
    } else {
      await loadSessionsFromCache('tutor_sessions', isStudent: false);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Session?> createSession(Session session) async {
    try {
      final created = await repository.createSession(session);
      if (created != null) {
        studentSessions.add(created);
        notifyListeners();
      }
      return created;
    } catch (e) {
      errorMessage = "Error creando sesión: $e";
      notifyListeners();
      return null;
    }
  }

  Future<void> saveSessionsCache(String key, List<Session> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final json = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(key, json);
  }

  Future<void> loadSessionsFromCache(String key, {required bool isStudent}) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(key) ?? [];
    final sessions = json.map((s) => Session.fromJson(jsonDecode(s))).toList();
    if (isStudent) {
      studentSessions = sessions;
    } else {
      tutorSessions = sessions;
    }
  }
}