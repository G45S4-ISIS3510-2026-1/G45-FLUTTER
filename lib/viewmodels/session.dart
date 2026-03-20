import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g45_flutter/repositories/session_repository.dart';
import '../repositories/user_repository.dart';
import '../models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionViewModel {
  final repository = SessionRepository();

  static final SessionViewModel instance = SessionViewModel.internal();
  factory SessionViewModel() => instance;
  SessionViewModel.internal();

  Session? session;

  Future<List<Session>> getSessionsByStudent(String studentId) async {
    return await repository.getSessionsByStudent(studentId);
  }

}