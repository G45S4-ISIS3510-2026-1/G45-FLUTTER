// import 'package:flutter/material.dart';
// import 'package:g45_flutter/models/tutor_summary.dart';
// import 'package:g45_flutter/models/user.dart';
// import 'package:g45_flutter/views/pages/user/tutor_profile_page.dart';
// import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';

// class TutorCard extends StatelessWidget {
//   final TutorSummary tutor;

//   const TutorCard({super.key, required this.tutor});

//   @override
//   Widget build(BuildContext context) {
//     //detectar press de tutor y routing a detail de tutor
//     return GestureDetector(
//       onTap: (){
//       if (tutor.id == null) return;
//         Navigator.push(
//           context, 
//           MaterialPageRoute(
//             builder: (context) => TutorProfilePage(tutorId: tutor.id!)));
//       },
//       //-----------------------------------------------------------------
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             //Fila superior con foto, nombre, carrera y habilidades
//             Row(
//               children: [
//                 //Foto de perfil del tutor
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(tutor.profileImageUrl),
//                 ),
//                 SizedBox(width: 12),
//                 //Información del tutor
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //renglon Superior
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           //Nombre del tutor
//                           Text(
//                             tutor["name"],
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           //Precio por hora del tutor
//                           Text(
//                             "\$${tutor["price"]}",
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ],
//                       ),
//                       //major del tutor
//                       Text(
//                         tutor["major"],
//                         style: TextStyle(color: Colors.grey),
//                       ),

//                       Wrap(
//                         spacing: 6,
//                         children: (tutor["tutoring_skills"] as List<String>)
//                             .map((skill) => Chip(label: Text(skill)))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 12),
//             //Fila inferior con rating y boton
//             Row(
//               children: [
//                 //Rating
//                 Text(
//                   "⭐ ${tutor["rating"]}",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 Spacer(),
//                 //--------------------------------------------------
//                 //Boton reseva(DIEGO)->TOCA MANDARLE EL TUTOR PUNTUAL
//                 //--------------------------------------------------
//                 ElevatedButton(onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ReservationGatewayPage(),
//                     ),
//                   );
//                 }, child: Text("Reservar")),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
