import 'package:shared_preferences/shared_preferences.dart';

class RecentViewedService {
  static final RecentViewedService instance = RecentViewedService.internal();
  factory RecentViewedService() => instance;
  RecentViewedService.internal();

  static const int maxIds = 10;
  static const String cacheKey = 'recent_viewed_tutors';

  List<String> viewedIds = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    viewedIds = prefs.getStringList(cacheKey) ?? [];
  }

  Future<void> addTutor(String tutorId) async {
    viewedIds.remove(tutorId);
    viewedIds.insert(0, tutorId);
    if (viewedIds.length > maxIds) {
      viewedIds.removeLast();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(cacheKey, viewedIds);
  }

  List<String> get ids => List.unmodifiable(viewedIds);
}