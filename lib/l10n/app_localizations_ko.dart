// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '별똥별 스도쿠';

  @override
  String get appTitle => '별똥별 스도쿠';

  @override
  String get loading => '앱을 초기화하는 중...';

  @override
  String get adLoading => '광고 로딩 중...';

  @override
  String get home => '홈';

  @override
  String get play => '플레이';

  @override
  String get tutorial => '튜토리얼';

  @override
  String get settings => '설정';

  @override
  String get profile => '프로필';

  @override
  String get time => '시간';

  @override
  String get mistakes => '실수';

  @override
  String get undo => '돌리기';

  @override
  String get erase => '지우기';

  @override
  String get reset => '초기화';

  @override
  String get gameComplete => '축하합니다!';

  @override
  String get gameCompleteMessage => '조각을 모두 모았습니다!';

  @override
  String get completionTime => '완료 시간';

  @override
  String get goHome => '홈으로';

  @override
  String get goStage => '스테이지로';

  @override
  String get gameFailed => '게임 실패!';

  @override
  String get gameFailedMessage => '실수를 3번 하였습니다.\n다시 시도해보세요!';

  @override
  String get gameFailedNoMoves => '더 이상 유효한 움직임이 없습니다.\n다시 시도해보세요!';

  @override
  String get continueGame => '이어서 하기';

  @override
  String mistakeMessage(Object count, Object max) {
    return '실수 $count/$max - 이 위치에 해당 캐릭터를 넣을 수 없습니다';
  }

  @override
  String mistakeCount(Object count, Object max) {
    return '$count/$max';
  }

  @override
  String get stageComplete => '스테이지 완료!';

  @override
  String get levelComplete => '레벨 완료!';

  @override
  String get settingsTitle => '설정';

  @override
  String get gameSettings => '게임 설정';

  @override
  String get backgroundMusic => '배경음악';

  @override
  String get backgroundMusicDesc => '게임 배경음악 재생';

  @override
  String get soundEffects => '효과음';

  @override
  String get soundEffectsDesc => '버튼 클릭 및 게임 효과음';

  @override
  String get vibration => '진동 효과';

  @override
  String get vibrationDesc => '터치 시 진동 피드백';

  @override
  String get notifications => '알림';

  @override
  String get notificationsDesc => '게임 관련 알림 수신';

  @override
  String get info => '정보';

  @override
  String get appVersion => '앱 버전';

  @override
  String get developer => '개발자';

  @override
  String get contact => '문의하기';

  @override
  String get contactEmail => 'support@shootingstarsudoku.com';

  @override
  String get data => '데이터';

  @override
  String get resetData => '데이터 초기화';

  @override
  String get resetDataDesc => '모든 게임 데이터를 삭제합니다';

  @override
  String get resetDataConfirm => '모든 게임 데이터가 삭제됩니다.\n정말로 진행하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get dataResetComplete => '데이터가 초기화되었습니다';

  @override
  String get tutorialTitle => '게임 사용법';

  @override
  String get tutorialWelcome => '별똥별 스도쿠에\n오신 것을 환영합니다!';

  @override
  String get tutorialDescription =>
      '별똥별 스도쿠는 캐릭터를 맞추는 퍼즐 게임이에요!\n각 행, 열, 박스에 캐릭터가 겹치지 않게\n배치하는 것이 목표입니다.';

  @override
  String get tutorialStartTip => '초급부터 시작해서 차근차근 배워보세요!';

  @override
  String get tutorialBeginner => '초급 (4×4)';

  @override
  String get tutorialBeginnerSubtitle => '스도쿠 기본 익히기';

  @override
  String get tutorialBeginnerDesc =>
      '4×4 격자에서 1번부터 4번까지의 캐릭터를 사용합니다.\n각 행, 열, 그리고 2×2 박스에 1~4번 캐릭터가 한 번씩만 들어가야 해요!';

  @override
  String get tutorialIntermediate => '중급 (6×6)';

  @override
  String get tutorialIntermediateSubtitle => '조금 더 복잡한 도전';

  @override
  String get tutorialIntermediateDesc =>
      '6×6 격자에서 1번부터 6번까지의 캐릭터를 사용합니다.\n각 행, 열, 그리고 3×2 박스에 1~6번 캐릭터가 한 번씩만 들어가야 해요!';

  @override
  String get tutorialAdvanced => '고급 (9×9)';

  @override
  String get tutorialAdvancedSubtitle => '진짜 스도쿠 마스터 도전';

  @override
  String get tutorialAdvancedDesc =>
      '9×9 격자에서 1번부터 9번까지의 캐릭터를 사용합니다.\n각 행, 열, 그리고 3×3 박스에 1~9번 캐릭터가 한 번씩만 들어가야 해요!';

  @override
  String get gameRules => '게임 규칙';

  @override
  String get gameControls => '조작 방법';

  @override
  String get control1 => '1. 빈 칸을 터치하여 선택하세요';

  @override
  String get control2 => '2. 하단의 캐릭터 버튼을 눌러 캐릭터를 입력하세요';

  @override
  String get control3 => '3. 실수했다면 \"돌리기\" 버튼으로 되돌릴 수 있어요';

  @override
  String get control4 => '4. \"지우기\" 모드로 캐릭터를 삭제할 수도 있어요';

  @override
  String get profileManagement => '프로필 관리';

  @override
  String get noProfiles => '아직 프로필이 없습니다';

  @override
  String get createFirstProfile => '첫 프로필 만들기';

  @override
  String get active => '활성';

  @override
  String get stars => '별';

  @override
  String get select => '선택';

  @override
  String get edit => '편집';

  @override
  String get delete => '삭제';

  @override
  String get createProfile => '새 프로필 만들기';

  @override
  String get profileName => '프로필 이름';

  @override
  String get avatarSelection => '아바타 선택';

  @override
  String get create => '만들기';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get save => '저장';

  @override
  String get deleteProfile => '프로필 삭제';

  @override
  String deleteProfileConfirm(Object name) {
    return '$name 프로필을 삭제하시겠습니까?';
  }

  @override
  String get stage1Title => '빛의 조각';

  @override
  String get stage2Title => '멜로디 조각';

  @override
  String get stage3Title => '무지개 조각';

  @override
  String get stage4Title => '탱탱볼 조각';

  @override
  String get stage5Title => '지혜의 조각';

  @override
  String get stage6Title => '생명의 조각';

  @override
  String get stage7Title => '에너지 조각';

  @override
  String get stage8Title => '온기의 조각';

  @override
  String get stage9Title => '별자리 조각';

  @override
  String get stageDefaultTitle => '수수께끼 조각';

  @override
  String levelFormat(Object level) {
    return '$level / 20';
  }

  @override
  String get storyTitle => '행성 스토리';

  @override
  String get help => '도움말';

  @override
  String get findLight => '어서 빛을 찾아주세요.';

  @override
  String get stage1StoryTitle => '반짝이 행성의 전설';

  @override
  String get stage2StoryTitle => '방울이 행성의 멜로디';

  @override
  String get stage3StoryTitle => '구름이 행성의 무지개';

  @override
  String get stage4StoryTitle => '꼬마젤리 행성의 축제';

  @override
  String get stage5StoryTitle => '똑똑이 행성의 도서관';

  @override
  String get stage6StoryTitle => '숲지기 행성의 생명';

  @override
  String get stage7StoryTitle => '꼬마번개 행성의 에너지';

  @override
  String get stage8StoryTitle => '따뜻이 행성의 온기';

  @override
  String get stage9StoryTitle => '어둠이 행성의 이야기';

  @override
  String get stageDefaultStoryTitle => '우주의 신비';

  @override
  String get stage1StoryContent =>
      '우주 한편에 반짝이는 것을 무엇보다 사랑하는 작은 요정 \'반짝이\'가 살고 있는 아름다운 행성이 있었습니다. 반짝이 행성은 수많은 반짝이는 별들로 가득했고, 반짝이는 그 별들과 함께 행복하게 살고 있었어요. 하지만 어느 날, 거대한 별똥별이 행성과 충돌하면서 모든 반짝이는 별들이 조각조각 흩어져 버렸습니다! 반짝이는 너무나 슬펐고, 흩어진 별 조각들을 다시 모아야만 행성의 빛을 되찾을 수 있다는 것을 알게 되었습니다.';

  @override
  String get stage2StoryContent =>
      '이곳은 온 세상이 맑고 투명한 물로 이루어진 방울이 행성이에요. 행성의 별들은 \'별방울\'이라 불렸는데, 이 별방울들이 수면 위로 떠오를 때마다 아름다운 멜로디가 울려 퍼졌죠. 하지만 거대한 별똥별이 행성의 바다와 충돌하면서, 모든 별방울이 깨져버렸어요! 그 후로 방울이 행성의 아름다운 음악은 멈추고 말았답니다. 방울이는 깨진 별방울 조각을 다시 맞춰 행성의 멜로디를 되찾고 싶어 해요.';

  @override
  String get stage3StoryContent =>
      '푹신푹신 구름으로 가득한 이곳은 구름이 행성이랍니다. 이곳의 별들은 \'솜사탕 별\'이라고 불렸어요. 낮에는 햇살을 머금고, 밤에는 스스로 무지갯빛을 내며 구름 세상을 아름답게 비춰주었죠. 별똥별이 부딪히는 바람에 솜사탕 별들이 산산조각 나면서, 행성은 온통 잿빛 구름에 갇히게 되었어요. 낮잠 자는 것을 가장 좋아했던 구름이는 알록달록한 꿈을 꾸기 위해 흩어진 별 조각을 모으기로 결심했어요.';

  @override
  String get stage4StoryContent =>
      '말랑말랑! 탱글탱글! 온통 젤리로 만들어진 꼬마젤리 행성에 오신 것을 환영해요! 이곳의 별들은 \'탱탱볼 별\'이었어요. 통통 튀어 오를 때마다 달콤한 에너지를 만들어내서, 행성 전체가 신나는 축제 같았죠. 하지만 별똥별이 떨어진 후, 탱탱볼 별들은 조각나 바닥에 끈적이게 붙어버렸어요. 행성의 신나는 축제도 멈춰버렸죠. 장난꾸러기 꼬마젤리는 다시 행성을 방방 뛰게 만들기 위해 당신의 도움이 필요해요!';

  @override
  String get stage5StoryContent =>
      '반짝이는 거대한 크리스탈이 지식의 숲을 이루는 이곳은 똑똑이 행성입니다. 행성의 별들은 \'지혜의 별\'이라 불리며, 그 빛 속에는 우주의 모든 지식과 이야기가 담겨 있었어요. 별똥별 충돌로 지혜의 별들이 조각나자, 행성의 모든 지식이 뒤죽박죽 섞여버렸습니다! 똑똑박사 똑똑이는 뒤섞인 지식을 바로잡고 행성의 위대한 도서관을 복원하기 위해 별 조각들을 맞추고 있어요.';

  @override
  String get stage6StoryContent =>
      '싱그러운 풀과 나무가 가득한 이곳은 숲지기 행성이에요. 밤하늘의 별들은 \'생명의 별\'이라 불렸는데, 이 별빛을 받은 식물들은 마법처럼 무럭무럭 자라났답니다. 하지만 거대한 별똥별이 숲을 덮치면서 생명의 별들이 모두 조각나 버렸고, 행성의 식물들은 시들기 시작했어요. 마음씨 착한 숲지기는 사랑하는 숲을 되살리기 위해 흩어진 생명의 별 조각들을 애타게 찾고 있답니다.';

  @override
  String get stage7StoryContent =>
      '찌릿찌릿! 짜릿한 에너지가 넘치는 이곳은 꼬마번개 행성이랍니다. 이곳의 별들은 \'에너지 별\'로, 행성 전체에 강력한 에너지를 공급해 주었어요. 덕분에 행성의 하늘에서는 매일 밤 멋진 번개 쇼가 펼쳐졌죠. 별똥별 충돌 이후, 에너지 별들이 모두 부서져 행성은 힘을 잃고 어두워졌어요. 활발한 꼬마번개는 이 조용한 어둠이 너무 심심해요! 어서 별 조각을 모아 다시 짜릿한 번개 쇼를 시작하고 싶어 해요.';

  @override
  String get stage8StoryContent =>
      '포근한 사랑의 기운이 가득한 이곳은 따뜻이 행성이에요. 하늘에 떠 있는 별들은 \'마음의 별\'로, 언제나 따스한 온기를 행성 곳곳에 나눠주었답니다. 하지만 별똥별이 떨어지며 마음의 별들이 차갑게 조각나 버렸고, 행성에는 외롭고 쓸쓸한 기운이 퍼지기 시작했어요. 다정한 따뜻이는 모두의 마음을 다시 따뜻하게 만들기 위해 흩어진 마음의 별 조각들을 모으고 있어요.';

  @override
  String get stage9StoryContent =>
      '고요한 어둠 속에서 가장 아름다운 밤하늘을 볼 수 있는 이곳은 어둠이 행성입니다. 이곳의 별들은 밤하늘에 커다란 그림을 그리는 \'별자리 별\'이었어요. 이 별자리들은 우주의 오래된 이야기를 들려주었죠. 별똥별이 별자리들을 흩어버린 후, 밤하늘의 위대한 이야기들도 모두 사라졌습니다. 신비로운 어둠이는 잊혀진 우주의 이야기를 되찾기 위해, 흩어진 별자리 조각들을 맞추려 합니다.';

  @override
  String adventureRecord(Object character) {
    return '$character의 모험 기록';
  }

  @override
  String level(Object number) {
    return 'Level $number';
  }

  @override
  String get rulesRow => '• 각 행에는 1, 2, 3, 4번 캐릭터가 한 번씩만';

  @override
  String get rulesColumn => '• 각 열에도 1, 2, 3, 4번 캐릭터가 한 번씩만';

  @override
  String get rulesBox4x4 => '• 각 2×2 박스에도 1, 2, 3, 4번 캐릭터가 한 번씩만';

  @override
  String get rulesFixed => '• 이미 채워진 캐릭터는 고정이에요';

  @override
  String get rulesRow6x6 => '• 각 행에는 1, 2, 3, 4, 5, 6번 캐릭터가 한 번씩만';

  @override
  String get rulesColumn6x6 => '• 각 열에도 1, 2, 3, 4, 5, 6번 캐릭터가 한 번씩만';

  @override
  String get rulesBox6x6 => '• 각 3×2 박스에도 1~6번 캐릭터가 한 번씩만';

  @override
  String get rulesLogic6x6 => '• 논리적 사고가 더 필요해요';

  @override
  String get rulesRow9x9 => '• 각 행에는 1~9번 캐릭터가 한 번씩만';

  @override
  String get rulesColumn9x9 => '• 각 열에도 1~9번 캐릭터가 한 번씩만';

  @override
  String get rulesBox9x9 => '• 각 3×3 박스에도 1~9번 캐릭터가 한 번씩만';

  @override
  String get rulesLogic9x9 => '• 고도의 집중력과 논리가 필요해요';

  @override
  String get gameTime => '시간';

  @override
  String get gameMistakes => '실수';

  @override
  String get gameUndo => '돌리기';

  @override
  String get gameErase => '지우기';

  @override
  String get gameHome => '홈으로';

  @override
  String get gameStage => '스테이지로';

  @override
  String get gameContinue => '이어서 하기';

  @override
  String get gameSuccess => '축하합니다!';

  @override
  String get gameCompleted => '완료!';

  @override
  String get gamePiecesCollected => '조각을 모두 모았습니다!';

  @override
  String gameCompletionTime(Object time) {
    return '완료 시간: $time';
  }

  @override
  String get gameFailure => '게임 실패!';

  @override
  String gameMaxMistakes(Object max) {
    return '실수를 $max번 하였습니다.\n다시 시도해보세요!';
  }

  @override
  String get gameNoValidMoves => '더 이상 유효한 움직임이 없습니다.\n다시 시도해보세요!';

  @override
  String gameMistakeMessage(Object current, Object max) {
    return '실수 $current/$max - 이 위치에 해당 캐릭터를 넣을 수 없습니다';
  }

  @override
  String get stage1Fragment => '빛의 조각';

  @override
  String get stage2Fragment => '멜로디 조각';

  @override
  String get stage3Fragment => '무지개 조각';

  @override
  String get stage4Fragment => '탱탱볼 조각';

  @override
  String get stage5Fragment => '지혜의 조각';

  @override
  String get stage6Fragment => '생명의 조각';

  @override
  String get stage7Fragment => '에너지 조각';

  @override
  String get stage8Fragment => '온기의 조각';

  @override
  String get stage9Fragment => '별자리 조각';

  @override
  String get stageDefaultFragment => '수수께끼 조각';

  @override
  String get character1 => '반짝이';

  @override
  String get character2 => '방울이';

  @override
  String get character3 => '구름이';

  @override
  String get character4 => '꼬마젤리';

  @override
  String get character5 => '똑똑이';

  @override
  String get character6 => '숲지기';

  @override
  String get character7 => '꼬마번개';

  @override
  String get character8 => '따뜻이';

  @override
  String get character9 => '어둠이';

  @override
  String get characterDefault => '우주친구';
}
