import 'package:json_annotation/json_annotation.dart';

part 'puzzle.g.dart';

@JsonSerializable()
class Puzzle {
  final int id;
  final int difficulty; // 3, 6, 9
  final List<List<int>> grid;
  final List<List<int>> solution;
  final String? hint;

  const Puzzle({
    required this.id,
    required this.difficulty,
    required this.grid,
    required this.solution,
    this.hint,
  });

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleToJson(this);

  int get size => difficulty;
  bool get isCompleted => _isGridComplete();
  
  bool _isGridComplete() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 0) return false;
      }
    }
    return true;
  }

  bool isValidMove(int row, int col, int value) {
    if (value == 0) return true;
    
    // 행 검사
    for (int j = 0; j < grid[row].length; j++) {
      if (j != col && grid[row][j] == value) return false;
    }
    
    // 열 검사
    for (int i = 0; i < grid.length; i++) {
      if (i != row && grid[i][col] == value) return false;
    }
    
    // 3x3 박스 검사
    int boxSize = (difficulty == 9) ? 3 : (difficulty == 6) ? 2 : 1;
    int boxRow = (row ~/ boxSize) * boxSize;
    int boxCol = (col ~/ boxSize) * boxSize;
    
    for (int i = boxRow; i < boxRow + boxSize; i++) {
      for (int j = boxCol; j < boxCol + boxSize; j++) {
        if ((i != row || j != col) && grid[i][j] == value) return false;
      }
    }
    
    return true;
  }

  bool isCorrect() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] != solution[i][j]) return false;
      }
    }
    return true;
  }
}
