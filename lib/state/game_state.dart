import 'package:flutter/foundation.dart';
import '../models/puzzle.dart';

class GameState extends ChangeNotifier {
  Puzzle? _currentPuzzle;
  int _currentTime = 0;
  int _hintCount = 0;
  bool _isPaused = false;
  bool _isCompleted = false;
  List<Map<String, int>> _errors = [];

  // Getters
  Puzzle? get currentPuzzle => _currentPuzzle;
  int get currentTime => _currentTime;
  int get hintCount => _hintCount;
  bool get isPaused => _isPaused;
  bool get isCompleted => _isCompleted;
  List<Map<String, int>> get errors => _errors;

  // 퍼즐 설정
  void setPuzzle(Puzzle puzzle) {
    _currentPuzzle = puzzle;
    _currentTime = 0;
    _hintCount = 0;
    _isPaused = false;
    _isCompleted = false;
    _errors.clear();
    notifyListeners();
  }

  // 시간 업데이트
  void updateTime(int time) {
    _currentTime = time;
    notifyListeners();
  }

  // 퍼즐 완료 확인
  void checkCompletion() {
    if (_currentPuzzle == null) return;
    
    _isCompleted = _currentPuzzle!.isCompleted && _currentPuzzle!.isCorrect();
    if (_isCompleted) {
      notifyListeners();
    }
  }

  // 힌트 사용
  void useHint() {
    if (_hintCount < 3) { // 최대 3개 힌트
      _hintCount++;
      notifyListeners();
    }
  }

  // 일시정지/재개
  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  // 오류 업데이트
  void updateErrors(List<Map<String, int>> errors) {
    _errors = errors;
    notifyListeners();
  }

  // 게임 리셋
  void reset() {
    _currentPuzzle = null;
    _currentTime = 0;
    _hintCount = 0;
    _isPaused = false;
    _isCompleted = false;
    _errors.clear();
    notifyListeners();
  }

  // 진행률 계산
  double getProgress() {
    if (_currentPuzzle == null) return 0.0;
    
    int totalCells = _currentPuzzle!.difficulty * _currentPuzzle!.difficulty;
    int filledCells = 0;
    
    for (int i = 0; i < _currentPuzzle!.grid.length; i++) {
      for (int j = 0; j < _currentPuzzle!.grid[i].length; j++) {
        if (_currentPuzzle!.grid[i][j] != 0) {
          filledCells++;
        }
      }
    }
    
    return filledCells / totalCells;
  }

  // 남은 힌트 수
  int getRemainingHints() {
    return 3 - _hintCount;
  }
}
