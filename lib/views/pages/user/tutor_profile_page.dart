import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/services/analytics_service.dart';
import 'package:g45_flutter/services/recent_viewed.dart';
import 'package:g45_flutter/viewmodels/review_viewmodel.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';
import 'package:g45_flutter/widgets/tutor/tutor_info_section.dart';
import 'package:g45_flutter/widgets/tutor/tutor_reviews_section.dart';
import 'package:provider/provider.dart';

class TutorProfilePage extends StatefulWidget {
  final String tutorId;
  final dynamic tutor;

  const TutorProfilePage({
    super.key,
    required this.tutorId,
    required this.tutor,
  });

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  User? tutor;
  bool isLoading = true;
  bool isFavorite = false;
  bool _timeSent = false;
  bool _viewSent = false;
  List<String> favorites = [];

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();

    _startTime = DateTime.now();
    print("⏱️ START TIME: $_startTime");

    AnalyticsService.instance.setCurrentService('TutorProfile');

    print("📤 Sending view_review for tutor: ${widget.tutorId}");

    if (!_viewSent) {
      _viewSent = true;

      AnalyticsService.instance.logEvent('view_review', {
        'tutor_id': widget.tutorId,
      });

      print(" ✅ view_review enviado una sola vez");
    }

    loadFavorites();
    loadTutor();
  }

  //----------------------------------
  // LOAD TUTOR
  //----------------------------------
  Future<void> loadTutor() async {
    try {
      final repo = UserRepository();
      final result = await repo.getUserById(widget.tutorId);

      setState(() {
        tutor = result;
        isLoading = false;
      });
    } catch (e, stack) {
      await AnalyticsService.instance.reportError(
        'TutorProfile',
        'Error loading tutor',
        e,
        stack,
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  //----------------------------------
  // FAVORITES
  //----------------------------------
  Future<void> loadFavorites() async {
    final repo = UserRepository();
    favorites = await repo.getFavorites();

    setState(() {
      isFavorite = favorites.contains(widget.tutorId);
    });
  }

  //----------------------------------
  // DISPOSE (TIME ANALYTICS)
  //----------------------------------

  //----------------------------------
  // UI HELPERS
  //----------------------------------
  Widget buildStat(String title, String value, ColorScheme colors) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: colors.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget buildDivider(ColorScheme colors) {
    return Container(height: 30, width: 1, color: colors.outlineVariant);
  }

  //----------------------------------
  // BUILD
  //----------------------------------
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (tutor == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No se pudo cargar el tutor",
            style: TextStyle(color: colors.onSurface),
          ),
        ),
      );
    }

    final skillsVM = Provider.of<SkillsViewModel>(context);
    final tutorSkills = tutor?.tutoringSkills ?? [];

    final skillNames = skillsVM.skills
        .where((skill) => tutorSkills.contains(skill.id))
        .map((skill) => skill.label ?? "")
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //----------------------------------
            // HEADER
            //----------------------------------
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      tutor!.profileImageUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.black),
                    ),
                  ),

                  // BACK
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // FAVORITE
                  Positioned(
                    top: 40,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: () async {
                          final repo = UserRepository();

                          setState(() {
                            if (isFavorite) {
                              favorites.remove(widget.tutorId);
                            } else {
                              favorites.add(widget.tutorId);
                            }
                            isFavorite = !isFavorite;
                          });

                          await repo.saveFavorites(favorites);
                        },
                      ),
                    ),
                  ),

                  // INFO
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            tutor!.profileImageUrl ?? "",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tutor!.name ?? "",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                            Text(
                              tutor!.major ?? "",
                              style: TextStyle(color: colors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //----------------------------------
            // BODY
            //----------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // STATS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildStat(
                        "PUNTAJE",
                        tutor!.tutorRating != null
                            ? "${tutor!.tutorRating!.toStringAsFixed(1)} ⭐"
                            : "Nuevo",
                        colors,
                      ),
                      buildDivider(colors),
                      buildStat("TUTORÍAS", "+120", colors),
                      buildDivider(colors),
                      buildStat("NIVEL", "Senior", colors),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // SKILLS
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Especialidades",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  Wrap(
                    spacing: 10,
                    children: skillNames
                        .map(
                          (e) => Chip(
                            label: Text(e),
                            backgroundColor: colors.surfaceContainerHigh,
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // INFO
                  SizedBox(height: 140, child: TutorInfoSection(tutor: tutor!)),

                  const SizedBox(height: 20),

                  // REVIEWS
                  ChangeNotifierProvider(
                    create: (_) =>
                        ReviewViewModel()..loadReviewsByTutor(widget.tutorId),
                    child: TutorReviewsSection(tutorId: widget.tutorId),
                  ),

                  const SizedBox(height: 20),

                  // BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.tertiary,
                      foregroundColor: colors.onTertiary,
                    ),
                    onPressed: () async {
                      print("🟡 CLICK EN RESERVAR");

                      if (_startTime != null && !_timeSent) {
                        final seconds = DateTime.now()
                            .difference(_startTime!)
                            .inSeconds;
                        final safeSeconds = seconds < 1 ? 1 : seconds;

                        print("⏱️ TIME CALCULATED: $safeSeconds segundos");

                        await AnalyticsService.instance.logEvent(
                          'time_spent_on_reviews',
                          {'tutor_id': widget.tutorId, 'seconds': safeSeconds},
                        );

                        print("✅ time_spent_on_reviews enviado");

                        _timeSent = true;
                      }
                      await Future.delayed(const Duration(milliseconds: 300));
                      print("📤 Sending session_scheduled...");

                      await AnalyticsService.instance.logEvent(
                        'session_scheduled',
                        {'tutor_id': tutor!.id ?? ""},
                      );

                      print("✅ session_scheduled enviado");

                      await Future.delayed(
                        const Duration(milliseconds: 300),
                      ); // 🔥 clave

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReservationGatewayPage(
                            tutor: TutorSummary.fromUser(tutor!),
                          ),
                        ),
                      );
                    },
                    child: const Text("Reservar sesión"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
