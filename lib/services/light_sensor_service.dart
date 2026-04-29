import 'dart:async';
import 'package:ambient_light/ambient_light.dart';

class LightSensorService {
  static final LightSensorService instance = LightSensorService.internal();
  factory LightSensorService() => instance;
  LightSensorService.internal();

  static const double darkThreshold = 50.0;

  final StreamController<bool> isDarkController =
      StreamController<bool>.broadcast();
  Stream<bool> get isDarkStream => isDarkController.stream;

  bool isDark = false;

  StreamSubscription? sensorSubscription;

  Future<void> initialize() async {
    try {
      sensorSubscription = AmbientLight().ambientLightStream.listen((double lux) {
        final shouldBeDark = lux < darkThreshold;
        if (shouldBeDark != isDark) {
          isDark = shouldBeDark;
          isDarkController.add(isDark);
        }
      });
    } catch (e) {
      return;
    }
  }

  void dispose() {
    sensorSubscription?.cancel();
    isDarkController.close();
  }
}