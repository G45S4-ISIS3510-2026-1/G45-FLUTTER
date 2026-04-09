import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart' as u;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // necesario para detectar web

enum AuthState {
  loading,
  login,
  selectSkills,
  home,
}

class AuthViewModel {
  final repository = UserRepository();

  static final AuthViewModel instance = AuthViewModel.internal();
  factory AuthViewModel() => instance;
  AuthViewModel.internal();

  u.User? usuarioCache;

  Future<u.User?> getUsuarioCache() async {
    if (usuarioCache != null) {
      print("Returning cached user (memory)");
      return usuarioCache;
    }

    print("Loading user from SharedPreferences");
    usuarioCache = await usuarioEnCache();
    print("User from cache: $usuarioCache");

    return usuarioCache;
  }

  Future<u.User?> updateUsuarioInterestedSkills(u.User user, String major) async {
    print("Updating user skills with major: $major");

    final updatedUser = await repository.updateUsuarioInterestedSkills(user, major);

    print("Updated user response: $updatedUser");

    if (updatedUser != null) {
      usuarioCache = updatedUser;
      await guardarUsuarioCache(updatedUser);
    }

    return updatedUser;
  }

  Future<AuthState> handleLogin() async {

    // bypass SOLO para móvil mientras no tengas Microsoft OAuth
    if (!kIsWeb) {
      print("Bypass auth for mobile");
      return AuthState.home;
    }

    final user = FirebaseAuth.instance.currentUser;

    print("Firebase user: $user");

    if (user == null) {
      print("No Firebase user → go LOGIN");
      return AuthState.login;
    }

    print("Calling backend with email: ${user.email}");

    u.User? backendUser = await repository.findUser(user.email ?? "");

    print("Backend user response: $backendUser");

    if (backendUser == null) {
      print("User NOT found → creating user");

      backendUser = await repository.createUser(
        user.uid,
        user.displayName ?? "",
        user.email ?? "",
      );

      print("Created user: $backendUser");

      if (backendUser == null) {
        print("ERROR: createUser returned null");
        return AuthState.login;
      }

      await guardarUsuarioCache(backendUser);

      print("Go SELECT SKILLS (new user)");
      return AuthState.selectSkills;
    }

    await guardarUsuarioCache(backendUser);

    print("User skills: ${backendUser.interestedSkills}");

    if (backendUser.interestedSkills.isEmpty) {
      print("No skills → go SELECT SKILLS");
      return AuthState.selectSkills;
    }

    print("Go HOME");
    return AuthState.home;
  }

  Future<void> guardarUsuarioCache(u.User user) async {
    print("Saving user to cache");

    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson();

    await prefs.setString('usuario', jsonEncode(userJson));

    print("User saved in cache");
  }

  Future<u.User?> usuarioEnCache() async {
    print("Reading user from SharedPreferences");

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');

    if (userData == null) {
      print("No user in cache");
      return null;
    }

    final user = u.User.fromJson(jsonDecode(userData));

    print("User loaded from cache: $user");

    return user;
  }
}