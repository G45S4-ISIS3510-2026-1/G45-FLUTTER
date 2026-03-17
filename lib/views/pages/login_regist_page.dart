import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:g45_flutter/views/pages/login_page.dart';
import 'package:g45_flutter/views/pages/registrarse_page.dart';

class LoginRegistPage extends StatelessWidget {
  const LoginRegistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
    backgroundColor: theme.colorScheme.primaryContainer,
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push( context, MaterialPageRoute(builder: (_) => const LoginPage())),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text("Entrar"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistrarsePage()),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text("Registrarse"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
