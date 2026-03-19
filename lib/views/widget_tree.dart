import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';
import 'package:g45_flutter/views/pages/user/tutor_catalog_page.dart';
import 'package:g45_flutter/views/pages/home_page.dart';
import 'package:g45_flutter/views/pages/messages/messages_page.dart';
import 'package:g45_flutter/views/pages/user/profile_page.dart';
import 'package:g45_flutter/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), CatalogPage(), MessagesPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,//para que quede el gradient abajo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff020617), Color(0xff0B1220), Color(0xff1E3A8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder<int>( //Detecta si hubo cambio en la pagina y recarga la ui en la nueva pagina
                  valueListenable: selectedPageNotifier,
                  builder: (context, selectedPage, child) {
                    return pages[selectedPage];
                  },
                ),
              ),

              const NavbarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
