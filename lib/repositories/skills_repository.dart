import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/skills.dart';
import '../core/api_config.dart';

class SkillRepository {

  // headers comunes para evitar la página intermedia de ngrok
  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      };

  //obtener los majors 
  Future<List<String>> getMajors() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/skills/majors");
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return List<String>.from(data); //de json a lista de strings
    }

    throw Exception("Error obteniendo majors: ${resp.statusCode}");
  }

  //todas las skills
  Future<List<Skill>> getAllSkills() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/skills");
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);//de josn a lista de skills
      return data.map((json) => Skill.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo skills: ${resp.statusCode}");
  }

  //buscar las skills que coincidan en la major
  Future<List<Skill>> getByMajor(String major) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/skills/by-major/$major");
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((json) => Skill.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo skills por major: ${resp.statusCode}");
  }

}