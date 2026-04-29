import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:g45_flutter/config/api_config.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService._();
  AnalyticsService._();

  final FirebaseAnalytics _fa = FirebaseAnalytics.instance;

  // BQ1: tag which screen/service is active for Crashlytics
  void setCurrentService(String service) {
    FirebaseCrashlytics.instance.setCustomKey('current_service', service);
  }

  // BQ1: record a caught error to Crashlytics + G45-Analytics dashboard
  Future<void> reportError(
    String service,
    String message, [
    Object? error,
    StackTrace? stack,
  ]) async {
    FirebaseCrashlytics.instance.setCustomKey('error_source', service);
    if (error != null) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: message,
      );
    } else {
      FirebaseCrashlytics.instance.log('Error in $service: $message');
    }
    await _post('crash_reported', {'service': service, 'message': message});
  }

  // BQ4, BQ5: log event to Firebase Analytics + G45-Analytics
  Future<void> logEvent(String eventType, Map<String, dynamic> metadata) async {
    final faParams = <String, Object>{};
    metadata.forEach(
      (k, v) =>
          faParams[k] = v is String || v is num || v is bool ? v : v.toString(),
    );
    await _fa.logEvent(name: eventType, parameters: faParams);
    await _post(eventType, metadata);
  }

  Future<void> _post(String eventType, Map<String, dynamic> metadata) async {
    try {
      await http.post(
        Uri.parse('${ApiConfig.analyticsUrl}/analytics/event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
          'event_type': eventType,
          'metadata': metadata,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } catch (_) {}
  }

  Future<void> setUserId(String userId) async {
    await _fa.setUserId(id: userId);
  }
}
