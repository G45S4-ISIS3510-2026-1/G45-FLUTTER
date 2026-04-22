import 'package:flutter/material.dart';
import '../../repositories/skills_repository.dart';
import '../../models/skills.dart';

class BecomeTutorViewModel extends ChangeNotifier {
  final repo = SkillRepository();

  List<String> majors = [];
  List<Skill> availableSkills = [];

  String? selectedMajor;
  Skill? selectedSkill;
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? profileImageUrl;

  List<String> addedSkills = [];
  List<String> addedSkillIds = [];

  Map<String, List<String>> availability = {
    "monday": [],
    "tuesday": [],
    "wednesday": [],
    "thursday": [],
    "friday": [],
    "saturday": [],
  };

  bool isLoading = false;

  final List<String> days = [
    "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"
  ];

  final Map<String, String> dayToKey = {
    "Lunes": "monday",
    "Martes": "tuesday",
    "Miércoles": "wednesday",
    "Jueves": "thursday",
    "Viernes": "friday",
    "Sábado": "saturday",
  };

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
    addedSkillIds.clear();
    availableSkills = [];
    notifyListeners();
    availableSkills = await repo.getByMajor(major);
    notifyListeners();
  }

  void selectSkill(Skill? skill) {
    selectedSkill = skill;
    notifyListeners();
  }

  bool addSkill() {
    if (selectedSkill == null) return false;
    if (addedSkills.contains(selectedSkill!.label)) return false;

    addedSkills.add(selectedSkill!.label);
    addedSkillIds.add(selectedSkill!.id);
    selectedSkill = null;
    notifyListeners();
    return true;
  }

  void removeSkill(String label) {
    final index = addedSkills.indexOf(label);
    if (index != -1) {
      addedSkills.removeAt(index);
      addedSkillIds.removeAt(index);
      notifyListeners();
    }
  }

  void selectDay(String? day) {
    selectedDay = day;
    notifyListeners();
  }

  void selectTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void addAvailability() {
    if (selectedDay == null || selectedTime == null) return;

    final key = dayToKey[selectedDay]!;
    final now = DateTime.now();

    final weekdayTarget = dayToKey.keys.toList().indexOf(selectedDay!) + 1;
    int daysUntil = weekdayTarget - now.weekday;
    if (daysUntil <= 0) daysUntil += 7;

    final targetDate = now.add(Duration(days: daysUntil));
    final dt = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    availability[key]!.add(dt.toIso8601String());
    selectedDay = null;
    selectedTime = null;
    notifyListeners();
  }

  void removeAvailability(String key, String isoString) {
    availability[key]!.remove(isoString);
    notifyListeners();
  }

  List<Map<String, String>> get availabilityDisplay {
    final List<Map<String, String>> result = [];
    availability.forEach((key, slots) {
      for (final iso in slots) {
        result.add({"key": key, "iso": iso});
      }
    });
    return result;
  }

  String formatSlot(String key, String isoString) {
    final dt = DateTime.parse(isoString);
    final dayLabel = dayToKey.entries.firstWhere((e) => e.value == key).key;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$dayLabel - $hour:$minute";
  }

  String? errorMessage;

  Future<void> becomeTutor() async {
    errorMessage = null;

    if (addedSkillIds.isEmpty && availabilityDisplay.isEmpty) {
      errorMessage = "Debes agregar al menos una skill y una disponibilidad";
      notifyListeners();
      return;
    }
    if (addedSkillIds.isEmpty) {
      errorMessage = "Debes agregar al menos una skill";
      notifyListeners();
      return;
    }
    if (availabilityDisplay.isEmpty) {
      errorMessage = "Debes agregar al menos una disponibilidad";
      notifyListeners();
      return;
    }

    // TODO: llamar al repo
    notifyListeners();
  }
}