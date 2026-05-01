import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';

class ProfileExtraInfo extends StatelessWidget {
  final User user;

  const ProfileExtraInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _box(context, "Código", user.id ?? ""),
        _box(context, "Promedio", "${user.tutorRating ?? 0}/5.0"),
      ],
    );
  }

  Widget _box(BuildContext context, String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}