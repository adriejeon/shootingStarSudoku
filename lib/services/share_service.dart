import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';

class ShareService {
  static const String _smartLink = 'https://onelink.to/75vk5t';
  static const String _nativeAppKey = 'cd56392b0cfe2724d177cab0c3085a87';

  /// 게임 스테이지 완료 공유하기 - 공유 방법 선택 바텀 시트 표시
  static Future<void> shareStageCompletion({
    required int stageNumber,
    required int levelNumber,
    required BuildContext context,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';

    // 바텀 시트로 공유 방법 선택
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.shareTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble, color: Color(0xFFFAE100)),
                title: Text(l10n.shareViaKakao),
                onTap: () {
                  Navigator.pop(context);
                  _shareStageToKakao(
                    stageNumber: stageNumber,
                    levelNumber: levelNumber,
                    context: context,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Color(0xFF4A90E2)),
                title: Text(l10n.shareViaSMS),
                onTap: () {
                  Navigator.pop(context);
                  _shareStageToSMS(
                    stageNumber: stageNumber,
                    levelNumber: levelNumber,
                    context: context,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// 카카오톡으로 스테이지 완료 공유 (내부 메서드)
  static Future<void> _shareStageToKakao({
    required int stageNumber,
    required int levelNumber,
    required BuildContext context,
  }) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final isKorean = Localizations.localeOf(context).languageCode == 'ko';

      // 스테이지별 이름 가져오기
      final stageName = _getStageName(stageNumber, l10n);
      final characterName = _getCharacterName(stageNumber, l10n);

      // 카카오 Feed Template을 사용하여 썸네일이 있는 카드 형태로 공유
      final template = FeedTemplate(
        content: Content(
          title: isKorean ? '별똥별 스도쿠' : 'Shooting Star Sudoku',
          description: isKorean
              ? '친구야 나 이 스토리 알아냈어!\n$stageName 스테이지 $levelNumber'
              : 'I figured out this story!\n$stageName Stage $levelNumber',
          imageUrl: Uri.parse(
            'https://raw.githubusercontent.com/adriejeon/shootingStarSudoku/main/assets/images/Icon-App.png',
          ),
          link: Link(
            // 카카오 디벨로퍼스 설정 사용
          ),
        ),
        buttons: [
          Button(
            title: l10n.playGameButton,
            link: Link(
              // 카카오 디벨로퍼스에 등록된 기본 앱 실행 설정 사용
            ),
          ),
        ],
      );

      final uri = await ShareClient.instance.shareDefault(template: template);
      await ShareClient.instance.launchKakaoTalk(uri);
    } catch (e) {
      print('카카오톡 공유 오류: $e');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.shareKakaoFailed),
          ),
        );
      }
    }
  }

  /// 문자 메시지로 스테이지 완료 공유 (내부 메서드)
  static Future<void> _shareStageToSMS({
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
          ? '친구야 나 이 스토리 알아냈어!\n별똥별 스도쿠\n$stageName 스테이지 $levelNumber\n\n게임 다운로드: $_smartLink'
          : 'I figured out this story!\nShooting Star Sudoku\n$stageName Stage $levelNumber\n\nDownload: $_smartLink';

      await Share.share(message);
    } catch (e) {
      print('문자 메시지 공유 오류: $e');
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

  /// 스테이지 번호에 따른 캐릭터 이름 반환
  static String _getCharacterName(int stageNumber, AppLocalizations l10n) {
    switch (stageNumber) {
      case 1:
        return l10n.character1;
      case 2:
        return l10n.character2;
      case 3:
        return l10n.character3;
      case 4:
        return l10n.character4;
      case 5:
        return l10n.character5;
      case 6:
        return l10n.character6;
      case 7:
        return l10n.character7;
      case 8:
        return l10n.character8;
      case 9:
        return l10n.character9;
      default:
        return l10n.characterDefault;
    }
  }
}

