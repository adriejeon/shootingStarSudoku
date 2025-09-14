import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home_screen.dart';
import 'state/game_state.dart';
import 'state/user_progress_state.dart';
import 'state/profile_manager_state.dart';
import 'services/data_service.dart';
import 'services/ad_service.dart';
import 'services/analytics_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  await Firebase.initializeApp();
  
  // Hive 초기화
  await Hive.initFlutter();
  
  // 데이터 서비스 초기화
  await DataService.instance.initialize();
  
  // 광고 서비스 초기화
  await AdService.instance.initialize();
  
  // 분석 서비스 초기화
  await AnalyticsService.instance.initialize();
  
  runApp(const ShootingStarSudokuApp());
}

class ShootingStarSudokuApp extends StatelessWidget {
  const ShootingStarSudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => UserProgressState()),
        ChangeNotifierProvider(create: (_) => ProfileManagerState()),
      ],
      child: MaterialApp(
        title: '별똥별 스도쿠',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'NotoSansKR',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
