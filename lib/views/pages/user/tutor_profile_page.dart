import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/models/review.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/review_repository.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/services/analytics_service.dart';
import 'package:g45_flutter/viewmodels/review_viewmodel.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';
import 'package:g45_flutter/widgets/tutor/tutor_info_section.dart';
import 'package:g45_flutter/widgets/tutor/tutor_review_card.dart';
import 'package:g45_flutter/widgets/tutor/tutor_reviews_section.dart';
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
  bool isFavorite = false;
  List<String> favorites = [];

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    loadFavorites();
    AnalyticsService.instance.setCurrentService('TutorProfile');
    AnalyticsService.instance.logEvent('view_review', {
      'tutor_id': widget.tutorId,
    });
    loadTutor();
  }

  Future<void> loadTutor() async {
    try {
      final repo = UserRepository();

      final result = await repo.getUserById(widget.tutorId);

      if (result == null) {
        //----------------------------------
        // SIN DATA (ni backend ni cache)
        //----------------------------------
        setState(() {
          isLoading = false;
          tutor = null;
        });
        return;
      }

      //----------------------------------
      // DATA OK (backend o cache)
      //----------------------------------
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

  Future<void> loadFavorites() async {
    final repo = UserRepository();

    favorites = await repo.getFavorites();

    setState(() {
      isFavorite = favorites.contains(widget.tutorId);
    });

    print("FAVORITOS CARGADOS: $favorites");
  }

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
    print("TUTOR ID: ${widget.tutorId}");
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tutor == null) {
      return const Center(
        child: Text(
          "No se pudo cargar el tutor, Verifique su conexión a internet",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    //
    final skillsVM = Provider.of<SkillsViewModel>(context);
    final tutorSkills = tutor?.tutoringSkills ?? [];
    final skillNames = skillsVM.skills
        .where((skill) => tutorSkills.contains(skill.id))
        .map((skill) => skill.label ?? "")
        .toList();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        filterQuality: FilterQuality.high,
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

                            print("FAVORITOS GUARDADOS: $favorites");
                          },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                    SizedBox(
                      height: 140,
                      child: TutorInfoSection(tutor: tutor!),
                    ),

                    // REVIEWS
                    SizedBox(height: 10),

                    // Review cards)
                    SizedBox(height: 20),

                    ChangeNotifierProvider(
                      create: (_) =>
                          ReviewViewModel()..loadReviewsByTutor(widget.tutorId),
                      child: TutorReviewsSection(tutorId: widget.tutorId),
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
      ),
    );
  }
}
