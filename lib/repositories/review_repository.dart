import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';
import '../config/api_config.dart';

class ReviewRepository {
  final String baseUrl = ApiConfig.baseUrl;

  //Reviews de cada autor
  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/reviews/by-tutor/$tutorId",
      ), // se le pasa el id puntual del tutor.
    );

    print(response.body); //debug

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body); // recibe json
      return data
          .map((e) => Review.fromJson(e))
          .toList(); // pasa de json a objeto dart lista
    } else {
      throw Exception("Error cargando reviews: ${response.statusCode}");
    }
  }

  Future<bool> createReview({
    required String authorId,
    required String tutorId,
    required int rating,
    required String details,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reviews"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "authorId": authorId,
        "tutorId": tutorId,
        "rating": rating,
        "details": details,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}
