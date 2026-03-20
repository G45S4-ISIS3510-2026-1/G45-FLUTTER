import 'package:flutter/material.dart';
import 'package:g45_flutter/data/mock/facultades_mock.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/models/user.dart' as u;
import 'package:g45_flutter/widgets/tutor_card.dart';
import '../../viewmodels/auth.dart';

class HomePage extends StatefulWidget { // Cambiado a StatefulWidget
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authVM = AuthViewModel();
  String nombre = "Usuario"; // Variable simple para el nombre

  @override
  void initState() {
    super.initState();
    cargarDatos(); // Cargamos el usuario apenas entre a la página
  }

  // Función para obtener el nombre sin bloquear la UI
  Future<void> cargarDatos() async {
    u.User? user = await authVM.getUsuarioCache();
    if (user != null) {
      setState(() {
        nombre = user.name ?? "Usuario"; // Esto redibuja la página con el nombre real
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
                    '¡Hola $nombre!',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Proxima sesiónes',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ordenar por'),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text("Mejor Ratings")),
                    ElevatedButton(onPressed: () {}, child: const Text("Precio")),
                    ElevatedButton(onPressed: () {}, child: const Text("Proximidad")),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Facultades'),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: facultades.map((facultad) {
                    return ElevatedButton(
                      onPressed: () {},
                      child: Text(facultad),
                    );
                  }).toList(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tutores.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TutorCard(tutor: tutores[index]),
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