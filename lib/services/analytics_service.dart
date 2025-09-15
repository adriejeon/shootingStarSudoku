// import 'package:firebase_analytics/firebase_analytics.dart';
// import '../utils/constants.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  static AnalyticsService get instance => _instance;
  AnalyticsService._internal();

  // FirebaseAnalytics? _analytics;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // _analytics = FirebaseAnalytics.instance;
      _isInitialized = true;
      print('AnalyticsService: Initialized successfully (Firebase disabled)');
    } catch (e) {
      print('AnalyticsService: Initialization failed: $e');
      print('AnalyticsService: Continuing without analytics...');
      _isInitialized = false;
    }
  }

  // 퍼즐 시작 이벤트 (Firebase 비활성화)
  Future<void> logPuzzleStarted(int difficulty, int puzzleId) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print(
        'AnalyticsService: Puzzle started (Firebase disabled) - difficulty: $difficulty, puzzleId: $puzzleId',
      );
    } catch (e) {
      print('AnalyticsService: Failed to log puzzle started: $e');
    }
  }

  // 퍼즐 완료 이벤트 (Firebase 비활성화)
  Future<void> logPuzzleCompleted(
    int difficulty,
    int puzzleId,
    int timeInSeconds,
    int hintCount,
    bool isPerfect,
  ) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print(
        'AnalyticsService: Puzzle completed (Firebase disabled) - difficulty: $difficulty, puzzleId: $puzzleId, time: ${timeInSeconds}s, hints: $hintCount, perfect: $isPerfect',
      );
    } catch (e) {
      print('AnalyticsService: Failed to log puzzle completed: $e');
    }
  }

  // 힌트 사용 이벤트 (Firebase 비활성화)
  Future<void> logHintUsed(
    int difficulty,
    int puzzleId,
    String hintType,
  ) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print(
        'AnalyticsService: Hint used (Firebase disabled) - difficulty: $difficulty, puzzleId: $puzzleId, hintType: $hintType',
      );
    } catch (e) {
      print('AnalyticsService: Failed to log hint used: $e');
    }
  }

  // 캐릭터 기능 제거됨

  // 광고 시청 이벤트 (비활성화)
  // Future<void> logAdViewed(String adType, String adUnitId) async {
  //   if (!_isInitialized) return;

  //   await _analytics.logEvent(
  //     name: AppConstants.eventAdViewed,
  //     parameters: {
  //       'ad_type': adType,
  //       'ad_unit_id': adUnitId,
  //       'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     },
  //   );
  // }

  // 사용자 속성 설정 (Firebase 비활성화)
  Future<void> setUserProperty(String name, String value) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print(
        'AnalyticsService: User property set (Firebase disabled) - $name: $value',
      );
    } catch (e) {
      print('AnalyticsService: Failed to set user property: $e');
    }
  }

  // 사용자 ID 설정 (Firebase 비활성화)
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print('AnalyticsService: User ID set (Firebase disabled) - $userId');
    } catch (e) {
      print('AnalyticsService: Failed to set user ID: $e');
    }
  }

  // 화면 조회 이벤트 (Firebase 비활성화)
  Future<void> logScreenView(String screenName) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print('AnalyticsService: Screen view (Firebase disabled) - $screenName');
    } catch (e) {
      print('AnalyticsService: Failed to log screen view: $e');
    }
  }

  // 커스텀 이벤트 로깅 (Firebase 비활성화)
  Future<void> logCustomEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print(
        'AnalyticsService: Custom event (Firebase disabled) - $eventName: $parameters',
      );
    } catch (e) {
      print('AnalyticsService: Failed to log custom event: $e');
    }
  }

  // 앱 시작 이벤트 (Firebase 비활성화)
  Future<void> logAppStart() async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print('AnalyticsService: App start (Firebase disabled)');
    } catch (e) {
      print('AnalyticsService: Failed to log app start: $e');
    }
  }

  // 앱 종료 이벤트 (Firebase 비활성화)
  Future<void> logAppEnd() async {
    if (!_isInitialized) return;

    try {
      // Firebase 비활성화로 인해 로깅 비활성화
      print('AnalyticsService: App end (Firebase disabled)');
    } catch (e) {
      print('AnalyticsService: Failed to log app end: $e');
    }
  }
}
