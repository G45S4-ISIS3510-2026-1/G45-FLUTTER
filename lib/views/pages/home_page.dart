import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/models/user.dart' as u;
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/widgets/tutor_card_small.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import '../../viewmodels/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authVM = AuthViewModel();
  final sessionVM = SessionViewModel();
  String nombre = "Usuario";
  List<Session> sesiones = [];

  List<TutorSummary> tutoresDestacados = tutores
      .map((t) => TutorSummary(
            id: t["uniandesId"],
            name: t["name"],
            major: t["major"],
            sessionPrice: 30,
            tutoringSkills: List<String>.from(t["tutoring_skills"]),
            profileImageUrl: t["image"],
          ))
      .toList();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    u.User? user = await authVM.getUsuarioCache();
    if (user != null) {
      final listaSesiones = await sessionVM.getSessionsByStudent(user.id);
      setState(() {
        nombre = user.name;
        sesiones = listaSesiones;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Hola $nombre!',
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Proximas sesiones',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sesiones.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SessionCardWidget(session: sesiones[index]),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Tutores destacados',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 210,
              ),
              itemCount: tutoresDestacados.length,
              itemBuilder: (context, index) {
                return TutorCardSmall(tutor: tutoresDestacados[index]);
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}