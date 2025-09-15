import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserProfile {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String avatar;
  @HiveField(3)
  final int totalStars;
  @HiveField(4)
  final Map<String, int> completedPuzzles; // difficulty -> count
  @HiveField(5)
  final Map<String, int> bestTimes; // difficulty -> best time in seconds
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime lastPlayedAt;
  @HiveField(8)
  final Map<String, bool> completedLevels; // "stage-level" -> completed
  @HiveField(9)
  final Map<String, bool> visitedStages; // "stage" -> visited

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatar,
    this.totalStars = 0,
    this.completedPuzzles = const {},
    this.bestTimes = const {},
    this.completedLevels = const {},
    this.visitedStages = const {},
    required this.createdAt,
    required this.lastPlayedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatar,
    int? totalStars,
    Map<String, int>? completedPuzzles,
    Map<String, int>? bestTimes,
    Map<String, bool>? completedLevels,
    Map<String, bool>? visitedStages,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      totalStars: totalStars ?? this.totalStars,
      completedPuzzles: completedPuzzles ?? this.completedPuzzles,
      bestTimes: bestTimes ?? this.bestTimes,
      completedLevels: completedLevels ?? this.completedLevels,
      visitedStages: visitedStages ?? this.visitedStages,
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

  UserProfile addStars(int stars) {
    return copyWith(totalStars: totalStars + stars);
  }

  // 레벨 완료 상태 확인
  bool isLevelCompleted(int stageNumber, int levelNumber) {
    String key = '$stageNumber-$levelNumber';
    return completedLevels[key] ?? false;
  }

  // 레벨 완료 처리
  UserProfile completeLevel(int stageNumber, int levelNumber) {
    String key = '$stageNumber-$levelNumber';
    Map<String, bool> newCompletedLevels = Map.from(completedLevels);
    newCompletedLevels[key] = true;
    return copyWith(completedLevels: newCompletedLevels);
  }

  // 스테이지 방문 상태 확인
  bool isStageVisited(int stageNumber) {
    String key = stageNumber.toString();
    return visitedStages[key] ?? false;
  }

  // 스테이지 방문 처리
  UserProfile visitStage(int stageNumber) {
    String key = stageNumber.toString();
    Map<String, bool> newVisitedStages = Map.from(visitedStages);
    newVisitedStages[key] = true;
    return copyWith(visitedStages: newVisitedStages);
  }

  // 캐릭터 기능 제거됨
}
