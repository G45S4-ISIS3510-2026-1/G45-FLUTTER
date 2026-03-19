import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import '../../repositories/skills_repository.dart';
import '../../models/user.dart' as u;

class SelectSkills extends StatefulWidget {
  const SelectSkills({super.key});

  @override
  State<SelectSkills> createState() => _SelectSkillsState();
}

class _SelectSkillsState extends State<SelectSkills> {
  final repo = SkillRepository();
  final AuthViewModel authVM = AuthViewModel();

  List<String> majors = [];
  String? selectedMajor;

  @override
  void initState() {
    super.initState();
    loadMajors();
  }

  Future<void> loadMajors() async {
    final data = await repo.getMajors();
    setState(() => majors = data);
  }

  Future<void> saveSelectedMajor(String selectedMajor) async {
    u.User? miUsuario = await authVM.getUsuarioCache();
    final theme = Theme.of(context);

    if(miUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Usuario no encontrado en cache"),
          backgroundColor: theme.colorScheme.onSurface,
        ),
      );
      return ;
    }

    await authVM.updateUsuarioInterestedSkills(miUsuario, selectedMajor);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.school, size: 80, color: theme.colorScheme.onSurface),
              const SizedBox(height: 24),
              Text(
                "Selecciona tu carrera",
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),

              if (majors.isEmpty)
                const CircularProgressIndicator()
              else
                Column(
                  children: majors.map((m) {
                    final isSelected = selectedMajor == m;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => selectedMajor = m);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.inversePrimary,
                          foregroundColor: theme.colorScheme.onSurface ,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(m),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedMajor == null ? null : () async {
                    await saveSelectedMajor(selectedMajor!);
                    // authVM.setAuthState(AuthState.home);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.onSurface,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Continuar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}