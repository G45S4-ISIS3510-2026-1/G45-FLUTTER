import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewRepository {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/reviews/by-tutor/$tutorId"),
    );

    print(response.body); 

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception("Error cargando reviews: ${response.statusCode}");
    }
  }
}