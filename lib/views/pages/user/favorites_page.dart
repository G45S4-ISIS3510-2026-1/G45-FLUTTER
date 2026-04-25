import 'package:flutter/material.dart';
import 'package:g45_flutter/repositories/user_repository.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favoriteIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final repo = UserRepository();

    final favs = await repo.getFavorites();

    setState(() {
      favoriteIds = favs;
      isLoading = false;
    });

    print("FAVORITOS CARGADOS EN PAGE: $favoriteIds");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutores Favoritos"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteIds.isEmpty
              ? const Center(
                  child: Text(
                    "No tienes tutores favoritos",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteIds.length,
                  itemBuilder: (context, index) {
                    final tutorId = favoriteIds[index];

                    return ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text("Tutor ID: $tutorId"),
                      subtitle: const Text("Favorito guardado"),
                    );
                  },
                ),
    );
  }
}