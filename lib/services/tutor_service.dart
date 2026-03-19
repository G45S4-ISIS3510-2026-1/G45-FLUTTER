import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g45_flutter/models/tutor.dart';
class TutorService {
  final _db = FirebaseFirestore.instance;

  Future<List<Tutor>> fetchTutors() async {
    final snapshot = await _db
        .collection('users')
        .where('isTutoring', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Tutor.fromFirestore(doc))
        .toList();
  }
}