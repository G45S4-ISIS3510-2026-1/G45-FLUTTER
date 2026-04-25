import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../models/tutor_summary.dart';
import 'package:g45_flutter/services/recent_viewed.dart';

class TutorViewModel extends ChangeNotifier {
  final UserRepository repo;

  List<TutorSummary> tutors = [];
  List<TutorSummary> recommendedTutors = [];
  List<String> lastLoadedIds = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  String? errorMessage;

  int limit = 20;

  TutorViewModel(this.repo);

  Future<void> loadTutors({
    String? name,
    List<String>? skillIds,
    String? major,
  }) async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    limit = 20;
    notifyListeners();

    try {
      tutors = await repo.getTutors(
        name: name,
        skillIds: skillIds,
        major: major,
        limit: limit,
      );
    } catch (e) {
      errorMessage = "Error cargando tutores";
      tutors = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreTutors() async {
    if (isFetchingMore) return;

    isFetchingMore = true;
    limit += 20;

    try {
      final newTutors = await repo.getTutors(limit: limit);

      if (newTutors.length == tutors.length) {
        isFetchingMore = false;
        return;
      }

      tutors = newTutors;
    } catch (e) {
      errorMessage = "Error cargando más tutores";
    }

    isFetchingMore = false;
    notifyListeners();
  }

  Future<void> loadRecommendations() async {
    final ids = RecentViewedService().ids;
    if (ids.isEmpty) return;
    if (ids.toString() == lastLoadedIds.toString()) return;
    lastLoadedIds = List.from(ids);

    try {
      recommendedTutors = await repo.getRecommendations(ids);
      notifyListeners();
    } catch (e) {}
  }
}