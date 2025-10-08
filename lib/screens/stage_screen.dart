import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_progress_state.dart';
import '../utils/constants.dart';
import '../widgets/story_bubble.dart';
import '../models/story_data.dart';
import '../services/daily_game_service.dart';
import '../ads/admob_handler.dart';
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
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
      return;
    }

    // UserProgressState에서 최초 진입 여부 확인
    final userProgress = Provider.of<UserProgressState>(context, listen: false);

    // 프로필이 없으면 잠시 대기 후 다시 시도 (최대 5번, 더 긴 대기시간)
    int retryCount = 0;
    while (userProgress.currentProfile == null && retryCount < 5) {
      await Future.delayed(const Duration(milliseconds: 1000));
      retryCount++;
    }

    // 최종 프로필 확인
    if (userProgress.currentProfile == null) {
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
      return;
    }

    final isFirstVisit = !userProgress.isStageVisited(widget.stageNumber);

    if (!isFirstVisit) {
      // 최초 진입이 아니면 애니메이션 없이 바로 완료 상태로
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
      return;
    }

    // 최초 진입이면 애니메이션 실행

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

  // 게임 시작 처리 (일일 게임 카운팅 포함)
  Future<void> _handleGameStart(int difficulty, int levelNumber) async {
    try {
      // 디버그 정보 출력
      await DailyGameService.debugCurrentState();

      // 현재 게임 횟수 확인
      final currentCount = await DailyGameService.getTodayGameCount();
      print('현재 게임 횟수: $currentCount');

      // 게임 횟수 증가
      await DailyGameService.incrementGameCount();

      // 증가된 횟수로 광고 여부 확인
      final newCount = currentCount + 1;
      final shouldShowAd = newCount >= 2; // 3번째부터 (0, 1, 2...)

      if (shouldShowAd) {
        // 3번째 게임부터 광고 표시
        print('일일 게임 광고 표시 - ${newCount + 1}번째 게임');
        final adHandler = AdmobHandler();

        // 광고가 준비되지 않았으면 먼저 로드
        if (!adHandler.isInterstitialAdLoaded) {
          print('일일 게임 광고 로드 중...');
          await adHandler.loadInterstitialAd();
        }

        await adHandler.showInterstitialAd();

        // 광고를 본 후 게임 화면으로 이동
        _navigateToGame(difficulty, levelNumber);
      } else {
        // 1-2번째 게임은 광고 없이 바로 이동
        print('무료 게임 - 광고 없이 진행');
        _navigateToGame(difficulty, levelNumber);
      }
    } catch (e) {
      print('게임 시작 오류: $e');
      // 오류 발생 시에도 게임 화면으로 이동
      _navigateToGame(difficulty, levelNumber);
    }
  }

  // 게임 화면으로 이동
  void _navigateToGame(int difficulty, int levelNumber) {
    if (mounted) {
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg${widget.stageNumber}.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isTablet, screenSize),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildLevelsGrid(context, isTablet, screenSize),
                ),
              ),
              // 스토리 말풍선 (하단 고정)
              _buildStorySection(context, isTablet, screenSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet, Size screenSize) {
    final titleHeight = isTablet ? screenSize.height * 0.05 : 50.0; // 타이틀 크기 증가
    final iconSize = isTablet ? screenSize.width * 0.03 : 24.0; // 아이콘 크기 줄임
    final buttonSize = isTablet ? screenSize.width * 0.06 : 40.0; // 버튼 크기 줄임
    final padding = isTablet ? screenSize.width * 0.03 : 20.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          // 홈 버튼 (왼쪽) - 주석처리
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => const HomeScreen()),
          //       (route) => false,
          //     );
          //   },
          //   child: Container(
          //     width: 35,
          //     height: 35,
          //     decoration: BoxDecoration(
          //       color: Colors.black.withOpacity(0.3),
          //       borderRadius: BorderRadius.circular(8),
          //       border: Border.all(
          //         color: Colors.white.withOpacity(0.2),
          //         width: 1,
          //       ),
          //     ),
          //     child: Icon(Icons.home, color: Colors.white, size: 20),
          //   ),
          // ),
          // 타이틀 이미지 (왼쪽 정렬)
          Image.asset(
            'assets/images/title${widget.stageNumber}.png',
            height: titleHeight,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          // 스토리 모달 버튼 (오른쪽)
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(isTablet ? 30 : 20),
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
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: IconButton(
                onPressed: () => _showStoryModal(context),
                icon: Image.asset(
                  'assets/images/icon-info.png',
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
                tooltip: '행성 스토리',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    bool isTablet,
    Size screenSize,
  ) {
    final buttonSize = isTablet ? screenSize.width * 0.08 : 60.0;
    final padding = isTablet ? screenSize.width * 0.03 : 20.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 뒤로 가기 버튼
          GestureDetector(
            onTap: () {
              if (widget.stageNumber > 1) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        StageScreen(
                          stageNumber: widget.stageNumber - 1,
                          skipAnimation: true,
                        ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          // 이전 스테이지로 이동: 왼쪽에서 오른쪽으로 슬라이드
                          const begin = Offset(-1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/btn-back.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 앞으로 가기 버튼
          GestureDetector(
            onTap: widget.stageNumber < 9
                ? () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            StageScreen(
                              stageNumber: widget.stageNumber + 1,
                              skipAnimation: true,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              // 다음 스테이지로 이동: 오른쪽에서 왼쪽으로 슬라이드
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  }
                : null,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Opacity(
                opacity: widget.stageNumber < 9 ? 1.0 : 0.5,
                child: Image.asset(
                  'assets/images/btn-front.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsGrid(
    BuildContext context,
    bool isTablet,
    Size screenSize,
  ) {
    return Consumer<UserProgressState>(
      builder: (context, userProgress, child) {
        // 프로필이 없어도 기본 레벨 그리드 표시

        final padding = isTablet ? screenSize.width * 0.08 : 20.0;
        final spacing = isTablet ? screenSize.height * 0.025 : 20.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            padding,
            padding * 0.3,
            padding,
            padding,
          ),
          child: Column(
            children: [
              // 첫 번째 줄: 3x3 레벨 (1-4)
              _buildLevelRow(
                context,
                userProgress,
                1,
                4,
                AppConstants.easyDifficulty,
                isTablet,
                screenSize,
              ),
              SizedBox(height: spacing),

              // 두 번째 줄: 6x6 레벨 (5-8)
              _buildLevelRow(
                context,
                userProgress,
                5,
                8,
                AppConstants.mediumDifficulty,
                isTablet,
                screenSize,
              ),
              SizedBox(height: spacing),

              // 세 번째 줄: 6x6 레벨 (9-12)
              _buildLevelRow(
                context,
                userProgress,
                9,
                12,
                AppConstants.mediumDifficulty,
                isTablet,
                screenSize,
              ),
              SizedBox(height: spacing),

              // 네 번째 줄: 9x9 레벨 (13-16)
              _buildLevelRow(
                context,
                userProgress,
                13,
                16,
                AppConstants.hardDifficulty,
                isTablet,
                screenSize,
              ),
              SizedBox(height: spacing),

              // 다섯 번째 줄: 9x9 레벨 (17-20)
              _buildLevelRow(
                context,
                userProgress,
                17,
                20,
                AppConstants.hardDifficulty,
                isTablet,
                screenSize,
              ),
              SizedBox(height: spacing * 1.5),

              // 네비게이션 버튼들
              _buildNavigationButtons(context, isTablet, screenSize),
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
    bool isTablet,
    Size screenSize,
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
          isTablet,
          screenSize,
        );
      }),
    );
  }

  Widget _buildLevelButton(
    BuildContext context,
    UserProgressState userProgress,
    int levelNumber,
    int difficulty,
    bool isTablet,
    Size screenSize,
  ) {
    bool isUnlocked = _isLevelUnlocked(userProgress, levelNumber);
    bool isCompleted = _isLevelCompleted(userProgress, levelNumber);

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
          ? () async {
              await _handleGameStart(difficulty, levelNumber);
            }
          : null,
      child: Container(
        width: isTablet ? screenSize.width * 0.1 : 60,
        height: isTablet ? screenSize.width * 0.1 : 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 15 : 8),
        ),
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
    // 스테이지가 잠겨있으면 모든 레벨이 잠김
    if (userProgress.isStageLocked(widget.stageNumber)) {
      return false;
    }

    // 첫 번째 레벨은 항상 언락 (스테이지가 잠금 해제된 경우)
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
                  Expanded(
                    child: Text(
                      storyTitle,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
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
              const SizedBox(height: 10),

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
              const SizedBox(height: 10),

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
        return '방울이 행성의 멜로디';
      case 3:
        return '구름이 행성의 무지개';
      case 4:
        return '꼬마젤리 행성의 축제';
      case 5:
        return '똑똑이 행성의 도서관';
      case 6:
        return '숲지기 행성의 생명';
      case 7:
        return '꼬마번개 행성의 에너지';
      case 8:
        return '따뜻이 행성의 온기';
      case 9:
        return '어둠이 행성의 이야기';
      default:
        return '우주의 신비';
    }
  }

  String _getStoryContent() {
    switch (widget.stageNumber) {
      case 1:
        return '''우주 한편에 반짝이는 것을 무엇보다 사랑하는 작은 요정 '반짝이'가 살고 있는 아름다운 행성이 있었습니다. 반짝이 행성은 수많은 반짝이는 별들로 가득했고, 반짝이는 그 별들과 함께 행복하게 살고 있었어요. 하지만 어느 날, 거대한 별똥별이 행성과 충돌하면서 모든 반짝이는 별들이 조각조각 흩어져 버렸습니다! 반짝이는 너무나 슬펐고, 흩어진 별 조각들을 다시 모아야만 행성의 빛을 되찾을 수 있다는 것을 알게 되었습니다.''';
      case 2:
        return '''이곳은 온 세상이 맑고 투명한 물로 이루어진 방울이 행성이에요. 행성의 별들은 '별방울'이라 불렸는데, 이 별방울들이 수면 위로 떠오를 때마다 아름다운 멜로디가 울려 퍼졌죠. 하지만 거대한 별똥별이 행성의 바다와 충돌하면서, 모든 별방울이 깨져버렸어요! 그 후로 방울이 행성의 아름다운 음악은 멈추고 말았답니다. 방울이는 깨진 별방울 조각을 다시 맞춰 행성의 멜로디를 되찾고 싶어 해요.''';
      case 3:
        return '''푹신푹신 구름으로 가득한 이곳은 구름이 행성이랍니다. 이곳의 별들은 '솜사탕 별'이라고 불렸어요. 낮에는 햇살을 머금고, 밤에는 스스로 무지갯빛을 내며 구름 세상을 아름답게 비춰주었죠. 별똥별이 부딪히는 바람에 솜사탕 별들이 산산조각 나면서, 행성은 온통 잿빛 구름에 갇히게 되었어요. 낮잠 자는 것을 가장 좋아했던 구름이는 알록달록한 꿈을 꾸기 위해 흩어진 별 조각을 모으기로 결심했어요.''';
      case 4:
        return '''말랑말랑! 탱글탱글! 온통 젤리로 만들어진 꼬마젤리 행성에 오신 것을 환영해요! 이곳의 별들은 '탱탱볼 별'이었어요. 통통 튀어 오를 때마다 달콤한 에너지를 만들어내서, 행성 전체가 신나는 축제 같았죠. 하지만 별똥별이 떨어진 후, 탱탱볼 별들은 조각나 바닥에 끈적이게 붙어버렸어요. 행성의 신나는 축제도 멈춰버렸죠. 장난꾸러기 꼬마젤리는 다시 행성을 방방 뛰게 만들기 위해 당신의 도움이 필요해요!''';
      case 5:
        return '''반짝이는 거대한 크리스탈이 지식의 숲을 이루는 이곳은 똑똑이 행성입니다. 행성의 별들은 '지혜의 별'이라 불리며, 그 빛 속에는 우주의 모든 지식과 이야기가 담겨 있었어요. 별똥별 충돌로 지혜의 별들이 조각나자, 행성의 모든 지식이 뒤죽박죽 섞여버렸습니다! 똑똑박사 똑똑이는 뒤섞인 지식을 바로잡고 행성의 위대한 도서관을 복원하기 위해 별 조각들을 맞추고 있어요.''';
      case 6:
        return '''싱그러운 풀과 나무가 가득한 이곳은 숲지기 행성이에요. 밤하늘의 별들은 '생명의 별'이라 불렸는데, 이 별빛을 받은 식물들은 마법처럼 무럭무럭 자라났답니다. 하지만 거대한 별똥별이 숲을 덮치면서 생명의 별들이 모두 조각나 버렸고, 행성의 식물들은 시들기 시작했어요. 마음씨 착한 숲지기는 사랑하는 숲을 되살리기 위해 흩어진 생명의 별 조각들을 애타게 찾고 있답니다.''';
      case 7:
        return '''찌릿찌릿! 짜릿한 에너지가 넘치는 이곳은 꼬마번개 행성이랍니다. 이곳의 별들은 '에너지 별'로, 행성 전체에 강력한 에너지를 공급해 주었어요. 덕분에 행성의 하늘에서는 매일 밤 멋진 번개 쇼가 펼쳐졌죠. 별똥별 충돌 이후, 에너지 별들이 모두 부서져 행성은 힘을 잃고 어두워졌어요. 활발한 꼬마번개는 이 조용한 어둠이 너무 심심해요! 어서 별 조각을 모아 다시 짜릿한 번개 쇼를 시작하고 싶어 해요.''';
      case 8:
        return '''포근한 사랑의 기운이 가득한 이곳은 따뜻이 행성이에요. 하늘에 떠 있는 별들은 '마음의 별'로, 언제나 따스한 온기를 행성 곳곳에 나눠주었답니다. 하지만 별똥별이 떨어지며 마음의 별들이 차갑게 조각나 버렸고, 행성에는 외롭고 쓸쓸한 기운이 퍼지기 시작했어요. 다정한 따뜻이는 모두의 마음을 다시 따뜻하게 만들기 위해 흩어진 마음의 별 조각들을 모으고 있어요.''';
      case 9:
        return '''고요한 어둠 속에서 가장 아름다운 밤하늘을 볼 수 있는 이곳은 어둠이 행성입니다. 이곳의 별들은 밤하늘에 커다란 그림을 그리는 '별자리 별'이었어요. 이 별자리들은 우주의 오래된 이야기를 들려주었죠. 별똥별이 별자리들을 흩어버린 후, 밤하늘의 위대한 이야기들도 모두 사라졌습니다. 신비로운 어둠이는 잊혀진 우주의 이야기를 되찾기 위해, 흩어진 별자리 조각들을 맞추려 합니다.''';
      default:
        return '''우주의 신비로운 모험이 당신을 기다리고 있습니다.

각각의 퍼즐을 해결하며 우주의 비밀을 하나씩 밝혀나가세요.

당신의 지혜와 용기가 필요한 순간입니다.''';
    }
  }

  /// 스토리 섹션을 구축합니다 (하단 고정)
  Widget _buildStorySection(
    BuildContext context,
    bool isTablet,
    Size screenSize,
  ) {
    return Consumer<UserProgressState>(
      builder: (context, userProgress, child) {
        // 현재 스테이지에서 가장 최근에 완료된 레벨을 찾습니다
        int latestCompletedLevel = _findLatestCompletedLevel(userProgress);

        // 완료된 레벨이 없으면 기본 메시지를 표시합니다
        if (latestCompletedLevel == 0) {
          return _buildDefaultStoryBubble(context, isTablet, screenSize);
        }

        return StoryBubble(
          stageNumber: widget.stageNumber,
          levelNumber: latestCompletedLevel,
          onTap: () => _showAllStories(context, userProgress),
        );
      },
    );
  }

  /// 게임을 하나도 깨지 않은 상태의 기본 말풍선을 구축합니다
  Widget _buildDefaultStoryBubble(
    BuildContext context,
    bool isTablet,
    Size screenSize,
  ) {
    final characterName = StoryData.getCharacterName(widget.stageNumber);
    final theme = StoryData.getStageTheme(widget.stageNumber);

    return GestureDetector(
      onTap: () => _showStoryModal(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(
          isTablet ? 40 : 20,
          0,
          isTablet ? 40 : 20,
          isTablet ? 10 : 5,
        ),
        child: Stack(
          children: [
            // 말풍선 그림자
            Positioned(
              left: 4,
              top: 4,
              child: _buildDefaultBubbleShape(
                characterName,
                theme,
                isTablet,
                isShadow: true,
              ),
            ),
            // 메인 말풍선
            _buildDefaultBubbleShape(characterName, theme, isTablet),
          ],
        ),
      ),
    );
  }

  /// 기본 말풍선 모양을 구축합니다
  Widget _buildDefaultBubbleShape(
    String characterName,
    Map<String, dynamic> theme,
    bool isTablet, {
    bool isShadow = false,
  }) {
    return CustomPaint(
      painter: BubblePainter(
        color: isShadow
            ? Colors.black.withOpacity(0.2)
            : const Color(0xFF0E132A).withOpacity(0.6),
        borderColor: isShadow
            ? Colors.transparent
            : Color(theme['accentColor']),
        isShadow: isShadow,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 24 : 20,
          isTablet ? 20 : 16,
          isTablet ? 24 : 20,
          isTablet ? 28 : 24,
        ),
        constraints: BoxConstraints(
          minHeight: isTablet ? 80 : 60,
          maxWidth: MediaQuery.of(context).size.width * (isTablet ? 0.9 : 0.95),
        ),
        child: isShadow
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 캐릭터 이름
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(theme['accentColor']).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(theme['accentColor']).withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          characterName,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // 안내 메시지
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '도움말',
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 기본 메시지
                  Text(
                    '어서 빛을 찾아주세요.',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// 현재 스테이지에서 가장 최근에 완료된 레벨을 찾습니다
  int _findLatestCompletedLevel(UserProgressState userProgress) {
    if (userProgress.currentProfile == null) return 0;

    int latestLevel = 0;
    for (int level = 1; level <= 20; level++) {
      if (userProgress.isLevelCompleted(widget.stageNumber, level)) {
        latestLevel = level;
      } else {
        break; // 순차적으로 완료되므로 미완료 레벨을 만나면 중단
      }
    }
    return latestLevel;
  }

  /// 완료된 모든 스토리를 보여주는 모달을 표시합니다
  void _showAllStories(BuildContext context, UserProgressState userProgress) {
    final completedLevels = <int>[];

    for (int level = 1; level <= 20; level++) {
      if (userProgress.isLevelCompleted(widget.stageNumber, level)) {
        completedLevels.add(level);
      }
    }

    if (completedLevels.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
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
                  Expanded(
                    child: Text(
                      '${StoryData.getCharacterName(widget.stageNumber)}의 모험 기록',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
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
              const SizedBox(height: 10),

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
              const SizedBox(height: 15),

              // 스토리 목록
              Expanded(
                child: ListView.builder(
                  itemCount: completedLevels.length,
                  itemBuilder: (context, index) {
                    final level = completedLevels[index];
                    final storyText = StoryData.getStoryText(
                      widget.stageNumber,
                      level,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $level',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            storyText ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
