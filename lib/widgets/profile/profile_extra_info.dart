import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';

class ProfileExtraInfo extends StatelessWidget {
  final User user;

  const ProfileExtraInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _box("Código", user.id ?? ""),
        _box("Promedio", "${user.tutorRating ?? 0}/5.0"),
      ],
    );
  }

  Widget _box(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}