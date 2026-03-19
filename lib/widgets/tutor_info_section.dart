import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:g45_flutter/models/tutor.dart';

class TutorInfoSection extends StatefulWidget {
  final Tutor tutor;

  const TutorInfoSection({super.key, required this.tutor});

  @override
  State<TutorInfoSection> createState() => _TutorInfoSectionState();
}

class _TutorInfoSectionState extends State<TutorInfoSection> {//necesito quitar censura por eso statefull
  bool isUnlocked = false;
  @override
  Widget build(BuildContext context) {
    //Quitar censura
    return GestureDetector(
      onTap: () {
        setState(() {
          isUnlocked = true;
        });
      },
      //-------------------------------------
      //Contenido
      //-------------------------------------
      child: Stack(
        children: [
          //-------------------------------------
          // 1. CONTENIDO REAL (fondo)
          //-------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.email, color: Colors.white54),
                  SizedBox(width: 8),
                  Text(
                    widget.tutor.email ?? "No disponible",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.white54),
                  SizedBox(width: 8),
                  Text(
                    "No disponible",
                    //widget.tutor['phone'] ?? "No disponible",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
          //-------------------------------------
          // 2. Logica BLUR + OSCURECIDO + TEXTO + ICONO (ENCIMA)
          //-------------------------------------
          if (!isUnlocked) ...[
            // BLUR + OSCURECIDO
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),
            ),

            //TEXTO + ICONO (ENCIMA)
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock, color: Colors.blue, size: 28),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Información de contacto oculta",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ],
          //------------------------------------------
        ],
      ),
    );
  }
}
