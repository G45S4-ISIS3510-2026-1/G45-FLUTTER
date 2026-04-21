import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';

class ProfileStats extends StatelessWidget {
  final User user;

  const ProfileStats({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          //-------------------------------------
          // SCORE
          //-------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tutor Score",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "${user.tutorRating ?? 0}/5.0",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          //-------------------------------------
          // PLACEHOLDER STATS
          //-------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Column(
                children: [
                  Text("0", style: TextStyle(color: Colors.white)),
                  Text("Tutorías", style: TextStyle(color: Colors.white54)),
                ],
              ),
              Column(
                children: [
                  Text("0", style: TextStyle(color: Colors.white)),
                  Text("Estudiantes", style: TextStyle(color: Colors.white54)),
                ],
              ),
              Column(
                children: [
                  Text("0", style: TextStyle(color: Colors.white)),
                  Text("Insignias", style: TextStyle(color: Colors.white54)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}