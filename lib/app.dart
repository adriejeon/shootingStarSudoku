import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home_screen.dart';
import 'state/game_state.dart';
import 'state/user_progress_state.dart';
import 'state/profile_manager_state.dart';
import 'models/user_profile.dart';
import 'services/data_service.dart';
import 'services/ad_service.dart'; // 더미 구현으로 활성화
// import 'services/analytics_service.dart';
import 'services/audio_service.dart';
import 'ads/admob_handler.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 (비활성화)
  // try {
  //   await Firebase.initializeApp();
  //   print('Firebase initialized successfully');
  // } catch (e) {
  //   print('Firebase initialization failed: $e');
  //   print('Continuing without Firebase...');
  // }

  // Hive 초기화
  await Hive.initFlutter();

  // UserProfile 어댑터 등록
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserProfileAdapter());
  }

  // 데이터 서비스 초기화
  await DataService.instance.initialize();

  // 광고 서비스 초기화 (더미 구현)
  await AdService.instance.initialize();

  // AdMob은 main.dart에서 이미 초기화됨

  // 분석 서비스 초기화 (Firebase 비활성화로 인해 비활성화)
  // await AnalyticsService.instance.initialize();

  // 오디오 서비스 초기화
  await AudioService().initialize();
}

class ShootingStarSudokuApp extends StatelessWidget {
  const ShootingStarSudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => ProfileManagerState()),
        ChangeNotifierProxyProvider<ProfileManagerState, UserProgressState>(
          create: (_) => UserProgressState(),
          update: (context, profileManager, userProgress) {
            userProgress?.setProfileManager(profileManager);
            return userProgress ?? UserProgressState()
              ..setProfileManager(profileManager);
          },
        ),
      ],
      child: MaterialApp(
        title: '별똥별 스도쿠',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'NotoSansKR',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFF10152C), // 앱의 기본 배경색
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: AppInitializer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('AppInitializer: Starting initialization...');

      // DataService 초기화 (강제로 다시 초기화)
      print('AppInitializer: Initializing DataService...');
      await DataService.instance.initialize();
      print('AppInitializer: DataService initialized successfully');

      // ProfileManagerState에서 프로필 로드
      final profileManager = Provider.of<ProfileManagerState>(
        context,
        listen: false,
      );
      await profileManager.loadProfiles();
      print(
        'AppInitializer: Profiles loaded: ${profileManager.profiles.length}',
      );

      // 기본 프로필이 없으면 생성
      if (profileManager.profiles.isEmpty) {
        print('AppInitializer: No profiles found, creating default profile...');
        final newProfile = await profileManager.createProfile(
          '플레이어',
          'default',
        );
        print('AppInitializer: Default profile created: ${newProfile.id}');
      }

      print('AppInitializer: Initialization completed successfully');

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('AppInitializer: Initialization failed: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true; // 오류가 있어도 앱은 실행
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('앱을 초기화하는 중...'),
            ],
          ),
        ),
      );
    }

    return const HomeScreen();
  }
}
