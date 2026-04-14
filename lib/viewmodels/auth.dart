import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart' as u;
import 'package:shared_preferences/shared_preferences.dart';
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
      return usuarioCache;
    }

    usuarioCache = await usuarioEnCache();
    return usuarioCache;
  }

  Future<u.User?> updateUsuarioInterestedSkills(u.User user,String major) async {
    final updatedUser = await repository.updateUsuarioInterestedSkills(user, major);
    if (updatedUser != null) {
      usuarioCache = updatedUser;
      await guardarUsuarioCache(updatedUser);
    }
    return updatedUser;
  }

  Future<AuthState> handleLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return AuthState.login;
    }

    u.User? backendUser = await repository.findUser(user.email ?? "");
    if (backendUser == null) {
      backendUser = await repository.createUser(
        user.uid,
        user.displayName ?? "",
        user.email ?? "",
      );

      await guardarUsuarioCache(backendUser);

      return AuthState.selectSkills;
    }

    await guardarUsuarioCache(backendUser);

    if (backendUser.interestedSkills.isEmpty) {
      return AuthState.selectSkills;
    }

    return AuthState.home;
  }

  Future<void> guardarUsuarioCache(u.User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    await prefs.setString('usuario', jsonEncode(userJson));
  }

  Future<u.User?> usuarioEnCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if (userData == null) {
      return null;
    }

    return u.User.fromJson(jsonDecode(userData));
  }
}