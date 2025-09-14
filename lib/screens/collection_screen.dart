import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_progress_state.dart';
import '../utils/constants.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('캐릭터 컬렉션'),
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
          child: Consumer<UserProgressState>(
            builder: (context, userProgress, child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsCard(userProgress),
                    const SizedBox(height: 20),
                    const Text(
                      '수집한 별똥별들',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildCharacterGrid(userProgress),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(UserProgressState userProgress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.star,
                label: '총 별',
                value: '${userProgress.totalStars}',
                color: Colors.amber,
              ),
              _buildStatItem(
                icon: Icons.collections,
                label: '수집한 캐릭터',
                value: '${userProgress.unlockedCharacters.length}',
                color: Colors.purple,
              ),
              _buildStatItem(
                icon: Icons.emoji_events,
                label: '등급',
                value: _getStarRating(userProgress.totalStars),
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterGrid(UserProgressState userProgress) {
    if (userProgress.characters.isEmpty) {
      return const Center(
        child: Text(
          '캐릭터를 로딩 중입니다...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: userProgress.characters.length,
      itemBuilder: (context, index) {
        final character = userProgress.characters[index];
        return _buildCharacterCard(character);
      },
    );
  }

  Widget _buildCharacterCard(character) {
    final isUnlocked = character.isUnlocked;
    
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked 
            ? const Color(AppConstants.cardColor)
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isUnlocked 
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isUnlocked ? Icons.star : Icons.lock,
              size: 40,
              color: isUnlocked ? Colors.amber : Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            character.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? Colors.white : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            character.description,
            style: TextStyle(
              fontSize: 12,
              color: isUnlocked 
                  ? Colors.white.withOpacity(0.7)
                  : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isUnlocked) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${character.requiredStars} 별 필요',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStarRating(int stars) {
    if (stars >= 1000) return '마스터';
    if (stars >= 500) return '탐험가';
    if (stars >= 200) return '관찰자';
    if (stars >= 100) return '천문학자';
    if (stars >= 50) return '수집가';
    if (stars >= 20) return '여행자';
    if (stars >= 10) return '발견자';
    return '신입생';
  }
}
