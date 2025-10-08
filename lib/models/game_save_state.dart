class GameSaveState {
  final List<List<int>> grid;
  final int mistakeCount;
  final int elapsedSeconds;
  final int stageNumber;
  final int levelNumber;
  final String difficulty;
  final DateTime saveTime;

  GameSaveState({
    required this.grid,
    required this.mistakeCount,
    required this.elapsedSeconds,
    required this.stageNumber,
    required this.levelNumber,
    required this.difficulty,
    required this.saveTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'grid': grid,
      'mistakeCount': mistakeCount,
      'elapsedSeconds': elapsedSeconds,
      'stageNumber': stageNumber,
      'levelNumber': levelNumber,
      'difficulty': difficulty,
      'saveTime': saveTime.millisecondsSinceEpoch,
    };
  }

  factory GameSaveState.fromJson(Map<String, dynamic> json) {
    return GameSaveState(
      grid: List<List<int>>.from(
        json['grid'].map((row) => List<int>.from(row)),
      ),
      mistakeCount: json['mistakeCount'],
      elapsedSeconds: json['elapsedSeconds'],
      stageNumber: json['stageNumber'],
      levelNumber: json['levelNumber'],
      difficulty: json['difficulty'],
      saveTime: DateTime.fromMillisecondsSinceEpoch(json['saveTime']),
    );
  }
}
