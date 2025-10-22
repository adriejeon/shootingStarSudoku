import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';

class ShareService {
  // 배달의민족 방식 공유 링크
  static const String _stageShareLink =
      'https://adriejeon.github.io/ShootingStartSudokuPolicy/share.html';

  /// 게임 스테이지 완료 공유하기 - 배달의민족 방식
  static Future<void> shareStageCompletion({
    required int stageNumber,
    required int levelNumber,
    required BuildContext context,
  }) async {
    await _shareStageToText(
      stageNumber: stageNumber,
      levelNumber: levelNumber,
      context: context,
    );
  }

  /// 배달의민족 방식 텍스트 공유 (내부 메서드)
  static Future<void> _shareStageToText({
    required int stageNumber,
    required int levelNumber,
    required BuildContext context,
  }) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final isKorean = Localizations.localeOf(context).languageCode == 'ko';

      // 스테이지별 이름 가져오기
      final stageName = _getStageName(stageNumber, l10n);

      final message = isKorean
          ? '⭐ 별똥별 스도쿠 - 스테이지 완료!\n\n스테이지: $stageName\n레벨: $levelNumber\n\n친구야 나 이 스토리 알아냈어!\n\n결과 확인하기: $_stageShareLink'
          : '⭐ Shooting Star Sudoku - Stage Complete!\n\nStage: $stageName\nLevel: $levelNumber\n\nI figured out this story!\n\nCheck Results: $_stageShareLink';

      await Share.share(message);
    } catch (e) {
      print('텍스트 공유 오류: $e');
    }
  }

  /// 스테이지 번호에 따른 스테이지 이름 반환
  static String _getStageName(int stageNumber, AppLocalizations l10n) {
    switch (stageNumber) {
      case 1:
        return l10n.stage1Title;
      case 2:
        return l10n.stage2Title;
      case 3:
        return l10n.stage3Title;
      case 4:
        return l10n.stage4Title;
      case 5:
        return l10n.stage5Title;
      case 6:
        return l10n.stage6Title;
      case 7:
        return l10n.stage7Title;
      case 8:
        return l10n.stage8Title;
      case 9:
        return l10n.stage9Title;
      default:
        return l10n.stageDefaultTitle;
    }
  }
}
