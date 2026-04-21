import 'package:flutter/material.dart';

class ReservationHistoryPage extends StatelessWidget {
  const ReservationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Reservas"),
      ),
      body: const Center(
        child: Text("Reservation History Page"),
      ),
    );
  }
}