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
        final fetched = await repository.getByStudent(studentId);
        if (fetched != null) {
          studentSessions = fetched;
          await saveSessionsCache('student_sessions', studentSessions);
        }
      } catch (e) {
        print("Error en servidor, cayendo a caché: $e");
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
        final fetched = await repository.getByTutor(tutorId);
        if (fetched != null) {
          tutorSessions = fetched;
          await saveSessionsCache('tutor_sessions', tutorSessions);
        }
      } catch (e) {
        print("Error en servidor, cayendo a caché: $e");
        await loadSessionsFromCache('tutor_sessions', isStudent: false);
      }
    } else {
      await loadSessionsFromCache('tutor_sessions', isStudent: false);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Session?> createSession(Session session) async {
    errorMessage = null;
    if (!ConnectionService().hasConnection) {
      errorMessage = "Sin conexión";
      notifyListeners();
      return null;
    }
    try {
      final created = await repository.createSession(session);
      if (created != null) {
        studentSessions.add(created);
        notifyListeners();
      }
      return created;
    } catch (e) {
      errorMessage = "Error al crear sesión";
      notifyListeners();
      return null;
    }
  }

  Future<void> saveSessionsCache(String key, List<Session> sessions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList(key, jsonList);
    } catch (e) {
      print("Error guardando caché: $e");
    }
  }

  Future<void> loadSessionsFromCache(String key, {required bool isStudent}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(key);

      if (jsonList == null || jsonList.isEmpty) {
        if (isStudent) studentSessions = []; else tutorSessions = [];
        return;
      }

      final List<Session> tempSessions = [];
      for (var jsonStr in jsonList) {
        final decoded = jsonDecode(jsonStr);
        if (decoded != null && decoded is Map<String, dynamic>) {
          tempSessions.add(Session.fromJson(decoded));
        }
      }

      if (isStudent) {
        studentSessions = tempSessions;
      } else {
        tutorSessions = tempSessions;
      }
    } catch (e) {
      print("Error procesando caché: $e");
      if (isStudent) studentSessions = []; else tutorSessions = [];
    }
  }
}