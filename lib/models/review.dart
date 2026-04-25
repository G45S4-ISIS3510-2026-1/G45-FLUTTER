class Review {
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String details;
  final double rating;
  final DateTime createdAt;
  final String tutorId;

  Review({
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.details,
    required this.rating,
    required this.createdAt,
    required this.tutorId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      details: json['details'],
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      tutorId: json['tutorId'],
    );
  }
  Map<String, dynamic> toJson() {
  return {
    "authorId": authorId,
    "authorName": authorName,
    "authorImage": authorImage,
    "rating": rating,
    "details": details,
    "createdAt": createdAt.toIso8601String(),
    "tutorId": tutorId,
  };
}
}