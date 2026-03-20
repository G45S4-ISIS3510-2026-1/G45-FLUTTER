import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/skills.dart';
import '../config/api_config.dart';

class SkillRepository {
  final String baseUrl = "${ApiConfig.baseUrl}/skills";

  //obtener los majors 
  Future<List<String>> getMajors() async {
    final url = Uri.parse("$baseUrl/majors");
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return List<String>.from(data); //de json a lista de strings
    }

    throw Exception("Error obteniendo majors: ${resp.statusCode}");
  }
  //todas las skills
  Future<List<Skill>> getAllSkills() async {
    final url = Uri.parse(baseUrl);
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);//de josn a lista de skills
      return data.map((json) => Skill.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo skills: ${resp.statusCode}");
  }
  //buscar las skills que coincidan en la major
  Future<List<Skill>> getByMajor(String major) async {
    final url = Uri.parse("$baseUrl/by-major/$major");
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((json) => Skill.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo skills por major: ${resp.statusCode}");
  }

}