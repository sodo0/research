import 'package:shared_preferences/shared_preferences.dart';

class StatisticsService {
  static const String _completedLessonsKey = 'completed_lessons';
  static const String _aiWinsKey = 'ai_wins';
  static const String _achievementAiBeaterKey = 'achievement_ai_beater';

  // Singleton instance
  static final StatisticsService _instance = StatisticsService._internal();
  factory StatisticsService() => _instance;
  StatisticsService._internal();

  Future<void> markLessonCompleted(String lessonTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedLessonsKey) ?? [];
    
    if (!completed.contains(lessonTitle)) {
      completed.add(lessonTitle);
      await prefs.setStringList(_completedLessonsKey, completed);
    }
  }

  Future<bool> isLessonCompleted(String lessonTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedLessonsKey) ?? [];
    return completed.contains(lessonTitle);
  }

  Future<List<String>> getCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedLessonsKey) ?? [];
  }
  
  // AI Win Tracking
  Future<void> recordAIWin() async {
    final prefs = await SharedPreferences.getInstance();
    int wins = prefs.getInt(_aiWinsKey) ?? 0;
    wins++;
    await prefs.setInt(_aiWinsKey, wins);
    
    // Unlock achievement on first win
    if (wins == 1) {
      await prefs.setBool(_achievementAiBeaterKey, true);
    }
  }

  Future<int> getAIWins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_aiWinsKey) ?? 0;
  }

  Future<bool> isAchievementUnlocked(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  // Method to clear progress (useful for testing/debugging)
  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedLessonsKey);
    await prefs.remove(_aiWinsKey);
    await prefs.remove(_achievementAiBeaterKey);
  }
}
