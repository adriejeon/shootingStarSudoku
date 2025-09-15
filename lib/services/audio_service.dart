import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPlayer _backgroundPlayer;

  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  bool _isInitialized = false;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _backgroundPlayer = AudioPlayer();

    // SharedPreferences에서 설정 로드
    final prefs = await SharedPreferences.getInstance();
    _isMusicEnabled = prefs.getBool('music_enabled') ?? true;
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;

    // 배경음악 설정 (capybara_game 방식 적용)
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    await _backgroundPlayer.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );

    // 배경음악 재생 완료 시 자동으로 다시 시작하도록 리스너 추가
    _backgroundPlayer.onPlayerComplete.listen((event) async {
      if (_isMusicEnabled) {
        try {
          await _backgroundPlayer.play(AssetSource('sounds/bg.mp3'));
        } catch (e) {
          // 재시작 실패 시 조용히 처리
        }
      }
    });

    _isInitialized = true;
  }

  Future<void> playBackgroundMusic() async {
    if (!_isInitialized) await initialize();

    if (_isMusicEnabled) {
      try {
        await _backgroundPlayer.play(AssetSource('sounds/bg.mp3'));
      } catch (e) {
        print('배경음악 재생 오류: $e');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (!_isInitialized) return;
    await _backgroundPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    if (!_isInitialized) return;
    await _backgroundPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_isInitialized) return;
    if (_isMusicEnabled) {
      await _backgroundPlayer.resume();
    }
  }

  Future<void> playPopSound() async {
    await _playSound('sounds/pop.mp3');
  }

  Future<void> playSuccessSound() async {
    await _playSound('sounds/success.mp3');
  }

  // capybara_game 방식의 효과음 재생 메서드
  Future<void> _playSound(String soundPath) async {
    if (!_isInitialized) await initialize();
    if (!_isSoundEnabled) return;

    try {
      // 매번 새로운 AudioPlayer 인스턴스 생성 (capybara_game 방식)
      final player = AudioPlayer();

      // 안드로이드에서 효과음 끊김 방지를 위한 설정
      await player.setPlayerMode(PlayerMode.mediaPlayer);
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ),
      );

      // 재생 완료 이벤트 리스너 추가
      player.onPlayerComplete.listen((event) {
        // 재생 완료 후 플레이어 정리
        Future.delayed(const Duration(milliseconds: 100), () {
          player.dispose();
        });
      });

      await player.play(AssetSource(soundPath));
    } catch (e) {
      // 오디오 재생 실패 시 조용히 처리
    }
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;

    // SharedPreferences에 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', enabled);

    if (_isInitialized) {
      await _backgroundPlayer.setVolume(enabled ? 0.3 : 0.0);

      if (enabled) {
        // 음악이 켜졌을 때 현재 재생 중이 아니면 재생 시작
        final state = _backgroundPlayer.state;
        if (state != PlayerState.playing) {
          await playBackgroundMusic();
        }
      }
    }
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _isSoundEnabled = enabled;

    // SharedPreferences에 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);
  }

  void dispose() {
    _backgroundPlayer.dispose();
  }
}
