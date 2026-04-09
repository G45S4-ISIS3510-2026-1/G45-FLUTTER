import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'skills_repository.dart';
import '../models/tutor_summary.dart';
import '../core/api_config.dart';

class UserRepository {
  final SkillRepository skillRepo = SkillRepository();

  // headers comunes para evitar problemas con ngrok
  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      };

  //buscar user por email retorna un objeeto usuario
  Future<User?> findUser(String email) async {
    print("EMAIL BEFORE REQUEST: '$email'");

    final url = Uri.parse('${ApiConfig.baseUrl}/users/by-email/$email');

    print("FINAL URL: $url");

    final resp = await http.get(url, headers: headers);

    print("STATUS: ${resp.statusCode}");
    print("BODY: ${resp.body}");

    if (resp.statusCode == 404) {
      return null;
    }

    final data = jsonDecode(resp.body);
    return User.fromJson(data);
  }

  //actualizar el major del usuario 
  Future<User?> updateUsuarioInterestedSkills(User user, String major) async {
    final skillsMajor = await skillRepo.getByMajor(major);
    user.interestedSkills = skillsMajor.map((s) => s.id!).toList();

    final url = Uri.parse("${ApiConfig.baseUrl}/users/${user.id}");

    final resp = await http.put(
      url,
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error actualizando usuario en backend");
    }

    return User.fromJson(jsonDecode(resp.body));
  }

  //crear usuario params:  id, name, email
  Future<User?> createUser(String id, String name, String email) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/");

    final body = {
      "id": id,
      "name": name,
      "email": email,
      "major": "Otro",
      "uniandesId": 0,
      "isTutoring": false,
      "interestedSkills": [],
      "favTutors": [],
      "fcmTokens": [],
      "paymentMethods": [],
      "availability": {
        "monday": [],
        "tuesday": [],
        "wednesday": [],
        "thursday": [],
        "friday": [],
        "saturday": [],
        "sunday": []
      }
    };

    final resp = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print("CREATE USER STATUS: ${resp.statusCode}");
    print("CREATE USER BODY: ${resp.body}");

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return User.fromJson(jsonDecode(resp.body));
    }

    return null;
  }

//-----------------------------------------------
//Llamado de lista de tutores 
//-----------------------------------------------

  //obteneer la lista de tutoreSummary con params opcionales: nombre, lista de skills y major
  Future<List<TutorSummary>> getTutors({
    String? name,
    List<String>? skillIds,
    String? major,
  }) async {
    final baseUri = Uri.parse("${ApiConfig.baseUrl}/users/tutors/search");

    final query = <String>[];

    if (name != null) {
      query.add("name=${Uri.encodeComponent(name)}");
    }

    if (major != null) {
      query.add("major=${Uri.encodeComponent(major)}");
    }

    if (skillIds != null && skillIds.isNotEmpty) {
      for (final id in skillIds) {
        query.add("skill_ids=${Uri.encodeComponent(id)}");
      }
    }

    final finalUri = Uri.parse(
      "${baseUri.toString()}${query.isNotEmpty ? "?" + query.join("&") : ""}",
    );

    final resp = await http.get(finalUri, headers: headers);

    if (resp.statusCode != 200) {
      print("ERROR getTutors: ${resp.body}");
      throw Exception("Error obteniendo tutores");
    }

    final List data = jsonDecode(resp.body);

    return data.map((json) => TutorSummary.fromJson(json)).toList();
  }

  //obtener lista de usuarios por ID
  Future<User> getUserById(String id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/$id");

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      throw Exception("Error obteniendo usuario");
    }

    return User.fromJson(jsonDecode(resp.body));
  }
}