import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: const Color(AppConstants.backgroundColor),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(AppConstants.backgroundColor),
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildSettingsSection(
                  title: '게임 설정',
                  children: [
                    _buildSwitchTile(
                      icon: Icons.volume_up,
                      title: '사운드',
                      subtitle: '효과음 및 배경음악',
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.vibration,
                      title: '진동',
                      subtitle: '터치 시 진동 피드백',
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
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
          child: Column(
            children: children,
          ),
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
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(AppConstants.primaryColor),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
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
      leading: Icon(
        icon,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      onTap: onTap,
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 초기화'),
        content: const Text(
          '모든 게임 데이터가 삭제됩니다.\n정말로 진행하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 데이터 초기화 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('데이터가 초기화되었습니다'),
                ),
              );
            },
            child: const Text(
              '초기화',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
