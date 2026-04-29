import 'package:flutter/material.dart';
import 'package:g45_flutter/services/light_sensor_service.dart';
import 'dart:async';

class ThemeViewModel extends ChangeNotifier {
  final LightSensorService sensorService;

  ThemeViewModel(this.sensorService);

  ThemeMode themeMode = ThemeMode.system;

  StreamSubscription? subscription;

  Future<void> initialize() async {
    await sensorService.initialize();

    subscription = sensorService.isDarkStream.listen((isDark) {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}