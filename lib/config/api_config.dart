/// Centralized API configuration.
///
/// Switch [baseUrl] depending on your target platform:
/// - Android emulator: `http://10.0.2.2:8000`
/// - Chrome / Web:     `http://127.0.0.1:8000`
/// - Physical device:  `http://<your-local-ip>:8000`
class ApiConfig {
  // ── Toggle this line to switch environments ──
  // static const String baseUrl = "http://10.0.2.2:8000";
  static const String baseUrl =
      "https://g45-backend.onrender.com"; // Web / Chrome
  static const String analyticsUrl = "http://127.0.0.1:8001";
}
