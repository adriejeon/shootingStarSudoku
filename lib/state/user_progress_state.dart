import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../models/character.dart';
import '../services/data_service.dart';

class UserProgressState extends ChangeNotifier {
  UserProfile? _currentProfile;
  List<Character> _characters = [];
  final DataService _dataService = DataService.instance;

  // Getters
  UserProfile? get currentProfile => _currentProfile;
  List<Character> get characters => _characters;
  int get totalStars => _currentProfile?.totalStars ?? 0;
  List<Character> get unlockedCharacters => 
      _characters.where((c) => c.isUnlocked).toList();

  // 프로필 설정
  void setProfile(UserProfile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  // 캐릭터 로드
  Future<void> loadCharacters() async {
    _characters = _dataService.getAllCharacters();
    notifyListeners();
  }

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
  void completePuzzle(int difficulty, int timeInSeconds) {
    if (_currentProfile == null) return;
    
    final key = difficulty.toString();
    final completedCount = _currentProfile!.completedPuzzles[key] ?? 0;
    final bestTime = _currentProfile!.bestTimes[key] ?? 0;
    
    // 완료 수 증가
    final newCompletedPuzzles = Map<String, int>.from(_currentProfile!.completedPuzzles);
    newCompletedPuzzles[key] = completedCount + 1;
    
    // 최고 기록 업데이트
    final newBestTimes = Map<String, int>.from(_currentProfile!.bestTimes);
    if (bestTime == 0 || timeInSeconds < bestTime) {
      newBestTimes[key] = timeInSeconds;
    }
    
    // 별 추가 (기본 10개 + 완벽한 경우 보너스 5개)
    int starsEarned = 10;
    if (timeInSeconds < (difficulty == 3 ? 60 : difficulty == 6 ? 300 : 600)) {
      starsEarned += 5; // 완벽한 시간 내 완료 시 보너스
    }
    
    _currentProfile = _currentProfile!.copyWith(
      totalStars: _currentProfile!.totalStars + starsEarned,
      completedPuzzles: newCompletedPuzzles,
      bestTimes: newBestTimes,
      lastPlayedAt: DateTime.now(),
    );
    
    _dataService.saveUserProfile(_currentProfile!);
    _checkCharacterUnlocks();
    notifyListeners();
  }

  // 캐릭터 언락 확인
  void _checkCharacterUnlocks() {
    if (_currentProfile == null) return;
    
    for (final character in _characters) {
      if (!character.isUnlocked && 
          _currentProfile!.totalStars >= character.requiredStars) {
        unlockCharacter(character.id);
      }
    }
  }

  // 캐릭터 언락
  void unlockCharacter(String characterId) {
    if (_currentProfile == null) return;
    
    final characterIndex = _characters.indexWhere((c) => c.id == characterId);
    if (characterIndex != -1) {
      _characters[characterIndex] = _characters[characterIndex].copyWith(
        isUnlocked: true,
      );
      _dataService.saveCharacter(_characters[characterIndex]);
      
      // 프로필에 언락된 캐릭터 추가
      if (!_currentProfile!.unlockedCharacters.contains(characterId)) {
        final newUnlockedCharacters = List<String>.from(_currentProfile!.unlockedCharacters);
        newUnlockedCharacters.add(characterId);
        
        _currentProfile = _currentProfile!.copyWith(
          unlockedCharacters: newUnlockedCharacters,
        );
        _dataService.saveUserProfile(_currentProfile!);
      }
      
      notifyListeners();
    }
  }

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

  // 프로필 초기화
  void resetProfile() {
    _currentProfile = null;
    _characters.clear();
    notifyListeners();
  }
}
