import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart' as u;
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {
  loading,
  login,
  selectSkills,
  home,
}

class AuthViewModel extends ChangeNotifier {
  final repository = UserRepository();

  AuthState _authState = AuthState.loading;
  AuthState get authState => _authState;

  u.User? userCache;
  String? errorMessage;

  // ── INIT (REACTIVO) ───────────────────────────────────────
  void initState() {
    setAuthState(AuthState.loading);

    FirebaseAuth.instance.idTokenChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        userCache = null;
        setAuthState(AuthState.login);
        return;
      }

      try {
        // 🔥 importante para redirect login
        await firebaseUser.reload();

        userCache = await userInCache();

        if (userCache == null) {
          await syncWithBackend(firebaseUser);
        } else {
          resolveState();
        }
      } catch (e) {
        errorMessage = "Error auth: $e";
        setAuthState(AuthState.login);
      }
    });
  }

  // ── SKILLS ────────────────────────────────────────────────
  Future<void> updateUserInterestedSkills(u.User user, String major) async {
    final updatedUser = await repository.updateUserInterestedSkills(user, major);
    if (updatedUser != null) {
      userCache = updatedUser;
      await saveUserInCache(updatedUser);
      resolveState();
    }
  }

  Future<u.User?> getUserCache() async {
    if (userCache != null) return userCache;
    userCache = await userInCache();
    return userCache;
  }

  // ── CACHE ────────────────────────────────────────────────
  Future<void> saveUserInCache(u.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', jsonEncode(user.toJson()));
  }

  Future<u.User?> userInCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if (userData == null) return null;
    return u.User.fromJson(jsonDecode(userData));
  }

  // ── BACKEND ───────────────────────────────────────────────
  Future<void> syncWithBackend(User firebaseUser) async {
    try {
      u.User? backendUser =
          await repository.findUser(firebaseUser.email ?? '');

      backendUser ??= await repository.createUser(
        firebaseUser.uid,
        firebaseUser.displayName ?? '',
        firebaseUser.email ?? '',
      );

      userCache = backendUser;
      await saveUserInCache(backendUser);
      resolveState();
    } catch (e) {
      errorMessage = 'Error al sincronizar usuario: $e';
      setAuthState(AuthState.login);
    }
  }

  // ── STATE LOGIC ───────────────────────────────────────────
  void resolveState() {
    final next = (userCache?.interestedSkills.isEmpty ?? true)
        ? AuthState.selectSkills
        : AuthState.home;

    setAuthState(next);
  }

  void setAuthState(AuthState newState) {
    _authState = newState;
    notifyListeners();
  }

  // ── LOGOUT ────────────────────────────────────────────────
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    userCache = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');

    setAuthState(AuthState.login);
  }
}