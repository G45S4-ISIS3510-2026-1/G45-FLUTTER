import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/repositories/user_repository.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/views/pages/user/pqr_page.dart';
import 'package:g45_flutter/widgets/profile/profile_extra_info.dart';
import 'package:g45_flutter/widgets/profile/profile_header.dart';
import 'package:g45_flutter/widgets/profile/profile_options.dart';
import 'package:g45_flutter/widgets/profile/profile_stats.dart';
import 'package:provider/provider.dart';
import 'package:g45_flutter/views/pages/user/reservation_history_page.dart';
import 'package:g45_flutter/views/pages/user/reviews_page.dart';
import 'package:g45_flutter/views/pages/user/favorites_page.dart';

// -------------------------------------
// DEV FLAG
// true = no llama backend
// false = flujo normal
// -------------------------------------
const bool SKIP_PROFILE_FETCH = true; // no llama backend
const bool DEV_MODE = true; // permite mock si no hay cache

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _userRepo = UserRepository();

  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  //-------------------------------------
  // CARGAR USUARIO
  //-------------------------------------
  Future<void> loadUser() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    //-------------------------------------
    // 1. CARGAR CACHE
    //-------------------------------------
    final cached = await authVM.getUserCache();

    if (cached != null) {
      setState(() {
        user = cached;
        isLoading = false;
      });
    }

    //-------------------------------------
    // 2. SIN CACHE
    //-------------------------------------
    if (cached == null) {
      //-------------------------------------
      // DEV MODE → USAR MOCK
      //-------------------------------------
      if (DEV_MODE) {
        final mockJson = {
          "id": "202012345",
          "name": "Nicolás Ballén",
          "email": "n.ballen@uniandes.edu.co",
          "major": "Ingeniería de Sistemas y Computación",
          "isTutoring": true,
          "uniandesId": 202012345,
          "fcmTokens": ["token_abc123"],
          "favTutors": ["uid_tutor_1"],
          "tutoringSkills": ["skill_001", "skill_002"],
          "interestedSkills": ["skill_042"],
          "tutorRating": 4.5,
          "availability": {},
          "paymentMethods": [],
          "sessionPrice": 50000,
          "profileImageUrl": null,
        };

        setState(() {
          user = User.fromMock(mockJson);
          isLoading = false;
        });

        return;
      }

      //-------------------------------------
      // PRODUCCIÓN → NO MOCK
      //-------------------------------------
      setState(() {
        isLoading = false;
      });

      return;
    }

    //-------------------------------------
    // 3. DEV → NO LLAMAR BACKEND
    //-------------------------------------
    if (SKIP_PROFILE_FETCH) return;

    //-------------------------------------
    // 4. BACKEND (NO BLOQUEANTE)
    //-------------------------------------
    try {
      final fetched = await _userRepo.getUserById(cached.id!);

      setState(() {
        user = fetched;
      });
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //final authVM = Provider.of<AuthViewModel>(context);

    if (isLoading || user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //-------------------------------------
              // HEADER
              //-------------------------------------
              ProfileHeader(user: user!),
          
              //-------------------------------------
              // STATS
              //-------------------------------------
              ProfileStats(user: user!),
          
              //-------------------------------------
              // EXTRA INFO
              //-------------------------------------
              ProfileExtraInfo(user: user!),
          
              //-------------------------------------
              // OPTIONS
              //-------------------------------------
              ProfileOptions(
                onReservationsTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReservationHistoryPage(),
                    ),
                  );
                },
                onReviewsTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewsPage()),
                  );
                },
                onFavoritesTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesPage()),
                  );
                },
                onPqrTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PqrPage()),
                  );
                },
              ),
          
              //-------------------------------------
              // LOGOUT
              //-------------------------------------
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    //await authVM.logout();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Cerrar Sesión"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
