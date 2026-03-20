import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginRegistPage extends StatelessWidget {
  const LoginRegistPage({super.key});

  Future<void> ingresarConUniandes(BuildContext context) async {
    final theme = Theme.of(context);
    try {

      final microsoftProvider = MicrosoftAuthProvider();
      
      microsoftProvider.setCustomParameters({
        'prompt': 'select_account',
        'tenant': 'common', 
      });

      UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
      } else {
        userCredential = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      }

      final email = userCredential.user?.email ?? "";

      if (!email.endsWith('@uniandes.edu.co')) {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Acceso denegado: Solo correos @uniandes.edu.co"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error de autenticación: $error"),
            backgroundColor: theme.colorScheme.onError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, size: 100, color: theme.colorScheme.onSurface),
                      const SizedBox(height: 15),
                      Text(
                        "Tutorías Uniandes",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ingresarConUniandes(context), // Llama a la función aquí
                  icon: Icon(Icons.account_balance, color: theme.colorScheme.primary),
                  label: Text(
                    "ENTRAR CON UNIANDES",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}