import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../utils/constants.dart';
import '../services/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _backgroundMusicEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final audioService = AudioService();

    setState(() {
      _backgroundMusicEnabled = audioService.isMusicEnabled;
      _soundEffectsEnabled = audioService.isSoundEnabled;
      _vibrationEnabled =
          prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;
      _notificationsEnabled =
          prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      AppConstants.keyBackgroundMusicEnabled,
      _backgroundMusicEnabled,
    );
    await prefs.setBool(
      AppConstants.keySoundEffectsEnabled,
      _soundEffectsEnabled,
    );
    await prefs.setBool(AppConstants.keyVibrationEnabled, _vibrationEnabled);
    await prefs.setBool(
      AppConstants.keyNotificationsEnabled,
      _notificationsEnabled,
    );
  }

  Future<void> _triggerHapticFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vibrationEnabled =
          prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;

      if (vibrationEnabled) {
        // 안드로이드에서 더 강력한 진동을 위해 vibration 패키지 사용
        if (await Vibration.hasVibrator() ?? false) {
          await Vibration.vibrate(duration: 50);
        } else {
          // 폴백으로 HapticFeedback 사용
          HapticFeedback.mediumImpact();
        }
      }
    } catch (e) {
      print('햅틱 피드백 오류: $e');
      // 오류 발생 시 HapticFeedback으로 폴백
      try {
        HapticFeedback.mediumImpact();
      } catch (fallbackError) {
        print('폴백 햅틱 피드백도 실패: $fallbackError');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: const Color(0xFF080C2B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF080C2B)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildSettingsSection(
                  title: '게임 설정',
                  children: [
                    _buildSwitchTile(
                      icon: Icons.music_note,
                      title: '배경음악',
                      subtitle: '게임 배경음악 재생',
                      value: _backgroundMusicEnabled,
                      onChanged: (value) async {
                        setState(() {
                          _backgroundMusicEnabled = value;
                        });
                        await AudioService().setMusicEnabled(value);
                        _saveSettings();
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.volume_up,
                      title: '효과음',
                      subtitle: '버튼 클릭 및 게임 효과음',
                      value: _soundEffectsEnabled,
                      onChanged: (value) async {
                        setState(() {
                          _soundEffectsEnabled = value;
                        });
                        await AudioService().setSoundEnabled(value);
                        _saveSettings();
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.vibration,
                      title: '진동 효과',
                      subtitle: '터치 시 진동 피드백',
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                        _saveSettings();
                        // 진동 효과가 켜져 있으면 토글 시 진동 발생
                        if (value) {
                          _triggerHapticFeedback();
                        }
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.notifications,
                      title: '알림',
                      subtitle: '게임 관련 알림 수신',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(
                  title: '정보',
                  children: [
                    _buildInfoTile(
                      icon: Icons.info,
                      title: '앱 버전',
                      subtitle: AppConstants.appVersion,
                    ),
                    _buildInfoTile(
                      icon: Icons.star,
                      title: '개발자',
                      subtitle: 'Adrie Jeon',
                    ),
                    _buildInfoTile(
                      icon: Icons.email,
                      title: '문의하기',
                      subtitle: 'support@shootingstarsudoku.com',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(
                  title: '데이터',
                  children: [
                    _buildActionTile(
                      icon: Icons.refresh,
                      title: '데이터 초기화',
                      subtitle: '모든 게임 데이터를 삭제합니다',
                      onTap: () {
                        _showResetDialog();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40), // 하단 여유 공간 추가
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(AppConstants.cardColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white, // 흰색
        activeTrackColor: const Color(0xFF4A90E2), // 밝은 파란색 트랙
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      onTap: onTap,
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 초기화'),
        content: const Text('모든 게임 데이터가 삭제됩니다.\n정말로 진행하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 데이터 초기화 로직 구현
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('데이터가 초기화되었습니다')));
            },
            child: const Text('초기화', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
