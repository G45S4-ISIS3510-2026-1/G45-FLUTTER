import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g45_flutter/core/theme.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';

import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/views/pages/login/login_regist_page.dart';
import 'package:g45_flutter/firebase_options.dart';
import 'package:g45_flutter/views/widget_tree.dart';
import 'package:g45_flutter/views/pages/select_skills.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SOLO WEB
  if (kIsWeb) {
    await FirebaseAuth.instance.getRedirectResult();
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<AuthState>? _authFuture;
  User? _lastUser;

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData.dark().textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TutorViewModel(UserRepository())),
        ChangeNotifierProvider(create: (_) => SkillsViewModel()..loadSkills()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: materialTheme.dark(),

        //SKIP AUTH TEMPORAL
        home: const WidgetTree(),

        /*
        LÓGICA ORIGINAL (COMENTADA)

        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = snapshot.data;

            //no logueado
            if (user == null) {
              _authFuture = null;
              _lastUser = null;
              return const LoginRegistPage();
            }

            //recalcula si el usuario cambia
            if (_authFuture == null || _lastUser?.uid != user.uid) {
              _lastUser = user;
              _authFuture = AuthViewModel().handleLogin();
            }

            return FutureBuilder<AuthState>(
              future: _authFuture,
              builder: (context, snap) {

                if (snap.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snap.hasData) {
                  return const LoginRegistPage();
                }

                switch (snap.data!) {
                  case AuthState.selectSkills:
                    return const SelectSkills();

                  case AuthState.home:
                    return const WidgetTree();

                  default:
                    return const LoginRegistPage();
                }
              },
            );
          },
        ),
        */

      ),
    );
  }
}