import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> loginConUniandes() async {
    try {
      final microsoftProvider = MicrosoftAuthProvider();

      microsoftProvider.setCustomParameters({
        'prompt': 'select_account',
        'tenant': 'common',
      });

      UserCredential userCredential;
      userCredential = await FirebaseAuth.instance.signInWithProvider(
        microsoftProvider,
      );

      final email = userCredential.user?.email ?? "";

      if (!email.endsWith('@uniandes.edu.co')) {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Acceso denegado: Usa tu correo @uniandes.edu.co"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print("Login exitoso: $email");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Colors.black),
                const SizedBox(height: 24),
                Text(
                  "Tutorías Uniandes",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: loginConUniandes,
                    icon: const Icon(Icons.window),
                    label: const Text("Ingresar con correo Uniandes"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Solo se permite el ingreso con cuentas institucionales activas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
