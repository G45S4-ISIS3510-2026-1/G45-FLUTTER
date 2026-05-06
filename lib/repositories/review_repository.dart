import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review.dart';
import '../config/api_config.dart';

class ReviewRepository {
  final String baseUrl = ApiConfig.baseUrl;

  //-------------------------------------
  // CREATE REVIEW (POST)
  //-------------------------------------
  Future<bool> createReview({
    required String authorId,
    required String tutorId,
    required int rating,
    required String details,
  }) async {
    try {
      final body = {
        "authorId": authorId,
        "tutorId": tutorId,
        "rating": rating.toDouble(), //  backend espera double
        "details": details,
        "label": "Reseña",
        "createdAt": DateTime.now().toIso8601String(),
      };

      final url = "$baseUrl/reviews/"; 

      print("====== CREATE REVIEW ======");
      print("POST URL: $url");
      print("BODY SENT: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("CREATE REVIEW SUCCESS ");
        return true;
      } else {
        print("ERROR BACKEND : ${response.body}");
        return false;
      }
    } catch (e) {
      print("EXCEPTION createReview : $e");
      return false;
    }
  }

  //-------------------------------------
  // GET REVIEWS BY TUTOR (GET)
  //-------------------------------------
  Future<List<Review>> getReviewsByTutor(String tutorId) async {
    try {
      final url = "$baseUrl/reviews/by-tutor/$tutorId";

      print("====== GET REVIEWS ======");
      print("GET URL: $url");

      final response = await http.get(Uri.parse(url));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        //----------------------------------
        // MANEJO DEFENSIVO JSON
        //----------------------------------
        List data;

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey("data")) {
          data = decoded["data"];
        } else {
          print("Formato inesperado de respuesta ");
          return [];
        }

        final reviews = data.map((e) => Review.fromJson(e)).toList();

        print("PARSED REVIEWS COUNT: ${reviews.length}");

        //----------------------------------
        // GUARDAR CACHE
        //----------------------------------
        await _saveReviewsCache(tutorId, reviews);

        return reviews;
      } else {
        throw Exception("Error status ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR GET REVIEWS → usando cache : $e");

      //----------------------------------
      // FALLBACK CACHE
      //----------------------------------
      return await _getReviewsCache(tutorId);
    }
  }

  //-------------------------------------
  // SAVE CACHE
  //-------------------------------------
  Future<void> _saveReviewsCache(
      String tutorId, List<Review> reviews) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = reviews.map((e) => e.toJson()).toList();

    await prefs.setString(
      "reviews_cache_$tutorId",
      jsonEncode(jsonList),
    );

    print("CACHE SAVED: reviews_cache_$tutorId");
  }

  //-------------------------------------
  // GET CACHE
  //-------------------------------------
  Future<List<Review>> _getReviewsCache(String tutorId) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("reviews_cache_$tutorId");

    if (data == null) {
      print("CACHE EMPTY");
      return [];
    }

    final List decoded = jsonDecode(data);
    final reviews = decoded.map((e) => Review.fromJson(e)).toList();

    print("CACHE LOADED: ${reviews.length} reviews");

    return reviews;
  }
}