import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
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

  //-------------------------------------
  // VALIDACIÓN + ENVÍO
  //-------------------------------------
  Future<bool> sendPqr({
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
    // OBTENER USUARIO REAL
    //-------------------------------------
    final user = await AuthViewModel().getUserCache();

    if (user == null) {
      _errorMessage = "Usuario no disponible";
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
        authorId: user.id,
        type: type,
        description: description,
        sessionId: sessionId,
      );

      //-------------------------------------
      // SUCCESS
      //-------------------------------------
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      //-------------------------------------
      // ERROR
      //-------------------------------------
      _isLoading = false;
      _errorMessage = "Error enviando PQR";
      notifyListeners();
      return false;
    }
  }
}
