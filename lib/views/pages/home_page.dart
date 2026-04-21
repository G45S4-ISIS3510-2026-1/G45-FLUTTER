import 'package:flutter/material.dart';
import 'package:g45_flutter/data/mock/facultades_mock.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/models/user.dart' as u;
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/widgets/tutor_card.dart';
import 'package:g45_flutter/widgets/tutor_card_small.dart';
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
  final ScrollController _scrollController = ScrollController(); // Define the ScrollController

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
    Future.microtask(() async {
      await cargarDatos();
    });
    Future.microtask(() {
      Provider.of<TutorViewModel>(context, listen: false).loadTutors();
    });
  }

  Future<void> cargarDatos() async {
    u.User? user = await authVM.getUserCache();
    print(user);
    if (user != null) {
      nombre = user.name;
      final listaSesiones = await sessionVM.getSessionsByStudent(user.id);
      setState(() {
        sesiones = listaSesiones;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  final viewmodel = Provider.of<TutorViewModel>(context);

  return CustomScrollView(
    controller: _scrollController,
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Hola $nombre!',
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Proximas sesiones',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SessionCardWidget(session: sesiones[index]),
          ),
          childCount: sesiones.length,
        ),
      ),
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Tutores destacados',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tutoresDestacados.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TutorCardSmall(tutor: tutoresDestacados[index]),
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ordenar por'),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text("Mejor Ratings")),
                  ElevatedButton(onPressed: () {}, child: const Text("Precio")),
                  ElevatedButton(onPressed: () {}, child: const Text("Proximidad")),
                ],
              ),
              const Text('Facultades'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: facultades.map((facultad) =>
                  ElevatedButton(onPressed: () {}, child: Text(facultad)),
                ).toList(),
              ),
            ],
          ),
        ),
      ),
      viewmodel.isLoading
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == viewmodel.tutors.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TutorCard(tutor: viewmodel.tutors[index]),
                  );
                },
                childCount: viewmodel.tutors.length,
              ),
            ),
      const SliverToBoxAdapter(child: SizedBox(height: 5)),
    ],
  );
}
}
