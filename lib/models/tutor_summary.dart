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
      id: json['id'],
      name: json['name'],
      major: json['major'],
      profileImageUrl: json['profileImageUrl'],
      sessionPrice: json['sessionPrice'],
      tutoringSkills: List<String>.from(json['tutoringSkills'] ?? []),
    );
  }
}