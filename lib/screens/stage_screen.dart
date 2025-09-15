import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_progress_state.dart';
import '../state/profile_manager_state.dart';
import '../utils/constants.dart';
import 'game_screen.dart';

class StageScreen extends StatefulWidget {
  final int stageNumber;
  final bool skipAnimation;

  const StageScreen({
    super.key,
    this.stageNumber = 1,
    this.skipAnimation = false,
  });

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticIn),
    );

    // 화면이 로드될 때마다 상태 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
        _startInitialAnimation();
      }
    });
  }

  void _startInitialAnimation() async {
    // 애니메이션 스킵 플래그 확인
    if (widget.skipAnimation) {
      print('StageScreen: Skipping animation (game completion return)');
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
      return;
    }

    // UserProgressState에서 최초 진입 여부 확인
    final userProgress = Provider.of<UserProgressState>(context, listen: false);

    print('StageScreen: Starting animation check...');
    print(
      'StageScreen: UserProgressState profile: ${userProgress.currentProfile?.name ?? 'null'}',
    );

    // 프로필이 없으면 잠시 대기 후 다시 시도 (최대 5번, 더 긴 대기시간)
    int retryCount = 0;
    while (userProgress.currentProfile == null && retryCount < 5) {
      print('StageScreen: No profile found, waiting... (${retryCount + 1}/5)');
      await Future.delayed(const Duration(milliseconds: 1000));
      retryCount++;
    }

    // 최종 프로필 확인
    if (userProgress.currentProfile == null) {
      print('StageScreen: No profile available, proceeding without profile');
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
      return;
    }

    print('StageScreen: Profile found: ${userProgress.currentProfile!.name}');

    final isFirstVisit = !userProgress.isStageVisited(widget.stageNumber);

    if (!isFirstVisit) {
      // 최초 진입이 아니면 애니메이션 없이 바로 완료 상태로
      print('StageScreen: Not first visit, skipping animation');
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
      return;
    }

    // 최초 진입이면 애니메이션 실행
    print(
      'StageScreen: First visit to stage ${widget.stageNumber}, starting animation',
    );

    // 잠시 대기 후 애니메이션 시작
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      // 스케일 애니메이션 먼저 시작
      _scaleController.forward();

      // 페이드 애니메이션 시작
      await _fadeController.forward();

      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });

        // 최초 방문 완료로 표시
        userProgress.visitStage(widget.stageNumber);
        print('StageScreen: Animation completed, marked as visited');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 의존성이 변경될 때마다 상태 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildLevelsGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Spacer(),
              // 스토리 모달 버튼
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _showStoryModal(context),
                  icon: const Icon(
                    Icons.menu_book,
                    color: Colors.amber,
                    size: 28,
                  ),
                  tooltip: '행성 스토리',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/title1.png',
            height: 80,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsGrid(BuildContext context) {
    return Consumer<UserProgressState>(
      builder: (context, userProgress, child) {
        // 프로필이 없어도 기본 레벨 그리드 표시
        print(
          'StageScreen: Building levels grid, profile: ${userProgress.currentProfile?.name ?? 'null'}',
        );

        // 디버그용 로그 추가
        print(
          'StageScreen: Rebuilding levels grid for stage ${widget.stageNumber}',
        );
        print(
          'Current completed levels: ${userProgress.currentProfile?.completedLevels}',
        );

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 첫 번째 줄: 3x3 레벨 (1-4)
              _buildLevelRow(
                context,
                userProgress,
                1,
                4,
                AppConstants.easyDifficulty,
              ),
              const SizedBox(height: 20),

              // 두 번째 줄: 6x6 레벨 (5-8)
              _buildLevelRow(
                context,
                userProgress,
                5,
                8,
                AppConstants.mediumDifficulty,
              ),
              const SizedBox(height: 20),

              // 세 번째 줄: 6x6 레벨 (9-12)
              _buildLevelRow(
                context,
                userProgress,
                9,
                12,
                AppConstants.mediumDifficulty,
              ),
              const SizedBox(height: 20),

              // 네 번째 줄: 9x9 레벨 (13-16)
              _buildLevelRow(
                context,
                userProgress,
                13,
                16,
                AppConstants.hardDifficulty,
              ),
              const SizedBox(height: 20),

              // 다섯 번째 줄: 9x9 레벨 (17-20)
              _buildLevelRow(
                context,
                userProgress,
                17,
                20,
                AppConstants.hardDifficulty,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelRow(
    BuildContext context,
    UserProgressState userProgress,
    int startLevel,
    int endLevel,
    int difficulty,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(endLevel - startLevel + 1, (index) {
        int levelNumber = startLevel + index;
        return _buildLevelButton(
          context,
          userProgress,
          levelNumber,
          difficulty,
        );
      }),
    );
  }

  Widget _buildLevelButton(
    BuildContext context,
    UserProgressState userProgress,
    int levelNumber,
    int difficulty,
  ) {
    bool isUnlocked = _isLevelUnlocked(userProgress, levelNumber);
    bool isCompleted = _isLevelCompleted(userProgress, levelNumber);

    // 디버그 로그 추가
    print('Level $levelNumber: unlocked=$isUnlocked, completed=$isCompleted');

    String finalImagePath;
    if (isCompleted) {
      finalImagePath = 'assets/images/btn-sucess.png';
    } else if (isUnlocked) {
      finalImagePath = 'assets/images/btn-star.png';
    } else {
      finalImagePath = 'assets/images/btn-lock.png';
    }

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    difficulty: difficulty,
                    stageNumber: widget.stageNumber,
                    levelNumber: levelNumber,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            // 애니메이션이 완료되지 않았으면 success 이미지 표시
            if (!_animationCompleted)
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(
                                0.6 * _fadeAnimation.value,
                              ),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
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
            // 최종 이미지 (애니메이션 완료 후 또는 처음부터)
            if (_animationCompleted)
              Image.asset(
                finalImagePath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }

  bool _isLevelUnlocked(UserProgressState userProgress, int levelNumber) {
    // 첫 번째 레벨은 항상 언락
    if (levelNumber == 1) return true;

    // 프로필이 없으면 첫 번째 레벨만 언락
    if (userProgress.currentProfile == null) {
      return levelNumber == 1;
    }

    // 이전 레벨이 완료되었으면 언락
    return _isLevelCompleted(userProgress, levelNumber - 1);
  }

  bool _isLevelCompleted(UserProgressState userProgress, int levelNumber) {
    // 프로필이 없으면 모든 레벨을 미완료로 처리
    if (userProgress.currentProfile == null) {
      return false;
    }

    // UserProgressState에서 레벨 완료 상태를 확인
    bool completed = userProgress.isLevelCompleted(
      widget.stageNumber,
      levelNumber,
    );
    print('Level ${widget.stageNumber}-$levelNumber completed: $completed');
    return completed;
  }

  void _showStoryModal(BuildContext context) {
    String storyTitle = _getStoryTitle();
    String storyContent = _getStoryContent();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
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
            border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목
              Row(
                children: [
                  Icon(Icons.auto_stories, color: Colors.amber, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      storyTitle,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 구분선
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.amber.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 스토리 내용
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Text(
                    storyContent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 닫기 버튼
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.withOpacity(0.2),
                  foregroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(
                      color: Colors.amber.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  '모험 시작하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStoryTitle() {
    switch (widget.stageNumber) {
      case 1:
        return '반짝이 행성의 전설';
      case 2:
        return '푸른 달의 비밀';
      case 3:
        return '불타는 태양의 수수께끼';
      case 4:
        return '얼음 혜성의 미스터리';
      case 5:
        return '무지개 성운의 신화';
      case 6:
        return '검은 홀의 전설';
      case 7:
        return '크리스탈 위성의 이야기';
      case 8:
        return '황금 소행성의 보물';
      case 9:
        return '은하수의 마지막 비밀';
      default:
        return '우주의 신비';
    }
  }

  String _getStoryContent() {
    switch (widget.stageNumber) {
      case 1:
        return '''우주 한 켠에 반짝이는 것을 무엇보다 사랑하는 작은 요정 '반짝이'가 살고 있는 아름다운 행성이 있었습니다.

반짝이 행성은 수많은 반짝이는 별들로 가득했고, 반짝이는 그 별들과 함께 행복하게 살고 있었어요.

하지만 어느 날, 거대한 별똥별이 행성과 충돌하면서 모든 반짝이는 별들이 조각조각 흩어져 버렸습니다!

반짝이는 너무나 슬퍼했고, 흩어진 별조각들을 다시 모아야만 행성의 빛을 되찾을 수 있다는 것을 알게 되었습니다.

당신은 반짝이를 도와 흩어진 별조각들을 올바른 자리에 배치하여 반짝이 행성의 빛을 되찾아 주세요!

각 퍼즐을 완성할 때마다 별조각 하나가 제자리를 찾아가고, 모든 퍼즐을 완성하면 반짝이 행성이 다시 아름답게 빛날 것입니다.''';
      case 2:
        return '''신비로운 푸른 달에는 고대의 지혜가 숨겨져 있습니다.

달의 크레이터마다 숨겨진 암호를 풀어야만 다음 단계로 나아갈 수 있어요.

푸른 달의 수호자가 당신을 기다리고 있습니다.''';
      case 3:
        return '''불타는 태양 속에는 뜨거운 에너지의 비밀이 숨겨져 있습니다.

태양의 흑점들이 만드는 패턴을 해독해야 합니다.

태양신의 시험을 통과하여 진정한 용기를 증명하세요.''';
      default:
        return '''우주의 신비로운 모험이 당신을 기다리고 있습니다.

각각의 퍼즐을 해결하며 우주의 비밀을 하나씩 밝혀나가세요.

당신의 지혜와 용기가 필요한 순간입니다.''';
    }
  }
}
