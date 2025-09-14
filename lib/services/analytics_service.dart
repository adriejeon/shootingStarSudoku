import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/constants.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  static AnalyticsService get instance => _instance;
  AnalyticsService._internal();

  late FirebaseAnalytics _analytics;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _analytics = FirebaseAnalytics.instance;
    _isInitialized = true;
  }

  // 퍼즐 시작 이벤트
  Future<void> logPuzzleStarted(int difficulty, int puzzleId) async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: AppConstants.eventPuzzleStarted,
      parameters: {
        'difficulty': difficulty,
        'puzzle_id': puzzleId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // 퍼즐 완료 이벤트
  Future<void> logPuzzleCompleted(
    int difficulty, 
    int puzzleId, 
    int timeInSeconds,
    int hintCount,
    bool isPerfect
  ) async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: AppConstants.eventPuzzleCompleted,
      parameters: {
        'difficulty': difficulty,
        'puzzle_id': puzzleId,
        'time_seconds': timeInSeconds,
        'hint_count': hintCount,
        'is_perfect': isPerfect,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // 힌트 사용 이벤트
  Future<void> logHintUsed(int difficulty, int puzzleId, String hintType) async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: AppConstants.eventHintUsed,
      parameters: {
        'difficulty': difficulty,
        'puzzle_id': puzzleId,
        'hint_type': hintType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // 캐릭터 언락 이벤트
  Future<void> logCharacterUnlocked(String characterId, int starsRequired) async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: AppConstants.eventCharacterUnlocked,
      parameters: {
        'character_id': characterId,
        'stars_required': starsRequired,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // 광고 시청 이벤트
  Future<void> logAdViewed(String adType, String adUnitId) async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: AppConstants.eventAdViewed,
      parameters: {
        'ad_type': adType,
        'ad_unit_id': adUnitId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // 사용자 속성 설정
  Future<void> setUserProperty(String name, String value) async {
    if (!_isInitialized) return;
    
    await _analytics.setUserProperty(name: name, value: value);
  }

  // 사용자 ID 설정
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) return;
    
    await _analytics.setUserId(id: userId);
  }

  // 화면 조회 이벤트
  Future<void> logScreenView(String screenName) async {
    if (!_isInitialized) return;
    
    await _analytics.logScreenView(screenName: screenName);
  }

  // 커스텀 이벤트 로깅
  Future<void> logCustomEvent(String eventName, Map<String, dynamic> parameters) async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // 앱 시작 이벤트
  Future<void> logAppStart() async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: 'app_start',
      parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // 앱 종료 이벤트
  Future<void> logAppEnd() async {
    if (!_isInitialized) return;
    
    await _analytics.logEvent(
      name: 'app_end',
      parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
