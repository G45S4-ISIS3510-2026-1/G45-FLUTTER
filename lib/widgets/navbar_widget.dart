import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: 'Agenda',
            ),
            NavigationDestination(icon: Icon(Icons.message), label: 'Mensajes'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
          ],
          selectedIndex: selectedPage,
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
        );
      },
    );
  }
}
