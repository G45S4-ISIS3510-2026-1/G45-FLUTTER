import 'package:flutter/material.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/views/pages/user/tutor_profile_page.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';

import 'package:g45_flutter/models/user.dart';
import 'package:provider/provider.dart';

class TutorCard extends StatelessWidget {
  final TutorSummary tutor; //cambio de mock a real

  const TutorCard({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    final skillsVM = Provider.of<SkillsViewModel>(context);

    final tutorSkills = tutor.tutoringSkills ?? [];
    print("TutorSummary skills: ${tutor.tutoringSkills}");

    final skillNames = skillsVM.skills
        .where((skill) => tutorSkills.contains(skill.label))
        .map((skill) => skill.label)
        .where((label) => label != null)
        .map((label) => label!)
        .toList();
    
    //detectar press de tutor y routing a detail de tutor
    return GestureDetector(
    
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorProfilePage(tutorId: tutor.id ?? ""),
          ),
        );
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
                  backgroundImage:
                      (tutor.profileImageUrl != null &&
                          tutor.profileImageUrl!.isNotEmpty)
                      ? NetworkImage(tutor.profileImageUrl!)
                      : null,
                  child:
                      (tutor.profileImageUrl == null ||
                          tutor.profileImageUrl!.isEmpty)
                      ? Icon(Icons.person)
                      : null,
                ),
                SizedBox(width: 12),
                //Información del tutor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //renglon Superior
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tutor.name ?? "Sin nombre",
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "\$${tutor.sessionPrice}",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      //major del tutor
                      Text(
                        tutor.major ?? "Sin carrera",
                        style: TextStyle(color: Colors.grey),
                      ),

                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
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
                  "⭐ ",
                  //"⭐ ${tutor["rating"]}",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                //--------------------------------------------------
                //Boton reseva(DIEGO)->TOCA MANDARLE EL TUTOR PUNTUAL
                //--------------------------------------------------
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReservationGatewayPage(),
                      ),
                    );
                  },
                  child: Text("Reservar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
