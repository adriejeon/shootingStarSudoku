import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/data_service.dart';
import '../utils/helpers.dart';

class ProfileManagerState extends ChangeNotifier {
  List<UserProfile> _profiles = [];
  UserProfile? _activeProfile;
  final DataService _dataService = DataService.instance;

  // Getters
  List<UserProfile> get profiles => _profiles;
  UserProfile? get activeProfile => _activeProfile;
  int get profileCount => _profiles.length;

  // 프로필 로드
  Future<void> loadProfiles() async {
    print('ProfileManagerState: Loading profiles...');
    _profiles = _dataService.getAllUserProfiles();
    print('ProfileManagerState: Loaded ${_profiles.length} profiles');

    if (_profiles.isNotEmpty && _activeProfile == null) {
      _activeProfile = _profiles.first;
      print('ProfileManagerState: Set active profile: ${_activeProfile!.name}');
    } else if (_profiles.isEmpty) {
      print('ProfileManagerState: No profiles found');
    }
    notifyListeners();
  }

  // 프로필 생성
  Future<UserProfile> createProfile(String name, String avatar) async {
    print('ProfileManagerState: Creating profile: $name');

    final profile = UserProfile(
      id: AppHelpers.generateId(),
      name: name,
      avatar: avatar,
      createdAt: DateTime.now(),
      lastPlayedAt: DateTime.now(),
    );

    print('ProfileManagerState: Saving profile to database...');
    await _dataService.saveUserProfile(profile);
    _profiles.add(profile);

    // 항상 새로 생성된 프로필을 활성 프로필로 설정
    _activeProfile = profile;
    print('ProfileManagerState: Set active profile: ${_activeProfile!.name}');

    notifyListeners();
    return profile;
  }

  // 활성 프로필 변경
  void setActiveProfile(UserProfile profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  // 프로필 업데이트
  Future<void> updateProfile(UserProfile profile) async {
    await _dataService.saveUserProfile(profile);

    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
    }

    if (_activeProfile?.id == profile.id) {
      _activeProfile = profile;
    }

    notifyListeners();
  }

  // 프로필 삭제
  Future<void> deleteProfile(String profileId) async {
    await _dataService.deleteUserProfile(profileId);
    _profiles.removeWhere((p) => p.id == profileId);

    if (_activeProfile?.id == profileId) {
      _activeProfile = _profiles.isNotEmpty ? _profiles.first : null;
    }

    notifyListeners();
  }

  // 프로필 이름 변경
  Future<void> renameProfile(String profileId, String newName) async {
    final profile = _profiles.firstWhere((p) => p.id == profileId);
    final updatedProfile = profile.copyWith(name: newName);
    await updateProfile(updatedProfile);
  }

  // 프로필 아바타 변경
  Future<void> changeAvatar(String profileId, String newAvatar) async {
    final profile = _profiles.firstWhere((p) => p.id == profileId);
    final updatedProfile = profile.copyWith(avatar: newAvatar);
    await updateProfile(updatedProfile);
  }

  // 프로필 통계
  Map<String, dynamic> getProfileStats(String profileId) {
    final profile = _profiles.firstWhere((p) => p.id == profileId);

    int totalCompleted = 0;
    for (final count in profile.completedPuzzles.values) {
      totalCompleted += count;
    }

    return {
      'totalStars': profile.totalStars,
      'totalCompleted': totalCompleted,
      'createdAt': profile.createdAt,
      'lastPlayedAt': profile.lastPlayedAt,
    };
  }

  // 프로필 정렬 (별 개수 기준)
  void sortProfilesByStars() {
    _profiles.sort((a, b) => b.totalStars.compareTo(a.totalStars));
    notifyListeners();
  }

  // 프로필 정렬 (최근 플레이 기준)
  void sortProfilesByLastPlayed() {
    _profiles.sort((a, b) => b.lastPlayedAt.compareTo(a.lastPlayedAt));
    notifyListeners();
  }

  // 프로필 정렬 (이름 기준)
  void sortProfilesByName() {
    _profiles.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  // 프로필 검색
  List<UserProfile> searchProfiles(String query) {
    if (query.isEmpty) return _profiles;

    return _profiles
        .where(
          (profile) => profile.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // 프로필 초기화
  void reset() {
    _profiles.clear();
    _activeProfile = null;
    notifyListeners();
  }
}
