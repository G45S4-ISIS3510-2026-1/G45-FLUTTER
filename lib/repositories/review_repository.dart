import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewRepository {
  final String baseUrl = "http://127.0.0.1:8000";

  //Reviews de cada autor
  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/reviews/by-tutor/$tutorId"), // se le pasa el id puntual del tutor.
    );

    print(response.body); //debug

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);// recibe json
      return data.map((e) => Review.fromJson(e)).toList();// pasa de json a objeto dart lista
    } else {
      throw Exception("Error cargando reviews: ${response.statusCode}");
    }
  }
}