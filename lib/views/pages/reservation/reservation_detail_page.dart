import 'package:flutter/material.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';
import 'package:g45_flutter/widgets/qr_code_widget.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/widgets/simple_user_card_widget.dart';

class ReservationDetailPage extends StatelessWidget {
  const ReservationDetailPage({super.key, required this.session});

  final Session session;
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
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Detalle de Reserva',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      SessionCardWidget(session: session),
                      SizedBox(height: 16),
                      SimpleUserCardWidget(
                        user: User.fromMock(tutores.firstWhere(
                          (t) =>
                              t['id'] == session.tutorId ||
                              t['name'] == session.tutorId ||
                              t['uniandesId'] == session.tutorId,
                          orElse: () => tutores.first,
                        )),
                        isTutor: true,
                      ),
                      SizedBox(height: 16),
                      SimpleUserCardWidget(
                        user: User.fromMock(tutores.firstWhere(
                          (t) =>
                              t['id'] == session.studentId ||
                              t['name'] == session.studentId ||
                              t['uniandesId'] == session.studentId,
                          orElse: () => tutores.last,
                        )),
                        isTutor: false,
                      ),
                      SizedBox(height: 16),
                      QrCodeWidget(verifCode: session.verifCode, isTutor: true),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Cancelar reserva'),
                                    content: Text(
                                      '¿Está seguro de que desea cancelar la reserva?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // agregar reserva
                                        },
                                        child: Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Confirmar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
