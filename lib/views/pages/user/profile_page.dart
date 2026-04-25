import 'package:flutter/material.dart';
import 'package:g45_flutter/models/user.dart';
import 'package:g45_flutter/services/conection_service.dart';
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
import 'package:g45_flutter/views/pages/tutor/become_tutor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadUser();
      if (mounted) {
        Provider.of<AuthViewModel>(context, listen: false).refreshUser();
      }
    });
  }

  Future<void> loadUser() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final cached = await authVM.getUserCache();
    setState(() {
      user = cached;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    if (authVM.userCache != null && authVM.userCache != user) {
      user = authVM.userCache;
    }

    if (isLoading || user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(user: user!),
              if (user!.isTutoring)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD15C),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Ver agenda de tutor"),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ConnectionService().checkAndExecute(context, () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BecomeTutor()),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD15C),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Conviertete en tutor!"),
                    ),
                  ),
                ),
              ProfileStats(user: user!),
              ProfileExtraInfo(user: user!),
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
                }, onPqrTap: () {  },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    ConnectionService().checkAndExecute(context, () async {
                      await authVM.logout();
                    });
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