import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review.dart';
import '../config/api_config.dart';

class ReviewRepository {
  final String baseUrl = ApiConfig.baseUrl;

  Future<bool> createReview({
  required String authorId,
  required String tutorId,
  required int rating,
  required String details,
}) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/reviews"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "authorId": authorId,
        "tutorId": tutorId,
        "rating": rating,
        "details": details,
        "createdAt": DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Error backend: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error createReview: $e");
    return false;
  }
}

  //Reviews de cada autor
  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/reviews/by-tutor/$tutorId"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final reviews = data.map((e) => Review.fromJson(e)).toList();

        //----------------------------------
        //  GUARDAR CACHE
        //----------------------------------
        await _saveReviewsCache(tutorId, reviews);

        return reviews;
      } else {
        throw Exception();
      }
    } catch (e) {
      //----------------------------------
      //  FALLBACK CACHE
      //----------------------------------
      return await _getReviewsCache(tutorId);
    }
  }

  Future<void> _saveReviewsCache(String tutorId, List<Review> reviews) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = reviews.map((e) => e.toJson()).toList();

    await prefs.setString("reviews_cache_$tutorId", jsonEncode(jsonList));
  }

  Future<List<Review>> _getReviewsCache(String tutorId) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("reviews_cache_$tutorId");

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => Review.fromJson(e)).toList();
  }
}
