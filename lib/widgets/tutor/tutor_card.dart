import 'package:flutter/material.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';
import 'package:g45_flutter/views/pages/user/tutor_profile_page.dart';
import 'package:provider/provider.dart';

class TutorCard extends StatelessWidget {
  final bool showButton;
  const TutorCard({super.key, required this.tutor, this.showButton = true});
  final TutorSummary tutor; //cambio de mock a real

  @override
  Widget build(BuildContext context) {
    final skillsVM = Provider.of<SkillsViewModel>(context);

    final tutorSkills = tutor.tutoringSkills ?? [];
    print("""
------ TUTOR DEBUG ------
ID: ${tutor.id}
Nombre: ${tutor.name}
Carrera: ${tutor.major}
Rating: ${tutor.rating}
Precio: ${tutor.sessionPrice}
Skills IDs: $tutorSkills

-------------------------
""");
    //     print("Tutor skills IDs: $tutorSkills");
    //     print("All skills: ${skillsVM.skills.map((s) => s.id)}");

    final skillNames = skillsVM.skills
        .where((skill) => tutorSkills.contains(skill.id)) //comparar IDs
        .map((skill) => skill.label ?? "") //devolver label
        .toList();

    //detectar press de tutor y routing a detail de tutor
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TutorProfilePage(tutorId: tutor.id ?? "", tutor: tutor),
          ),
        );
      },
      //-----------------------------------------------------------------
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
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
                      ? Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )
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
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "\$${tutor.sessionPrice}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      //major del tutor
                      Text(
                        tutor.major ?? "Sin carrera",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),

                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: skillNames
                            .map(
                              (skill) => Chip(
                                label: Text(skill),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text(
                  (tutor.receivedRatings ?? 0) == 0
                      ? "Nuevo"
                      : (tutor.rating ?? 0).toStringAsFixed(1),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Spacer(),
                //--------------------------------------------------
                //Boton reseva
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReservationGatewayPage(tutor: tutor),
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
