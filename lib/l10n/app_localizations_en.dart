// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shooting Star Sudoku';

  @override
  String get appTitle => 'Shooting Star Sudoku';

  @override
  String get loading => 'Initializing app...';

  @override
  String get adLoading => 'Loading ad...';

  @override
  String get home => 'Home';

  @override
  String get play => 'Play';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get time => 'Time';

  @override
  String get mistakes => 'Mistakes';

  @override
  String get undo => 'Undo';

  @override
  String get erase => 'Erase';

  @override
  String get reset => 'Reset';

  @override
  String get gameComplete => 'Congratulations!';

  @override
  String get gameCompleteMessage => 'All pieces collected!';

  @override
  String get completionTime => 'Completion time';

  @override
  String get goHome => 'Go Home';

  @override
  String get goStage => 'Go to Stage';

  @override
  String get gameFailed => 'Game Failed!';

  @override
  String get gameFailedMessage => 'You made 3 mistakes.\nPlease try again!';

  @override
  String get gameFailedNoMoves =>
      'No more valid moves available.\nPlease try again!';

  @override
  String get continueGame => 'Continue';

  @override
  String mistakeMessage(Object count, Object max) {
    return 'Mistake $count/$max - Cannot place this character here';
  }

  @override
  String mistakeCount(Object count, Object max) {
    return '$count/$max';
  }

  @override
  String get stageComplete => 'Stage Complete!';

  @override
  String get levelComplete => 'Level Complete!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get gameSettings => 'Game Settings';

  @override
  String get backgroundMusic => 'Background Music';

  @override
  String get backgroundMusicDesc => 'Play game background music';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get soundEffectsDesc => 'Button clicks and game sound effects';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationDesc => 'Vibration feedback on touch';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDesc => 'Receive game-related notifications';

  @override
  String get info => 'Information';

  @override
  String get appVersion => 'App Version';

  @override
  String get developer => 'Developer';

  @override
  String get contact => 'Contact';

  @override
  String get contactEmail => 'support@shootingstarsudoku.com';

  @override
  String get data => 'Data';

  @override
  String get resetData => 'Reset Data';

  @override
  String get resetDataDesc => 'Delete all game data';

  @override
  String get resetDataConfirm =>
      'All game data will be deleted.\nAre you sure you want to proceed?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get dataResetComplete => 'Data has been reset';

  @override
  String get tutorialTitle => 'How to Play';

  @override
  String get tutorialWelcome => 'Welcome to\nShooting Star Sudoku!';

  @override
  String get tutorialDescription =>
      'Shooting Star Sudoku is a puzzle game where you match characters!\nThe goal is to place characters in each row, column, and box\nwithout any duplicates.';

  @override
  String get tutorialStartTip =>
      'Start with beginner level and learn step by step!';

  @override
  String get tutorialBeginner => 'Beginner (4×4)';

  @override
  String get tutorialBeginnerSubtitle => 'Learn Sudoku basics';

  @override
  String get tutorialBeginnerDesc =>
      'Use characters 1 through 4 in a 4×4 grid.\nEach row, column, and 2×2 box must contain\ncharacters 1~4 exactly once!';

  @override
  String get tutorialIntermediate => 'Intermediate (6×6)';

  @override
  String get tutorialIntermediateSubtitle => 'A bit more challenging';

  @override
  String get tutorialIntermediateDesc =>
      'Use characters 1 through 6 in a 6×6 grid.\nEach row, column, and 3×2 box must contain\ncharacters 1~6 exactly once!';

  @override
  String get tutorialAdvanced => 'Advanced (9×9)';

  @override
  String get tutorialAdvancedSubtitle => 'True Sudoku master challenge';

  @override
  String get tutorialAdvancedDesc =>
      'Use characters 1 through 9 in a 9×9 grid.\nEach row, column, and 3×3 box must contain\ncharacters 1~9 exactly once!';

  @override
  String get gameRules => 'Game Rules';

  @override
  String get gameControls => 'Controls';

  @override
  String get control1 => '1. Tap an empty cell to select it';

  @override
  String get control2 => '2. Tap character buttons below to input characters';

  @override
  String get control3 => '3. Use \"Undo\" button to revert mistakes';

  @override
  String get control4 => '4. Use \"Erase\" mode to delete characters';

  @override
  String get profileManagement => 'Profile Management';

  @override
  String get noProfiles => 'No profiles yet';

  @override
  String get createFirstProfile => 'Create First Profile';

  @override
  String get active => 'Active';

  @override
  String get stars => 'stars';

  @override
  String get select => 'Select';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get createProfile => 'Create New Profile';

  @override
  String get profileName => 'Profile Name';

  @override
  String get avatarSelection => 'Avatar Selection';

  @override
  String get create => 'Create';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get save => 'Save';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String deleteProfileConfirm(Object name) {
    return 'Delete $name profile?';
  }

  @override
  String get stage1Title => 'Light Fragment';

  @override
  String get stage2Title => 'Melody Fragment';

  @override
  String get stage3Title => 'Rainbow Fragment';

  @override
  String get stage4Title => 'Bouncy Ball Fragment';

  @override
  String get stage5Title => 'Wisdom Fragment';

  @override
  String get stage6Title => 'Life Fragment';

  @override
  String get stage7Title => 'Energy Fragment';

  @override
  String get stage8Title => 'Warmth Fragment';

  @override
  String get stage9Title => 'Constellation Fragment';

  @override
  String get stageDefaultTitle => 'Mystery Fragment';

  @override
  String levelFormat(Object level) {
    return '$level / 20';
  }

  @override
  String get storyTitle => 'Planet Story';

  @override
  String get help => 'Help';

  @override
  String get findLight => 'Please help us find the light.';

  @override
  String get stage1StoryTitle => 'Legend of the Twinkle Planet';

  @override
  String get stage2StoryTitle => 'Melody of the Bubble Planet';

  @override
  String get stage3StoryTitle => 'Rainbow of the Cloud Planet';

  @override
  String get stage4StoryTitle => 'Festival of the Jelly Planet';

  @override
  String get stage5StoryTitle => 'Library of the Smart Planet';

  @override
  String get stage6StoryTitle => 'Life of the Forest Planet';

  @override
  String get stage7StoryTitle => 'Energy of the Lightning Planet';

  @override
  String get stage8StoryTitle => 'Warmth of the Warm Planet';

  @override
  String get stage9StoryTitle => 'Story of the Dark Planet';

  @override
  String get stageDefaultStoryTitle => 'Mystery of the Universe';

  @override
  String get stage1StoryContent =>
      'In a corner of the universe, there was a beautiful planet where a small fairy named \'Sparkle\' lived, who loved twinkling things more than anything. The Sparkle Planet was filled with countless twinkling stars, and Sparkle lived happily with those stars. But one day, a giant shooting star collided with the planet, scattering all the twinkling stars into pieces! Sparkle was so sad and learned that only by gathering the scattered star pieces could the planet\'s light be restored.';

  @override
  String get stage2StoryContent =>
      'This is the Bubble Planet, where the entire world is made of clear and transparent water. The planet\'s stars were called \'Star Bubbles\', and whenever these star bubbles floated to the water\'s surface, beautiful melodies would resonate. But when a giant shooting star collided with the planet\'s ocean, all the star bubbles shattered! Since then, the beautiful music of the Bubble Planet has stopped. Bubble wants to piece together the broken star bubble fragments to restore the planet\'s melody.';

  @override
  String get stage3StoryContent =>
      'This place filled with fluffy clouds is the Cloud Planet. The stars here were called \'Cotton Candy Stars\'. During the day, they absorbed sunlight, and at night, they emitted rainbow colors, beautifully illuminating the cloud world. When a shooting star crashed, the cotton candy stars shattered into pieces, and the planet became trapped in gray clouds. Cloud, who loves napping most, decided to gather the scattered star pieces to dream colorful dreams.';

  @override
  String get stage4StoryContent =>
      'Welcome to the Little Jelly Planet, made entirely of squishy, bouncy jelly! The stars here were \'Bouncy Ball Stars\'. Every time they bounced, they created sweet energy, making the entire planet feel like an exciting festival. But after the shooting star fell, the bouncy ball stars shattered and stuck stickily to the floor. The planet\'s exciting festival stopped too. The mischievous Little Jelly needs your help to make the planet bounce again!';

  @override
  String get stage5StoryContent =>
      'This is the Smart Planet, where giant crystals form a forest of knowledge. The planet\'s stars were called \'Wisdom Stars\', containing all the knowledge and stories of the universe within their light. When the shooting star collision shattered the wisdom stars, all the planet\'s knowledge became jumbled! Smart is piecing together the star fragments to restore the planet\'s great library and organize the mixed-up knowledge.';

  @override
  String get stage6StoryContent =>
      'This place filled with fresh grass and trees is the Forest Keeper Planet. The stars in the night sky were called \'Life Stars\', and plants that received this starlight grew magically lush. But when a giant shooting star struck the forest, all the life stars shattered, and the planet\'s plants began to wither. The kind-hearted Forest Keeper is desperately searching for the scattered life star pieces to revive the beloved forest.';

  @override
  String get stage7StoryContent =>
      'Zap! Zap! This is the Little Lightning Planet, overflowing with thrilling energy. The stars here were \'Energy Stars\' that supplied powerful energy to the entire planet. Thanks to them, amazing lightning shows unfolded every night in the planet\'s sky. After the shooting star collision, all the energy stars shattered, and the planet lost its power and became dark. The active Little Lightning finds this quiet darkness too boring! It wants to gather star pieces quickly to start the thrilling lightning show again.';

  @override
  String get stage8StoryContent =>
      'This is the Warm Planet, filled with cozy love energy. The stars floating in the sky were \'Heart Stars\' that always shared warm comfort throughout the planet. But when the shooting star fell, the heart stars shattered into cold pieces, and a lonely, desolate atmosphere began to spread across the planet. The affectionate Warm is gathering the scattered heart star pieces to make everyone\'s hearts warm again.';

  @override
  String get stage9StoryContent =>
      'This is the Dark Planet, where you can see the most beautiful night sky in the quiet darkness. The stars here were \'Constellation Stars\' that drew great pictures in the night sky. These constellations told ancient stories of the universe. After the shooting star scattered the constellations, all the great stories of the night sky disappeared. The mysterious Dark is trying to piece together the scattered constellation fragments to recover the forgotten stories of the universe.';

  @override
  String adventureRecord(Object character) {
    return '$character\'s Adventure Record';
  }

  @override
  String level(Object number) {
    return 'Level $number';
  }

  @override
  String get rulesRow =>
      '• Each row must contain characters 1, 2, 3, 4 exactly once';

  @override
  String get rulesColumn =>
      '• Each column must contain characters 1, 2, 3, 4 exactly once';

  @override
  String get rulesBox4x4 =>
      '• Each 2×2 box must contain characters 1, 2, 3, 4 exactly once';

  @override
  String get rulesFixed => '• Pre-filled characters are fixed';

  @override
  String get rulesRow6x6 =>
      '• Each row must contain characters 1, 2, 3, 4, 5, 6 exactly once';

  @override
  String get rulesColumn6x6 =>
      '• Each column must contain characters 1, 2, 3, 4, 5, 6 exactly once';

  @override
  String get rulesBox6x6 =>
      '• Each 3×2 box must contain characters 1~6 exactly once';

  @override
  String get rulesLogic6x6 => '• More logical thinking is required';

  @override
  String get rulesRow9x9 =>
      '• Each row must contain characters 1~9 exactly once';

  @override
  String get rulesColumn9x9 =>
      '• Each column must contain characters 1~9 exactly once';

  @override
  String get rulesBox9x9 =>
      '• Each 3×3 box must contain characters 1~9 exactly once';

  @override
  String get rulesLogic9x9 => '• High concentration and logic are required';

  @override
  String get gameTime => 'Time';

  @override
  String get gameMistakes => 'Mistakes';

  @override
  String get gameUndo => 'Undo';

  @override
  String get gameErase => 'Erase';

  @override
  String get gameHome => 'Home';

  @override
  String get gameStage => 'Stage';

  @override
  String get gameContinue => 'Continue';

  @override
  String get gameSuccess => 'Congratulations!';

  @override
  String get gameCompleted => 'Completed!';

  @override
  String get gamePiecesCollected => 'All pieces collected!';

  @override
  String gameCompletionTime(Object time) {
    return 'Completion time: $time';
  }

  @override
  String get gameFailure => 'Game Failed!';

  @override
  String gameMaxMistakes(Object max) {
    return 'Made $max mistakes.\nPlease try again!';
  }

  @override
  String get gameNoValidMoves =>
      'No more valid moves available.\nPlease try again!';

  @override
  String gameMistakeMessage(Object current, Object max) {
    return 'Mistake $current/$max - Cannot place this character here';
  }

  @override
  String get stage1Fragment => 'Light Fragment';

  @override
  String get stage2Fragment => 'Melody Fragment';

  @override
  String get stage3Fragment => 'Rainbow Fragment';

  @override
  String get stage4Fragment => 'Bouncy Ball Fragment';

  @override
  String get stage5Fragment => 'Wisdom Fragment';

  @override
  String get stage6Fragment => 'Life Fragment';

  @override
  String get stage7Fragment => 'Energy Fragment';

  @override
  String get stage8Fragment => 'Warmth Fragment';

  @override
  String get stage9Fragment => 'Constellation Fragment';

  @override
  String get stageDefaultFragment => 'Mystery Fragment';

  @override
  String get character1 => 'Sparklie';

  @override
  String get character2 => 'Bubblie';

  @override
  String get character3 => 'Cloudie';

  @override
  String get character4 => 'Little Jellie';

  @override
  String get character5 => 'Smartie';

  @override
  String get character6 => 'Forestitie';

  @override
  String get character7 => 'Little Boltie';

  @override
  String get character8 => 'Warmie';

  @override
  String get character9 => 'Darkie';

  @override
  String get characterDefault => 'Space Friend';
}
