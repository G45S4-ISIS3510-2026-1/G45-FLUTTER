import 'package:g45_flutter/repositories/session_repository.dart';

import '../models/session.dart';

class SessionViewModel {
  final repository = SessionRepository();

  static final SessionViewModel instance = SessionViewModel.internal();
  factory SessionViewModel() => instance;
  SessionViewModel.internal();

  Session? session;

  Future<List<Session>> getSessionsByStudent(String studentId) async {
    return await repository.getByStudent(studentId);
  }

  Future<List<Session>> getSessionsByTutor(String tutorId) async {
    return await repository.getByTutor(tutorId);
  }

  Future<Session?> createSession(Session session) async {
    try {
      return await repository.createSession(session);
    } catch (e) {
      print("Error creating session in VM: $e");
      return null;
    }
  }
}
