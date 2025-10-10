import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../services/audio_service.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 4; // 소개 + 초급 + 중급 + 고급

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _playButtonSound() {
    AudioService().playPopSound();
    HapticFeedback.lightImpact();
  }

  Widget _buildCharacterImage(int characterNumber, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Image.asset(
        'assets/puzzles/char$characterNumber.png',
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E132A), Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 헤더
              _buildHeader(),

              // 메인 콘텐츠
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildIntroPage(),
                    _buildTutorialPage(
                      title: AppLocalizations.of(context)!.tutorialBeginner,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.tutorialBeginnerSubtitle,
                      gridSize: 4,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialBeginnerDesc,
                      tips: [
                        AppLocalizations.of(context)!.rulesRow,
                        AppLocalizations.of(context)!.rulesColumn,
                        AppLocalizations.of(context)!.rulesBox4x4,
                        AppLocalizations.of(context)!.rulesFixed,
                      ],
                      color: const Color(0xFF4CAF50),
                    ),
                    _buildTutorialPage(
                      title: AppLocalizations.of(context)!.tutorialIntermediate,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.tutorialIntermediateSubtitle,
                      gridSize: 6,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialIntermediateDesc,
                      tips: [
                        AppLocalizations.of(context)!.rulesRow6x6,
                        AppLocalizations.of(context)!.rulesColumn6x6,
                        AppLocalizations.of(context)!.rulesBox6x6,
                        AppLocalizations.of(context)!.rulesLogic6x6,
                      ],
                      color: const Color(0xFF2196F3),
                    ),
                    _buildTutorialPage(
                      title: AppLocalizations.of(context)!.tutorialAdvanced,
                      subtitle: AppLocalizations.of(
                        context,
                      )!.tutorialAdvancedSubtitle,
                      gridSize: 9,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialAdvancedDesc,
                      tips: [
                        AppLocalizations.of(context)!.rulesRow9x9,
                        AppLocalizations.of(context)!.rulesColumn9x9,
                        AppLocalizations.of(context)!.rulesBox9x9,
                        AppLocalizations.of(context)!.rulesLogic9x9,
                      ],
                      color: const Color(0xFFFF5722),
                    ),
                  ],
                ),
              ),

              // 하단 네비게이션
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // 뒤로가기 버튼
          GestureDetector(
            onTap: () {
              _playButtonSound();
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          const Spacer(),
          // 제목
          Text(
            AppLocalizations.of(context)!.tutorialTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // 빈 공간 (대칭을 위해)
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildIntroPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 하단 캐릭터 이미지들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCharacterImage(1, 40),
              const SizedBox(width: 8),
              _buildCharacterImage(2, 40),
              const SizedBox(width: 8),
              _buildCharacterImage(3, 40),
              const SizedBox(width: 8),
              _buildCharacterImage(4, 40),
            ],
          ),
          const SizedBox(height: 40),

          // 제목
          Text(
            AppLocalizations.of(context)!.tutorialWelcome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 30),

          // 설명
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.tutorialDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.tutorialStartTip,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage({
    required String title,
    required String subtitle,
    required int gridSize,
    required String description,
    required List<String> tips,
    required Color color,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 섹션
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.5), width: 2),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 게임 예시 그리드
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: _buildExampleGrid(gridSize, color),
            ),
          ),
          const SizedBox(height: 30),

          // 설명
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // 규칙
          Text(
            AppLocalizations.of(context)!.gameRules,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tips
                .map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      tip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          // 조작법
          Text(
            AppLocalizations.of(context)!.gameControls,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.control1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.control2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.control3,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.control4,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleGrid(int gridSize, Color color) {
    // 각 난이도별 예시 그리드 데이터 (캐릭터 번호)
    List<List<int?>> exampleData;

    if (gridSize == 4) {
      // 4x4 스도쿠: 규칙을 보여주기 위한 예시 (첫 번째 행, 첫 번째 열, 첫 번째 2x2 박스에 올바른 배치)
      exampleData = [
        [1, 2, 3, 4], // 첫 번째 행: 1,2,3,4가 모두 다름
        [3, 4, null, null], // 첫 번째 열: 1,3이 다름, 첫 번째 2x2 박스: 1,2,3,4가 모두 다름
        [2, null, null, null], // 첫 번째 열: 1,3,2가 다름
        [4, null, null, null], // 첫 번째 열: 1,3,2,4가 다름
      ];
    } else if (gridSize == 6) {
      // 6x6 스도쿠: 규칙을 보여주기 위한 예시 (첫 번째 행, 첫 번째 열, 첫 번째 3x2 박스에 올바른 배치)
      exampleData = [
        [1, 2, 3, 4, 5, 6], // 첫 번째 행: 1,2,3,4,5,6이 모두 다름
        [
          4,
          5,
          6,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4가 다름, 첫 번째 3x2 박스: 1,2,3,4,5,6이 모두 다름
        [2, null, null, null, null, null], // 첫 번째 열: 1,4,2가 다름
        [5, null, null, null, null, null], // 첫 번째 열: 1,4,2,5가 다름
        [3, null, null, null, null, null], // 첫 번째 열: 1,4,2,5,3이 다름
        [6, null, null, null, null, null], // 첫 번째 열: 1,4,2,5,3,6이 다름
      ];
    } else {
      // 9x9 스도쿠: 규칙을 보여주기 위한 예시 (첫 번째 행, 첫 번째 열, 첫 번째 3x3 박스에 올바른 배치)
      exampleData = [
        [1, 2, 3, 4, 5, 6, 7, 8, 9], // 첫 번째 행: 1,2,3,4,5,6,7,8,9가 모두 다름
        [
          4,
          5,
          6,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4가 다름, 첫 번째 3x3 박스: 1,2,3,4,5,6이 모두 다름
        [
          7,
          8,
          9,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7이 다름, 첫 번째 3x3 박스: 1,2,3,4,5,6,7,8,9가 모두 다름
        [
          2,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7,2가 다름
        [
          5,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7,2,5가 다름
        [
          8,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7,2,5,8이 다름
        [
          3,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7,2,5,8,3이 다름
        [
          6,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7,2,5,8,3,6이 다름
        [
          9,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ], // 첫 번째 열: 1,4,7,2,5,8,3,6,9가 다름
      ];
    }

    return Container(
      width: 200,
      height: 200,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          int row = index ~/ gridSize;
          int col = index % gridSize;
          int? value = exampleData[row][col];

          bool isOriginal = value != null;

          // 테두리 색상 결정 (각 난이도별 테마 색상 사용)
          List<Color> borderColors = [];
          Color themeColor;

          // 난이도별 테마 색상 설정
          if (gridSize == 4) {
            themeColor = const Color(0xFF4CAF50); // 초록색
          } else if (gridSize == 6) {
            themeColor = const Color(0xFF2196F3); // 파란색
          } else {
            themeColor = const Color(0xFFFF5722); // 빨간색
          }

          // 첫 번째 행 (가로줄 규칙)
          if (row == 0) {
            borderColors.add(themeColor.withOpacity(0.8));
          }

          // 첫 번째 열 (세로줄 규칙)
          if (col == 0) {
            borderColors.add(themeColor.withOpacity(0.8));
          }

          // 첫 번째 박스 (박스 규칙)
          bool inFirstBox = false;
          if (gridSize == 4) {
            inFirstBox = row < 2 && col < 2; // 2x2 박스
          } else if (gridSize == 6) {
            inFirstBox = row < 2 && col < 3; // 3x2 박스 (2행 3열)
          } else {
            inFirstBox = row < 3 && col < 3; // 3x3 박스
          }

          if (inFirstBox) {
            borderColors.add(themeColor.withOpacity(0.8));
          }

          // 겹치는 부분은 더 진한 색상
          Color borderColor = Colors.white.withOpacity(0.3);
          if (borderColors.isNotEmpty) {
            if (borderColors.length == 1) {
              borderColor = themeColor.withOpacity(0.8);
            } else if (borderColors.length == 2) {
              // 두 규칙이 겹치는 경우 더 진한 색상
              borderColor = themeColor.withOpacity(1.0);
            } else if (borderColors.length == 3) {
              // 세 규칙이 모두 겹치는 경우 가장 진한 색상
              borderColor = themeColor.withOpacity(1.0);
            }
          }

          return Container(
            decoration: BoxDecoration(
              color: isOriginal
                  ? color.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              border: Border.all(color: borderColor, width: 2.0),
            ),
            child: Center(
              child: value != null
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/puzzles/char$value.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 이전 버튼
          if (_currentPage > 0)
            GestureDetector(
              onTap: () {
                _playButtonSound();
                _previousPage();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )
          else
            const SizedBox(width: 56),

          // 페이지 인디케이터
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalPages, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.amber
                      : Colors.white.withOpacity(0.3),
                ),
              );
            }),
          ),

          // 다음/완료 버튼
          GestureDetector(
            onTap: () {
              _playButtonSound();
              if (_currentPage < _totalPages - 1) {
                _nextPage();
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                _currentPage < _totalPages - 1
                    ? Icons.arrow_forward
                    : Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
