import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../models/tutor_summary.dart';

class TutorViewModel extends ChangeNotifier {
  final UserRepository repo;

  List<TutorSummary> tutors = [];
  bool isLoading = false;
  bool _isFetchingMore = false;
  String? errorMessage;

  int _limit = 20;

  int get limit => _limit;
  bool get isFetchingMore => _isFetchingMore;

  TutorViewModel(this.repo);

  Future<void> loadTutors({
    String? name,
    List<String>? skillIds,
    String? major,
  }) async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    _limit = 20;
    notifyListeners();

    try {
      tutors = await repo.getTutors(
        name: name,
        skillIds: skillIds,
        major: major,
        limit: _limit,
      );
    } catch (e) {
      errorMessage = "Error cargando tutores";
      tutors = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreTutors() async {
    if (_isFetchingMore) return;

    _isFetchingMore = true;
    _limit += 20;

    try {
      final newTutors = await repo.getTutors(limit: _limit);

      if (newTutors.length == tutors.length) {
        _isFetchingMore = false;
        return;
      }

      tutors = newTutors;
    } catch (e) {
      errorMessage = "Error cargando más tutores";
    }

    _isFetchingMore = false;
    notifyListeners();
  }
}
