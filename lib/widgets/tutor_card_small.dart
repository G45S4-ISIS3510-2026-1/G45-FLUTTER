import 'package:flutter/material.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';
import 'package:g45_flutter/views/pages/user/tutor_profile_page.dart';

class TutorCardSmall extends StatelessWidget {
  final TutorSummary tutor;

  const TutorCardSmall({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E222D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: (tutor.profileImageUrl != null &&
                          tutor.profileImageUrl!.isNotEmpty)
                      ? NetworkImage(tutor.profileImageUrl!)
                      : null,
                  child: (tutor.profileImageUrl == null ||
                          tutor.profileImageUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black54,
                  child: Text("⭐", style: TextStyle(fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tutor.name ?? "Sin nombre",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              tutor.major ?? "Carrera",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationGatewayPage(tutor: tutor),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD15C),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("RESERVAR",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
