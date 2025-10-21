import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'ads/admob_handler.dart';
import 'app.dart' show initializeApp, ShootingStarSudokuApp;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'cd56392b0cfe2724d177cab0c3085a87',
  );

  // 앱 초기화 먼저 실행
  await initializeApp();

  // AdMob 초기화 (백그라운드에서 실행 - 앱 시작을 차단하지 않음)
  AdmobHandler()
      .initialize()
      .then((_) {
        print('Main: AdMob 초기화 성공');
      })
      .catchError((e) {
        print('Main: AdMob 초기화 실패 - 앱은 계속 실행: $e');
      });

  FlutterNativeSplash.remove();
  runApp(const ShootingStarSudokuApp());
}
