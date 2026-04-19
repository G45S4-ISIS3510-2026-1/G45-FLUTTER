import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/tutor_summary.dart';
import '../models/user.dart';
import 'skills_repository.dart';

class UserRepository {
  final String baseUrl = "${ApiConfig.baseUrl}/users";
  final SkillRepository skillRepo = SkillRepository();

  //buscar user por email retorna un objeeto usuario
  //OJO: este endpoint puede no existir en el backend
  Future<User?> findUser(String email) async {
    final url = Uri.parse("$baseUrl/by-email/$email");

    final resp = await http.get(url);

    if (resp.statusCode == 404) {
      return null;
    }

    if (resp.statusCode != 200) {
      throw Exception("Error consultando backend");
    }

    final Map<String, dynamic> json = jsonDecode(resp.body);
    return User.fromJson(json);
  }

  //actualizar el major del usuario
  Future<User?> updateUserInterestedSkills(User user, String major) async {
    final skillsMajor = await skillRepo.getByMajor(major);
    final skillIds = skillsMajor.map((s) => s.id!).toList();

    //endpoint correcto segun backend
    final url = Uri.parse("$baseUrl/${user.id}/interested-skills");

    final resp = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(skillIds),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error actualizando usuario en backend");
    }

    return User.fromJson(jsonDecode(resp.body));
  }

  //crear usuario params:  id, name, email
  Future<User> createUser(String uid, String name, String email) async {
    final url = Uri.parse("$baseUrl/");

    //si el endpoint no existe, esto puede fallar
    User? usuario;
    try {
      usuario = await findUser(email);
    } catch (_) {
      usuario = null;
    }

    if (usuario != null) {
      return usuario;
    }

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

    print(resp.statusCode);

    if (resp.statusCode != 201) {
      print("BACKEND ERROR: ${resp.body}");
      throw Exception("Error creando usuario en backend");
    }

    return User.fromJson(jsonDecode(resp.body));
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
    final uri = Uri.parse("$baseUrl/tutors/search").replace(
      queryParameters: {
        if (name != null) "name": name,
        if (major != null) "major": major,
      },
    );

    //agregar skill_ids repetidos manualmente
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

  //obtener lista de usuarios por ID
  Future<User> getUserById(String id) async {
    //endpoint correcto segun backend
    final url = Uri.parse("$baseUrl/profile/$id");

    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Error obteniendo usuario");
    }

    return User.fromJson(jsonDecode(resp.body));
  }
}