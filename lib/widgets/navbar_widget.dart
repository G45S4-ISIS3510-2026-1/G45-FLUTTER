import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';

const destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
  NavigationDestination(icon: Icon(Icons.import_contacts), label: 'Catálogo'),
  NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Agenda'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
];

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder<int>(
  valueListenable: selectedPageNotifier,
  builder: (context, selectedPage, child) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Redondo por defecto navbar no trae border radius tonces se pone uno redondo atras y se deja el navbar traparente
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6), //Efecto de vidrio
            borderRadius: BorderRadius.circular(30),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent, // Trasparente con efecto de vidrio negro definido linea 25
            elevation: 0,
            selectedIndex: selectedPage,
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
            destinations: destinations,
          ),
        ),
      ),
    );
  },
);
  }
}
