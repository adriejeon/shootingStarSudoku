import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../l10n/app_localizations.dart';
import 'settings_screen.dart';
import 'stage_screen.dart';
import 'tutorial_screen.dart';
import '../state/profile_manager_state.dart';
import '../state/locale_state.dart';
import '../services/data_service.dart';
import '../services/audio_service.dart';
// import '../services/daily_game_service.dart'; // 사용하지 않음
import '../ads/admob_handler.dart';
import '../widgets/shooting_star_background.dart';
// import '../widgets/banner_ad_widget.dart'; // 더 이상 사용하지 않음
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _starController;
  bool _bannerAdLoaded = false;
  bool _isChangingLanguage = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
    _startBackgroundMusic();
    _setupBannerAdCallback();
  }

  void _startBackgroundMusic() async {
    await AudioService().playBackgroundMusic();
  }

  void _toggleLanguage() async {
    setState(() {
      _isChangingLanguage = true;
    });

    final localeState = Provider.of<LocaleState>(context, listen: false);
    localeState.toggleLocale();

    setState(() {
      _isChangingLanguage = false;
    });
  }

  void _setupBannerAdCallback() {
    final adHandler = AdmobHandler();

    // 초기 상태 확인
    _bannerAdLoaded = adHandler.bannerAd != null;
    print('HomeScreen: 초기 배너 광고 상태 - $_bannerAdLoaded');

    // 콜백 설정
    adHandler.setBannerCallback(() {
      if (mounted) {
        setState(() {
          _bannerAdLoaded = adHandler.bannerAd != null;
          print('HomeScreen: 배너 광고 상태 변경 - $_bannerAdLoaded');
        });
      }
    });

    // 주기적으로 광고 상태 확인 (폴백) - 여러 번 체크
    _checkBannerAdStatus(1);
    _checkBannerAdStatus(2);
    _checkBannerAdStatus(3);
    _checkBannerAdStatus(5);
  }

  void _checkBannerAdStatus(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      if (mounted) {
        final adHandler = AdmobHandler();
        final isLoaded = adHandler.bannerAd != null;
        if (isLoaded != _bannerAdLoaded) {
          setState(() {
            _bannerAdLoaded = isLoaded;
            print('HomeScreen: 배너 광고 상태 재확인 ($seconds초) - $_bannerAdLoaded');
          });
        }
      }
    });
  }

  void _initializeAnimations() {
    _starController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _starController.repeat(reverse: true);
  }

  Future<void> _loadData() async {
    // DataService 초기화 확인 (AppInitializer에서 이미 초기화됨)
    if (!DataService.instance.isInitialized) {
      await DataService.instance.initialize();
    }

    // 프로필 로드
    final profileManager = Provider.of<ProfileManagerState>(
      context,
      listen: false,
    );

    await profileManager.loadProfiles();
  }

  Future<void> _triggerHapticFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vibrationEnabled =
          prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;

      if (vibrationEnabled) {
        // 안드로이드에서 더 강력한 진동을 위해 vibration 패키지 사용
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
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

  // 플레이 버튼 클릭 처리
  Future<void> _handlePlayButtonClick() async {
    // 홈 화면에서는 단순히 스테이지 화면으로 이동
    _navigateToStage();
  }

  // 스테이지 화면으로 이동
  void _navigateToStage() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StageScreen()),
      );
    }
  }

  // 배너 광고 위젯
  Widget _buildBannerAd() {
    // 언어 변경 중이거나 광고가 로드되지 않았을 때는 플레이스홀더 표시
    if (_isChangingLanguage || !_bannerAdLoaded) {
      return Container(
        width: 320,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.adLoading,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      );
    }

    // 광고가 로드되었으면 표시
    final adHandler = AdmobHandler();
    final bannerAd = adHandler.bannerAd;

    if (bannerAd != null) {
      return Container(
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        child: AdWidget(ad: bannerAd),
      );
    } else {
      // 광고 객체가 없으면 플레이스홀더 표시
      return Container(
        width: 320,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.adLoading,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Consumer<LocaleState>(
      builder: (context, localeState, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF0E132A)),
            child: ShootingStarBackground(
              numberOfStars: 3,
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 화면 크기에 따른 레이아웃 조정
                    final screenHeight = constraints.maxHeight;
                    final isSmallScreen = screenHeight < 600;
                    final isVerySmallScreen = screenHeight < 500;

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: screenHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              // 상단 여백
                              SizedBox(
                                height: isVerySmallScreen
                                    ? 20
                                    : isSmallScreen
                                    ? 40
                                    : 60,
                              ),

                              // 메인 콘텐츠 (화면 중앙)
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildHeader(
                                      isTablet,
                                      screenSize,
                                      localeState,
                                    ),
                                    _buildContent(
                                      isTablet,
                                      screenSize,
                                      localeState,
                                    ),
                                  ],
                                ),
                              ),

                              // 하단 여백과 배너 광고
                              SizedBox(
                                height: isVerySmallScreen
                                    ? 20
                                    : isSmallScreen
                                    ? 40
                                    : 60,
                              ),
                              // 배너 광고 (직접 처리)
                              _buildBannerAd(),
                              SizedBox(height: 20), // 하단 여백
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isTablet, Size screenSize, LocaleState localeState) {
    // 아이패드에서는 타이틀 크기와 위치 조절
    final titleHeight = isTablet ? screenSize.height * 0.10 : 78.0;

    // 현재 언어에 따라 타이틀 이미지 선택
    final titleImage = localeState.currentLocale.languageCode == 'en'
        ? 'assets/images/main-title-en.png'
        : 'assets/images/main-title.png';

    return Image.asset(titleImage, height: titleHeight, fit: BoxFit.contain);
  }

  Widget _buildContent(
    bool isTablet,
    Size screenSize,
    LocaleState localeState,
  ) {
    // 화면 크기에 따른 버튼 크기와 간격 조절
    final screenHeight = screenSize.height;
    final isSmallScreen = screenHeight < 600;
    final isVerySmallScreen = screenHeight < 500;

    final playButtonHeight = isTablet
        ? screenSize.height * 0.08
        : isVerySmallScreen
        ? 50.0
        : isSmallScreen
        ? 60.0
        : 70.0;
    final settingButtonHeight = isTablet
        ? screenSize.height * 0.07
        : isVerySmallScreen
        ? 40.0
        : isSmallScreen
        ? 50.0
        : 60.0;
    final buttonSpacing = isTablet
        ? screenSize.height * 0.05
        : isVerySmallScreen
        ? 20.0
        : isSmallScreen
        ? 30.0
        : 40.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: buttonSpacing),
          // 플레이 버튼
          GestureDetector(
            onTap: () async {
              await _triggerHapticFeedback();
              await _handlePlayButtonClick();
            },
            child: Image.asset(
              'assets/images/btn-play.png',
              height: playButtonHeight,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: buttonSpacing),
          // 튜토리얼 버튼과 설정 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 튜토리얼 버튼
              GestureDetector(
                onTap: () {
                  _triggerHapticFeedback();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TutorialScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/btn-tutorial.png',
                  height: settingButtonHeight,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: isTablet ? 40 : 20),
              // 설정 버튼
              GestureDetector(
                onTap: () {
                  _triggerHapticFeedback();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/btn-setting.png',
                  height: settingButtonHeight,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: isTablet ? 40 : 20),
              // 언어 교체 버튼
              GestureDetector(
                onTap: () {
                  _triggerHapticFeedback();
                  _toggleLanguage();
                },
                child: Image.asset(
                  localeState.currentLocale.languageCode == 'ko'
                      ? 'assets/images/lang_en.png'
                      : 'assets/images/lang_kr.png',
                  height: settingButtonHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: buttonSpacing),
          // 홈 이미지 (화면 크기에 따라 크기 조정)
          SizedBox(
            width:
                screenSize.width *
                (isVerySmallScreen
                    ? 0.8
                    : isSmallScreen
                    ? 0.85
                    : 0.9),
            height: isVerySmallScreen
                ? 120
                : isSmallScreen
                ? 150
                : 180,
            child: Image.asset(
              'assets/images/home-img.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
