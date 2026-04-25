import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/models/skills.dart';
import 'package:g45_flutter/models/tutor_summary.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/viewmodels/reservation_gateway_viewmodel.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_detail_page.dart';
import 'package:g45_flutter/widgets/date_card_widget.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';
import 'package:g45_flutter/widgets/tutor/tutor_card.dart';
import 'package:provider/provider.dart';

class ReservationGatewayPage extends StatefulWidget {
  const ReservationGatewayPage({super.key, required this.tutor});
  final TutorSummary tutor;

  @override
  State<ReservationGatewayPage> createState() => _ReservationGatewayPageState();
}

class _ReservationGatewayPageState extends State<ReservationGatewayPage> {
  ReservationGatewayViewModel viewModel = ReservationGatewayViewModel();
  DateTime? selectedDate;
  String? selectedTime;
  User? fullTutor;
  bool isLoadingTutor = true;

  @override
  void initState() {
    super.initState();
    _loadTutor();
  }

  Future<void> _loadTutor() async {
    final repo = UserRepository();
    try {
      final tutor = await repo.getUserById(widget.tutor.id!);
      if (mounted) {
        setState(() {
          fullTutor = tutor;
          isLoadingTutor = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingTutor = false;
        });
      }
    }
  }

  List<String> getAvailableTimesForDate(DateTime? date) {
    if (date == null || fullTutor == null) return [];
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    String dayName = days[date.weekday - 1];

    Map<String, dynamic> avail = fullTutor!.availability;
    if (avail.containsKey(dayName)) {
      var timesList = avail[dayName];
      if (timesList is List) {
        List<String> formatted = [];
        for (var t in timesList) {
          if (t is String && t.length >= 16) {
            try {
              DateTime parsed = DateTime.parse(t);
              int hour = parsed.toUtc().hour;
              int minute = parsed.toUtc().minute;
              String ampm = hour >= 12 ? 'PM' : 'AM';
              int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
              String timeformatted =
                  "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm";
              formatted.add(timeformatted);
            } catch (e) {}
          }
        }
        return formatted;
      }
    }
    return [];
  }

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
              TutorCard(tutor: widget.tutor),
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
                      setState(() {
                        selectedDate = p1;
                        selectedTime = null; // reset time because date changed
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              if (isLoadingTutor)
                const Center(child: CircularProgressIndicator())
              else if (selectedDate == null)
                const Text(
                  'Selecciona una fecha para ver los horarios',
                  style: TextStyle(color: Colors.white),
                )
              else if (getAvailableTimesForDate(selectedDate).isEmpty)
                const Text(
                  'No hay horarios disponibles para esta fecha',
                  style: TextStyle(color: Colors.white),
                )
              else
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  alignment: WrapAlignment.center,
                  children: getAvailableTimesForDate(selectedDate).map((time) {
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
                          final timePart = selectedTime!.split(' ')[0];
                          final ampm = selectedTime!.split(' ')[1];
                          int hour = int.parse(timePart.split(':')[0]);
                          int minute = int.parse(timePart.split(':')[1]);
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
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'card',
                      groupValue: selectedPaymentMethod,
                      title: const Text('Tarjeta de crédito'),
                      subtitle: const Text('**** **** **** 1234'),
                      secondary: const Icon(Icons.credit_card),
                      onChanged: (value) {
                        setState(() => selectedPaymentMethod = value);
                      },
                    ),
                    RadioListTile<String>(
                      value: 'cash',
                      groupValue: selectedPaymentMethod,
                      title: const Text('Efectivo'),
                      subtitle: const Text('Pagar en la sesión'),
                      secondary: const Icon(Icons.money),
                      onChanged: (value) {
                        setState(() => selectedPaymentMethod = value);
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final connectivity = await Connectivity().checkConnectivity();
                  if (!mounted) return;
                  if (connectivity.every((r) => r == ConnectivityResult.none)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sin conexión a internet")),
                    );
                    return;
                  }

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
                  final skillsViewModel = Provider.of<SkillsViewModel>(
                    context,
                    listen: false,
                  );
                  final tutorSkillIds = widget.tutor.tutoringSkills ?? [];
                  final tutorSkill = skillsViewModel.skills.firstWhere(
                    (skill) => tutorSkillIds.contains(skill.id),
                    orElse: () => Skill(
                      id: tutorSkillIds.isNotEmpty ? tutorSkillIds.first : '0',
                      major: 'Otro',
                      label: 'Tutoría',
                      iconUrl: '',
                    ),
                  );
                  final reservation = Session(
                    skill: {
                      'id': tutorSkill.id,
                      'label': tutorSkill.label,
                      'major': tutorSkill.major,
                      'iconUrl': tutorSkill.iconUrl,
                    },
                    scheduledAt: selectedDate!,
                    status: 'Pendiente',
                    studentId: AuthViewModel.instance.userCache!.id,
                    tutorId: widget.tutor.id.toString(),
                    verifCode: '',
                  );

                  Session? createdSession;
                  // CONTINGENCIA
                  try {
                    createdSession = await viewModel.createSession(reservation);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error al conectar con firebase. Mostrando vista previa.',
                          ),
                        ),
                      );
                    }
                  }

                  final sessionToDisplay = createdSession ?? reservation;
                  // CONTINGENCIA P2
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReservationDetailPage(session: sessionToDisplay),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
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
