class TutorSummary {
  final String id;
  final String name;
  final String major;
  final double? averageRating;

  final String? profileImageUrl;
  final int? sessionPrice;

  TutorSummary({
    required this.id,
    required this.name,
    required this.major,
    this.averageRating,
    this.profileImageUrl,
    this.sessionPrice,
  });

  factory TutorSummary.fromJson(Map<String, dynamic> json) {
    return TutorSummary(
      id: json["id"],
      name: json["name"],
      major: json["major"],
      averageRating: json["average_rating"]?.toDouble(),
      profileImageUrl: json["profile_image_url"],
      sessionPrice: json["session_price"],
    );
  }
}
