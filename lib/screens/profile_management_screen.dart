import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/profile_manager_state.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedAvatar = 'star_1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileManagerState>().loadProfiles();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 관리'),
        backgroundColor: const Color(AppConstants.backgroundColor),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateProfileDialog,
          ),
        ],
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
          child: Consumer<ProfileManagerState>(
            builder: (context, profileManager, child) {
              if (profileManager.profiles.isEmpty) {
                return _buildEmptyState();
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildActiveProfile(profileManager.activeProfile),
                    const SizedBox(height: 20),
                    _buildProfilesList(profileManager.profiles),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            '아직 프로필이 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showCreateProfileDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConstants.primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              '첫 프로필 만들기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProfile(UserProfile? activeProfile) {
    if (activeProfile == null) return const SizedBox.shrink();

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
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeProfile.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activeProfile.totalStars} 별',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '활성',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesList(List<UserProfile> profiles) {
    return Expanded(
      child: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          final isActive = profile.id == context.read<ProfileManagerState>().activeProfile?.id;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isActive 
                  ? const Color(AppConstants.primaryColor).withOpacity(0.2)
                  : const Color(AppConstants.cardColor),
              borderRadius: BorderRadius.circular(12),
              border: isActive 
                  ? Border.all(color: const Color(AppConstants.primaryColor), width: 2)
                  : null,
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              title: Text(
                profile.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                '${profile.totalStars} 별',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'select':
                      context.read<ProfileManagerState>().setActiveProfile(profile);
                      break;
                    case 'edit':
                      _showEditProfileDialog(profile);
                      break;
                    case 'delete':
                      _showDeleteProfileDialog(profile);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'select',
                    child: Text('선택'),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('편집'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('삭제'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateProfileDialog() {
    _nameController.clear();
    _selectedAvatar = 'star_1';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 프로필 만들기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '프로필 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('아바타 선택'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption('star_1', Icons.star),
                _buildAvatarOption('planet_1', Icons.public),
                _buildAvatarOption('comet_1', Icons.wb_twilight),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                context.read<ProfileManagerState>().createProfile(
                  _nameController.text,
                  _selectedAvatar,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('만들기'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOption(String avatarId, IconData icon) {
    final isSelected = _selectedAvatar == avatarId;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = avatarId;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(AppConstants.primaryColor).withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: const Color(AppConstants.primaryColor), width: 2)
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(AppConstants.primaryColor) : Colors.grey,
        ),
      ),
    );
  }

  void _showEditProfileDialog(UserProfile profile) {
    _nameController.text = profile.name;
    _selectedAvatar = profile.avatar;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 편집'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '프로필 이름',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                context.read<ProfileManagerState>().renameProfile(
                  profile.id,
                  _nameController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _showDeleteProfileDialog(UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 삭제'),
        content: Text('${profile.name} 프로필을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileManagerState>().deleteProfile(profile.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
