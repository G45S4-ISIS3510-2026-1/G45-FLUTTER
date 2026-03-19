import 'package:flutter/material.dart';
import 'package:g45_flutter/repositories/tutor_repository.dart';
import 'package:g45_flutter/models/tutor.dart';

class TutorViewModel extends ChangeNotifier {
  final TutorRepository repo;

  List<Tutor> tutors = [];
  bool isLoading = true;

  TutorViewModel(this.repo);

  Future<void> loadTutors() async {
    isLoading = true;
    notifyListeners();

    tutors = await repo.getTutors();

    isLoading = false;
    notifyListeners();
  }
}