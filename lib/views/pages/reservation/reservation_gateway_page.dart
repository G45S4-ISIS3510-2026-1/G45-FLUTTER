import 'package:flutter/material.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_detail_page.dart';
import 'package:g45_flutter/widgets/date_card_widget.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';
import 'package:g45_flutter/widgets/tutor_card.dart';

class ReservationGatewayPage extends StatefulWidget {
  const ReservationGatewayPage({super.key, required this.tutor});
  final User tutor;

  @override
  State<ReservationGatewayPage> createState() => _ReservationGatewayPageState();
}

class _ReservationGatewayPageState extends State<ReservationGatewayPage> {
  DateTime? selectedDate;
  String? selectedTime;
  final List<String> availableTimes = [
    '08:00 AM',
    '10:00 AM',
    '12:00 PM',
    '02:00 PM',
    '04:00 PM',
    '06:00 PM',
    '08:00 PM',
  ];

  List<DateTime> getNextDays() {
    return List.generate(
      5,
      (index) => DateTime.now().add(Duration(days: index)),
    );
  }

  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completar Reserva'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Resumen de la tutoría',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TutorCard(tutor: widget.tutor, showButton: false),
              SizedBox(height: 24),
              Text(
                'Seleccionar fecha',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.center,
                children: getNextDays().map((date) {
                  return DateCardWidget(
                    selectedDate: selectedDate,
                    date: date,
                    onSelected: (DateTime p1) {
                      setState(() => selectedDate = p1);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.center,
                children: availableTimes.map((time) {
                  final isSelected = selectedTime == time;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    onSelected: (selected) {
                      setState(() => selectedTime = selected ? time : null);
                      if (selected && selectedDate != null) {
                        final time = selectedTime!.split(' ')[0];
                        final ampm = selectedTime!.split(' ')[1];
                        int hour = int.parse(time.split(':')[0]);
                        int minute = int.parse(time.split(':')[1]);
                        if (ampm == 'PM' && hour != 12) {
                          hour += 12;
                        }
                        if (ampm == 'AM' && hour == 12) {
                          hour = 0;
                        }
                        selectedDate = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          hour,
                          minute,
                        );
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Card(
                child: RadioGroup<String>(
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() => selectedPaymentMethod = value);
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'card',
                        title: const Text('Tarjeta de crédito'),
                        subtitle: const Text('**** **** **** 1234'),
                        secondary: const Icon(Icons.credit_card),
                      ),
                      RadioListTile<String>(
                        value: 'cash',
                        title: const Text('Efectivo'),
                        subtitle: const Text('Pagar en la sesión'),
                        secondary: const Icon(Icons.money),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor seleccione una fecha')),
                    );
                    return;
                  }

                  if (selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor seleccione una hora')),
                    );
                    return;
                  }

                  if (selectedPaymentMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor seleccione un método de pago'),
                      ),
                    );
                    return;
                  }

                  final reservation = Session(
                    skill: {
                      'label': widget.tutor.tutoringSkills![0],
                      'major': widget.tutor.major,
                      'iconUrl': 'https://cdn.example.com/icons/calculus.png',
                    },
                    scheduledAt: selectedDate!,
                    status: 'Pendiente',
                    studentId: '9GgVfKROcyBbaveLU2lw',
                    tutorId: widget.tutor.id.toString(),
                    verifCode: 'TOHEB3',
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReservationDetailPage(session: reservation),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.infinity, 50),
                ),
                child: Text('Reservar', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
