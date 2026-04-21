import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reseñas"),
      ),
      body: const Center(
        child: Text("Reviews Page"),
      ),
    );
  }
}