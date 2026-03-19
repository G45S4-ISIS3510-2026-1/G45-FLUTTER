import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';
import 'package:g45_flutter/views/pages/catalog_page.dart';
import 'package:g45_flutter/views/pages/home_page.dart';
import 'package:g45_flutter/views/pages/messages_page.dart';
import 'package:g45_flutter/views/pages/profile_page.dart';
import 'package:g45_flutter/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), CatalogPage(), MessagesPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPageNotifier, child) {
          return pages.elementAt(selectedPageNotifier);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
