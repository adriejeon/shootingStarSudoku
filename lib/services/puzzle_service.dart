import 'dart:math';
import '../models/puzzle.dart';
import 'data_service.dart';

class PuzzleService {
  static final PuzzleService _instance = PuzzleService._internal();
  factory PuzzleService() => _instance;
  static PuzzleService get instance => _instance;
  PuzzleService._internal();

  final DataService _dataService = DataService.instance;
  final Random _random = Random();

  // 퍼즐 로드
  Future<List<Puzzle>> loadPuzzles(int difficulty) async {
    return await _dataService.loadPuzzles(difficulty);
  }

  // 랜덤 퍼즐 선택
  Future<Puzzle?> getRandomPuzzle(int difficulty) async {
    final puzzles = await loadPuzzles(difficulty);
    if (puzzles.isEmpty) return null;
    
    final randomIndex = _random.nextInt(puzzles.length);
    return puzzles[randomIndex];
  }

  // 특정 ID의 퍼즐 로드
  Future<Puzzle?> getPuzzleById(int difficulty, int puzzleId) async {
    final puzzles = await loadPuzzles(difficulty);
    try {
      return puzzles.firstWhere((puzzle) => puzzle.id == puzzleId);
    } catch (e) {
      return null;
    }
  }

  // 퍼즐 검증
  bool validatePuzzle(Puzzle puzzle) {
    return puzzle.isCorrect();
  }

  // 힌트 제공 (가능한 숫자들 반환)
  List<int> getHint(Puzzle puzzle, int row, int col) {
    if (puzzle.grid[row][col] != 0) return [];
    
    List<int> possibleNumbers = [];
    for (int num = 1; num <= puzzle.difficulty; num++) {
      if (puzzle.isValidMove(row, col, num)) {
        possibleNumbers.add(num);
      }
    }
    return possibleNumbers;
  }

  // 오류 체크 (잘못된 칸들 반환)
  List<Map<String, int>> findErrors(Puzzle puzzle) {
    List<Map<String, int>> errors = [];
    
    for (int i = 0; i < puzzle.grid.length; i++) {
      for (int j = 0; j < puzzle.grid[i].length; j++) {
        if (puzzle.grid[i][j] != 0 && !puzzle.isValidMove(i, j, puzzle.grid[i][j])) {
          errors.add({'row': i, 'col': j});
        }
      }
    }
    
    return errors;
  }

  // 퍼즐 완료 여부 확인
  bool isPuzzleCompleted(Puzzle puzzle) {
    return puzzle.isCompleted && puzzle.isCorrect();
  }

  // 퍼즐 진행률 계산 (0.0 ~ 1.0)
  double getProgress(Puzzle puzzle) {
    int totalCells = puzzle.difficulty * puzzle.difficulty;
    int filledCells = 0;
    
    for (int i = 0; i < puzzle.grid.length; i++) {
      for (int j = 0; j < puzzle.grid[i].length; j++) {
        if (puzzle.grid[i][j] != 0) {
          filledCells++;
        }
      }
    }
    
    return filledCells / totalCells;
  }

  // 퍼즐 난이도별 통계
  Future<Map<String, int>> getPuzzleStats(int difficulty) async {
    final puzzles = await loadPuzzles(difficulty);
    return {
      'total': puzzles.length,
      'completed': 0, // 사용자별 완료된 퍼즐 수는 별도로 관리
    };
  }

  // 퍼즐 생성 (개발용)
  Puzzle generatePuzzle(int difficulty) {
    // 실제 구현에서는 복잡한 스도쿠 생성 알고리즘이 필요
    // 여기서는 간단한 예시만 제공
    List<List<int>> grid = List.generate(
      difficulty, 
      (i) => List.generate(difficulty, (j) => 0)
    );
    
    List<List<int>> solution = List.generate(
      difficulty, 
      (i) => List.generate(difficulty, (j) => (i + j) % difficulty + 1)
    );
    
    return Puzzle(
      id: DateTime.now().millisecondsSinceEpoch,
      difficulty: difficulty,
      grid: grid,
      solution: solution,
    );
  }
}
