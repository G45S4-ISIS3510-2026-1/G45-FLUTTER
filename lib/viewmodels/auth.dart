import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/services/conection_service.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart' as u;
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState { loading, login, selectSkills, home }

class AuthViewModel extends ChangeNotifier {
  static final AuthViewModel instance = AuthViewModel.internal();
  factory AuthViewModel() => instance;
  AuthViewModel.internal();

  final repository = UserRepository();

  AuthState _authState = AuthState.loading;
  AuthState get authState => _authState;

  u.User? userCache;
  String? errorMessage;

  void startListening() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      setAuthState(AuthState.loading);

      if (user == null) {
        setAuthState(AuthState.login);
        return;
      }

      userCache = await getUserCache();

      if (userCache != null && !ConnectionService().hasConnection) {
        resolveState();
        return;
      }

      await syncWithBackend(user);
    });
  }

  Future<void> updateUserInterestedSkills(u.User user, String major) async {
    setAuthState(AuthState.loading);

    try {
      final updatedUser = await repository.updateUserInterestedSkills(user, major);
      if (updatedUser != null) {
        userCache = updatedUser;
        await saveUserInCache(updatedUser);
        resolveState();
      } else {
        resolveState();
      }
    } catch (e) {
      errorMessage = 'Error al guardar carrera: $e';
      resolveState();
    }
  }

  Future<void> saveUserInCache(u.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', jsonEncode(user.toJson()));
  }

  Future<u.User?> getUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if (userData == null) return null;
    return u.User.fromJson(jsonDecode(userData));
  }

  Future<void> syncWithBackend(User firebaseUser) async {
    try {
      u.User? backendUser = await repository.findUser(firebaseUser.email ?? '');

      if (backendUser == null) {
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
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('usuario');
      userCache = null;
      errorMessage = 'Sesión inválida';
      setAuthState(AuthState.login);
    }
  }

  Future<void> refreshUser() async {
    if (userCache == null) return;
    if (!ConnectionService().hasConnection) return;

    try {
      final fetched = await repository.getUserById(userCache!.id!);
      userCache = fetched;
      await saveUserInCache(fetched);
      notifyListeners();
    } catch (e) {
      // queda con el cache, no hacer signOut
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

  Future<void> logout() async {
    setAuthState(AuthState.loading);

    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
    userCache = null;

    setAuthState(AuthState.login);
  }
}