import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('난이도 선택'),
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
                const Text(
                  '어떤 난이도로\n별똥별을 찾아볼까요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                _buildDifficultyCard(
                  context,
                  difficulty: AppConstants.easyDifficulty,
                  title: '쉬움',
                  subtitle: '3x3 그리드',
                  description: '처음 시작하는 분들에게\n추천합니다',
                  color: Colors.green,
                  icon: Icons.star_outline,
                ),
                const SizedBox(height: 20),
                _buildDifficultyCard(
                  context,
                  difficulty: AppConstants.mediumDifficulty,
                  title: '보통',
                  subtitle: '6x6 그리드',
                  description: '적당한 도전을 원하는\n분들에게 추천합니다',
                  color: Colors.orange,
                  icon: Icons.star_half,
                ),
                const SizedBox(height: 20),
                _buildDifficultyCard(
                  context,
                  difficulty: AppConstants.hardDifficulty,
                  title: '어려움',
                  subtitle: '9x9 그리드',
                  description: '진정한 스도쿠 마스터를\n위한 도전입니다',
                  color: Colors.red,
                  icon: Icons.star,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context, {
    required int difficulty,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(AppConstants.cardColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: 퍼즐 화면으로 이동
            AppHelpers.showSnackBar(
              context,
              '${AppHelpers.getDifficultyName(difficulty)} 난이도 선택됨',
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
