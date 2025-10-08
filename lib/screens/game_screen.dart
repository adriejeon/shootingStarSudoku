import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../utils/constants.dart';
import '../state/user_progress_state.dart';
import '../services/audio_service.dart';
import '../widgets/stage_completion_dialog.dart';
import '../models/game_save_state.dart';
import '../ads/admob_handler.dart';
import '../services/daily_game_service.dart';
import 'dart:convert';

class GameScreen extends StatefulWidget {
  final int difficulty;
  final int stageNumber;
  final int levelNumber;

  const GameScreen({
    super.key,
    required this.difficulty,
    this.stageNumber = 1,
    this.levelNumber = 1,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<int?>> _grid;
  late List<List<bool>> _isOriginal;
  int _selectedNumber = 1;
  int _selectedRow = -1;
  int _selectedCol = -1;
  int _gridSize = 3;

  // 타이머 관련 변수
  Timer? _gameTimer;
  int _elapsedSeconds = 0;

  // 되돌리기 기능을 위한 변수
  List<Map<String, dynamic>> _moveHistory = [];

  // 지우기 기능을 위한 변수
  bool _isEraseMode = false;

  // 실수 카운팅 변수
  int _mistakeCount = 0;
  static const int _maxMistakes = 3;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
    // 게임 상태 확인은 완전히 제거하고 항상 새로 시작
  }

  void _initializeGame() {
    print('게임 초기화 시작 - 완전히 새로 시작');

    setState(() {
      _gridSize = widget.difficulty == AppConstants.easyDifficulty
          ? 4
          : widget.difficulty == AppConstants.mediumDifficulty
          ? 6
          : 9;

      // 그리드 완전히 새로 생성
      _grid = List.generate(_gridSize, (_) => List.filled(_gridSize, null));
      _isOriginal = List.generate(
        _gridSize,
        (_) => List.filled(_gridSize, false),
      );

      // 모든 게임 상태 완전 초기화
      _elapsedSeconds = 0;
      _moveHistory.clear();
      _mistakeCount = 0;
      _isEraseMode = false;
      _selectedRow = -1;
      _selectedCol = -1;
      _selectedNumber = 1;
    });

    // 퍼즐 새로 생성
    _generatePuzzle();

    print('게임 초기화 완료 - 실수: $_mistakeCount/$_maxMistakes');
  }

  void _generatePuzzle() {
    // 스테이지와 레벨에 따른 힌트 개수 계산
    int hintCount = _calculateHintCount();

    if (_gridSize == 4) {
      _generate4x4Puzzle(hintCount);
    } else if (_gridSize == 6) {
      _generate6x6Puzzle(hintCount);
    } else {
      _generate9x9Puzzle(hintCount);
    }
  }

  int _calculateHintCount() {
    // 스테이지 1 레벨 1: 최대 힌트 (80%)
    // 스테이지 6 레벨 20: 힌트 (50%) - 기존 난이도 유지
    // 스테이지 9 레벨 20: 힌트 (35%) - 고급 수준으로 조정
    int totalCells = _gridSize * _gridSize;
    int stage = widget.stageNumber;
    int level = widget.levelNumber;

    // 난이도 계산: 스테이지에 따라 다른 난이도 곡선 적용
    double difficulty;
    int hintCount;

    if (stage <= 6) {
      // 스테이지 1~6: 기존 난이도 유지 (80% ~ 50%)
      difficulty = ((stage - 1) * 20 + (level - 1)) / (6 * 20 - 1); // 0.0 ~ 1.0
      hintCount = (totalCells * (0.8 - difficulty * 0.3)).round(); // 80% ~ 50%
    } else {
      // 스테이지 7~9: 조정된 난이도 (50% ~ 35%)
      double stage7to9Difficulty =
          ((stage - 7) * 20 + (level - 1)) / (3 * 20 - 1); // 0.0 ~ 1.0
      hintCount = (totalCells * (0.5 - stage7to9Difficulty * 0.15))
          .round(); // 50% ~ 35%
    }

    return hintCount.clamp(3, totalCells - 1); // 최소 3개, 최대 전체-1개
  }

  void _generate4x4Puzzle(int hintCount) {
    // 4x4 완전한 스도쿠 솔루션 생성 (2x2 박스)
    List<List<int?>> solution = [
      [1, 2, 3, 4],
      [3, 4, 1, 2],
      [2, 1, 4, 3],
      [4, 3, 2, 1],
    ];

    _applyHints(solution, hintCount);
  }

  void _generate6x6Puzzle(int hintCount) {
    // 6x6 완전한 스도쿠 솔루션 생성 (3x2 박스)
    List<List<int?>> solution = [
      [1, 2, 3, 4, 5, 6],
      [4, 5, 6, 1, 2, 3],
      [2, 3, 1, 5, 6, 4],
      [5, 6, 4, 2, 3, 1],
      [3, 1, 2, 6, 4, 5],
      [6, 4, 5, 3, 1, 2],
    ];

    _applyHints(solution, hintCount);
  }

  void _generate9x9Puzzle(int hintCount) {
    // 9x9 완전한 스도쿠 솔루션 생성 (3x3 박스)
    List<List<int?>> solution = [
      [1, 2, 3, 4, 5, 6, 7, 8, 9],
      [4, 5, 6, 7, 8, 9, 1, 2, 3],
      [7, 8, 9, 1, 2, 3, 4, 5, 6],
      [2, 3, 1, 5, 6, 4, 8, 9, 7],
      [5, 6, 4, 8, 9, 7, 2, 3, 1],
      [8, 9, 7, 2, 3, 1, 5, 6, 4],
      [3, 1, 2, 6, 4, 5, 9, 7, 8],
      [6, 4, 5, 9, 7, 8, 3, 1, 2],
      [9, 7, 8, 3, 1, 2, 6, 4, 5],
    ];

    _applyHints(solution, hintCount);
  }

  void _applyHints(List<List<int?>> solution, int hintCount) {
    // 모든 셀을 null로 초기화
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        _grid[i][j] = null;
        _isOriginal[i][j] = false;
      }
    }

