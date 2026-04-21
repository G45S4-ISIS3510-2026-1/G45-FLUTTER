import 'package:flutter/material.dart';

class PqrPage extends StatefulWidget {
  const PqrPage({super.key});

  @override
  State<PqrPage> createState() => _PqrPageState();
}

class _PqrPageState extends State<PqrPage> {
  //-------------------------------------
  // STATE
  //-------------------------------------
  String? selectedType;
  final TextEditingController descriptionController =
      TextEditingController();

  int? selectedSessionIndex;

  //-------------------------------------
  // MOCK SESIONES (Todo: conectar backend)
  //-------------------------------------
  final List<Map<String, String>> sessions = [
    {"date": "20", "title": "Cálculo Diferencial", "tutor": "Camilo Rivas"},
    {"date": "18", "title": "Física Mecánica", "tutor": "Sofía Méndez"},
  ];

  //-------------------------------------
  // BUILD
  //-------------------------------------
  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  DropdownMenuItem(value: "reclamo", child: Text("Reclamo")),
                  DropdownMenuItem(value: "peticion", child: Text("Petición")),
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
                    style: TextStyle(color: Colors.blueAccent, fontSize: 12),
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
                          //-------------------------------------
                          // FECHA
                          //-------------------------------------
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              session["date"]!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 12),

                          //-------------------------------------
                          // INFO
                          //-------------------------------------
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session["title"]!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Tutor: ${session["tutor"]}",
                                style:
                                    const TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),

                          const Spacer(),

                          //-------------------------------------
                          // SELECTOR
                          //-------------------------------------
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

              const Spacer(),

              //-------------------------------------
              // BOTÓN ENVIAR
              //-------------------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: conectar backend
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
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
  }
}