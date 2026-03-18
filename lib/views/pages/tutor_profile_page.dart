import 'package:flutter/material.dart';

class TutorProfilePage extends StatefulWidget {
  //variable de widget
  final Map<String, dynamic> tutor;
  
  
  const TutorProfilePage({super.key, required this.tutor});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  //varianbles


  @override
  Widget build(BuildContext context) {
    final tutor = widget.tutor;
    return Scaffold(
      body: SingleChildScrollView(
        //Columna principal
        child: Column(
          children: [
            //header
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
                  )
                ),
                // 2. overlay (gradiente o sombra)
                // 3. botones back + like
                //boton back (Derecha)
                Positioned(
                  top: 40,
                  left: 16,
                  child: Icon(Icons.arrow_back)
                ),
                //Boton like (Izquierda)
                Positioned(
                  top: 40,
                  right: 16,
                  child: Icon(Icons.favorite_border)
                )

                //// 4. info (nombre, carrera)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
