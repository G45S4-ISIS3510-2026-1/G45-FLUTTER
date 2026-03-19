import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'skills_repository.dart';

class UserRepository {
  final String baseUrl = "http://127.0.0.1:8000/users";
  final SkillRepository skillRepo = SkillRepository();

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

  Future<User?> updateUsuarioInterestedSkills(User user, String major) async {
  
    final skillsMajor = await skillRepo.getByMajor(major);
    user.interestedSkills = skillsMajor.map((s) => s.id!).toList();

    final url = Uri.parse("$baseUrl/${user.id}");
    final resp = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error actualizando usuario en backend");
    }

    return User.fromJson(jsonDecode(resp.body));
  }

  Future<User> createUser(String uid, String name, String email) async {
    final url = Uri.parse(baseUrl);

    User? usuario = await findUser(email);

    if(usuario != null){
      return usuario;
    }

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": uid,
        "name": name,
        "email": email,
        "major":"Otro",
        "uniandesId":0,
        "interestedSkills": [],
        "tutoringSkills": [],
        "availability": {},
        "isTutoring": false,
        "favTutors": [],
        "fcmTokens": []
      }),
    );

    if (resp.statusCode != 201) {
      throw Exception("Error creando usuario en backend");
    }

    return User.fromJson(jsonDecode(resp.body));
  }
}