import 'package:flutter/material.dart';
import 'package:g45_flutter/widgets/tutor_info_section.dart';
import 'package:g45_flutter/widgets/tutor_review_card.dart';

class TutorProfilePage extends StatefulWidget {
  //variable de widget
  final Map<String, dynamic> tutor;
  

  const TutorProfilePage({super.key, required this.tutor});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  //varianbles
List<Map<String, dynamic>> reviews = [
  {
    "userName": "Juan Pérez",
    "userImage": "https://i.pravatar.cc/150?img=3",
    "rating": 4.9,
    "description": "Explica muy bien cálculo diferencial, súper claro.",
    "date": "12 Feb 2026"
  },
  {
    "userName": "María Gómez",
    "userImage": "https://i.pravatar.cc/150?img=4",
    "rating": 5.0,
    "description": "De los mejores tutores que he tenido, recomendado 100%.",
    "date": "10 Feb 2026"
  },
  {
    "userName": "Carlos Ruiz",
    "userImage": "https://i.pravatar.cc/150?img=5",
    "rating": 4.5,
    "description": "Muy bueno en Python, aunque a veces va un poco rápido.",
    "date": "8 Feb 2026"
  },
  {
    "userName": "Laura Martínez",
    "userImage": "https://i.pravatar.cc/150?img=6",
    "rating": 4.8,
    "description": "Me ayudó a pasar el parcial, explica con paciencia.",
    "date": "5 Feb 2026"
  },
  {
    "userName": "Andrés Torres",
    "userImage": "https://i.pravatar.cc/150?img=7",
    "rating": 3.9,
    "description": "Sabe bastante, pero podría mejorar la organización de la clase.",
    "date": "2 Feb 2026"
  },
  {
    "userName": "Sofía Ramírez",
    "userImage": "https://i.pravatar.cc/150?img=8",
    "rating": 5.0,
    "description": "Excelente tutor, muy claro y amable.",
    "date": "30 Ene 2026"
  },
  {
    "userName": "Diego Fernández",
    "userImage": "https://i.pravatar.cc/150?img=9",
    "rating": 4.2,
    "description": "Buen dominio del tema, pero le falta un poco de ritmo.",
    "date": "28 Ene 2026"
  },
  {
    "userName": "Valentina Castro",
    "userImage": "https://i.pravatar.cc/150?img=10",
    "rating": 4.7,
    "description": "Muy didáctico, hace que los temas difíciles sean fáciles.",
    "date": "25 Ene 2026"
  },
  {
    "userName": "Sebastián López",
    "userImage": "https://i.pravatar.cc/150?img=11",
    "rating": 3.5,
    "description": "Regular, esperaba más profundidad en los temas.",
    "date": "20 Ene 2026"
  },
  {
    "userName": "Camila Herrera",
    "userImage": "https://i.pravatar.cc/150?img=12",
    "rating": 4.9,
    "description": "Explicaciones muy claras, repetiría sin duda.",
    "date": "18 Ene 2026"
  },
];

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
    final tutor = widget.tutor;
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
                      tutor['image'],
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
                                    image: NetworkImage(tutor['image']),
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
                                  tutor["name"],
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
                              tutor["major"],
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
                    children: (tutor["tutoring_skills"] as List<String>)
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
                  SizedBox(height: 140, child: TutorInfoSection(tutor: tutor)),
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
                    children: reviews.take(2).map((review) {
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

                  // BOTÓN PRINCIPAL
                  ElevatedButton(
                    onPressed: () {},
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
