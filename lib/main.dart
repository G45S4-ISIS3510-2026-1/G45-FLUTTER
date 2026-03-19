import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:g45_flutter/theme.dart';
import 'package:g45_flutter/firebase_options.dart';
import 'package:g45_flutter/views/pages/login_regist_page.dart';
import 'package:g45_flutter/views/widget_tree.dart';
import 'package:g45_flutter/views/pages/select_skills.dart';
import 'package:g45_flutter/viewmodels/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData.dark().textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: materialTheme.dark(),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData) {
            return const LoginRegistPage();
          }
          final authVM = AuthViewModel();

          return FutureBuilder<AuthState>(
            future: authVM.handleLogin(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              switch (snap.data!) {
                case AuthState.selectSkills:
                  return const SelectSkills();

                case AuthState.home:
                  return const WidgetTree();

                default:
                  return const LoginRegistPage();
              }
            }
          );
        },
      ),
    );
  }
}