import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
              NavigationDestination(
                icon: Icon(Icons.import_contacts),
                label: 'Catálogo',
              ),
              NavigationDestination(
                icon: Icon(Icons.message),
                label: 'Mensajes',
              ),
              NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
            ],
            selectedIndex: selectedPage,
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
          ),
        );
      },
    );
  }
}
