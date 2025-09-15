import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';
import 'stage_screen.dart';
import '../state/profile_manager_state.dart';
import '../services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _starController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.elasticOut),
    );

    _starController.repeat(reverse: true);
    _titleController.forward();
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

  @override
  void dispose() {
    _starController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-main.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: AnimatedBuilder(
        animation: _titleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _titleAnimation.value,
            child: Image.asset(
              'assets/images/main-title.png',
              height: 80,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // 플레이 버튼
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StageScreen()),
              );
            },
            child: Image.asset(
              'assets/images/btn-play.png',
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          // 설정 버튼
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Image.asset(
              'assets/images/btn-setting.png',
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
