import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/become_tutor_viewmodel.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:provider/provider.dart';
import '../../../models/skills.dart';
import 'package:g45_flutter/services/conection_service.dart';

class BecomeTutor extends StatefulWidget {
  const BecomeTutor({super.key});

  @override
  State<BecomeTutor> createState() => BecomeTutorState();
}

class BecomeTutorState extends State<BecomeTutor> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<BecomeTutorViewModel>(context, listen: false).loadMajors()
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BecomeTutorViewModel>(context);
    final connectionService = ConnectionService();
    final authVM = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    if(vm.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hacerme tutor")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.becomedTutor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Hacerme tutor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            // ------------------------------------- //
            // FOTO DE PERFIL
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: conectar con image picker
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.secondary,
                  backgroundImage: vm.profileImageUrl != null
                      ? NetworkImage(vm.profileImageUrl!)
                      : null,
                  child: vm.profileImageUrl == null
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
            // ------------------------------------- //
            // CARRERA
            const SizedBox(height: 24),
            Text("Tu carrera", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            vm.isLoading
                ? const CircularProgressIndicator()
                : Autocomplete<String>(
                    optionsBuilder: (value) {
                      if (value.text.isEmpty) return vm.majors;
                      return vm.majors.where((m) =>
                          m.toLowerCase().contains(value.text.toLowerCase()));
                    },
                    onSelected: (value) => vm.selectMajor(value),
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

            // ------------------------------------- //
            // SKILLS
            const SizedBox(height: 24),

            Text("Skills que puedes tutorear", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Skill>(
                    value: vm.selectedSkill,
                    hint: Text(vm.selectedMajor == null? "Primero selecciona una carrera" : "Selecciona una skill"),
                    items: vm.availableSkills.map((s) =>
                        DropdownMenuItem<Skill>(value: s, child: Text(s.label))).toList(),
                    onChanged: vm.selectedMajor == null
                        ? null
                        : (val) => vm.selectSkill(val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: vm.selectedSkill == null ? null : vm.addSkill,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            // ------------------------------------- //
            // LISTA SKILLS
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vm.addedSkills.map((s) => Chip(
                label: Text(s),
                onDeleted: () => vm.removeSkill(s),
              )).toList(),
            ),

            // ------------------------------------- //
            // DISPONIBILIDADES
            const SizedBox(height: 24),

            Text("Disponibilidades", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: vm.selectedDay,
                    hint: const Text("Día"),
                    items: vm.days.map((d) =>
                        DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => vm.selectDay(val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) vm.selectTime(picked);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        vm.selectedTime == null
                            ? "Hora"
                            : vm.selectedTime!.format(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (vm.selectedDay == null || vm.selectedTime == null) ? null : () => vm.addAvailability(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            // ------------------------------------- //
            // LISTA DISPONIBILIDADES
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vm.availabilityDisplay.map((entry) => Chip(
                label: Text(vm.formatSlot(entry["key"]!, entry["iso"]!)),
                onDeleted: () => vm.removeAvailability(entry["key"]!, entry["iso"]!),
              )).toList(),
            ),

            const SizedBox(height: 32),
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  vm.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            SizedBox(
              width: double.infinity,
              child:ElevatedButton(
                onPressed: () {
                  if (connectionService.hasConnection) {
                    vm.becomeTutor(authVM.userCache!.id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sin conexión a internet")),
                    );
                  }
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