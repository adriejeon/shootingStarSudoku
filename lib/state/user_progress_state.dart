import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/data_service.dart';
import 'profile_manager_state.dart';

class UserProgressState extends ChangeNotifier {
  UserProfile? _currentProfile;
  final DataService _dataService = DataService.instance;
  ProfileManagerState? _profileManager;

  // Getters
  UserProfile? get currentProfile => _currentProfile;
  int get totalStars => _currentProfile?.totalStars ?? 0;

  // ProfileManagerState 설정
  void setProfileManager(ProfileManagerState profileManager) {
    print('UserProgressState: Setting profile manager...');
    _profileManager = profileManager;
    _loadCurrentProfile();

    // ProfileManagerState의 변경사항을 구독
    profileManager.addListener(_onProfileManagerChanged);
  }

  // ProfileManagerState 변경사항 감지
  void _onProfileManagerChanged() {
    print('UserProgressState: ProfileManager changed, reloading profile...');
    _loadCurrentProfile();
  }

  // 현재 프로필 로드
  void _loadCurrentProfile() {
    print('UserProgressState: Loading current profile...');
    if (_profileManager != null) {
      print('UserProgressState: ProfileManager found');
      print(
        'UserProgressState: ProfileManager profiles count: ${_profileManager!.profiles.length}',
      );
      print(
        'UserProgressState: ProfileManager active profile: ${_profileManager!.activeProfile?.name ?? 'null'}',
      );

      if (_profileManager!.activeProfile != null) {
        _currentProfile = _profileManager!.activeProfile;
        print(
          'UserProgressState: Active profile loaded: ${_currentProfile!.name}',
        );
        print(
          'UserProgressState: Profile completed levels: ${_currentProfile!.completedLevels}',
        );
        print(
          'UserProgressState: Profile total stars: ${_currentProfile!.totalStars}',
        );
        notifyListeners();
      } else {
        print('UserProgressState: No active profile found');
        // 프로필이 없으면 null로 설정하고 알림
        _currentProfile = null;
        notifyListeners();
      }
    } else {
      print('UserProgressState: ProfileManager is null');
      _currentProfile = null;
      notifyListeners();
    }
  }

