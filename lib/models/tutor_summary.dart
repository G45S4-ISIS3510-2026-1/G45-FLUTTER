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

  factory TutorSummary.fromJson(Map<String, dynamic> json) {
    return TutorSummary(
      id: json['id']?.toString(),
      name: json['name'],
      major: json['major'],
      profileImageUrl: json['profileImageUrl'] ?? json['image'],
      sessionPrice: json['sessionPrice'] ?? (json['price'] is int ? json['price'] : null),
      tutoringSkills: List<String>.from(json['tutoringSkills'] ?? json['tutoring_skills'] ?? []),
    );
  }

  factory TutorSummary.fromMap(Map<String, dynamic> map) {
    return TutorSummary(
      id: map['id']?.toString() ?? map['uniandesId']?.toString(),
      name: map['name'],
      major: map['major'],
      profileImageUrl: map['image'] ?? map['profileImageUrl'],
      sessionPrice: map['sessionPrice'] ?? int.tryParse(map['price']?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "") ?? 0,
      tutoringSkills: List<String>.from(map['tutoringSkills'] ?? map['tutoring_skills'] ?? []),
    );
  }
}
