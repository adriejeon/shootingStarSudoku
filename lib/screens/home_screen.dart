import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'stage_screen.dart';
import '../state/profile_manager_state.dart';
import '../services/data_service.dart';
import '../services/audio_service.dart';
import '../widgets/shooting_star_background.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
    _startBackgroundMusic();
  }

  void _startBackgroundMusic() async {
    await AudioService().playBackgroundMusic();
  }

  void _initializeAnimations() {
    _starController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _starController.repeat(reverse: true);
  }

  Future<void> _loadData() async {
    print('HomeScreen: Starting data load...');

    // DataService 초기화 확인 (AppInitializer에서 이미 초기화됨)
    if (!DataService.instance.isInitialized) {
      print('HomeScreen: DataService not initialized, initializing...');
      await DataService.instance.initialize();
    }
    print('HomeScreen: DataService initialized');

    // 프로필 로드
    final profileManager = Provider.of<ProfileManagerState>(
      context,
      listen: false,
    );

    print('HomeScreen: Loading profiles...');
    await profileManager.loadProfiles();
    print('HomeScreen: Loaded ${profileManager.profiles.length} profiles');

    print('HomeScreen: Data load completed');
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

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF0E132A)),
        child: ShootingStarBackground(
          numberOfStars: 3,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(isTablet, screenSize),
                _buildContent(isTablet, screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet, Size screenSize) {
    // 아이패드에서는 타이틀 크기와 위치 조절
    final titleHeight = isTablet ? screenSize.height * 0.10 : 78.0;

    return Image.asset(
      'assets/images/main-title.png',
      height: titleHeight,
      fit: BoxFit.contain,
    );
  }

  Widget _buildContent(bool isTablet, Size screenSize) {
    // 아이패드에서는 버튼 크기와 간격 조절
    final playButtonHeight = isTablet ? screenSize.height * 0.08 : 70.0;
    final settingButtonHeight = isTablet ? screenSize.height * 0.07 : 60.0;
    final buttonSpacing = isTablet ? screenSize.height * 0.05 : 40.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: buttonSpacing),
          // 플레이 버튼
          GestureDetector(
            onTap: () {
              _triggerHapticFeedback();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StageScreen()),
              );
            },
            child: Image.asset(
              'assets/images/btn-play.png',
              height: playButtonHeight,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: buttonSpacing),
          // 설정 버튼
          GestureDetector(
            onTap: () {
              _triggerHapticFeedback();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Image.asset(
              'assets/images/btn-setting.png',
              height: settingButtonHeight,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: buttonSpacing),
          // 홈 이미지
          SizedBox(
            width: screenSize.width * 0.9,
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
