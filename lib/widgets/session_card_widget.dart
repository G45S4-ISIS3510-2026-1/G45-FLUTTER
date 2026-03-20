import 'package:flutter/material.dart';
import 'package:g45_flutter/models/session.dart';

class SessionCardWidget extends StatelessWidget {
  final Session session;
  const SessionCardWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final String month = months[session.scheduledAt.month - 1];
    final String day = session.scheduledAt.day.toString();
    //detectarW detail de tutor
    return
    //-----------------------------------------------------------------
    Container(
      height: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              //foto de perfil del tutor
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A8A), // Azul oscuro
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      day,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(width: 12),
              //Información del tutor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //renglon Superior
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // materia
                        Text(
                          session.skill['label'],
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "${session.skill['major']}",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    //major del tutor
                    Text(
                      "Edificio Mario Laserna - ML 502",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
