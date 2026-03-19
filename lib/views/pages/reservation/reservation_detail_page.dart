import 'package:flutter/material.dart';

class ReservationDetailPage extends StatelessWidget {
  const ReservationDetailPage({super.key, required this.reservation});

  final String reservation;
  final String sessionStatus = 'Pendiente de Asistencia';
  final bool isTutorView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Reserva'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Detalle de Reserva',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Text('Fecha: 19/03/2026'),
                  Text('Hora: 10:00'),
                  Text('Tutor: Mario Lino'),
                  Text('Materia: Arquitectura de Software'),
                  Text('Estado: $sessionStatus'),
                  Text('Código de verificación: A3X9KQ'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
