import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';
import 'package:g45_flutter/services/conection_service.dart';
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/widgets/tutor/tutor_card_small.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authVM = AuthViewModel();
  String nombre = "Usuario";
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedPageNotifier.addListener(onTabChanged);

    Future.microtask(() async {
      final user = await authVM.getUserCache();
      if (user != null) {
        setState(() => nombre = user.name);

        if (mounted) {
          Provider.of<SessionViewModel>(
            context,
            listen: false,
          ).loadSessionsByStudent(user.id);
        }
      }
    });

    Future.microtask(() {
      final tutorVM = Provider.of<TutorViewModel>(context, listen: false);
      tutorVM.loadRecommendations();

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          tutorVM.loadMoreTutors();
        }
      });
    });
  }

  void onTabChanged() {
    if (selectedPageNotifier.value == 0 && mounted) {
      Future.microtask(() async {
        final user = await authVM.getUserCache();
        if (user != null && mounted) {
          Provider.of<SessionViewModel>(
            context,
            listen: false,
          ).loadSessionsByStudent(user.id);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TutorViewModel>(context, listen: false)
        .loadRecommendations();
  }

  @override
  void dispose() {
    selectedPageNotifier.removeListener(onTabChanged);
    scrollController.dispose();
    super.dispose();
  }

  void showNoConnectionSnackbar() {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Sin conexión a internet, no puedes ver los detalles ahora",
        ),
        backgroundColor: colors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tutorVM = Provider.of<TutorViewModel>(context);
    final sessionVM = Provider.of<SessionViewModel>(context);
    final connection = ConnectionService();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // 🔹 SALUDO
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Hola $nombre!',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ),
        ),

        // 🔹 TÍTULO SESIONES
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Próximas sesiones',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ),
        ),

        // 🔹 LISTA SESIONES
        (sessionVM.isLoading || tutorVM.isLoading)
            ? const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            : sessionVM.studentSessions.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        "No tienes sesiones próximas",
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => GestureDetector(
                        onTap: () {
                          if (!connection.hasConnection) {
                            showNoConnectionSnackbar();
                            return;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SessionCardWidget(
                            session: sessionVM.studentSessions[index],
                          ),
                        ),
                      ),
                      childCount: sessionVM.studentSessions.length,
                    ),
                  ),

        // 🔹 TUTORES DESTACADOS
        if (tutorVM.recommendedTutors.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Tutores destacados',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ),
          ),

        // 🔹 LISTA HORIZONTAL TUTORES
        if (tutorVM.recommendedTutors.isNotEmpty)
          SliverToBoxAdapter(
            child: tutorVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: tutorVM.recommendedTutors.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          if (!connection.hasConnection) {
                            showNoConnectionSnackbar();
                            return;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: TutorCardSmall(
                            tutor: tutorVM.recommendedTutors[index],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),
      ],
    );
  }
}