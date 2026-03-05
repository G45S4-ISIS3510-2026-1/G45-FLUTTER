import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            20,
            (index) => ListTile(
              title: Text('Tutor ${index + 1}'),
              subtitle: Text('Descripción del tutor ${index + 1}'),
              leading: Icon(Icons.person),
            ),
          ),
        ),
      ),
    );
  }
}
