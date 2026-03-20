import 'package:flutter/material.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/viewmodels/reservation_detail_viewmodel.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';
import 'package:g45_flutter/widgets/qr_code_widget.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/widgets/simple_user_card_widget.dart';

class ReservationDetailPage extends StatefulWidget {
  const ReservationDetailPage({super.key, required this.session});

  final Session session;

  @override
  State<ReservationDetailPage> createState() => ReservationDetailPageState();
}

class ReservationDetailPageState extends State<ReservationDetailPage> {
  final ReservationDetailViewModel viewModel = ReservationDetailViewModel();
  final bool isTutorView = false;

  @override
  void initState() {
    super.initState();
    viewModel.loadParticipants(
      widget.session.tutorId,
      widget.session.studentId,
    );
    viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

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
                      widget.session.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      SessionCardWidget(session: widget.session),
                      SizedBox(height: 16),
                      if (viewModel.isLoading)
                        CircularProgressIndicator()
                      else if (viewModel.errorMessage != null)
                        Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        )
                      else ...[
                        if (viewModel.tutor != null)
                          SimpleUserCardWidget(
                            user: viewModel.tutor!,
                            isTutor: true,
                          ),
                        SizedBox(height: 16),
                        if (viewModel.student != null)
                          SimpleUserCardWidget(
                            user: viewModel.student!,
                            isTutor: false,
                          ),
                      ],
                      SizedBox(height: 16),
                      QrCodeWidget(
                        verifCode: widget.session.verifCode,
                        isTutor: true,
                      ),
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
                                          viewModel.cancelSession(
                                            widget.session,
                                          );
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
                              viewModel.confirmSession(widget.session);
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
