import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';
import '../core/api_config.dart';

class ReviewRepository {

  // headers comunes para evitar que ngrok devuelva la página intermedia
  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      };

  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/reviews/by-tutor/$tutorId"), // se le pasa el id puntual del tutor.
      headers: headers,
    );

    print(response.body);//debug

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);// recibe json
      return data.map((e) => Review.fromJson(e)).toList();// pasa de json a objeto dart lista
    } else {
      throw Exception("Error cargando reviews: ${response.statusCode}");
    }
  }
}