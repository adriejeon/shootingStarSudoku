class AppConstants {
  // 앱 정보
  static const String appName = '별똥별 스도쿠';
  static const String appVersion = '1.0.0';
  
  // 난이도
  static const int easyDifficulty = 3;
  static const int mediumDifficulty = 6;
  static const int hardDifficulty = 9;
  
  // 게임 설정
  static const int maxHintCount = 3;
  static const int starsPerPuzzle = 10;
  static const int bonusStarsForPerfect = 5;
  
  // 애니메이션
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 1000);
  
  // 색상
  static const int primaryColor = 0xFF1E3A8A; // 파란색
  static const int secondaryColor = 0xFFF59E0B; // 노란색
  static const int accentColor = 0xFF8B5CF6; // 보라색
  static const int backgroundColor = 0xFF0F172A; // 어두운 배경
  static const int cardColor = 0xFF1E293B; // 카드 배경
  
  // 퍼즐 데이터
  static const String puzzleDataPath = 'assets/puzzles/';
  static const String easyPuzzleFile = 'easy_puzzles.json';
  static const String mediumPuzzleFile = 'medium_puzzles.json';
  static const String hardPuzzleFile = 'hard_puzzles.json';
  
  // 캐릭터 데이터
  static const String characterDataPath = 'assets/data/characters.json';
  
  // Hive 박스 이름
  static const String userProfilesBox = 'user_profiles';
  static const String gameStateBox = 'game_state';
  static const String settingsBox = 'settings';
  static const String charactersBox = 'characters';
  
  // 광고 ID (테스트용)
  static const String testBannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  
  // Firebase 이벤트
  static const String eventPuzzleStarted = 'puzzle_started';
  static const String eventPuzzleCompleted = 'puzzle_completed';
  static const String eventHintUsed = 'hint_used';
  static const String eventCharacterUnlocked = 'character_unlocked';
  static const String eventAdViewed = 'ad_viewed';
}
