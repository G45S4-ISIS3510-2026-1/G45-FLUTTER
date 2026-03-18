import 'package:flutter/material.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_gateway_page.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            20,
            (index) => ListTile(
              title: Text('Tutor ${index + 1}'),
              subtitle: Text('Descripción del tutor ${index + 1}'),
              leading: Icon(Icons.person),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReservationGatewayPage(),
                    ),
                  );
                },
                child: const Text('Reservar'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
