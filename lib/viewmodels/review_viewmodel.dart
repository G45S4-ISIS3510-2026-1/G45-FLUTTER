import 'package:flutter/material.dart';
import '../models/review.dart';
import '../repositories/review_repository.dart';
import '../viewmodels/auth.dart';

class ReviewViewModel extends ChangeNotifier {
  //-------------------------------------
  // STATE
  //-------------------------------------
  final ReviewRepository _repo = ReviewRepository();

  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  //-------------------------------------
  // GET REVIEWS BY TUTOR
  //-------------------------------------
  Future<void> loadReviewsByTutor(String tutorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = await _repo.getReviewsByTutor(tutorId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error cargando reseñas";
    }

    _isLoading = false;
    notifyListeners();
  }

  //-------------------------------------
  // CREATE REVIEW
  //-------------------------------------
  Future<bool> createReview({
    required String tutorId,
    required int rating,
    required String details,
  }) async {
    //-------------------------------------
    // VALIDACIONES
    //-------------------------------------
    if (rating == 0) {
      _errorMessage = "Selecciona una calificación";
      notifyListeners();
      return false;
    }

    if (details.isEmpty || details.length < 10) {
      _errorMessage = "La reseña es muy corta";
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
      // USER DESDE AUTH
      //-------------------------------------
      final user = AuthViewModel().userCache;

      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      //-------------------------------------
      // POST REVIEW
      //-------------------------------------
      final success = await _repo.createReview(
        authorId: user.id,
        tutorId: tutorId,
        rating: rating,
        details: details,
      );

      if (!success) {
        throw Exception("Error backend");
      }

      //-------------------------------------
      // REFRESH LISTA
      //-------------------------------------
      await loadReviewsByTutor(tutorId);

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
      _errorMessage = "Error enviando reseña";
      notifyListeners();
      return false;
    }
  }
}