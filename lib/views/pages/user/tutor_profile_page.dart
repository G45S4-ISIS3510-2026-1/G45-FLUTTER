import 'package:flutter/material.dart';
import 'package:g45_flutter/data/mock/facultades_mock.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/models/user.dart' as u;
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/widgets/tutor_card.dart';
import 'package:g45_flutter/widgets/tutor_card_small.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth.dart';

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
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await cargarDatos();
    });

    Future.microtask(() {
      final tutorVM = Provider.of<TutorViewModel>(context, listen: false);
      tutorVM.loadTutors();
      tutorVM.loadRecommendations();

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          tutorVM.loadMoreTutors();
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    u.User? user = await authVM.getUserCache();
    if (user != null) {
      nombre = user.name;
      try {
        final listaSesiones = await sessionVM.getSessionsByStudent(user.id);
        setState(() {
          sesiones = listaSesiones;
        });
      } catch (e) {
        setState(() {
          nombre = user.name;
          sesiones = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<TutorViewModel>(context);
    viewmodel.loadRecommendations();

    return CustomScrollView(
      controller: scrollController,
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
        if (viewmodel.recommendedTutors.isNotEmpty) ...[
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
                itemCount: viewmodel.recommendedTutors.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: TutorCardSmall(tutor: viewmodel.recommendedTutors[index]),
                ),
              ),
            ),
          ),
        ],
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
                  childCount: viewmodel.tutors.length + (viewmodel.isFetchingMore ? 1 : 0),
                ),
              ),
        const SliverToBoxAdapter(child: SizedBox(height: 5)),
      ],
    );
  }
}