import 'package:flutter/material.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/viewmodels/session.dart';

class AgendaViewModel extends ChangeNotifier {
  final SessionViewModel _sessionVM = SessionViewModel.instance;

  List<Session> _studentSessions = [];
  List<Session> _tutorSessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Session> get studentSessions => _studentSessions;
  List<Session> get tutorSessions => _tutorSessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Una lista tanto para las clases que tomaré y que dictaré
  List<Session> get allSessions {
    final List<Session> combined = [..._studentSessions, ..._tutorSessions];

    // Ordenar por fecha
    combined.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return combined;
  }

  Future<void> loadAgenda() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = AuthViewModel.instance.userCache;
      if (user == null) {
        throw Exception("No hay usuario autenticado.");
      }

      final studentFuture = _sessionVM.getSessionsByStudent(user.id);
      final tutorFuture = _sessionVM.getSessionsByTutor(user.id);

      final results = await Future.wait([studentFuture, tutorFuture]);

      _studentSessions = results[0];
      _tutorSessions = results[1];
    } catch (e) {
      _errorMessage = "Error cargando la agenda: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
