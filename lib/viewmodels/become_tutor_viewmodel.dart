import 'package:flutter/material.dart';
import '../../repositories/skills_repository.dart';

class BecomeTutorViewModel extends ChangeNotifier {
  final repo = SkillRepository();

  List<String> majors = [];
  List<String> availableSkills = [];

  String? selectedMajor;
  String? selectedSkill;
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? profileImageUrl;

  List<String> addedSkills = [];
  List<String> availabilities = [];

  bool isLoading = false;

  final List<String> days = [
    "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
  ];

  Future<void> loadMajors() async {
    isLoading = true;
    notifyListeners();
    final data = await repo.getMajors();
    majors = data;
    isLoading = false;
    notifyListeners();
  }

  Future<void> selectMajor(String major) async {
    selectedMajor = major;
    selectedSkill = null;
    addedSkills.clear();
    availableSkills = [];
    notifyListeners();
    // TODO: availableSkills = await repo.getByMajor(major);
    notifyListeners();
  }

  void selectSkill(String? skill) {
    selectedSkill = skill;
    notifyListeners();
  }

  void addSkill() {
    if (selectedSkill != null && !addedSkills.contains(selectedSkill)) {
      addedSkills.add(selectedSkill!);
      selectedSkill = null;
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    addedSkills.remove(skill);
    notifyListeners();
  }

  void selectDay(String? day) {
    selectedDay = day;
    notifyListeners();
  }

  void selectTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void addAvailability(BuildContext context) {
    if (selectedDay != null && selectedTime != null) {
      final entry = "$selectedDay - ${selectedTime!.format(context)}";
      availabilities.add(entry);
      selectedDay = null;
      selectedTime = null;
      notifyListeners();
    }
  }

  void removeAvailability(String availability) {
    availabilities.remove(availability);
    notifyListeners();
  }

  Future<void> becomeTutor() async {
    // TODO: conectar con repo para hacerse tutor
  }
}