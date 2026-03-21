import 'package:flutter/material.dart';
import 'package:g45_flutter/repositories/skills_repository.dart';
import '../models/skills.dart';


class SkillsViewModel extends ChangeNotifier {
  final SkillRepository _repo = SkillRepository();

  List<Skill> _skills = [];
  List<String> _majors = [];

  bool _isLoading = false;
  String? _error;

  // getters
  List<Skill> get skills => _skills;
  List<String> get majors => _majors;
  bool get isLoading => _isLoading;//para manejar logo de carga
  String? get error => _error;// para try catch y guardar errores

  // ---------------------------------- LOAD ALL SKILLS
  Future<void> loadSkills() async {
    _isLoading = true; 
    _error = null;
    notifyListeners();

    try {
      _skills = await _repo.getAllSkills();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------------------------- LOAD MAJORS
  Future<void> loadMajors() async {
    try {
      _majors = await _repo.getMajors();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ---------------------------------- FILTER BY MAJOR
  Future<void> filterByMajor(String major) async {
    _isLoading = true;
    notifyListeners();

    try {
      _skills = await _repo.getByMajor(major);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}