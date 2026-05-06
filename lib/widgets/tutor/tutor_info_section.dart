import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';

class TutorInfoSection extends StatefulWidget {
  final User tutor;

  const TutorInfoSection({super.key, required this.tutor});

  @override
  State<TutorInfoSection> createState() => _TutorInfoSectionState();
}

class _TutorInfoSectionState extends State<TutorInfoSection> {
  bool isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isUnlocked = true;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF101827),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // CONTENIDO REAL
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.white54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.tutor.email ?? "No disponible",
                          style: const TextStyle(color: Colors.white54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.phone, color: Colors.white54),
                      SizedBox(width: 8),
                      Text(
                        "No disponible",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ],
              ),

              // CAPA SÓLIDA DE CENSURA
              if (!isUnlocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1020),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Información de contacto oculta",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Reserva una sesión para entrar en contacto con el tutor",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}