import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../state/user_progress_state.dart';
import '../services/audio_service.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _gridSize = widget.difficulty == AppConstants.easyDifficulty
        ? 3
        : widget.difficulty == AppConstants.mediumDifficulty
        ? 6
        : 9;

    _grid = List.generate(_gridSize, (_) => List.filled(_gridSize, null));
    _isOriginal = List.generate(
      _gridSize,
      (_) => List.filled(_gridSize, false),
    );

    _generatePuzzle();
  }

  void _generatePuzzle() {
    // 스테이지와 레벨에 따른 힌트 개수 계산
    int hintCount = _calculateHintCount();

    if (_gridSize == 3) {
      _generate3x3Puzzle(hintCount);
    } else if (_gridSize == 6) {
      _generate6x6Puzzle(hintCount);
    } else {
      _generate9x9Puzzle(hintCount);
    }
  }

  int _calculateHintCount() {
    // 스테이지 1 레벨 1: 최대 힌트 (80%)
    // 스테이지 9 레벨 20: 최소 힌트 (30%)
    int totalCells = _gridSize * _gridSize;
    int stage = widget.stageNumber;
    int level = widget.levelNumber;

    // 난이도 계산: 스테이지와 레벨에 따라 힌트 개수 조절
    double difficulty =
        ((stage - 1) * 20 + (level - 1)) / (9 * 20 - 1); // 0.0 ~ 1.0
    int hintCount = (totalCells * (0.8 - difficulty * 0.5))
        .round(); // 80% ~ 30%

    return hintCount.clamp(3, totalCells - 1); // 최소 3개, 최대 전체-1개
  }

  void _generate3x3Puzzle(int hintCount) {
    // 3x3 완전한 스도쿠 솔루션 생성
    List<List<int?>> solution = [
      [1, 2, 3],
      [2, 3, 1],
      [3, 1, 2],
    ];

    _applyHints(solution, hintCount);
  }

  void _generate6x6Puzzle(int hintCount) {
    // 6x6 완전한 스도쿠 솔루션 생성 (2x2 박스)r
    List<List<int?>> solution = [
      [1, 2, 3, 4, 5, 6],
      [3, 4, 5, 6, 1, 2],
      [5, 6, 1, 2, 3, 4],
      [2, 1, 4, 3, 6, 5],
      [4, 3, 6, 5, 2, 1],
      [6, 5, 2, 1, 4, 3],
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
    if (_gridSize == 3) {
      // 3x3: 전체가 하나의 박스이므로 박스 검사 생략
      return true;
    } else if (_gridSize == 6) {
      // 6x6: 3x3 박스 (가로 3줄, 세로 3줄씩 구분) - 각 박스는 2x2
      int boxRow = (row ~/ 2) * 2; // 2줄씩 그룹화
      int boxCol = (col ~/ 2) * 2; // 2줄씩 그룹화

      for (int i = boxRow; i < boxRow + 2; i++) {
        for (int j = boxCol; j < boxCol + 2; j++) {
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

  bool _isGameComplete() {
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_grid[i][j] == null) return false;
      }
    }
    return true;
  }

  bool _isGameFailed() {
    // 모든 빈 셀에 대해 가능한 숫자가 있는지 확인
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_grid[i][j] == null && !_isOriginal[i][j]) {
          // 이 셀에 넣을 수 있는 숫자가 있는지 확인
          for (int num = 1; num <= _gridSize; num++) {
            if (_isValidMove(i, j, num)) {
              return false; // 가능한 움직임이 있으면 실패가 아님
            }
          }
        }
      }
    }

    // 빈 셀이 있지만 가능한 움직임이 없으면 실패
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_grid[i][j] == null) {
          return true;
        }
      }
    }

    return false; // 게임이 완료되었거나 아직 진행 중
  }

  void _onCellTap(int row, int col) {
    if (!_isOriginal[row][col]) {
      setState(() {
        _selectedRow = row;
        _selectedCol = col;
      });

      // 셀 선택 시 진동 피드백
      _triggerHapticFeedback();
    }
  }

  Future<void> _triggerHapticFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vibrationEnabled =
          prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;

      if (vibrationEnabled) {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      print('햅틱 피드백 오류: $e');
    }
  }

  void _onNumberSelect(int number) {
    if (_selectedRow != -1 &&
        _selectedCol != -1 &&
        !_isOriginal[_selectedRow][_selectedCol]) {
      if (_isValidMove(_selectedRow, _selectedCol, number)) {
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
          _showGameCompleteDialog();
        } else if (_isGameFailed()) {
          _showGameFailedDialog();
        }
      } else {
        // 잘못된 캐릭터 입력 시 피드백
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이 위치에 해당 캐릭터를 넣을 수 없습니다'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );

        // 잘못된 입력 시 진동 피드백
        _triggerHapticFeedback();
      }
    }
  }

  void _showGameCompleteDialog() async {
    // 성공 효과음 재생
    AudioService().playSuccessSound();

    // 게임 완료 시 진동 피드백
    _triggerHapticFeedback();

    // 레벨 완료 처리
    final userProgress = Provider.of<UserProgressState>(context, listen: false);
    userProgress.completeLevel(
      widget.stageNumber,
      widget.levelNumber,
      widget.difficulty,
      60,
    ); // 임시 시간

    // 데이터 저장이 완료될 때까지 잠시 대기
    await Future.delayed(const Duration(milliseconds: 200));

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
              '스테이지 ${widget.stageNumber} - 레벨 ${widget.levelNumber} 완료!\n별똥별을 모두 찾았습니다!',
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스테이지 ${widget.stageNumber} - 레벨 ${widget.levelNumber}'),
        backgroundColor: const Color(AppConstants.backgroundColor),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeGame();
                _selectedRow = -1;
                _selectedCol = -1;
              });
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
              Expanded(child: _buildGameGrid()),
              _buildNumberPad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid() {
    // 그리드 크기에 따른 패딩 조정
    double padding = _gridSize == 3
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

                return GestureDetector(
                  onTap: () => _onCellTap(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.cyan.withOpacity(0.4)
                          : isOriginal
                          ? Colors.white.withOpacity(0.15)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.cyan.withOpacity(0.8)
                            : Colors.white.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Text(
              '캐릭터를 선택하세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
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

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedNumber = number;
                  });
                  _onNumberSelect(number);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.cyan.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? Colors.cyan.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                      if (isSelected)
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
            const Text(
              '더 이상 유효한 움직임이 없습니다.\n다시 시도해보세요!',
              style: TextStyle(color: Colors.white70, fontSize: 16),
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
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  _resetGame(); // 게임 리셋
                },
                child: const Text(
                  '다시 시도',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      // 그리드를 원래 상태로 리셋
      for (int i = 0; i < _gridSize; i++) {
        for (int j = 0; j < _gridSize; j++) {
          if (!_isOriginal[i][j]) {
            _grid[i][j] = null;
          }
        }
      }
      _selectedRow = -1;
      _selectedCol = -1;
    });
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

    if (gridSize == 3) {
      // 3x3: 전체가 하나의 박스이므로 박스 경계선 없음
      return;
    } else if (gridSize == 6) {
      // 6x6: 3x3 박스 (가로 3줄, 세로 3줄씩 구분) - 각 박스는 2x2
      boxHeight = 3;
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
