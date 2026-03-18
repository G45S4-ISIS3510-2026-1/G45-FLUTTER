import 'package:flutter/material.dart';
import 'package:g45_flutter/views/pages/tutor_profile_page.dart';

class TutorCard extends StatelessWidget {
  final Map<String, dynamic> tutor;

  const TutorCard({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    //detectar press de tutor y routing a detail de tutor
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => TutorProfilePage(tutor: tutor)));
      },
      //-----------------------------------------------------------------
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            //Fila superior con foto, nombre, carrera y habilidades
            Row(
              children: [
                //Foto de perfil del tutor
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(tutor["image"]),
                ),
                SizedBox(width: 12),
                //Información del tutor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //renglon Superior
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Nombre del tutor
                          Text(
                            tutor["name"],
                            style: TextStyle(color: Colors.white),
                          ),
                          //Precio por hora del tutor
                          Text(
                            "\$${tutor["price"]}",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      //major del tutor
                      Text(
                        tutor["major"],
                        style: TextStyle(color: Colors.grey),
                      ),

                      Wrap(
                        spacing: 6,
                        children: (tutor["tutoring_skills"] as List<String>)
                            .map((skill) => Chip(label: Text(skill)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            //Fila inferior con rating y boton
            Row(
              children: [
                //Rating
                Text(
                  "⭐ ${tutor["rating"]}",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                //Boton reseva
                ElevatedButton(onPressed: () {}, child: Text("Reservar")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
