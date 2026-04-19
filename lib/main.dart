import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/core/theme.dart';
import 'package:g45_flutter/firebase_options.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/viewmodels/reservation_detail_viewmodel.dart';
import 'package:g45_flutter/viewmodels/reservation_gateway_viewmodel.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/views/pages/login/login_regist_page.dart';
import 'package:g45_flutter/views/pages/select_skills.dart';
import 'package:g45_flutter/views/widget_tree.dart';
import 'package:provider/provider.dart';

// ---------------------------
// CAMBIAR AQUÍ
// true = salta login
// false = usa Firebase normal
// ---------------------------
const bool SKIP_LOGIN = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData.dark().textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TutorViewModel(UserRepository())),
        ChangeNotifierProvider(create: (_) => SkillsViewModel()..loadSkills()),
        ChangeNotifierProvider(create: (_) => ReservationDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ReservationGatewayViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: materialTheme.dark(),

        // ---------------------------
        // LOGIN SWITCH
        // ---------------------------
        home: SKIP_LOGIN
            ? const WidgetTree() // entra directo sin login
            : StreamBuilder<User?>(
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
                        return Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
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
                    },
                  );
                },
              ),
      ),
    );
  }
}