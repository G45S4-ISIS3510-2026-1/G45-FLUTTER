import 'package:flutter/material.dart';
import 'package:g45_flutter/core/util.dart';
import 'package:g45_flutter/views/widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> login() async {
    final token = "await Api.login(emailCtrl.text, passCtrl.text)";

    if (token != null) {
      await SessionManager.saveToken(token);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Credenciales incorrectas")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Entrar")),
          ],
        ),
      ),
    );
  }
}
