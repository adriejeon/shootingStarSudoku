import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart' show initializeApp, ShootingStarSudokuApp;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeApp();

  FlutterNativeSplash.remove();
  runApp(const ShootingStarSudokuApp());
}
