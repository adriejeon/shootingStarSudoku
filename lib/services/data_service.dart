import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/puzzle.dart';
import '../models/user_profile.dart';
import '../models/character.dart';
import '../utils/constants.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  static DataService get instance => _instance;
  DataService._internal();

  late Box<UserProfile> _userProfilesBox;
  late Box<Map> _gameStateBox;
  late Box<Map> _settingsBox;
  late Box<Character> _charactersBox;

  Future<void> initialize() async {
    // Hive 어댑터 등록
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(CharacterAdapter());
    
    // 박스 열기
    _userProfilesBox = await Hive.openBox<UserProfile>(AppConstants.userProfilesBox);
    _gameStateBox = await Hive.openBox<Map>(AppConstants.gameStateBox);
    _settingsBox = await Hive.openBox<Map>(AppConstants.settingsBox);
    _charactersBox = await Hive.openBox<Character>(AppConstants.charactersBox);
    
    // 기본 데이터 로드
    await _loadDefaultCharacters();
  }

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
        '${AppConstants.puzzleDataPath}$fileName'
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
    await _userProfilesBox.put(profile.id, profile);
  }

  // 사용자 프로필 로드
  UserProfile? getUserProfile(String profileId) {
    return _userProfilesBox.get(profileId);
  }

  // 모든 사용자 프로필 로드
  List<UserProfile> getAllUserProfiles() {
    return _userProfilesBox.values.toList();
  }

  // 사용자 프로필 삭제
  Future<void> deleteUserProfile(String profileId) async {
    await _userProfilesBox.delete(profileId);
  }

  // 게임 상태 저장
  Future<void> saveGameState(String key, Map<String, dynamic> state) async {
    await _gameStateBox.put(key, state);
  }

  // 게임 상태 로드
  Map<String, dynamic>? getGameState(String key) {
    return _gameStateBox.get(key);
  }

  // 설정 저장
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  // 설정 로드
  T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  // 캐릭터 저장
  Future<void> saveCharacter(Character character) async {
    await _charactersBox.put(character.id, character);
  }

  // 캐릭터 로드
  Character? getCharacter(String characterId) {
    return _charactersBox.get(characterId);
  }

  // 모든 캐릭터 로드
  List<Character> getAllCharacters() {
    return _charactersBox.values.toList();
  }

  // 기본 캐릭터 데이터 로드
  Future<void> _loadDefaultCharacters() async {
    if (_charactersBox.isEmpty) {
      final defaultCharacters = [
        Character(
          id: 'star_1',
          name: '별똥별',
          description: '반짝반짝 빛나는 별똥별',
          imagePath: 'assets/images/characters/star_1.png',
          requiredStars: 0,
          isUnlocked: true,
          type: CharacterType.star,
        ),
        Character(
          id: 'planet_1',
          name: '지구',
          description: '우리가 사는 아름다운 행성',
          imagePath: 'assets/images/characters/planet_1.png',
          requiredStars: 50,
          isUnlocked: false,
          type: CharacterType.planet,
        ),
        Character(
          id: 'comet_1',
          name: '혜성',
          description: '긴 꼬리를 가진 우주 방문자',
          imagePath: 'assets/images/characters/comet_1.png',
          requiredStars: 100,
          isUnlocked: false,
          type: CharacterType.comet,
        ),
      ];
      
      for (final character in defaultCharacters) {
        await saveCharacter(character);
      }
    }
  }

  // 데이터 초기화
  Future<void> clearAllData() async {
    await _userProfilesBox.clear();
    await _gameStateBox.clear();
    await _settingsBox.clear();
    await _charactersBox.clear();
  }
}
