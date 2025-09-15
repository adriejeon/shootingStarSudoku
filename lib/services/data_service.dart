import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/puzzle.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  static DataService get instance => _instance;
  DataService._internal();

  late Box<UserProfile> _userProfilesBox;
  late Box<Map> _gameStateBox;
  late Box<Map> _settingsBox;
  bool _isInitialized = false;

  Future<void> initialize() async {
    // 박스 열기
    _userProfilesBox = await Hive.openBox<UserProfile>(
      AppConstants.userProfilesBox,
    );
    _gameStateBox = await Hive.openBox<Map>(AppConstants.gameStateBox);
    _settingsBox = await Hive.openBox<Map>(AppConstants.settingsBox);
    _isInitialized = true;
  }

  // 초기화 상태 확인
  bool get isInitialized => _isInitialized;

  // 퍼즐 데이터 로드
  Future<List<Puzzle>> loadPuzzles(int difficulty) async {
    try {
      String fileName;
      switch (difficulty) {
        case 3:
          fileName = AppConstants.easyPuzzleFile;
          break;
        case 6:
          fileName = AppConstants.mediumPuzzleFile;
          break;
        case 9:
          fileName = AppConstants.hardPuzzleFile;
          break;
        default:
          throw Exception('지원하지 않는 난이도입니다: $difficulty');
      }

      final String jsonString = await rootBundle.loadString(
        '${AppConstants.puzzleDataPath}$fileName',
      );

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Puzzle.fromJson(json)).toList();
    } catch (e) {
      print('퍼즐 데이터 로드 실패: $e');
      return [];
    }
  }

  // 사용자 프로필 저장
  Future<void> saveUserProfile(UserProfile profile) async {
    if (!_isInitialized) {
      print('DataService not initialized, skipping saveUserProfile');
      return;
    }
    print(
      'DataService: Saving profile ${profile.name} with completed levels: ${profile.completedLevels}',
    );
    await _userProfilesBox.put(profile.id, profile);
    print('DataService: Profile saved successfully');
  }

  // 사용자 프로필 로드
  UserProfile? getUserProfile(String profileId) {
    if (!_isInitialized) {
      print('DataService not initialized, returning null for getUserProfile');
      return null;
    }
    return _userProfilesBox.get(profileId);
  }

  // 모든 사용자 프로필 로드
  List<UserProfile> getAllUserProfiles() {
    if (!_isInitialized) {
      print(
        'DataService not initialized, returning empty list for getAllUserProfiles',
      );
      return [];
    }
    return _userProfilesBox.values.toList();
  }

  // 사용자 프로필 삭제
  Future<void> deleteUserProfile(String profileId) async {
    if (!_isInitialized) {
      print('DataService not initialized, skipping deleteUserProfile');
      return;
    }
    await _userProfilesBox.delete(profileId);
  }

  // 게임 상태 저장
  Future<void> saveGameState(String key, Map<String, dynamic> state) async {
    await _gameStateBox.put(key, state);
  }

  // 게임 상태 로드
  Map<String, dynamic>? getGameState(String key) {
    final result = _gameStateBox.get(key);
    return result?.cast<String, dynamic>();
  }

  // 설정 저장
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  // 설정 로드
  T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  // 캐릭터 기능 제거됨

  // 데이터 초기화
  Future<void> clearAllData() async {
    await _userProfilesBox.clear();
    await _gameStateBox.clear();
    await _settingsBox.clear();
  }
}
