import 'package:flutter/material.dart';
import 'package:g45_flutter/services/conection_service.dart';
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
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
  String nombre = "Usuario";
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = await authVM.getUserCache();
      if (user != null) {
        setState(() => nombre = user.name);
        if (mounted) {
          Provider.of<SessionViewModel>(context, listen: false)
              .loadSessionsByStudent(user.id);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TutorViewModel>(context, listen: false).loadRecommendations();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void showNoConnectionSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sin conexión a internet, no puedes ver los detalles ahora"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutorVM = Provider.of<TutorViewModel>(context);
    final sessionVM = Provider.of<SessionViewModel>(context);
    final connection = ConnectionService();

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

        sessionVM.isLoading || tutorVM.isLoading
            ? const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            : sessionVM.studentSessions.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("No tienes sesiones próximas"),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: SessionCardWidget(session: sessionVM.studentSessions[index]),
                        ),
                      ),
                      childCount: sessionVM.studentSessions.length,
                    ),
                  ),

        if (tutorVM.recommendedTutors.isNotEmpty) ...[
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
                          child: TutorCardSmall(tutor: tutorVM.recommendedTutors[index]),
                        ),
                      ),
                    ),
                  ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 5)),
      ],
    );
  }
}