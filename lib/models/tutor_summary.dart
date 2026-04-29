import 'package:g45_flutter/models/user.dart';

class TutorSummary {
  final String? id;
  final String? name;
  final String? major;
  final double? rating;
  final String? profileImageUrl;
  final int? sessionPrice;
  final List<String>? tutoringSkills;

  TutorSummary({
    this.id,
    this.name,
    this.major,
    this.rating,
    this.profileImageUrl,
    this.sessionPrice,
    this.tutoringSkills,
  });

  factory TutorSummary.fromUser(User user) {
    return TutorSummary(
      id: user.id,
      name: user.name,
      major: user.major,
      rating: user.tutorRating,
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
      rating: ((json['rating'] ?? json['tutorRating']) as num?)?.toDouble(),
      profileImageUrl: json['profile_image_url'] ?? json['profileImageUrl'],
      sessionPrice: json['session_price'] ?? json['sessionPrice'],
      tutoringSkills: List<String>.from(
        json['tutoring_skills'] ?? json['tutoringSkills'] ?? [],
      ),
    );
  }

  factory TutorSummary.fromMap(Map<String, dynamic> map) {
    return TutorSummary(
      id: map['id']?.toString(),
      name: map['name'],
      major: map['major'],
      rating: (map['rating'] as num?)?.toDouble(),
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
      'rating': rating,
      'profileImageUrl': profileImageUrl,
      'sessionPrice': sessionPrice,
      'tutoringSkills': tutoringSkills,
    };
  }
}
