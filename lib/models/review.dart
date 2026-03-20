class Review {
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String details;
  final double rating;
  final DateTime createdAt;

  Review({
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.details,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      details: json['details'],
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}