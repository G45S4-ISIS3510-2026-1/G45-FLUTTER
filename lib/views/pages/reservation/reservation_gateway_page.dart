import 'package:flutter/material.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_detail_page.dart';

class ReservationGatewayPage extends StatelessWidget {
  const ReservationGatewayPage({super.key});

  VoidCallback? get onPressed => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Reserva'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationDetailPage(reservation: ''),
                ),
              );
            },
            child: Text('Reservar'),
          ),
        ),
      ),
    );
  }
}
