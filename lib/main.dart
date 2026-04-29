import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/core/theme.dart';
import 'package:g45_flutter/firebase_options.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/viewmodels/agenda_viewmodel.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/viewmodels/pqr_viewmodel.dart';
import 'package:g45_flutter/services/recent_viewed.dart';
import 'package:g45_flutter/viewmodels/reservation_detail_viewmodel.dart';
import 'package:g45_flutter/viewmodels/reservation_gateway_viewmodel.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/viewmodels/session.dart';
import 'package:g45_flutter/viewmodels/become_tutor_viewmodel.dart';
import 'package:g45_flutter/viewmodels/theme_viewmodel.dart';
import 'package:g45_flutter/services/light_sensor_service.dart';
import 'package:g45_flutter/views/pages/login/login_regist_page.dart';
import 'package:g45_flutter/views/pages/select_skills.dart';
import 'package:g45_flutter/views/widget_tree.dart';
import 'package:provider/provider.dart';

const bool SKIP_LOGIN = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }
  } catch (e) {
    print("Error en Firebase init: $e");
  }

  await RecentViewedService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData.dark().textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel()..startListening(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(LightSensorService())..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => TutorViewModel(UserRepository())),
        ChangeNotifierProvider(create: (_) => SkillsViewModel()..loadSkills()),
        ChangeNotifierProvider(create: (_) => ReservationDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ReservationGatewayViewModel()),
        ChangeNotifierProvider(create: (_) => PqrViewModel()),
        ChangeNotifierProvider(create: (_) => AgendaViewModel()),
        ChangeNotifierProvider(create: (_) => BecomeTutorViewModel()),
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
      ],
      child: Consumer2<AuthViewModel, ThemeViewModel>(
        builder: (context, authVM, themeVM, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: materialTheme.light(),
            darkTheme: materialTheme.dark(),
            themeMode: themeVM.themeMode,
            home: SKIP_LOGIN
                ? const WidgetTree()
                : Builder(
                    builder: (context) {
                      switch (authVM.authState) {
                        case AuthState.loading:
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        case AuthState.login:
                          return const LoginRegistPage();
                        case AuthState.selectSkills:
                          return const SelectSkills();
                        case AuthState.home:
                          return const WidgetTree();
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}