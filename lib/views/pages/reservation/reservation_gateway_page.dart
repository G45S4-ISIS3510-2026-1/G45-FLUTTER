import 'package:flutter/material.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_detail_page.dart';

class ReservationGatewayPage extends StatefulWidget {
  const ReservationGatewayPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Resumen de la tutoría',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.person),
                ),
                title: Text('Mario Lino'),
                subtitle: Text('Arquitectura de Software'),
                trailing: Text('\$ 5.000.000 / hora'),
              ),
            ),
            Text(
              'Seleccionar fecha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  selectedDate == null
                      ? 'Elegir Fecha'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12.0,
              children: availableTimes.map((time) {
                final isSelected = selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  onSelected: (selected) {
                    setState(() => selectedTime = selected ? time : null);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReservationDetailPage(reservation: ''),
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
    );
  }
}
