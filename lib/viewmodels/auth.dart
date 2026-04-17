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

  u.User? userCache;

  Future<u.User?> getUserCache() async {
    if (userCache != null) {
      return userCache;
    }

    userCache = await userInCache();
    return userCache;
  }

  Future<u.User?> updateUserInterestedSkills(u.User user,String major) async {
    final updatedUser = await repository.updateUserInterestedSkills(user, major);
    if (updatedUser != null) {
      userCache = updatedUser;
      await saveUserInCache(updatedUser);
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

      await saveUserInCache(backendUser);

      return AuthState.selectSkills;
    }

    await saveUserInCache(backendUser);

    if (backendUser.interestedSkills.isEmpty) {
      return AuthState.selectSkills;
    }

    return AuthState.home;
  }

  Future<void> saveUserInCache(u.User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    await prefs.setString('usuario', jsonEncode(userJson));
  }

  Future<u.User?> userInCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if (userData == null) {
      return null;
    }

    return u.User.fromJson(jsonDecode(userData));
  }
}