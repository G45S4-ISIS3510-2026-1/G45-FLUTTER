// ignore_for_file: prefer_conditional_assignment

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

  static final AuthViewModel instance = AuthViewModel.internal();
  factory AuthViewModel() => instance;
  AuthViewModel.internal();

  AuthState _authState = AuthState.loading;
  AuthState get authState => _authState;

  u.User? userCache;
  String? errorMessage;

  void startListening() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      // await FirebaseAuth.instance.signOut();
      if (user == null) {
        setAuthState(AuthState.login);
        return;
      }

      userCache = await userInCache();
      if (userCache == null) {
        await syncWithBackend(user);
      } else {
        resolveState();
      }
    });
  }

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

  Future<void> syncWithBackend(User firebaseUser) async {
    try {
      u.User? backendUser = await repository.findUser(firebaseUser.email ?? '');

      if(backendUser == null) {
        backendUser = await repository.createUser(
          firebaseUser.uid,
          firebaseUser.displayName ?? 'Usuario',
          firebaseUser.email ?? '',
        );
      }

      userCache = backendUser;
      await saveUserInCache(backendUser);
      resolveState();
    } catch (e) {
      // Si el usuario fue borrado de Firebase
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('usuario');
      userCache = null;
      errorMessage = 'Sesión inválida';
      setAuthState(AuthState.login);
    }
  }

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
}