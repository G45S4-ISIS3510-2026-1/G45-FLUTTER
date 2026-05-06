import 'package:flutter/material.dart';
import 'package:g45_flutter/services/light_sensor_service.dart';
import 'dart:async';

class ThemeViewModel extends ChangeNotifier {
  final LightSensorService sensorService;

  ThemeViewModel(this.sensorService);

  ThemeMode themeMode = ThemeMode.system;
  bool _isDark = false;

  StreamSubscription? subscription;

  Future<void> initialize() async {
    try {
      // Get initial theme value before listening to stream
      _isDark = await sensorService.getInitialTheme();
      themeMode = _isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      // Fallback to system theme on error
      themeMode = ThemeMode.system;
    }

    // Initialize sensor and listen to changes
    await sensorService.initialize();

    subscription = sensorService.isDarkStream.listen((isDark) {
      _setDark(isDark);
    });
  }

  void _setDark(bool isDark) {
    if (_isDark != isDark) {
      _isDark = isDark;
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}