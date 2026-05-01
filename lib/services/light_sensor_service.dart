import 'dart:async';
import 'package:ambient_light/ambient_light.dart';

class LightSensorService {
  static final LightSensorService instance = LightSensorService.internal();
  factory LightSensorService() => instance;
  LightSensorService.internal();

  static const double darkThreshold = 50.0;
  static const int debounceMs = 500;
  static const double luxThresholdDifference = 10.0;

  final StreamController<bool> isDarkController =
      StreamController<bool>.broadcast();
  Stream<bool> get isDarkStream => isDarkController.stream;

  bool isDark = false;
  double lastLux = -1;

  StreamSubscription? sensorSubscription;
  Timer? debounceTimer;

  /// Gets the initial light value from the sensor
  Future<bool> getInitialTheme() async {
    try {
      final firstLuxValue = await AmbientLight()
          .ambientLightStream
          .first
          .timeout(const Duration(seconds: 2));
      lastLux = firstLuxValue;
      return firstLuxValue < darkThreshold;
    } catch (e) {
      // Fallback to light mode if sensor fails
      return false;
    }
  }

  Future<void> initialize() async {
    try {
      sensorSubscription = AmbientLight()
          .ambientLightStream
          .listen((double lux) {
        // Debounce rapid changes and only emit on significant differences
        if ((lastLux < 0) || (lastLux - lux).abs() > luxThresholdDifference) {
          lastLux = lux;
          debounceTimer?.cancel();
          debounceTimer = Timer(Duration(milliseconds: debounceMs), () {
            final shouldBeDark = lux < darkThreshold;
            if (shouldBeDark != isDark) {
              isDark = shouldBeDark;
              isDarkController.add(isDark);
            }
          });
        }
      });
    } catch (e) {
      return;
    }
  }

  void dispose() {
    sensorSubscription?.cancel();
    debounceTimer?.cancel();
    isDarkController.close();
  }
}