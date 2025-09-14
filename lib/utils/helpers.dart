import 'dart:math';
import 'package:flutter/material.dart';

class AppHelpers {
  // 랜덤 ID 생성
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }
  
  // 시간 포맷팅 (초 -> MM:SS)
  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  // 난이도 이름 반환
  static String getDifficultyName(int difficulty) {
    switch (difficulty) {
      case 3:
        return '쉬움';
      case 6:
        return '보통';
      case 9:
        return '어려움';
      default:
        return '알 수 없음';
    }
  }
  
  // 난이도별 색상 반환
  static Color getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 3:
        return Colors.green;
      case 6:
        return Colors.orange;
      case 9:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  // 별 개수에 따른 등급 반환
  static String getStarRating(int stars) {
    if (stars >= 1000) return '별똥별 마스터';
    if (stars >= 500) return '우주 탐험가';
    if (stars >= 200) return '별 관찰자';
    if (stars >= 100) return '초보 천문학자';
    if (stars >= 50) return '별똥별 수집가';
    if (stars >= 20) return '우주 여행자';
    if (stars >= 10) return '별똥별 발견자';
    return '우주 신입생';
  }
  
  // 스낵바 표시
  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  // 확인 다이얼로그 표시
  static Future<bool?> showConfirmDialog(
    BuildContext context, 
    String title, 
    String message
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  // 로딩 다이얼로그 표시
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
  
  // 로딩 다이얼로그 닫기
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
