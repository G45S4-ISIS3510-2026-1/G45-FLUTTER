import 'package:flutter/material.dart';

import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/widgets/tutor_info_section.dart';
import 'package:g45_flutter/widgets/tutor_review_card.dart';
import 'package:g45_flutter/repositories/review_repository.dart';
import 'package:g45_flutter/models/review.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';

class TutorProfilePage extends StatefulWidget {
  //variable de widget
  final String tutorId;
  const TutorProfilePage({super.key, required this.tutorId});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  User? tutor;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
                      //por si falla imagen no mate toda la pagina
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Icon(Icons.person, size: 50),
                        );
                      },
                    ),
                  ),
                  // 2. overlay (gradiente o sombra)
                  // 3. botones back + like
                  Positioned(
                    //boton back (Derecha)
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Positioned(
                    //Boton like (Izquierda)
                    top: 40,
                    right: 16,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
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
                        buildStat("PUNTAJE", "4.9 ⭐"),
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
                    children: <String>[]
                        .map<Widget>(
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
                  Column(
                    children: reviewsList.take(2).map((review) {
                      // TODO: PARA LIMITAR A 2 RESEÑAS, CAMBIAR DESPUÉS A TODAS
                      return ReviewCard(review: review);
                    }).toList(),
                  ),

                  TextButton(
                    onPressed: () {
                      // navegar a pantalla completa
                    },
                    child: Text("Ver todas las reseñas"),
                  ),

                  SizedBox(height: 20),
                  //-----------------------------------------------------------------------
                  // BOTÓN PRINCIPAL RESERVA (Diego)-> PASAR A RESERVA PUNTUAL DE ESE TUTOR
                  //------------------------------------------------------------------------
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservationGatewayPage(),
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
