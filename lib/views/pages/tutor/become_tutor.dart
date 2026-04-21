import 'package:flutter/material.dart';
import '../../../repositories/skills_repository.dart';

class BecomeTutor extends StatefulWidget {
  const BecomeTutor({super.key});

  @override
  State<BecomeTutor> createState() => _BecomeTutorState();
}

class _BecomeTutorState extends State<BecomeTutor> {
  final repo = SkillRepository();

  String? profileImageUrl;

  final TextEditingController majorController = TextEditingController();
  String? selectedMajor;

  String? selectedSkill;
  final List<String> addedSkills = [];

  final List<String> availabilities = [];
  String? selectedDay;
  TimeOfDay? selectedTime;

  List<String> majors = [];
  List<String> availableSkills = [];

  final List<String> days = [
    "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
  ];

  @override
  void initState() {
    super.initState();
    loadMajors();
  }

  Future<void> loadMajors() async {
    final data = await repo.getMajors();
    setState(() => majors = data);
  }

  Future<void> loadSkillsByMajor(String major) async {
    // TODO: conectar con repo.getByMajor(major) cuando esté disponible
    setState(() => availableSkills = []);
  }

  void addSkill() {
    if (selectedSkill != null && !addedSkills.contains(selectedSkill)) {
      setState(() {
        addedSkills.add(selectedSkill!);
        selectedSkill = null;
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void addAvailability() {
    if (selectedDay != null && selectedTime != null) {
      final entry = "$selectedDay - ${selectedTime!.format(context)}";
      setState(() {
        availabilities.add(entry);
        selectedDay = null;
        selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Hacerme tutor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Foto de perfil ────────────────────────────
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: conectar con image picker
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.secondary,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: theme.colorScheme.onSecondary),
                            Text("Foto", style: TextStyle(color: theme.colorScheme.onSecondary, fontSize: 12)),
                          ],
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Major autocomplete ────────────────────────
            Text("Tu carrera", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            majors.isEmpty
                ? const CircularProgressIndicator()
                : Autocomplete<String>(
                    optionsBuilder: (value) {
                      if (value.text.isEmpty) return majors;
                      return majors.where((m) =>
                          m.toLowerCase().contains(value.text.toLowerCase()));
                    },
                    onSelected: (value) {
                      setState(() {
                        selectedMajor = value;
                        selectedSkill = null;
                        addedSkills.clear();
                      });
                      loadSkillsByMajor(value);
                    },
                    fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: "Busca tu carrera...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 24),

            // ── Skills ────────────────────────────────────
            Text("Skills que puedes tutorear", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSkill,
                    hint: Text(selectedMajor == null ? "Primero selecciona una carrera" : "Selecciona una skill"),
                    items: availableSkills.map((s) =>
                        DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: selectedMajor == null
                        ? null
                        : (val) => setState(() => selectedSkill = val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: selectedSkill == null ? null : addSkill,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (addedSkills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: addedSkills.map((s) => Chip(
                  label: Text(s),
                  onDeleted: () => setState(() => addedSkills.remove(s)),
                )).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // ── Disponibilidades ──────────────────────────
            Text("Disponibilidades", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDay,
                    hint: const Text("Día"),
                    items: days.map((d) =>
                        DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => setState(() => selectedDay = val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: pickTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        selectedTime == null
                            ? "Hora"
                            : selectedTime!.format(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (selectedDay == null || selectedTime == null) ? null : addAvailability,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (availabilities.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...availabilities.map((a) => ListTile(
                dense: true,
                leading: const Icon(Icons.schedule),
                title: Text(a),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => availabilities.remove(a)),
                ),
              )),
            ],

            const SizedBox(height: 32),

            // ── Botón final ───────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: conectar con VM para hacerse tutor
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFFD15C),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Hacerme tutor", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}