import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionService {

  static final ConnectionService instance = ConnectionService.internal();
  factory ConnectionService() => instance;
  ConnectionService.internal();

  bool hasConnection = true;
  Timer? timer;

  final StreamController<bool> connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => connectionController.stream;

  void initialize() {
    Connectivity().onConnectivityChanged.listen((results) {
      checkRealConnection();
    });

    timer = Timer.periodic(const Duration(seconds: 5), (time) {
      checkRealConnection();
    });
    
    checkRealConnection();
  }

  Future<void> checkRealConnection() async {
    try {
      bool isAlive = await InternetConnection().hasInternetAccess;
      
      if (isAlive != hasConnection) {
        updateStateConnection(isAlive);
      }
    } catch (e) {
      updateStateConnection(false);
    }
  }

  void updateStateConnection(bool newState) {
    hasConnection = newState;
    connectionController.add(newState);
  }

  Future<bool> checkAndExecute(BuildContext context, Future<void> Function() action) async {
    await checkRealConnection();

    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sin conexión a internet'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    await action();
    return true;
  }

}