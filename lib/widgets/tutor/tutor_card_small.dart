import 'package:flutter/material.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';
import 'package:g45_flutter/views/pages/user/tutor_profile_page.dart';

class TutorCardSmall extends StatelessWidget {
  final TutorSummary tutor;

  const TutorCardSmall({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light) ...[
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                offset: const Offset(-4, -4),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(4, 4),
                blurRadius: 10,
              ),
            ]
          ],
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
                      ? Icon(Icons.person,
                          size: 40, color: colors.onSurfaceVariant)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: const Text("⭐", style: TextStyle(fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tutor.name ?? "Sin nombre",
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              tutor.major ?? "Carrera",
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 12,
              ),
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
                  backgroundColor: colors.tertiary,
                  foregroundColor: colors.onTertiary,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "RESERVAR",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}