  // 프로필 설정
  void setProfile(UserProfile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  // 캐릭터 기능 제거됨

  // 별 추가
  void addStars(int stars) {
    if (_currentProfile == null) return;

    _currentProfile = _currentProfile!.copyWith(
      totalStars: _currentProfile!.totalStars + stars,
    );
    _dataService.saveUserProfile(_currentProfile!);
    notifyListeners();
  }

  // 퍼즐 완료 처리
  void completePuzzle(
    int difficulty,
    int timeInSeconds, {
    int? stageNumber,
    int? levelNumber,
  }) {
    if (_currentProfile == null) return;

    final key = difficulty.toString();
    final completedCount = _currentProfile!.completedPuzzles[key] ?? 0;
    final bestTime = _currentProfile!.bestTimes[key] ?? 0;

    // 완료 수 증가
    final newCompletedPuzzles = Map<String, int>.from(
      _currentProfile!.completedPuzzles,
    );
    newCompletedPuzzles[key] = completedCount + 1;

    // 최고 기록 업데이트
    final newBestTimes = Map<String, int>.from(_currentProfile!.bestTimes);
    if (bestTime == 0 || timeInSeconds < bestTime) {
      newBestTimes[key] = timeInSeconds;
    }

    // 별 추가 (기본 10개 + 완벽한 경우 보너스 5개)
    int starsEarned = 10;
    if (timeInSeconds <
        (difficulty == 3
            ? 60
            : difficulty == 6
            ? 300
            : 600)) {
      starsEarned += 5; // 완벽한 시간 내 완료 시 보너스
    }

    // 레벨 완료 상태도 함께 업데이트
    Map<String, bool> newCompletedLevels = Map.from(
      _currentProfile!.completedLevels,
    );
    if (stageNumber != null && levelNumber != null) {
      String levelKey = '$stageNumber-$levelNumber';
      newCompletedLevels[levelKey] = true;
    }

    _currentProfile = _currentProfile!.copyWith(
      totalStars: _currentProfile!.totalStars + starsEarned,
      completedPuzzles: newCompletedPuzzles,
      bestTimes: newBestTimes,
      lastPlayedAt: DateTime.now(),
      completedLevels: newCompletedLevels, // 업데이트된 완료 레벨
      visitedStages: _currentProfile!.visitedStages, // 기존 방문 스테이지 보존
    );

    _dataService.saveUserProfile(_currentProfile!);
    notifyListeners();
  }

  // 캐릭터 기능 제거됨

  // 난이도별 완료 수
  int getCompletedCount(int difficulty) {
    if (_currentProfile == null) return 0;
    return _currentProfile!.getCompletedPuzzleCount(difficulty);
  }

  // 난이도별 최고 기록
  int getBestTime(int difficulty) {
    if (_currentProfile == null) return 0;
    return _currentProfile!.getBestTime(difficulty);
  }

  // 스테이지 레벨 완료 상태 확인
  bool isLevelCompleted(int stageNumber, int levelNumber) {
    if (_currentProfile == null) {
      // 프로필이 없으면 자동으로 프로필을 다시 로드 시도
      _loadCurrentProfile();
      return false;
    }
    bool completed = _currentProfile!.isLevelCompleted(
      stageNumber,
      levelNumber,
    );
    print('Level $stageNumber-$levelNumber completed: $completed');
    return completed;
  }

  // 스테이지 레벨 완료 처리
  void completeLevel(
    int stageNumber,
    int levelNumber,
    int difficulty,
    int timeInSeconds,
  ) {
    print(
      'UserProgressState: Attempting to complete level $stageNumber-$levelNumber',
    );
    print(
      'UserProgressState: Current profile: ${_currentProfile?.name ?? 'null'}',
    );

    if (_currentProfile == null) {
      print('UserProgressState: No profile found for level completion');
      // 프로필을 다시 로드 시도
      _loadCurrentProfile();
      if (_currentProfile == null) {
        print('UserProgressState: Still no profile after reload attempt');
        return;
      }
    }

    print('UserProgressState: Completing level $stageNumber-$levelNumber');

    // 퍼즐 완료 로직 실행 (별, 기록, 레벨 완료 상태 모두 처리) - 이 안에서 프로필 저장됨
    completePuzzle(
      difficulty,
      timeInSeconds,
      stageNumber: stageNumber,
      levelNumber: levelNumber,
    );

    print(
      'UserProgressState: Updated completed levels: ${_currentProfile!.completedLevels}',
    );

    // 상태 변경 알림 - 여러 번 호출하여 확실하게 알림
    notifyListeners();

    // 추가로 약간의 지연 후 다시 알림 (UI 업데이트 보장)
    Future.delayed(const Duration(milliseconds: 50), () {
      notifyListeners();
    });

    print('UserProgressState: Level completion process finished');
  }

  // 스테이지 방문 상태 확인
  bool isStageVisited(int stageNumber) {
    if (_currentProfile == null) {
      // 프로필이 없으면 자동으로 프로필을 다시 로드 시도
      _loadCurrentProfile();
      return false;
    }
    return _currentProfile!.isStageVisited(stageNumber);
  }

  // 스테이지 방문 처리
  void visitStage(int stageNumber) {
    if (_currentProfile == null) return;

    _currentProfile = _currentProfile!.visitStage(stageNumber);
    _dataService.saveUserProfile(_currentProfile!);
    notifyListeners();
  }

  // 스테이지 완료 상태 확인 (모든 레벨 완료 여부)
  bool isStageCompleted(int stageNumber) {
    if (_currentProfile == null) return false;

    // 각 스테이지마다 20개의 레벨이 있다고 가정
    for (int level = 1; level <= 20; level++) {
      if (!isLevelCompleted(stageNumber, level)) {
        return false;
      }
    }
    return true;
  }

  // 스테이지 잠금 상태 확인
  bool isStageLocked(int stageNumber) {
    if (stageNumber == 1) return false; // 첫 번째 스테이지는 항상 열림

    // 이전 스테이지가 완료되었는지 확인
    return !isStageCompleted(stageNumber - 1);
  }

  // 프로필 초기화
  void resetProfile() {
    _currentProfile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // ProfileManagerState 리스너 제거
    _profileManager?.removeListener(_onProfileManagerChanged);
    super.dispose();
  }
}
