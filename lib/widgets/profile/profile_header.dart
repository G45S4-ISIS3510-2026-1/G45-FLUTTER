import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        CircleAvatar(
          radius: 45,
          backgroundImage: user.profileImageUrl != null
              ? NetworkImage(user.profileImageUrl!)
              : null,
          child: user.profileImageUrl == null
              ? const Icon(Icons.person, size: 40)
              : null,
        ),

        const SizedBox(height: 12),

        Text(
          user.name ?? "",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          user.major ?? "",
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}