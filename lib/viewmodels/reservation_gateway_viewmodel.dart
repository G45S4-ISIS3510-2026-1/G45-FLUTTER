import 'package:flutter/material.dart';
import 'package:g45_flutter/repositories/session_repository.dart';

import '../models/session.dart';

class ReservationGatewayViewModel extends ChangeNotifier {
  final SessionRepository _sessionRepo = SessionRepository();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Session?> createSession(Session session) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Session createdSession = await _sessionRepo.createSession(session);
      return createdSession;
    } catch (e) {
      _errorMessage = "Error creando sesion: $e";
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
