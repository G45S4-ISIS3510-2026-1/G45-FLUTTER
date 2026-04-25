import 'package:flutter/material.dart';
import 'package:g45_flutter/models/session.dart';

class SessionCardWidget extends StatelessWidget {
  final Session session;
  // null = don't show role badge (e.g. detail page header)
  final bool? isTutor;

  const SessionCardWidget({super.key, required this.session, this.isTutor});

  Color _statusColor(String status) {
    switch (status) {
      case 'Confirmada': return Colors.green;
      case 'Cancelada': return Colors.red;
      default: return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    const months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final dt = session.scheduledAt;
    final statusColor = _statusColor(session.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Date circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(months[dt.month - 1],
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                Text('${dt.day}',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (session.skill['label'] as String?) ?? '',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Text(
                        session.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
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
                      ],
                    ),
                    //major del tutor
                    Text(
                      "Edificio Mario Laserna - ML 502",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                if (isTutor != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    isTutor! ? 'TUTOR' : 'ESTUDIANTE',
                    style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
