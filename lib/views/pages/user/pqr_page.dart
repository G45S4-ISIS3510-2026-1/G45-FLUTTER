import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/repositories/pqr_repository.dart';
import 'package:g45_flutter/services/analytics_service.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/viewmodels/pqr_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PqrPage extends StatefulWidget {
  const PqrPage({super.key});

  @override
  State<PqrPage> createState() => _PqrPageState();
}

class _PqrPageState extends State<PqrPage> {
  //----------------------------------
  // INIT
  //----------------------------------

  @override
  void initState() {
    super.initState();

    //----------------------------------
    // TAG DE SERVICIO (Crashlytics)
    //----------------------------------
    AnalyticsService.instance.setCurrentService("pqr");
    //----------------------------------
    // CARGAR DRAFT
    //----------------------------------
    _loadDraft();
  }

  //-------------------------------------
  // STATE
  //-------------------------------------
  String? selectedType;
  final TextEditingController descriptionController = TextEditingController();

  int? selectedSessionIndex;

  //-------------------------------------
  // MOCK SESIONES
  //-------------------------------------
  final List<Map<String, String>> sessions = [
    {"date": "20", "title": "Cálculo Diferencial", "tutor": "Camilo Rivas"},
    {"date": "18", "title": "Física Mecánica", "tutor": "Sofía Méndez"},
  ];

  //-------------------------------------
  // DRAFT STORAGE
  //-------------------------------------
  void _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("pqr_draft", descriptionController.text);
  }

  void _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    descriptionController.text = prefs.getString("pqr_draft") ?? "";
  }

  //-------------------------------------
  // BUILD
  //-------------------------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PqrViewModel(),
      child: Builder(
        builder: (context) {
          final vm = context.watch<PqrViewModel>();

          return Scaffold(
            backgroundColor: const Color(0xFF0D1B2A),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //-------------------------------------
                    // HEADER
                    //-------------------------------------
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Novedades y\nQuejas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    //-------------------------------------
                    // DROPDOWN
                    //-------------------------------------
                    const Text(
                      "Motivo del reporte",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1B263B),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text(
                        "Selecciona un motivo",
                        style: TextStyle(color: Colors.white54),
                      ),
                      items: const [
                        DropdownMenuItem(value: "queja", child: Text("Queja")),
                        DropdownMenuItem(
                          value: "reclamo",
                          child: Text("Reclamo"),
                        ),
                        DropdownMenuItem(
                          value: "peticion",
                          child: Text("Petición"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    //-------------------------------------
                    // DESCRIPCIÓN
                    //-------------------------------------
                    const Text(
                      "Descripción detallada",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: descriptionController,
                      onChanged: (value) => _saveDraft(),
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Cuéntanos más sobre lo sucedido...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //-------------------------------------
                    // SESIONES (OPCIONAL)
                    //-------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Vincular tutoría previa",
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "OPCIONAL",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Column(
                      children: List.generate(sessions.length, (index) {
                        final session = sessions[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSessionIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    session["date"]!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session["title"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Tutor: ${session["tutor"]}",
                                      style: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(
                                  selectedSessionIndex == index
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),

                    //-------------------------------------
                    // LISTA DE PQRS
                    //-------------------------------------
                    Builder(
                      builder: (context) {
                        final user = AuthViewModel().userCache;

                        if (user == null) {
                          return const SizedBox();
                        }

                        return FutureBuilder(
                          future: PqrRepository().getPqrsByAuthor(user.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final pqrs = snapshot.data as List;

                            if (pqrs.isEmpty) {
                              return const Text(
                                "No tienes PQRS aún",
                                style: TextStyle(color: Colors.white54),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pqrs.length,
                              itemBuilder: (context, index) {
                                final pqr = pqrs[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      pqr["type"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      pqr["description"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    trailing: Text(
                                      pqr["status"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Spacer(),

                    //-------------------------------------
                    // BOTÓN ENVIAR
                    //-------------------------------------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                final connectivity = await Connectivity()
                                    .checkConnectivity();
                                //eventual conncetivity check before sending pqr d
                                if (connectivity == ConnectivityResult.none) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Sin conexión a internet"),
                                    ),
                                  );
                                  return;
                                }
                                final success = await vm.sendPqr(
                                  type: selectedType,
                                  description: descriptionController.text,
                                  sessionId: selectedSessionIndex?.toString(),
                                );

                                if (success) {
                                  await AnalyticsService.instance.logEvent(
                                    'pqr_submit',
                                    {
                                      'type': selectedType,
                                      'has_description':
                                          descriptionController.text.isNotEmpty,
                                      'has_session':
                                          selectedSessionIndex != null,
                                    },
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "PQR enviada correctamente",
                                      ),
                                    ),
                                  );
                                  // Clear form after successful submission
                                  //----------------------------------
                                  // LIMPIAR DRAFT
                                  //----------------------------------
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove("pqr_draft");

                                  //----------------------------------
                                  // UI UPDATE
                                  //----------------------------------
                                  setState(() {
                                    selectedType = null;
                                    descriptionController.clear();
                                    selectedSessionIndex = null;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.errorMessage ?? "Error"),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: vm.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
                                "Enviar Reporte >",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    //-------------------------------------
                    // TEXTO FINAL
                    //-------------------------------------
                    const Text(
                      "Tu reporte será revisado por el equipo administrativo en un plazo de 24 a 48 horas hábiles.",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
