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
    final colorScheme = Theme.of(context).colorScheme;
    
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: NavigationBar(
                backgroundColor: Colors.transparent,
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
