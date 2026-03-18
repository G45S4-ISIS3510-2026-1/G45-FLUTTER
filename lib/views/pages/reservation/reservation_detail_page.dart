import 'package:flutter/material.dart';

class ReservationDetailPage extends StatelessWidget {
  const ReservationDetailPage({super.key, required this.reservation});

  final String reservation;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Detalle de Reserva',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Column(
                  children: [
                    Text('Fecha: ${reservation.date}'),
                    Text('Hora: ${reservation.time}'),
                    Text('Cancha: ${reservation.court}'),
                    Text('Precio: ${reservation.price}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
