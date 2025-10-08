import 'package:shared_preferences/shared_preferences.dart';

class DailyGameService {
  static const String _dailyGameCountKey = 'daily_game_count';
  static const String _lastGameDateKey = 'last_game_date';
  static const int _maxFreeGames = 2;

  // 오늘 게임 시작 횟수 가져오기
  static Future<int> getTodayGameCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split(
        'T',
      )[0]; // YYYY-MM-DD 형식
      final lastGameDate = prefs.getString(_lastGameDateKey);

      // 날짜가 바뀌었으면 카운트 리셋
      if (lastGameDate != today) {
        await prefs.setString(_lastGameDateKey, today);
        await prefs.setInt(_dailyGameCountKey, 0);
        return 0;
      }

      return prefs.getInt(_dailyGameCountKey) ?? 0;
    } catch (e) {
      print('오늘 게임 횟수 조회 실패: $e');
      return 0;
    }
  }

  // 게임 시작 횟수 증가
  static Future<void> incrementGameCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastGameDate = prefs.getString(_lastGameDateKey);

      // 날짜가 바뀌었으면 카운트 리셋
      if (lastGameDate != today) {
        await prefs.setString(_lastGameDateKey, today);
        await prefs.setInt(_dailyGameCountKey, 0);
        print('날짜 변경 감지 - 게임 횟수 초기화');
      }

      final currentCount = prefs.getInt(_dailyGameCountKey) ?? 0;
      final newCount = currentCount + 1;
      await prefs.setInt(_dailyGameCountKey, newCount);
      print('게임 시작 횟수 증가: $newCount');

      // 광고가 필요한지 확인
      final shouldShowAd = newCount >= _maxFreeGames;
      print(
        '광고 표시 필요: $shouldShowAd (현재 횟수: $newCount, 최대 무료: $_maxFreeGames)',
      );
    } catch (e) {
      print('게임 횟수 증가 실패: $e');
    }
  }

  // 광고가 필요한지 확인
  static Future<bool> shouldShowAd() async {
    final gameCount = await getTodayGameCount();
    final shouldShow = gameCount >= _maxFreeGames;
    print(
      '광고 표시 확인 - 현재 횟수: $gameCount, 최대 무료: $_maxFreeGames, 광고 표시: $shouldShow',
    );
    return shouldShow;
  }

  // 남은 무료 게임 횟수
  static Future<int> getRemainingFreeGames() async {
    final gameCount = await getTodayGameCount();
    return _maxFreeGames - gameCount;
  }

  // 오늘 게임 횟수 리셋 (테스트용)
  static Future<void> resetTodayGameCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_dailyGameCountKey, 0);
      print('오늘 게임 횟수 리셋 완료');
    } catch (e) {
      print('게임 횟수 리셋 실패: $e');
    }
  }

  // 현재 상태 디버그 출력
  static Future<void> debugCurrentState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastGameDate = prefs.getString(_lastGameDateKey);
      final gameCount = prefs.getInt(_dailyGameCountKey) ?? 0;

      print('=== 일일 게임 상태 디버그 ===');
      print('오늘 날짜: $today');
      print('마지막 게임 날짜: $lastGameDate');
      print('현재 게임 횟수: $gameCount');
      print('최대 무료 게임: $_maxFreeGames');
      print('광고 표시 필요: ${gameCount >= _maxFreeGames}');
      print('========================');
    } catch (e) {
      print('상태 디버그 실패: $e');
    }
  }
}
