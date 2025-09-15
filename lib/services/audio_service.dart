import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _effectPlayer;

  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  bool _isInitialized = false;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _backgroundPlayer = AudioPlayer();
    _effectPlayer = AudioPlayer();

    // SharedPreferences에서 설정 로드
    final prefs = await SharedPreferences.getInstance();
    _isMusicEnabled = prefs.getBool('music_enabled') ?? true;
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;

    // 배경음악 설정
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(_isMusicEnabled ? 0.3 : 0.0);

    // 효과음 설정
    await _effectPlayer.setReleaseMode(ReleaseMode.stop);
    await _effectPlayer.setVolume(_isSoundEnabled ? 0.7 : 0.0);

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
    if (!_isInitialized) await initialize();

    if (_isSoundEnabled) {
      try {
        _effectPlayer.play(AssetSource('sounds/pop.mp3'));
      } catch (e) {
        print('Pop 효과음 재생 오류: $e');
      }
    }
  }

  Future<void> playSuccessSound() async {
    if (!_isInitialized) await initialize();

    if (_isSoundEnabled) {
      try {
        _effectPlayer.play(AssetSource('sounds/success.mp3'));
      } catch (e) {
        print('Success 효과음 재생 오류: $e');
      }
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

    if (_isInitialized) {
      await _effectPlayer.setVolume(enabled ? 0.7 : 0.0);
    }
  }

  void dispose() {
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
  }
}
