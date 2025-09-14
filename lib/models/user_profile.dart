import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  final String name;
  final String avatar;
  final int totalStars;
  final List<String> unlockedCharacters;
  final Map<String, int> completedPuzzles; // difficulty -> count
  final Map<String, int> bestTimes; // difficulty -> best time in seconds
  final DateTime createdAt;
  final DateTime lastPlayedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatar,
    this.totalStars = 0,
    this.unlockedCharacters = const [],
    this.completedPuzzles = const {},
    this.bestTimes = const {},
    required this.createdAt,
    required this.lastPlayedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatar,
    int? totalStars,
    List<String>? unlockedCharacters,
    Map<String, int>? completedPuzzles,
    Map<String, int>? bestTimes,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      totalStars: totalStars ?? this.totalStars,
      unlockedCharacters: unlockedCharacters ?? this.unlockedCharacters,
      completedPuzzles: completedPuzzles ?? this.completedPuzzles,
      bestTimes: bestTimes ?? this.bestTimes,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  int getCompletedPuzzleCount(int difficulty) {
    return completedPuzzles[difficulty.toString()] ?? 0;
  }

  int getBestTime(int difficulty) {
    return bestTimes[difficulty.toString()] ?? 0;
  }

  void addCompletedPuzzle(int difficulty) {
    final key = difficulty.toString();
    completedPuzzles[key] = (completedPuzzles[key] ?? 0) + 1;
  }

  void updateBestTime(int difficulty, int timeInSeconds) {
    final key = difficulty.toString();
    final currentBest = bestTimes[key] ?? 0;
    if (currentBest == 0 || timeInSeconds < currentBest) {
      bestTimes[key] = timeInSeconds;
    }
  }

  void addStars(int stars) {
    totalStars += stars;
  }

  void unlockCharacter(String characterId) {
    if (!unlockedCharacters.contains(characterId)) {
      unlockedCharacters.add(characterId);
    }
  }
}
