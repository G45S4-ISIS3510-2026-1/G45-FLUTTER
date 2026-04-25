import 'package:flutter/material.dart';
import '../repositories/pqr_repository.dart';

class PqrViewModel extends ChangeNotifier {
  //-------------------------------------
  // STATE
  //-------------------------------------
  bool _isLoading = false;
  String? _errorMessage;

  final PqrRepository _repo = PqrRepository();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List pqrs = [];

  //-------------------------------------
  // VALIDACIÓN + ENVÍO
  //-------------------------------------
  Future<bool> sendPqr({
    required String authorId,
    required String? type,
    required String description,
    String? sessionId,
  }) async {
    //-------------------------------------
    // VALIDACIONES
    //-------------------------------------
    if (type == null || type.isEmpty) {
      _errorMessage = "Selecciona un tipo de PQR";
      notifyListeners();
      return false;
    }

    if (description.isEmpty || description.length < 10) {
      _errorMessage = "La descripción es muy corta";
      notifyListeners();
      return false;
    }

    //-------------------------------------
    // LOADING
    //-------------------------------------
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      //-------------------------------------
      // LLAMAR REPOSITORY
      //-------------------------------------
      await _repo.createPqr(
        authorId: authorId,
        type: type,
        description: description,
        sessionId: sessionId,
      );

      //-------------------------------------
      // REFRESH LISTA
      //-------------------------------------
      await loadPqrs(authorId);

      //-------------------------------------
      // SUCCESS
      //-------------------------------------
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  //-------------------------------------
  // LOAD PQRS
  //-------------------------------------
  Future<void> loadPqrs(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      pqrs = await _repo.getPqrsByAuthor(userId);
    } catch (e) {
      print("ERROR LOAD PQRS: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
