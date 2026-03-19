import 'package:cloud_firestore/cloud_firestore.dart';
class Tutor {
  final String id;
  final String name;
  final String email;
  final String major;
  final bool isTutoring;
  final int sessionPrice;
  final String profileImageUrl;

  Tutor({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.isTutoring,
    required this.sessionPrice,
    required this.profileImageUrl,
  });

  factory Tutor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Tutor(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      major: data['major'] ?? '',
      isTutoring: data['isTutoring'] ?? false,
      sessionPrice: data['sessionPrice'] ?? 0,
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }
}