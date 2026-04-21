import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/models/review.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/review_repository.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';
import 'package:g45_flutter/widgets/tutor_info_section.dart';
import 'package:g45_flutter/widgets/tutor_review_card.dart';
import 'package:provider/provider.dart';

class TutorProfilePage extends StatefulWidget {
  //variable de widget
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
  bool showAllReviews = false;

  //ANALYTICS ENGINE
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: 'test_event');
    _startTime = DateTime.now();

    analytics.logEvent(
      name: 'view_tutor_profile',
      parameters: {'tutor_id': widget.tutorId},
    );

    loadTutor();
  }

  Future<void> loadTutor() async {
    final repo = UserRepository();
    final reviewRepo = ReviewRepository();

    tutor = await repo.getUserById(widget.tutorId);
    reviewsList = await reviewRepo.getReviewsByTutor(widget.tutorId);

    setState(() {
      isLoading = false;
    });
  }

  List<Review> reviewsList = [];

  //-------------------------------
  // Funciones Auxiliares
  //-------------------------------

  //Analytics engine
  @override
  void dispose() {
    if (_startTime != null) {
      final seconds = DateTime.now().difference(_startTime!).inSeconds;

      analytics.logEvent(
        name: 'time_spent_on_reviews',
        parameters: {'tutor_id': widget.tutorId, 'seconds': seconds},
      );
    }

    super.dispose();
  }

  //Fonts para Barra de stats
  Widget buildStat(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Linea de separador
  Widget buildDivider() {
    return Container(height: 30, width: 1, color: Colors.white24);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || tutor == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final reviewsToShow = showAllReviews
        ? reviewsList
        : reviewsList.take(2).toList();
    final skillsVM = Provider.of<SkillsViewModel>(context);
    final tutorSkills = tutor?.tutoringSkills ?? [];
    final skillNames = skillsVM.skills
        .where((skill) => tutorSkills.contains(skill.id))
        .map((skill) => skill.label ?? "")
        .toList();
    return Scaffold(
      body: SingleChildScrollView(
        //--------------------------------------------------
        //Columna principal
        //--------------------------------------------------
        child: Column(
          children: [
            //--------------------------------------------------
            //Bloque Superior Botones, imagen, informacion Tutor
            //--------------------------------------------------
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  // 1. imagen fondo
                  Positioned.fill(
                    child: Image.network(
                      tutor!.profileImageUrl ?? "",
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high, // 🔥 mejora render
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.black);
                      },
                    ),
                  ),
                  // 2. overlay (gradiente o sombra)
                  // 3. botones back + like
                  Positioned(
                    // Botón de regreso (Derecha)
                    top: 40,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  Positioned(
                    // Botón de favorito (Izquierda)
                    top: 40,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  //4. info (nombre, carrera)
                  Positioned(
                    bottom: 20,
                    left: 16, //centrado
                    right: 16, //centrado
                    child: Row(
                      children: [
                        //Foto de perfil del tutor
                        Stack(
                          children: [
                            // Marco de la Imagen
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),

                            // Imagen encima
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      tutor!.profileImageUrl ?? "",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        //Información del tutor
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //renglon Superior
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Nombre del tutor
                                Text(
                                  tutor!.name ?? "Sin nombre",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            //major del tutor
                            Text(
                              tutor!.major ?? "Sin carrera",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //--------------------------------------------------
            //Container Regular debajo de imagen(Sigue colores de la APP)
            //--------------------------------------------------
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A1A2F), Color(0xFF0D2A52)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  //--------------------------------------------------
                  //Puntaje, Tutorias, Nivel
                  //--------------------------------------------------
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildStat(
                          "PUNTAJE",
                          "${tutor!.tutorRating != null ? tutor!.tutorRating!.toStringAsFixed(1) : 'Nuevo'} ⭐",
                        ),
                        buildDivider(),
                        buildStat("TUTORÍAS", "+120"),
                        buildDivider(),
                        buildStat("NIVEL", "Senior"),
                      ],
                    ),
                  ),
                  //--------------------------------------------------
                  //Especialidades
                  //--------------------------------------------------
                  //Label de especialidades
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Especialidades',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Chips de tutoring skilss
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: skillNames
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            backgroundColor: Color(0xFF1A2A40),
                            labelStyle: TextStyle(color: Colors.blueAccent),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------
                  //Info Personal
                  SizedBox(height: 140, child: TutorInfoSection(tutor: tutor!)),
                  // REVIEWS
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reseñas",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // top 2 reviews
                  reviewsList.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Este tutor aún no tiene reseñas",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : Column(
                          children: reviewsToShow.map((review) {
                            return ReviewCard(review: review);
                          }).toList(),
                        ),

                  if (reviewsList.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllReviews = !showAllReviews;
                        });
                      },
                      child: Text(
                        showAllReviews
                            ? "Ver menos"
                            : "Ver todas las reseñas (${reviewsList.length})",
                      ),
                    ),

                  SizedBox(height: 20),
                  //-----------------------------------------------------------------------
                  // BOTÓN PRINCIPAL RESERVA
                  ElevatedButton(
                    onPressed: () {
                      analytics.logEvent(
                        name: 'schedule_session',
                        parameters: {'tutor_id': tutor!.id ?? ""},
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationGatewayPage(
                            tutor: TutorSummary.fromUser(tutor!),
                          ),
                        ),
                      );
                    },
                    child: Text("Reservar sesión"),
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
