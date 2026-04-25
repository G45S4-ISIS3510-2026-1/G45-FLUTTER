import 'package:flutter/material.dart';
import 'package:g45_flutter/data/mock/facultades_mock.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/models/user.dart' as u;
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/widgets/tutor/tutor_card.dart';
import 'package:g45_flutter/widgets/tutor/tutor_card_small.dart';
import 'package:provider/provider.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// Ejecuta esto para limpiar la instancia actua
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
      .map(
        (t) => TutorSummary(
          id: t["uniandesId"],
          name: t["name"],
          major: t["major"],
          sessionPrice: 30,
          tutoringSkills: List<String>.from(t["tutoring_skills"]),
          profileImageUrl: t["image"],
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    cargarDatos(); // Cargamos el usuario apenas entre a la página
    Future.microtask(() {
      Provider.of<TutorViewModel>(context, listen: false).loadTutors();
    });
  }

  Future<void> cargarDatos() async {
    u.User? user = await authVM.getUserCache();
    if (user != null) {
      final listaSesiones = await sessionVM.getSessionsByStudent(user.id);
      setState(() {
        nombre = user.name;
        sesiones = listaSesiones;
      });
    }
    // await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<TutorViewModel>(context);

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
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tutoresDestacados.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: TutorCardSmall(tutor: tutoresDestacados[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ordenar por'),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Mejor Ratings"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Precio"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Proximidad"),
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Facultades'),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: facultades.map((facultad) {
                    return ElevatedButton(
                      onPressed: () {},
                      child: Text(facultad),
                    );
                  }).toList(),
                ),
                viewmodel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewmodel.tutors.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TutorCard(tutor: viewmodel.tutors[index]),
                          );
                        },
                      ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
