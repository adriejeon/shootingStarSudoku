import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'별똥별 스도쿠'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'별똥별 스도쿠'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'앱을 초기화하는 중...'**
  String get loading;

  /// No description provided for @adLoading.
  ///
  /// In ko, this message translates to:
  /// **'광고 로딩 중...'**
  String get adLoading;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @play.
  ///
  /// In ko, this message translates to:
  /// **'플레이'**
  String get play;

  /// No description provided for @tutorial.
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼'**
  String get tutorial;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profile;

  /// No description provided for @time.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get time;

  /// No description provided for @mistakes.
  ///
  /// In ko, this message translates to:
  /// **'실수'**
  String get mistakes;

  /// No description provided for @undo.
  ///
  /// In ko, this message translates to:
  /// **'돌리기'**
  String get undo;

  /// No description provided for @erase.
  ///
  /// In ko, this message translates to:
  /// **'지우기'**
  String get erase;

  /// No description provided for @reset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get reset;

  /// No description provided for @gameComplete.
  ///
  /// In ko, this message translates to:
  /// **'축하합니다!'**
  String get gameComplete;

  /// No description provided for @gameCompleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'조각을 모두 모았습니다!'**
  String get gameCompleteMessage;

  /// No description provided for @completionTime.
  ///
  /// In ko, this message translates to:
  /// **'완료 시간'**
  String get completionTime;

  /// No description provided for @goHome.
  ///
  /// In ko, this message translates to:
  /// **'홈으로'**
  String get goHome;

  /// No description provided for @goStage.
  ///
  /// In ko, this message translates to:
  /// **'스테이지로'**
  String get goStage;

  /// No description provided for @gameFailed.
  ///
  /// In ko, this message translates to:
  /// **'게임 실패!'**
  String get gameFailed;

  /// No description provided for @gameFailedMessage.
  ///
  /// In ko, this message translates to:
  /// **'실수를 3번 하였습니다.\n다시 시도해보세요!'**
  String get gameFailedMessage;

  /// No description provided for @gameFailedNoMoves.
  ///
  /// In ko, this message translates to:
  /// **'더 이상 유효한 움직임이 없습니다.\n다시 시도해보세요!'**
  String get gameFailedNoMoves;

  /// No description provided for @continueGame.
  ///
  /// In ko, this message translates to:
  /// **'이어서 하기'**
  String get continueGame;

  /// No description provided for @mistakeMessage.
  ///
  /// In ko, this message translates to:
  /// **'실수 {count}/{max} - 이 위치에 해당 캐릭터를 넣을 수 없습니다'**
  String mistakeMessage(Object count, Object max);

  /// No description provided for @mistakeCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}/{max}'**
  String mistakeCount(Object count, Object max);

  /// No description provided for @stageComplete.
  ///
  /// In ko, this message translates to:
  /// **'스테이지 완료!'**
  String get stageComplete;

  /// No description provided for @levelComplete.
  ///
  /// In ko, this message translates to:
  /// **'레벨 완료!'**
  String get levelComplete;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @gameSettings.
  ///
  /// In ko, this message translates to:
  /// **'게임 설정'**
  String get gameSettings;

  /// No description provided for @backgroundMusic.
  ///
  /// In ko, this message translates to:
  /// **'배경음악'**
  String get backgroundMusic;

  /// No description provided for @backgroundMusicDesc.
  ///
  /// In ko, this message translates to:
  /// **'게임 배경음악 재생'**
  String get backgroundMusicDesc;

  /// No description provided for @soundEffects.
  ///
  /// In ko, this message translates to:
  /// **'효과음'**
  String get soundEffects;

  /// No description provided for @soundEffectsDesc.
  ///
  /// In ko, this message translates to:
  /// **'버튼 클릭 및 게임 효과음'**
  String get soundEffectsDesc;

  /// No description provided for @vibration.
  ///
  /// In ko, this message translates to:
  /// **'진동 효과'**
  String get vibration;

  /// No description provided for @vibrationDesc.
  ///
  /// In ko, this message translates to:
  /// **'터치 시 진동 피드백'**
  String get vibrationDesc;

  /// No description provided for @notifications.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notifications;

  /// No description provided for @notificationsDesc.
  ///
  /// In ko, this message translates to:
  /// **'게임 관련 알림 수신'**
  String get notificationsDesc;

  /// No description provided for @info.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get info;

  /// No description provided for @appVersion.
  ///
  /// In ko, this message translates to:
  /// **'앱 버전'**
  String get appVersion;

  /// No description provided for @developer.
  ///
  /// In ko, this message translates to:
  /// **'개발자'**
  String get developer;

  /// No description provided for @contact.
  ///
  /// In ko, this message translates to:
  /// **'문의하기'**
  String get contact;

  /// No description provided for @contactEmail.
  ///
  /// In ko, this message translates to:
  /// **'support@shootingstarsudoku.com'**
  String get contactEmail;

  /// No description provided for @data.
  ///
  /// In ko, this message translates to:
  /// **'데이터'**
  String get data;

  /// No description provided for @resetData.
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화'**
  String get resetData;

  /// No description provided for @resetDataDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 게임 데이터를 삭제합니다'**
  String get resetDataDesc;

  /// No description provided for @resetDataConfirm.
  ///
  /// In ko, this message translates to:
  /// **'모든 게임 데이터가 삭제됩니다.\n정말로 진행하시겠습니까?'**
  String get resetDataConfirm;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @dataResetComplete.
  ///
  /// In ko, this message translates to:
  /// **'데이터가 초기화되었습니다'**
  String get dataResetComplete;

  /// No description provided for @tutorialTitle.
  ///
  /// In ko, this message translates to:
  /// **'게임 사용법'**
  String get tutorialTitle;

  /// No description provided for @tutorialWelcome.
  ///
  /// In ko, this message translates to:
  /// **'별똥별 스도쿠에\n오신 것을 환영합니다!'**
  String get tutorialWelcome;

  /// No description provided for @tutorialDescription.
  ///
  /// In ko, this message translates to:
  /// **'별똥별 스도쿠는 캐릭터를 맞추는 퍼즐 게임이에요!\n각 행, 열, 박스에 캐릭터가 겹치지 않게\n배치하는 것이 목표입니다.'**
  String get tutorialDescription;

  /// No description provided for @tutorialStartTip.
  ///
  /// In ko, this message translates to:
  /// **'초급부터 시작해서 차근차근 배워보세요!'**
  String get tutorialStartTip;

  /// No description provided for @tutorialBeginner.
  ///
  /// In ko, this message translates to:
  /// **'초급 (4×4)'**
  String get tutorialBeginner;

  /// No description provided for @tutorialBeginnerSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'스도쿠 기본 익히기'**
  String get tutorialBeginnerSubtitle;

  /// No description provided for @tutorialBeginnerDesc.
  ///
  /// In ko, this message translates to:
  /// **'4×4 격자에서 1번부터 4번까지의 캐릭터를 사용합니다.\n각 행, 열, 그리고 2×2 박스에 1~4번 캐릭터가 한 번씩만 들어가야 해요!'**
  String get tutorialBeginnerDesc;

  /// No description provided for @tutorialIntermediate.
  ///
  /// In ko, this message translates to:
  /// **'중급 (6×6)'**
  String get tutorialIntermediate;

  /// No description provided for @tutorialIntermediateSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'조금 더 복잡한 도전'**
  String get tutorialIntermediateSubtitle;

  /// No description provided for @tutorialIntermediateDesc.
  ///
  /// In ko, this message translates to:
  /// **'6×6 격자에서 1번부터 6번까지의 캐릭터를 사용합니다.\n각 행, 열, 그리고 3×2 박스에 1~6번 캐릭터가 한 번씩만 들어가야 해요!'**
  String get tutorialIntermediateDesc;

  /// No description provided for @tutorialAdvanced.
  ///
  /// In ko, this message translates to:
  /// **'고급 (9×9)'**
  String get tutorialAdvanced;

  /// No description provided for @tutorialAdvancedSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'진짜 스도쿠 마스터 도전'**
  String get tutorialAdvancedSubtitle;

  /// No description provided for @tutorialAdvancedDesc.
  ///
  /// In ko, this message translates to:
  /// **'9×9 격자에서 1번부터 9번까지의 캐릭터를 사용합니다.\n각 행, 열, 그리고 3×3 박스에 1~9번 캐릭터가 한 번씩만 들어가야 해요!'**
  String get tutorialAdvancedDesc;

  /// No description provided for @gameRules.
  ///
  /// In ko, this message translates to:
  /// **'게임 규칙'**
  String get gameRules;

  /// No description provided for @gameControls.
  ///
  /// In ko, this message translates to:
  /// **'조작 방법'**
  String get gameControls;

  /// No description provided for @control1.
  ///
  /// In ko, this message translates to:
  /// **'1. 빈 칸을 터치하여 선택하세요'**
  String get control1;

  /// No description provided for @control2.
  ///
  /// In ko, this message translates to:
  /// **'2. 하단의 캐릭터 버튼을 눌러 캐릭터를 입력하세요'**
  String get control2;

  /// No description provided for @control3.
  ///
  /// In ko, this message translates to:
  /// **'3. 실수했다면 \"돌리기\" 버튼으로 되돌릴 수 있어요'**
  String get control3;

  /// No description provided for @control4.
  ///
  /// In ko, this message translates to:
  /// **'4. \"지우기\" 모드로 캐릭터를 삭제할 수도 있어요'**
  String get control4;

  /// No description provided for @profileManagement.
  ///
  /// In ko, this message translates to:
  /// **'프로필 관리'**
  String get profileManagement;

  /// No description provided for @noProfiles.
  ///
  /// In ko, this message translates to:
  /// **'아직 프로필이 없습니다'**
  String get noProfiles;

  /// No description provided for @createFirstProfile.
  ///
  /// In ko, this message translates to:
  /// **'첫 프로필 만들기'**
  String get createFirstProfile;

  /// No description provided for @active.
  ///
  /// In ko, this message translates to:
  /// **'활성'**
  String get active;

  /// No description provided for @stars.
  ///
  /// In ko, this message translates to:
  /// **'별'**
  String get stars;

  /// No description provided for @select.
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get select;

  /// No description provided for @edit.
  ///
  /// In ko, this message translates to:
  /// **'편집'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @createProfile.
  ///
  /// In ko, this message translates to:
  /// **'새 프로필 만들기'**
  String get createProfile;

  /// No description provided for @profileName.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이름'**
  String get profileName;

  /// No description provided for @avatarSelection.
  ///
  /// In ko, this message translates to:
  /// **'아바타 선택'**
  String get avatarSelection;

  /// No description provided for @create.
  ///
  /// In ko, this message translates to:
  /// **'만들기'**
  String get create;

  /// No description provided for @editProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 편집'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @deleteProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 삭제'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirm.
  ///
  /// In ko, this message translates to:
  /// **'{name} 프로필을 삭제하시겠습니까?'**
  String deleteProfileConfirm(Object name);

  /// No description provided for @stage1Title.
  ///
  /// In ko, this message translates to:
  /// **'빛의 조각'**
  String get stage1Title;

  /// No description provided for @stage2Title.
  ///
  /// In ko, this message translates to:
  /// **'멜로디 조각'**
  String get stage2Title;

  /// No description provided for @stage3Title.
  ///
  /// In ko, this message translates to:
  /// **'무지개 조각'**
  String get stage3Title;

  /// No description provided for @stage4Title.
  ///
  /// In ko, this message translates to:
  /// **'탱탱볼 조각'**
  String get stage4Title;

  /// No description provided for @stage5Title.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 조각'**
  String get stage5Title;

  /// No description provided for @stage6Title.
  ///
  /// In ko, this message translates to:
  /// **'생명의 조각'**
  String get stage6Title;

  /// No description provided for @stage7Title.
  ///
  /// In ko, this message translates to:
  /// **'에너지 조각'**
  String get stage7Title;

  /// No description provided for @stage8Title.
  ///
  /// In ko, this message translates to:
  /// **'온기의 조각'**
  String get stage8Title;

  /// No description provided for @stage9Title.
  ///
  /// In ko, this message translates to:
  /// **'별자리 조각'**
  String get stage9Title;

  /// No description provided for @stageDefaultTitle.
  ///
  /// In ko, this message translates to:
  /// **'수수께끼 조각'**
  String get stageDefaultTitle;

  /// No description provided for @levelFormat.
  ///
  /// In ko, this message translates to:
  /// **'{level} / 20'**
  String levelFormat(Object level);

  /// No description provided for @storyTitle.
  ///
  /// In ko, this message translates to:
  /// **'행성 스토리'**
  String get storyTitle;

  /// No description provided for @help.
  ///
  /// In ko, this message translates to:
  /// **'도움말'**
  String get help;

  /// No description provided for @findLight.
  ///
  /// In ko, this message translates to:
  /// **'어서 빛을 찾아주세요.'**
  String get findLight;

  /// No description provided for @stage1StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'반짝이 행성의 전설'**
  String get stage1StoryTitle;

  /// No description provided for @stage2StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'방울이 행성의 멜로디'**
  String get stage2StoryTitle;

  /// No description provided for @stage3StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'구름이 행성의 무지개'**
  String get stage3StoryTitle;

  /// No description provided for @stage4StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'꼬마젤리 행성의 축제'**
  String get stage4StoryTitle;

  /// No description provided for @stage5StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'똑똑이 행성의 도서관'**
  String get stage5StoryTitle;

  /// No description provided for @stage6StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'숲지기 행성의 생명'**
  String get stage6StoryTitle;

  /// No description provided for @stage7StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'꼬마번개 행성의 에너지'**
  String get stage7StoryTitle;

  /// No description provided for @stage8StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'따뜻이 행성의 온기'**
  String get stage8StoryTitle;

  /// No description provided for @stage9StoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'어둠이 행성의 이야기'**
  String get stage9StoryTitle;

  /// No description provided for @stageDefaultStoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'우주의 신비'**
  String get stageDefaultStoryTitle;

  /// No description provided for @stage1StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'우주 한편에 반짝이는 것을 무엇보다 사랑하는 작은 요정 \'반짝이\'가 살고 있는 아름다운 행성이 있었습니다. 반짝이 행성은 수많은 반짝이는 별들로 가득했고, 반짝이는 그 별들과 함께 행복하게 살고 있었어요. 하지만 어느 날, 거대한 별똥별이 행성과 충돌하면서 모든 반짝이는 별들이 조각조각 흩어져 버렸습니다! 반짝이는 너무나 슬펐고, 흩어진 별 조각들을 다시 모아야만 행성의 빛을 되찾을 수 있다는 것을 알게 되었습니다.'**
  String get stage1StoryContent;

  /// No description provided for @stage2StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'이곳은 온 세상이 맑고 투명한 물로 이루어진 방울이 행성이에요. 행성의 별들은 \'별방울\'이라 불렸는데, 이 별방울들이 수면 위로 떠오를 때마다 아름다운 멜로디가 울려 퍼졌죠. 하지만 거대한 별똥별이 행성의 바다와 충돌하면서, 모든 별방울이 깨져버렸어요! 그 후로 방울이 행성의 아름다운 음악은 멈추고 말았답니다. 방울이는 깨진 별방울 조각을 다시 맞춰 행성의 멜로디를 되찾고 싶어 해요.'**
  String get stage2StoryContent;

  /// No description provided for @stage3StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'푹신푹신 구름으로 가득한 이곳은 구름이 행성이랍니다. 이곳의 별들은 \'솜사탕 별\'이라고 불렸어요. 낮에는 햇살을 머금고, 밤에는 스스로 무지갯빛을 내며 구름 세상을 아름답게 비춰주었죠. 별똥별이 부딪히는 바람에 솜사탕 별들이 산산조각 나면서, 행성은 온통 잿빛 구름에 갇히게 되었어요. 낮잠 자는 것을 가장 좋아했던 구름이는 알록달록한 꿈을 꾸기 위해 흩어진 별 조각을 모으기로 결심했어요.'**
  String get stage3StoryContent;

  /// No description provided for @stage4StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'말랑말랑! 탱글탱글! 온통 젤리로 만들어진 꼬마젤리 행성에 오신 것을 환영해요! 이곳의 별들은 \'탱탱볼 별\'이었어요. 통통 튀어 오를 때마다 달콤한 에너지를 만들어내서, 행성 전체가 신나는 축제 같았죠. 하지만 별똥별이 떨어진 후, 탱탱볼 별들은 조각나 바닥에 끈적이게 붙어버렸어요. 행성의 신나는 축제도 멈춰버렸죠. 장난꾸러기 꼬마젤리는 다시 행성을 방방 뛰게 만들기 위해 당신의 도움이 필요해요!'**
  String get stage4StoryContent;

  /// No description provided for @stage5StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'반짝이는 거대한 크리스탈이 지식의 숲을 이루는 이곳은 똑똑이 행성입니다. 행성의 별들은 \'지혜의 별\'이라 불리며, 그 빛 속에는 우주의 모든 지식과 이야기가 담겨 있었어요. 별똥별 충돌로 지혜의 별들이 조각나자, 행성의 모든 지식이 뒤죽박죽 섞여버렸습니다! 똑똑박사 똑똑이는 뒤섞인 지식을 바로잡고 행성의 위대한 도서관을 복원하기 위해 별 조각들을 맞추고 있어요.'**
  String get stage5StoryContent;

  /// No description provided for @stage6StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'싱그러운 풀과 나무가 가득한 이곳은 숲지기 행성이에요. 밤하늘의 별들은 \'생명의 별\'이라 불렸는데, 이 별빛을 받은 식물들은 마법처럼 무럭무럭 자라났답니다. 하지만 거대한 별똥별이 숲을 덮치면서 생명의 별들이 모두 조각나 버렸고, 행성의 식물들은 시들기 시작했어요. 마음씨 착한 숲지기는 사랑하는 숲을 되살리기 위해 흩어진 생명의 별 조각들을 애타게 찾고 있답니다.'**
  String get stage6StoryContent;

  /// No description provided for @stage7StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'찌릿찌릿! 짜릿한 에너지가 넘치는 이곳은 꼬마번개 행성이랍니다. 이곳의 별들은 \'에너지 별\'로, 행성 전체에 강력한 에너지를 공급해 주었어요. 덕분에 행성의 하늘에서는 매일 밤 멋진 번개 쇼가 펼쳐졌죠. 별똥별 충돌 이후, 에너지 별들이 모두 부서져 행성은 힘을 잃고 어두워졌어요. 활발한 꼬마번개는 이 조용한 어둠이 너무 심심해요! 어서 별 조각을 모아 다시 짜릿한 번개 쇼를 시작하고 싶어 해요.'**
  String get stage7StoryContent;

  /// No description provided for @stage8StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'포근한 사랑의 기운이 가득한 이곳은 따뜻이 행성이에요. 하늘에 떠 있는 별들은 \'마음의 별\'로, 언제나 따스한 온기를 행성 곳곳에 나눠주었답니다. 하지만 별똥별이 떨어지며 마음의 별들이 차갑게 조각나 버렸고, 행성에는 외롭고 쓸쓸한 기운이 퍼지기 시작했어요. 다정한 따뜻이는 모두의 마음을 다시 따뜻하게 만들기 위해 흩어진 마음의 별 조각들을 모으고 있어요.'**
  String get stage8StoryContent;

  /// No description provided for @stage9StoryContent.
  ///
  /// In ko, this message translates to:
  /// **'고요한 어둠 속에서 가장 아름다운 밤하늘을 볼 수 있는 이곳은 어둠이 행성입니다. 이곳의 별들은 밤하늘에 커다란 그림을 그리는 \'별자리 별\'이었어요. 이 별자리들은 우주의 오래된 이야기를 들려주었죠. 별똥별이 별자리들을 흩어버린 후, 밤하늘의 위대한 이야기들도 모두 사라졌습니다. 신비로운 어둠이는 잊혀진 우주의 이야기를 되찾기 위해, 흩어진 별자리 조각들을 맞추려 합니다.'**
  String get stage9StoryContent;

  /// No description provided for @adventureRecord.
  ///
  /// In ko, this message translates to:
  /// **'{character}의 모험 기록'**
  String adventureRecord(Object character);

  /// No description provided for @level.
  ///
  /// In ko, this message translates to:
  /// **'Level {number}'**
  String level(Object number);

  /// No description provided for @rulesRow.
  ///
  /// In ko, this message translates to:
  /// **'• 각 행에는 1, 2, 3, 4번 캐릭터가 한 번씩만'**
  String get rulesRow;

  /// No description provided for @rulesColumn.
  ///
  /// In ko, this message translates to:
  /// **'• 각 열에도 1, 2, 3, 4번 캐릭터가 한 번씩만'**
  String get rulesColumn;

  /// No description provided for @rulesBox4x4.
  ///
  /// In ko, this message translates to:
  /// **'• 각 2×2 박스에도 1, 2, 3, 4번 캐릭터가 한 번씩만'**
  String get rulesBox4x4;

  /// No description provided for @rulesFixed.
  ///
  /// In ko, this message translates to:
  /// **'• 이미 채워진 캐릭터는 고정이에요'**
  String get rulesFixed;

  /// No description provided for @rulesRow6x6.
  ///
  /// In ko, this message translates to:
  /// **'• 각 행에는 1, 2, 3, 4, 5, 6번 캐릭터가 한 번씩만'**
  String get rulesRow6x6;

  /// No description provided for @rulesColumn6x6.
  ///
  /// In ko, this message translates to:
  /// **'• 각 열에도 1, 2, 3, 4, 5, 6번 캐릭터가 한 번씩만'**
  String get rulesColumn6x6;

  /// No description provided for @rulesBox6x6.
  ///
  /// In ko, this message translates to:
  /// **'• 각 3×2 박스에도 1~6번 캐릭터가 한 번씩만'**
  String get rulesBox6x6;

  /// No description provided for @rulesLogic6x6.
  ///
  /// In ko, this message translates to:
  /// **'• 논리적 사고가 더 필요해요'**
  String get rulesLogic6x6;

  /// No description provided for @rulesRow9x9.
  ///
  /// In ko, this message translates to:
  /// **'• 각 행에는 1~9번 캐릭터가 한 번씩만'**
  String get rulesRow9x9;

  /// No description provided for @rulesColumn9x9.
  ///
  /// In ko, this message translates to:
  /// **'• 각 열에도 1~9번 캐릭터가 한 번씩만'**
  String get rulesColumn9x9;

  /// No description provided for @rulesBox9x9.
  ///
  /// In ko, this message translates to:
  /// **'• 각 3×3 박스에도 1~9번 캐릭터가 한 번씩만'**
  String get rulesBox9x9;

  /// No description provided for @rulesLogic9x9.
  ///
  /// In ko, this message translates to:
  /// **'• 고도의 집중력과 논리가 필요해요'**
  String get rulesLogic9x9;

  /// No description provided for @gameTime.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get gameTime;

  /// No description provided for @gameMistakes.
  ///
  /// In ko, this message translates to:
  /// **'실수'**
  String get gameMistakes;

  /// No description provided for @gameUndo.
  ///
  /// In ko, this message translates to:
  /// **'돌리기'**
  String get gameUndo;

  /// No description provided for @gameErase.
  ///
  /// In ko, this message translates to:
  /// **'지우기'**
  String get gameErase;

  /// No description provided for @gameHome.
  ///
  /// In ko, this message translates to:
  /// **'홈으로'**
  String get gameHome;

  /// No description provided for @gameStage.
  ///
  /// In ko, this message translates to:
  /// **'스테이지로'**
  String get gameStage;

  /// No description provided for @gameContinue.
  ///
  /// In ko, this message translates to:
  /// **'이어서 하기'**
  String get gameContinue;

  /// No description provided for @gameSuccess.
  ///
  /// In ko, this message translates to:
  /// **'축하합니다!'**
  String get gameSuccess;

  /// No description provided for @gameCompleted.
  ///
  /// In ko, this message translates to:
  /// **'완료!'**
  String get gameCompleted;

  /// No description provided for @gamePiecesCollected.
  ///
  /// In ko, this message translates to:
  /// **'조각을 모두 모았습니다!'**
  String get gamePiecesCollected;

  /// No description provided for @gameCompletionTime.
  ///
  /// In ko, this message translates to:
  /// **'완료 시간: {time}'**
  String gameCompletionTime(Object time);

  /// No description provided for @gameFailure.
  ///
  /// In ko, this message translates to:
  /// **'게임 실패!'**
  String get gameFailure;

  /// No description provided for @gameMaxMistakes.
  ///
  /// In ko, this message translates to:
  /// **'실수를 {max}번 하였습니다.\n다시 시도해보세요!'**
  String gameMaxMistakes(Object max);

  /// No description provided for @gameNoValidMoves.
  ///
  /// In ko, this message translates to:
  /// **'더 이상 유효한 움직임이 없습니다.\n다시 시도해보세요!'**
  String get gameNoValidMoves;

  /// No description provided for @gameMistakeMessage.
  ///
  /// In ko, this message translates to:
  /// **'실수 {current}/{max} - 이 위치에 해당 캐릭터를 넣을 수 없습니다'**
  String gameMistakeMessage(Object current, Object max);

  /// No description provided for @stage1Fragment.
  ///
  /// In ko, this message translates to:
  /// **'빛의 조각'**
  String get stage1Fragment;

  /// No description provided for @stage2Fragment.
  ///
  /// In ko, this message translates to:
  /// **'멜로디 조각'**
  String get stage2Fragment;

  /// No description provided for @stage3Fragment.
  ///
  /// In ko, this message translates to:
  /// **'무지개 조각'**
  String get stage3Fragment;

  /// No description provided for @stage4Fragment.
  ///
  /// In ko, this message translates to:
  /// **'탱탱볼 조각'**
  String get stage4Fragment;

  /// No description provided for @stage5Fragment.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 조각'**
  String get stage5Fragment;

  /// No description provided for @stage6Fragment.
  ///
  /// In ko, this message translates to:
  /// **'생명의 조각'**
  String get stage6Fragment;

  /// No description provided for @stage7Fragment.
  ///
  /// In ko, this message translates to:
  /// **'에너지 조각'**
  String get stage7Fragment;

  /// No description provided for @stage8Fragment.
  ///
  /// In ko, this message translates to:
  /// **'온기의 조각'**
  String get stage8Fragment;

  /// No description provided for @stage9Fragment.
  ///
  /// In ko, this message translates to:
  /// **'별자리 조각'**
  String get stage9Fragment;

  /// No description provided for @stageDefaultFragment.
  ///
  /// In ko, this message translates to:
  /// **'수수께끼 조각'**
  String get stageDefaultFragment;

  /// No description provided for @character1.
  ///
  /// In ko, this message translates to:
  /// **'반짝이'**
  String get character1;

  /// No description provided for @character2.
  ///
  /// In ko, this message translates to:
  /// **'방울이'**
  String get character2;

  /// No description provided for @character3.
  ///
  /// In ko, this message translates to:
  /// **'구름이'**
  String get character3;

  /// No description provided for @character4.
  ///
  /// In ko, this message translates to:
  /// **'꼬마젤리'**
  String get character4;

  /// No description provided for @character5.
  ///
  /// In ko, this message translates to:
  /// **'똑똑이'**
  String get character5;

  /// No description provided for @character6.
  ///
  /// In ko, this message translates to:
  /// **'숲지기'**
  String get character6;

  /// No description provided for @character7.
  ///
  /// In ko, this message translates to:
  /// **'꼬마번개'**
  String get character7;

  /// No description provided for @character8.
  ///
  /// In ko, this message translates to:
  /// **'따뜻이'**
  String get character8;

  /// No description provided for @character9.
  ///
  /// In ko, this message translates to:
  /// **'어둠이'**
  String get character9;

  /// No description provided for @characterDefault.
  ///
  /// In ko, this message translates to:
  /// **'우주친구'**
  String get characterDefault;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
