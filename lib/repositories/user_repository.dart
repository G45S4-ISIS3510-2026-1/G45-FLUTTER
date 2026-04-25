import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/tutor_summary.dart';
import '../models/user.dart';
import 'skills_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String baseUrl = "${ApiConfig.baseUrl}/users";
  final SkillRepository skillRepo = SkillRepository();

  //-----------------------------------------------
  // FIND USER
  //-----------------------------------------------
  Future<User?> findUser(String email) async {
    final url = Uri.parse("$baseUrl/by-email/$email");

    final resp = await http.get(url);

    if (resp.statusCode == 404) return null;
    if (resp.statusCode != 200) {
      throw Exception("Error consultando backend");
    }

    return User.fromJson(jsonDecode(resp.body));
  }

  //-----------------------------------------------
  // UPDATE SKILLS
  //-----------------------------------------------
  Future<User?> updateUserInterestedSkills(User user, String major) async {
    final skillsMajor = await skillRepo.getByMajor(major);
    final skillIds = skillsMajor.map((s) => s.id!).toList();

    final url = Uri.parse("$baseUrl/${user.id}/interested-skills");

    final resp = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(skillIds),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error actualizando usuario");
    }

    return User.fromJson(jsonDecode(resp.body));
  }

  //-----------------------------------------------
  // CREATE USER
  //-----------------------------------------------
  Future<User> createUser(String uid, String name, String email) async {
    final url = Uri.parse("$baseUrl/");

    User? usuario;
    try {
      usuario = await findUser(email);
    } catch (_) {
      usuario = null;
    }

    if (usuario != null) return usuario;

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": uid,
        "name": name,
        "email": email,
        "major": "Otro",
        "uniandesId": null,
        "interestedSkills": [],
        "tutoringSkills": [],
        "availability": {},
        "isTutoring": false,
        "favTutors": [],
        "fcmTokens": [],
      }),
    );

    if (resp.statusCode != 201) {
      throw Exception("Error creando usuario");
    }

    return User.fromJson(jsonDecode(resp.body));
  }

  //-----------------------------------------------
  // GET TUTORS
  //-----------------------------------------------
  Future<List<TutorSummary>> getTutors({
    String? name,
    List<String>? skillIds,
    String? major,
    int limit = 20,
  }) async {
    final uri = Uri.parse("$baseUrl/tutors/search").replace(
      queryParameters: {
        if (name != null) "name": name,
        if (major != null) "major": major,
        "limit": limit.toString(),
      },
    );

    final finalUri = skillIds != null && skillIds.isNotEmpty
        ? Uri.parse(
            uri.toString() +
                "&" +
                skillIds.map((id) => "skill_ids=${Uri.encodeComponent(id)}").join("&"),
          )
        : uri;

    final resp = await http.get(finalUri);

    if (resp.statusCode != 200) {
      throw Exception("Error obteniendo tutores");
    }

    final List data = jsonDecode(resp.body);
    return data.map((json) => TutorSummary.fromJson(json)).toList();
  }

  //-----------------------------------------------
  // GET USER BY ID (CACHE + FALLBACK)
  //-----------------------------------------------
  Future<User?> getUserById(String id) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final url = Uri.parse("$baseUrl/profile/$id");

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);

        await prefs.setString("user_$id", jsonEncode(data));

        return User.fromJson(data);
      } else {
        throw Exception("Error status ${resp.statusCode}");
      }
    } catch (e) {
      final cached = prefs.getString("user_$id");

      if (cached != null) {
        return User.fromJson(jsonDecode(cached));
      }

      return null;
    }
  }

  //-----------------------------------------------
  // BECOME TUTOR
  //-----------------------------------------------
  Future<User> becomeTutor(
    String userId,
    List<String> skillIds,
    Map<String, List<String>> availability,
    int price,
  ) async {
    final tutoringUrl = Uri.parse("$baseUrl/$userId/tutoring?is_tutoring=true");
    await http.patch(tutoringUrl);

    final skillsUrl = Uri.parse("$baseUrl/$userId/tutoring-skills");
    await http.patch(
      skillsUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(skillIds),
    );

    final availabilityUrl = Uri.parse("$baseUrl/$userId/availability");
    final availabilityResp = await http.patch(
      availabilityUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(availability),
    );

    if (availabilityResp.statusCode != 200) {
      throw Exception("Error actualizando disponibilidad");
    }

    // Flutter
    final priceUrl = Uri.parse("$baseUrl/$userId/session-price?new_price=$price");

    final priceResp = await http.patch(
      priceUrl,
      headers: {"Content-Type": "application/json"},
    );

    if (priceResp.statusCode != 200) {
      throw Exception("Error actualizando precio: ${priceResp.body}");
    }

    return User.fromJson(jsonDecode(availabilityResp.body));
  }

  //-----------------------------------------------
  // RECOMMENDATIONS
  //-----------------------------------------------
  Future<List<TutorSummary>> getRecommendations(List<String> ids) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/recommendations");

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ids),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error obteniendo recomendaciones");
    }

    final List data = jsonDecode(resp.body);
    return data.map((json) => TutorSummary.fromJson(json)).toList();
  }

  //-----------------------------------------------
  // FAVORITES CACHE
  //-----------------------------------------------
  Future<void> saveFavorites(List<String> tutorIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favorites", tutorIds);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("favorites") ?? [];
  }
}