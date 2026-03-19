import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/skills.dart';

class SkillRepository {
  final String baseUrl = "http://127.0.0.1:8000/skills";

  Future<List<String>> getMajors() async {
    final url = Uri.parse("$baseUrl/majors");
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return List<String>.from(data);
    }

    throw Exception("Error obteniendo majors: ${resp.statusCode}");
  }

  Future<List<Skill>> getAllSkills() async {
    final url = Uri.parse(baseUrl);
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((json) => Skill.fromJson(json)).toList();
    }

    throw Exception("Error obteniendo skills: ${resp.statusCode}");
  }

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