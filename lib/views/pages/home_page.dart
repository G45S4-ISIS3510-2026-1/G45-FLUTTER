import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/session.dart';
// import 'package:g45_flutter/data/mock/facultades_mock.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/models/user.dart' as u;
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/widgets/tutor_card.dart';
import '../../viewmodels/auth.dart';

class HomePage extends StatefulWidget { // Cambiado a StatefulWidget
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authVM = AuthViewModel();
  final sessionVM = SessionViewModel(); 
  String nombre = "Usuario"; // Variable simple para el nombre
  List<Session> sesiones = []; // Lista para las sesiones

  @override
  void initState() {
    super.initState();
    cargarDatos(); // Cargamos el usuario apenas entre a la página
  }
  Future<void> cargarDatos() async {
    u.User? user = await authVM.getUsuarioCache();
    
    if (user != null) {
      final listaSesiones = await sessionVM.getSessionsByStudent(user.id);
      setState(() {
        nombre = user.name;
        sesiones = listaSesiones;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '!Hola $nombre',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Proximas sesiones',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sesiones.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SessionCardWidget(session: sesiones[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}