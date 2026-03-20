import 'package:flutter/material.dart';
import 'package:g45_flutter/views/pages/user/tutor_profile_page.dart';

class SimpleUserCardWidget extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isTutor;
  const SimpleUserCardWidget({
    super.key,
    required this.user,
    this.isTutor = true,
  });

  @override
  Widget build(BuildContext context) {
    //detectar press de tutor y routing a detail de tutor
    return GestureDetector(
      onTap: () {
        if (isTutor) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorProfilePage(tutor: user),
            ),
          );
        }
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
                  backgroundImage: NetworkImage(user["image"]),
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
                            user["name"],
                            style: TextStyle(color: Colors.white),
                          ),
                          if (isTutor)
                            Text("TUTOR", style: TextStyle(color: Colors.blue))
                          else
                            Text(
                              "STUDENT",
                              style: TextStyle(color: Colors.blue),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
