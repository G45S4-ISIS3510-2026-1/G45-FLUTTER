import 'package:flutter/material.dart';

class ProfileOptions extends StatelessWidget {
  final VoidCallback onReservationsTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onFavoritesTap;

  const ProfileOptions({
    super.key,
    required this.onReservationsTap,
    required this.onReviewsTap,
    required this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _option("Historial de Reservas", onReservationsTap),
        _option("Reseñas", onReviewsTap),
        _option("Tutores Favoritos", onFavoritesTap),
      ],
    );
  }

  Widget _option(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
      onTap: onTap,
    );
  }
}