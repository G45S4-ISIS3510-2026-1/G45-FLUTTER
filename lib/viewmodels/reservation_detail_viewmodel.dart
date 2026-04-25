import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/session_repository.dart';
import 'package:g45_flutter/repositories/user_repository.dart';

import '../models/session.dart';

class ReservationDetailViewModel extends ChangeNotifier {
  final SessionRepository _sessionRepo = SessionRepository();
  final UserRepository _userRepo = UserRepository();

  List<Session> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;
  User? _student;
  User? _tutor;

  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get student => _student;
  User? get tutor => _tutor;

  Future<void> loadSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sessions = await _sessionRepo.getAllSessions();
    } catch (e) {
      _errorMessage = "Error cargando sesiones: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadParticipants(String tutorId, String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _student = await _userRepo.getUserById(studentId);
      _tutor = await _userRepo.getUserById(tutorId);
    } catch (e) {
      _errorMessage = "Error cargando participantes: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelSession(Session session, String participantId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _sessionRepo.cancelSession(session, participantId);
      await loadSessions(); // Recargar para ver e cambio
    } catch (e) {
      _errorMessage = "Error cancelando sesión: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmSession(Session session, String participantId, String verifCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _sessionRepo.confirmSession(session, participantId, verifCode);
      await loadSessions(); // Recargar para ver el cambio
    } catch (e) {
      _errorMessage = "Error confirmando sesión: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
