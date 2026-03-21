import 'package:g45_flutter/models/user.dart';

class TutorSummary {
  final String? id;
  final String? name;
  final String? major;
  final String? profileImageUrl;
  final int? sessionPrice;
  final List<String>? tutoringSkills;

  TutorSummary({
    this.id,
    this.name,
    this.major,
    this.profileImageUrl,
    this.sessionPrice,
    this.tutoringSkills,
  });

  factory TutorSummary.fromUser(User user) {
    return TutorSummary(
      id: user.id,
      name: user.name,
      major: user.major,
      profileImageUrl: user.profileImageUrl,
      sessionPrice: user.sessionPrice,
      tutoringSkills: user.tutoringSkills,
    );
  }

  factory TutorSummary.fromJson(Map<String, dynamic> json) {
    return TutorSummary(
      id: json['id']?.toString(),
      name: json['name'],
      major: json['major'],
      sessionPrice: json['session_price'],
      profileImageUrl: json['profile_image_url'],
      tutoringSkills: List<String>.from(json['tutoring_skills'] ?? []),
    );
  }

  factory TutorSummary.fromMap(Map<String, dynamic> map) {
    return TutorSummary(
      id: map['id']?.toString(),
      name: map['name'],
      major: map['major'],
      profileImageUrl: map['profileImageUrl'],
      sessionPrice: map['sessionPrice'],
      tutoringSkills: List<String>.from(map['tutoringSkills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'major': major,
      'profileImageUrl': profileImageUrl,
      'sessionPrice': sessionPrice,
      'tutoringSkills': tutoringSkills,
    };
  }
}
