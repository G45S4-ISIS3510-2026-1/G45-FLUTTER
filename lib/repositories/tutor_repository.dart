import 'package:g45_flutter/models/tutor.dart';
import 'package:g45_flutter/services/tutor_service.dart';

class TutorRepository {
  final TutorService service;

  TutorRepository(this.service);

  Future<List<Tutor>> getTutors() {
    return service.fetchTutors();
  }
}