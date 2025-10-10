import 'dart:math' hide log;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/story_data.dart';
import '../services/audio_service.dart';

class StageCompletionDialog extends StatefulWidget {
  final int stageNumber;
  final VoidCallback onComplete;

  const StageCompletionDialog({
    super.key,
    required this.stageNumber,
    required this.onComplete,
  });

  @override
  State<StageCompletionDialog> createState() => _StageCompletionDialogState();
}

class _StageCompletionDialogState extends State<StageCompletionDialog>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _starController;
  late AnimationController _scaleController;
  late AnimationController _glowController;

  int _currentPage = 0;
  List<String> _storyPages = [];
  bool _showAnimation = true;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _starController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _storyPages = StoryData.getStageCompletionStory(
      widget.stageNumber,
      AppLocalizations.of(context),
    );

    // 완료 사운드 재생
    AudioService().playFinishSound();

    // 애니메이션 시작
    _startAnimations();
  }

  void _startAnimations() async {
    // 스케일 애니메이션
    _scaleController.forward();

    // 별 애니메이션 (회전과 크기 변화)
    _starController.repeat();

    // 글로우 애니메이션 (반복)
    _glowController.repeat(reverse: true);

    // 3초 후 애니메이션 숨기기
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _showAnimation = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _starController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _storyPages.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    final theme = StoryData.getStageTheme(widget.stageNumber);
    final characterName = StoryData.getCharacterName(
      widget.stageNumber,
      AppLocalizations.of(context),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Stack(
          children: [
            // 배경 글로우 효과
            if (_showAnimation)
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(
                            theme['primaryColor'],
                          ).withOpacity(0.3 * _glowController.value),
                          blurRadius: 50 * _glowController.value,
                          spreadRadius: 10 * _glowController.value,
                        ),
                      ],
                    ),
                  );
                },
              ),

            // 메인 다이얼로그
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(theme['accentColor']).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 상단 애니메이션 영역
                  if (_showAnimation) _buildAnimationSection(theme),

                  // 스토리 섹션
                  Expanded(child: _buildStorySection(theme, characterName)),

                  // 하단 컨트롤 섹션
                  _buildControlSection(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSection(Map<String, dynamic> theme) {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 별 폭발 애니메이션
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                final angle = (index * 45.0) * (3.14159 / 180);
                final distance = 60 * _starController.value;

                return Transform.translate(
                  offset: Offset(distance * cos(angle), distance * sin(angle)),
                  child: Transform.scale(
                    scale: 1.0 - _starController.value * 0.5,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(theme['accentColor']),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(theme['accentColor']).withOpacity(0.8),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // 중앙 성공 아이콘
          AnimatedBuilder(
            animation: _scaleController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleController.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(theme['primaryColor']).withOpacity(0.8),
                        Color(theme['accentColor']).withOpacity(0.6),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/btn-sucess.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
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

  Widget _buildStorySection(Map<String, dynamic> theme, String characterName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 상단 마진 추가
          const SizedBox(height: 40),

          // 캐릭터 이름 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(theme['accentColor']).withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(theme['accentColor']).withOpacity(0.6),
                width: 1,
              ),
            ),
            child: Text(
              characterName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 페이지 뷰
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _storyPages.length,
              itemBuilder: (context, index) {
                return _buildStoryPage(_storyPages[index], theme);
              },
            ),
          ),

          // 페이지 인디케이터
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_storyPages.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Color(theme['accentColor'])
                      : Colors.white.withOpacity(0.3),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStoryPage(String story, Map<String, dynamic> theme) {
    // 마크다운 스타일 텍스트 처리
    final parts = story.split('**');
    List<TextSpan> textSpans = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // 일반 텍스트
        textSpans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        );
      } else {
        // 굵은 텍스트
        textSpans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              color: Color(theme['accentColor']),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: textSpans),
        ),
      ),
    );
  }

  Widget _buildControlSection(Map<String, dynamic> theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 이전 버튼
          if (_currentPage > 0)
            GestureDetector(
              onTap: _previousPage,
              child: Container(
                padding: const EdgeInsets.all(12),
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
            const SizedBox(width: 48),

          // 중앙 빈 공간 (다음 버튼 제거)

          // 다음/완료 버튼
          GestureDetector(
            onTap: _currentPage < _storyPages.length - 1
                ? _nextPage
                : widget.onComplete,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                _currentPage < _storyPages.length - 1
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
