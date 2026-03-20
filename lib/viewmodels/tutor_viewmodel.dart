import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../models/tutor_summary.dart';

class TutorViewModel extends ChangeNotifier {
  final UserRepository repo;

  List<TutorSummary> tutors = [];
  bool isLoading = false;
  String? errorMessage;

  TutorViewModel(this.repo);

  Future<void> loadTutors({
    String? name,
    List<String>? skillIds,
    String? major,
  }) async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      tutors = await repo.getTutors(
        name: name,
        skillIds: skillIds,
        major: major,
      );
    } catch (e) {
      errorMessage = "Error cargando tutores";
      tutors = [];
    }

    isLoading = false;
    notifyListeners();
  }
}