    // 랜덤하게 힌트 개수만큼 셀 선택하여 솔루션 적용
    List<int> positions = List.generate(
      _gridSize * _gridSize,
      (index) => index,
    );
    positions.shuffle();

    for (int i = 0; i < hintCount && i < positions.length; i++) {
      int pos = positions[i];
      int row = pos ~/ _gridSize;
      int col = pos % _gridSize;

      _grid[row][col] = solution[row][col];
      _isOriginal[row][col] = true;
    }
  }

  bool _isValidMove(int row, int col, int number) {
    // 행 검사 - 같은 행에 동일한 숫자가 있는지 확인
    for (int i = 0; i < _gridSize; i++) {
      if (i != col && _grid[row][i] == number) {
        return false;
      }
    }

    // 열 검사 - 같은 열에 동일한 숫자가 있는지 확인
    for (int i = 0; i < _gridSize; i++) {
      if (i != row && _grid[i][col] == number) {
        return false;
      }
    }

    // 박스 검사 (스도쿠 규칙에 따라)
    if (_gridSize == 4) {
      // 4x4: 2x2 박스
      int boxRow = (row ~/ 2) * 2;
      int boxCol = (col ~/ 2) * 2;

      for (int i = boxRow; i < boxRow + 2; i++) {
        for (int j = boxCol; j < boxCol + 2; j++) {
          if ((i != row || j != col) && _grid[i][j] == number) {
            return false;
          }
        }
      }
    } else if (_gridSize == 6) {
      // 6x6: 3x2 박스
      int boxRow = (row ~/ 2) * 2; // 2줄씩 그룹화
      int boxCol = (col ~/ 3) * 3; // 3줄씩 그룹화

      for (int i = boxRow; i < boxRow + 2; i++) {
        for (int j = boxCol; j < boxCol + 3; j++) {
          if ((i != row || j != col) && _grid[i][j] == number) {
            return false;
          }
        }
      }
    } else {
      // 9x9: 3x3 박스
      int boxRow = (row ~/ 3) * 3;
      int boxCol = (col ~/ 3) * 3;

      for (int i = boxRow; i < boxRow + 3; i++) {
        for (int j = boxCol; j < boxCol + 3; j++) {
          if ((i != row || j != col) && _grid[i][j] == number) {
            return false;
          }
        }
      }
    }

    return true;
  }

  bool _isInSameRowColOrBox(
    int row,
    int col,
    int selectedRow,
    int selectedCol,
  ) {
    if (selectedRow == -1 || selectedCol == -1) return false;

    // 같은 행이나 열
    if (row == selectedRow || col == selectedCol) return true;

    // 같은 박스 검사
    if (_gridSize == 4) {
      // 4x4: 2x2 박스
      int boxRow1 = (row ~/ 2) * 2;
      int boxCol1 = (col ~/ 2) * 2;
      int boxRow2 = (selectedRow ~/ 2) * 2;
      int boxCol2 = (selectedCol ~/ 2) * 2;
      return boxRow1 == boxRow2 && boxCol1 == boxCol2;
    } else if (_gridSize == 6) {
      // 6x6: 3x2 박스
      int boxRow1 = (row ~/ 2) * 2;
      int boxCol1 = (col ~/ 3) * 3;
      int boxRow2 = (selectedRow ~/ 2) * 2;
      int boxCol2 = (selectedCol ~/ 3) * 3;
      return boxRow1 == boxRow2 && boxCol1 == boxCol2;
    } else {
      // 9x9: 3x3 박스
      int boxRow1 = (row ~/ 3) * 3;
      int boxCol1 = (col ~/ 3) * 3;
      int boxRow2 = (selectedRow ~/ 3) * 3;
      int boxCol2 = (selectedCol ~/ 3) * 3;
      return boxRow1 == boxRow2 && boxCol1 == boxCol2;
    }
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _pauseTimer() {
    _gameTimer?.cancel();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool _isGameComplete() {
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_grid[i][j] == null) return false;
      }
    }
    return true;
  }

  void _onCellTap(int row, int col) {
    // 원본 셀(고정된 셀)은 수정 불가
    if (_isOriginal[row][col]) {
      return;
    }

    // 지우기 모드인 경우
    if (_isEraseMode) {
      _eraseCell(row, col);
      return;
    }

    setState(() {
      _selectedRow = row;
      _selectedCol = col;
    });

    // 셀 선택 시 진동 피드백
    _triggerHapticFeedback();
  }

  Future<void> _triggerHapticFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vibrationEnabled =
          prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;

      if (vibrationEnabled) {
        // 안드로이드에서 더 강력한 진동을 위해 vibration 패키지 사용
        if (await Vibration.hasVibrator() == true) {
          await Vibration.vibrate(duration: 50);
        } else {
          // 폴백으로 HapticFeedback 사용
          HapticFeedback.lightImpact();
        }
      }
    } catch (e) {
      // 오류 발생 시 HapticFeedback으로 폴백
      try {
        HapticFeedback.lightImpact();
      } catch (fallbackError) {
        // 폴백도 실패하면 조용히 처리
      }
    }
  }

  Future<void> _onNumberSelect(int number) async {
    if (_selectedRow != -1 &&
        _selectedCol != -1 &&
        !_isOriginal[_selectedRow][_selectedCol]) {
      // 선택된 셀에 이미 같은 숫자가 있으면 제거
      if (_grid[_selectedRow][_selectedCol] == number) {
        // 되돌리기를 위한 이동 기록 저장
        _moveHistory.add({
          'row': _selectedRow,
          'col': _selectedCol,
          'previousValue': _grid[_selectedRow][_selectedCol],
          'newValue': null,
        });

        setState(() {
          _grid[_selectedRow][_selectedCol] = null;
          _selectedRow = -1;
          _selectedCol = -1;
        });

        // 숫자 제거 효과음 재생
        AudioService().playPopSound();
        _triggerHapticFeedback();
        return;
      }

      if (_isValidMove(_selectedRow, _selectedCol, number)) {
        // 되돌리기를 위한 이동 기록 저장
        _moveHistory.add({
          'row': _selectedRow,
          'col': _selectedCol,
          'previousValue': _grid[_selectedRow][_selectedCol],
          'newValue': number,
        });

        setState(() {
          _grid[_selectedRow][_selectedCol] = number;
          _selectedRow = -1;
          _selectedCol = -1;
        });

        // 숫자 배치 효과음 재생
        AudioService().playPopSound();

        // 진동 피드백 (설정이 켜져 있을 때만)
        _triggerHapticFeedback();

        if (_isGameComplete()) {
          _pauseTimer();
          _handleGameComplete();
        }
      } else {
        // 실수 카운트 증가
        setState(() {
          _mistakeCount++;
        });

        // 실수 3번 시 게임 실패
        if (_mistakeCount >= _maxMistakes) {
          _pauseTimer();
          await _saveGameState(); // 게임 상태 저장
          _showGameFailedDialog();
          return;
        }

        // 잘못된 캐릭터 입력 시 피드백
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '실수 $_mistakeCount/$_maxMistakes - 이 위치에 해당 캐릭터를 넣을 수 없습니다',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );

        // 잘못된 입력 시 진동 피드백
        _triggerHapticFeedback();
      }
    }
  }

  void _handleGameComplete() async {
    // 성공 효과음 재생
    AudioService().playSuccessSound();

    // 게임 완료 시 진동 피드백
    _triggerHapticFeedback();

    // 저장된 게임 상태 삭제
    await _clearSavedGame();

    // 레벨 완료 처리
    final userProgress = Provider.of<UserProgressState>(context, listen: false);
    userProgress.completeLevel(
      widget.stageNumber,
      widget.levelNumber,
      widget.difficulty,
      _elapsedSeconds,
    );

    // 데이터 저장이 완료될 때까지 잠시 대기
    await Future.delayed(const Duration(milliseconds: 200));

    // 스테이지 완료 여부 확인
    if (userProgress.isStageCompleted(widget.stageNumber)) {
      _showStageCompletionDialog();
    } else {
      _showGameCompleteDialog();
    }
  }

  void _showStageCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StageCompletionDialog(
        stageNumber: widget.stageNumber,
        onComplete: () {
          Navigator.of(context).pop(); // 다이얼로그 닫기
          Navigator.of(context).popUntil((route) => route.isFirst); // 홈으로 이동
        },
      ),
    );
  }

  void _showGameCompleteDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(AppConstants.cardColor),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 성공 이미지와 별 효과
            Stack(
              alignment: Alignment.center,
              children: [
                // 별 그림자 효과
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.amber.withOpacity(0.3),
                        Colors.orange.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
                // 별 효과
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.amber.withOpacity(0.6),
                        Colors.orange.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.8, 1.0],
                    ),
                  ),
                ),
                // 성공 이미지
                Image.asset(
                  'assets/images/btn-sucess.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '축하합니다!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${_getPlanetTitle(widget.stageNumber, widget.levelNumber)} 완료!\n조각을 모두 모았습니다!\n\n완료 시간: ${_formatTime(_elapsedSeconds)}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // 다이얼로그 닫기

                  // 상태 업데이트를 위해 잠시 대기
                  await Future.delayed(const Duration(milliseconds: 100));

                  // 홈으로 이동
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('홈으로', style: TextStyle(color: Colors.blue)),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop(); // 게임 화면 닫기 (스테이지로 돌아가기)
                },
                child: const Text(
                  '스테이지로',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          if (_isEraseMode) {
            setState(() {
              _isEraseMode = false;
              _selectedRow = -1;
              _selectedCol = -1;
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _getPlanetTitle(widget.stageNumber, widget.levelNumber),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(AppConstants.backgroundColor),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await _handleResetGame();
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFF10152C)),
          child: SafeArea(
            child: Column(
              children: [
                _buildGameInfo(),
                Expanded(child: _buildGameGrid()),
                _buildNumberPad(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid() {
    // 그리드 크기에 따른 패딩 조정
    double padding = _gridSize == 4
        ? 20.0
        : _gridSize == 6
        ? 10.0
        : 5.0;

    return Center(
      child: Container(
        padding: EdgeInsets.all(padding),
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: SudokuGridPainter(_gridSize),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridSize,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: _gridSize * _gridSize,
              itemBuilder: (context, index) {
                int row = index ~/ _gridSize;
                int col = index % _gridSize;
                bool isSelected = _selectedRow == row && _selectedCol == col;
                bool isOriginal = _isOriginal[row][col];
                bool isHighlighted =
                    _isInSameRowColOrBox(
                      row,
                      col,
                      _selectedRow,
                      _selectedCol,
                    ) &&
                    !isSelected;

                return GestureDetector(
                  onTap: () => _onCellTap(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.cyan.withOpacity(0.4)
                          : isHighlighted
                          ? Colors.blue.withOpacity(0.15)
                          : isOriginal
                          ? Colors.white.withOpacity(0.15)
                          : _isEraseMode && !isOriginal
                          ? Colors.red.withOpacity(0.1)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.cyan.withOpacity(0.8)
                            : isHighlighted
                            ? Colors.blue.withOpacity(0.4)
                            : _isEraseMode && !isOriginal
                            ? Colors.red.withOpacity(0.5)
                            : Colors.white.withOpacity(0.2),
                        width: isSelected ? 2 : (isHighlighted ? 1.5 : 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                        if (isSelected)
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          )
                        else if (isHighlighted)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                      ],
                    ),
                    child: Center(
                      child: _grid[row][col] != null
                          ? Container(
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                'assets/puzzles/char${_grid[row][col]}.png',
                                fit: BoxFit.contain,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _gridSize,
            itemBuilder: (context, index) {
              int number = index + 1;
              bool isSelected = _selectedNumber == number;
              bool isCurrentValue =
                  _selectedRow != -1 &&
                  _selectedCol != -1 &&
                  _grid[_selectedRow][_selectedCol] == number;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedNumber = number;
                  });
                  _onNumberSelect(number);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrentValue
                        ? Colors.orange.withOpacity(0.4)
                        : isSelected
                        ? Colors.cyan.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isCurrentValue
                          ? Colors.orange.withOpacity(0.8)
                          : isSelected
                          ? Colors.cyan.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                      width: (isSelected || isCurrentValue) ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                      if (isCurrentValue)
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 0),
                        )
                      else if (isSelected)
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 0),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/puzzles/char$number.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showGameFailedDialog() async {
    // 실패 시 진동 피드백
    _triggerHapticFeedback();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(AppConstants.cardColor),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 실패 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.red, size: 50),
            ),
            const SizedBox(height: 20),
            // 실패 메시지
            const Text(
              '게임 실패!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _mistakeCount >= _maxMistakes
                  ? '실수를 $_maxMistakes번 하였습니다.\n다시 시도해보세요!'
                  : '더 이상 유효한 움직임이 없습니다.\n다시 시도해보세요!',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop(); // 게임 화면 닫기 (스테이지로 돌아가기)
                },
                child: const Text(
                  '스테이지로',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // 다이얼로그 닫기

                  // 전면 광고 표시
                  final adHandler = AdmobHandler();

                  // 광고가 준비되지 않았으면 먼저 로드
                  if (!adHandler.isInterstitialAdLoaded) {
                    print('전면 광고 로드 중...');
                    await adHandler.loadInterstitialAd();
                  }

                  await adHandler.showInterstitialAd();

                  // 광고를 본 후 게임 상태 복원 (실수 카운트는 0으로 초기화)
                  _loadSavedGameWithResetMistakes();
                  _startTimer();
                },
                child: const Text(
                  '이어서 하기',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _undoLastMove() {
    if (_moveHistory.isNotEmpty) {
      final lastMove = _moveHistory.removeLast();
      setState(() {
        _grid[lastMove['row']][lastMove['col']] = lastMove['previousValue'];
        _selectedRow = -1;
        _selectedCol = -1;
      });

      // 되돌리기 효과음 재생
      AudioService().playPopSound();
      _triggerHapticFeedback();
    }
  }

  void _toggleEraseMode() {
    setState(() {
      _isEraseMode = !_isEraseMode;
      _selectedRow = -1;
      _selectedCol = -1;
    });

    // 지우기 모드 진동 피드백
    _triggerHapticFeedback();
  }

  void _eraseCell(int row, int col) {
    // 원래 퍼즐의 칸이 아니고, 사용자가 입력한 칸만 지울 수 있음
    if (!_isOriginal[row][col] && _grid[row][col] != null) {
      setState(() {
        _grid[row][col] = null;
        _selectedRow = -1;
        _selectedCol = -1;
        _isEraseMode = false;
      });

      // 지우기 효과음 재생
      AudioService().playPopSound();
      _triggerHapticFeedback();
    }
  }

  // 게임 상태 저장
  Future<void> _saveGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameState = GameSaveState(
        grid: _grid
            .map((row) => row.map((cell) => cell ?? 0).toList())
            .toList(),
        mistakeCount: _mistakeCount,
        elapsedSeconds: _elapsedSeconds,
        stageNumber: widget.stageNumber,
        levelNumber: widget.levelNumber,
        difficulty: _getDifficultyString(),
        saveTime: DateTime.now(),
      );

      final gameStateJson = jsonEncode(gameState.toJson());
      await prefs.setString('saved_game_state', gameStateJson);
      print('게임 상태 저장 완료');
    } catch (e) {
      print('게임 상태 저장 실패: $e');
    }
  }

  // 게임 상태 확인 및 복원
  Future<void> _checkAndLoadSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGameJson = prefs.getString('saved_game_state');

      if (savedGameJson != null) {
        final gameStateMap = jsonDecode(savedGameJson);
        final gameState = GameSaveState.fromJson(gameStateMap);

        // 현재 게임과 저장된 게임이 같은지 확인
        if (gameState.stageNumber == widget.stageNumber &&
            gameState.levelNumber == widget.levelNumber &&
            gameState.difficulty == _getDifficultyString()) {
          // 같은 게임인 경우에만 상태 복원
          print('같은 게임 감지 - 상태 복원');
          setState(() {
            _grid = gameState.grid
                .map(
                  (row) => row.map((cell) => cell == 0 ? null : cell).toList(),
                )
                .toList();
            _mistakeCount = gameState.mistakeCount;
            _elapsedSeconds = gameState.elapsedSeconds;
          });
        } else {
          // 다른 게임인 경우 저장된 상태 삭제
          print('다른 게임 감지 - 저장된 상태 삭제');
          await _clearSavedGame();
        }
      }

      // 게임 상태가 깨끗한지 최종 확인
      _ensureGameStateIsClean();
    } catch (e) {
      print('게임 상태 확인 실패: $e');
      // 오류 발생 시 게임을 새로 초기화
      _resetGameState();
    }
  }

  // 게임 상태 복원
  Future<void> _loadSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGameJson = prefs.getString('saved_game_state');

      if (savedGameJson != null) {
        final gameStateMap = jsonDecode(savedGameJson);
        final gameState = GameSaveState.fromJson(gameStateMap);

        // 현재 게임과 저장된 게임이 같은지 확인
        if (gameState.stageNumber == widget.stageNumber &&
            gameState.levelNumber == widget.levelNumber &&
            gameState.difficulty == _getDifficultyString()) {
          setState(() {
            _grid = gameState.grid
                .map(
                  (row) => row.map((cell) => cell == 0 ? null : cell).toList(),
                )
                .toList();
            _mistakeCount = gameState.mistakeCount;
            _elapsedSeconds = gameState.elapsedSeconds;
          });

          print('게임 상태 복원 완료');
        } else {
          // 다른 게임인 경우 저장된 상태 삭제
          print('다른 게임 시작 - 저장된 게임 상태 삭제');
          await _clearSavedGame();
        }
      }
    } catch (e) {
      print('게임 상태 복원 실패: $e');
    }
  }

  // 게임 상태 복원 (실수 카운트 초기화)
  Future<void> _loadSavedGameWithResetMistakes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGameJson = prefs.getString('saved_game_state');

      if (savedGameJson != null) {
        final gameStateMap = jsonDecode(savedGameJson);
        final gameState = GameSaveState.fromJson(gameStateMap);

        // 현재 게임과 저장된 게임이 같은지 확인
        if (gameState.stageNumber == widget.stageNumber &&
            gameState.levelNumber == widget.levelNumber &&
            gameState.difficulty == _getDifficultyString()) {
          setState(() {
            _grid = gameState.grid
                .map(
                  (row) => row.map((cell) => cell == 0 ? null : cell).toList(),
                )
                .toList();
            _mistakeCount = 0; // 실수 카운트를 0으로 초기화
            _elapsedSeconds = gameState.elapsedSeconds;
          });

          print('게임 상태 복원 완료 (실수 카운트 초기화)');
        } else {
          // 다른 게임인 경우 저장된 상태 삭제
          print('다른 게임 시작 - 저장된 게임 상태 삭제');
          await _clearSavedGame();
        }
      }
    } catch (e) {
      print('게임 상태 복원 실패: $e');
    }
  }

  // 게임 상태 삭제
  Future<void> _clearSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_game_state');
      print('저장된 게임 상태 삭제 완료');
    } catch (e) {
      print('게임 상태 삭제 실패: $e');
    }
  }

  // 난이도 문자열 반환
  String _getDifficultyString() {
    if (widget.difficulty == AppConstants.easyDifficulty) return 'easy';
    if (widget.difficulty == AppConstants.mediumDifficulty) return 'medium';
    return 'hard';
  }

  // 게임 상태가 깨끗한지 확인하고 필요시 초기화
  void _ensureGameStateIsClean() {
    bool needsReset = false;

    // 실수 카운트가 최대값을 초과하거나 비정상적인 상태인 경우
    if (_mistakeCount > _maxMistakes || _mistakeCount < 0) {
      print('비정상적인 실수 카운트 감지: $_mistakeCount');
      needsReset = true;
    }

    // 그리드가 비정상적인 상태인지 확인
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_grid[i][j] != null &&
            (_grid[i][j]! < 1 || _grid[i][j]! > _gridSize)) {
          print('비정상적인 그리드 값 감지: ${_grid[i][j]} at ($i, $j)');
          needsReset = true;
          break;
        }
      }
      if (needsReset) break;
    }

    // 게임이 이미 완료된 상태인지 확인
    if (_isGameComplete()) {
      print('게임이 이미 완료된 상태 감지');
      needsReset = true;
    }

    if (needsReset) {
      print('게임 상태 초기화 실행');
      _resetGameState();
    } else {
      print('게임 상태 정상 - 실수: $_mistakeCount/$_maxMistakes');
    }
  }

  // 게임 상태 완전 초기화
  void _resetGameState() {
    setState(() {
      _mistakeCount = 0;
      _elapsedSeconds = 0;
      _selectedRow = -1;
      _selectedCol = -1;
      _selectedNumber = 1;
      _isEraseMode = false;
      _moveHistory.clear();

      // 그리드 완전 재생성
      _grid = List.generate(_gridSize, (_) => List.filled(_gridSize, null));
      _isOriginal = List.generate(
        _gridSize,
        (_) => List.filled(_gridSize, false),
      );
    });

    // 퍼즐 재생성
    _generatePuzzle();
    print('게임 상태 완전 초기화 완료');
  }

  // 게임 리셋 처리 (일일 게임 카운팅 없음)
  Future<void> _handleResetGame() async {
    // 게임 리셋은 일일 카운팅에 포함되지 않음
    _resetGame();
  }

  // 게임 리셋
  void _resetGame() {
    if (mounted) {
      setState(() {
        _initializeGame();
        _selectedRow = -1;
        _selectedCol = -1;
        _startTimer();
      });
    }
  }

  String _getPlanetTitle(int stageNumber, int levelNumber) {
    switch (stageNumber) {
      case 1:
        return '빛의 조각 $levelNumber / 20';
      case 2:
        return '멜로디 조각 $levelNumber / 20';
      case 3:
        return '무지개 조각 $levelNumber / 20';
      case 4:
        return '탱탱볼 조각 $levelNumber / 20';
      case 5:
        return '지혜의 조각 $levelNumber / 20';
      case 6:
        return '생명의 조각 $levelNumber / 20';
      case 7:
        return '에너지 조각 $levelNumber / 20';
      case 8:
        return '온기의 조각 $levelNumber / 20';
      case 9:
        return '별자리 조각 $levelNumber / 20';
      default:
        return '수수께끼 조각 $levelNumber / 20';
    }
  }

  Widget _buildGameInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 너비에 따라 레이아웃 결정 (더 작은 화면에서만 좁은 레이아웃 사용)
        bool isNarrowScreen = constraints.maxWidth < 310;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.all(16),
          child: isNarrowScreen ? _buildNarrowLayout() : _buildWideLayout(),
        );
      },
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // 시간 표시 (1/4)
        Expanded(flex: 1, child: _buildTimeInfo()),
        // 실수 표시 (1/4)
        Expanded(flex: 1, child: _buildMistakeInfo()),
        // 실행취소 버튼 (1/4)
        Expanded(flex: 1, child: _buildUndoButton()),
        const SizedBox(width: 8),
        // 지우기 버튼 (1/4)
        Expanded(flex: 1, child: _buildEraseButton()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        // 상단: 시간과 실수 정보
        Row(
          children: [
            Expanded(flex: 1, child: _buildTimeInfo()),
            Expanded(flex: 1, child: _buildMistakeInfo()),
          ],
        ),
        const SizedBox(height: 12),
        // 하단: 버튼들
        Row(
          children: [
            Expanded(flex: 1, child: _buildUndoButton()),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildEraseButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 18, color: Colors.cyan),
            const SizedBox(width: 6),
            Text(
              '시간',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _formatTime(_elapsedSeconds),
          style: TextStyle(
            color: Colors.cyan,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMistakeInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 18, color: Colors.red),
            const SizedBox(width: 6),
            Text(
              '실수',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$_mistakeCount/$_maxMistakes',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUndoButton() {
    return GestureDetector(
      onTap: _moveHistory.isNotEmpty ? _undoLastMove : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _moveHistory.isNotEmpty
              ? Colors.orange.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _moveHistory.isNotEmpty
                ? Colors.orange.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.undo,
              size: 16,
              color: _moveHistory.isNotEmpty ? Colors.orange : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              '돌리기',
              style: TextStyle(
                color: _moveHistory.isNotEmpty ? Colors.orange : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEraseButton() {
    return GestureDetector(
      onTap: _toggleEraseMode,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isEraseMode
              ? Colors.red.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isEraseMode
                ? Colors.red.withOpacity(0.5)
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_fix_high,
              size: 16,
              color: _isEraseMode ? Colors.red : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              '지우기',
              style: TextStyle(
                color: _isEraseMode ? Colors.red : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SudokuGridPainter extends CustomPainter {
  final int gridSize;

  SudokuGridPainter(this.gridSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final thickPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;

    // 모든 셀 경계선 그리기
    for (int i = 0; i <= gridSize; i++) {
      final x = i * cellWidth;
      final y = i * cellHeight;

      // 세로선
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);

      // 가로선
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // 박스 경계선 그리기 (두꺼운 선)
    int boxHeight, boxWidth;

    if (gridSize == 4) {
      // 4x4: 2x2 박스
      boxHeight = 2;
      boxWidth = 2;
    } else if (gridSize == 6) {
      // 6x6: 3x2 박스
      boxHeight = 2;
      boxWidth = 3;
    } else {
      // 9x9: 3x3 박스
      boxHeight = 3;
      boxWidth = 3;
    }

    // 세로 박스 경계선
    for (int i = boxWidth; i < gridSize; i += boxWidth) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), thickPaint);
    }

    // 가로 박스 경계선
    for (int i = boxHeight; i < gridSize; i += boxHeight) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), thickPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
