import 'package:g45_flutter/models/user.dart';

class TutorSummary {
  final String? id;
  final String? name;
  final String? major;
  final double? rating;
  final int? receivedRatings;
  final String? profileImageUrl;
  final int? sessionPrice;
  final List<String>? tutoringSkills;

  TutorSummary({
    this.id,
    this.name,
    this.major,
    this.rating,
    this.receivedRatings,
    this.profileImageUrl,
    this.sessionPrice,
    this.tutoringSkills,
  });

  factory TutorSummary.fromUser(User user) {
    return TutorSummary(
      id: user.id,
      name: user.name,
      major: user.major,
      rating: user.tutorRating ?? 0,
      receivedRatings: 0,
      profileImageUrl: user.profileImageUrl,
      sessionPrice: user.sessionPrice,
      tutoringSkills: user.tutoringSkills,
    );
  }

  factory TutorSummary.fromJson(Map<String, dynamic> json) {
    return TutorSummary(
      id: json['id']?.toString(),
      name: json['name'],
      major: json['major']?.toString(),

      rating: (json['tutorRating'] ?? json['rating'] ?? 0).toDouble(),
      receivedRatings: json['receivedRatings'] ?? 0,

      profileImageUrl:
          json['profile_image_url'] ?? json['profileImageUrl'],

      sessionPrice:
          json['session_price'] ?? json['sessionPrice'],

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

      rating: (map['tutorRating'] ?? map['rating'] ?? 0).toDouble(),
      receivedRatings: map['receivedRatings'] ?? 0,

      profileImageUrl:
          map['profileImageUrl'] ?? map['profile_image_url'],

      sessionPrice:
          map['sessionPrice'] ?? map['session_price'],

      tutoringSkills: List<String>.from(
        map['tutoringSkills'] ?? map['tutoring_skills'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'major': major,
      'rating': rating,
      'receivedRatings': receivedRatings,
      'profileImageUrl': profileImageUrl,
      'sessionPrice': sessionPrice,
      'tutoringSkills': tutoringSkills,
    };
  }
}