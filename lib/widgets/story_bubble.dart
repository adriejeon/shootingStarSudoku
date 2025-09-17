import 'package:flutter/material.dart';
import '../models/story_data.dart';

class StoryBubble extends StatefulWidget {
  final int stageNumber;
  final int levelNumber;
  final VoidCallback? onTap;

  const StoryBubble({
    super.key,
    required this.stageNumber,
    required this.levelNumber,
    this.onTap,
  });

  @override
  State<StoryBubble> createState() => _StoryBubbleState();
}

class _StoryBubbleState extends State<StoryBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    // 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyText = StoryData.getStoryText(
      widget.stageNumber,
      widget.levelNumber,
    );
    final characterName = StoryData.getCharacterName(widget.stageNumber);
    final theme = StoryData.getStageTheme(widget.stageNumber);

    if (storyText == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildBubble(context, storyText, characterName, theme),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBubble(
    BuildContext context,
    String storyText,
    String characterName,
    Map<String, dynamic> theme,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          isTablet ? 40 : 20,
          0,
          isTablet ? 40 : 20,
          isTablet ? 10 : 5,
        ),
        child: Stack(
          children: [
            // 말풍선 그림자
            Positioned(
              left: 4,
              top: 4,
              child: _buildBubbleShape(
                storyText,
                characterName,
                theme,
                isTablet,
                isShadow: true,
              ),
            ),
            // 메인 말풍선
            _buildBubbleShape(storyText, characterName, theme, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleShape(
    String storyText,
    String characterName,
    Map<String, dynamic> theme,
    bool isTablet, {
    bool isShadow = false,
  }) {
    return CustomPaint(
      painter: BubblePainter(
        color: isShadow
            ? Colors.black.withOpacity(0.2)
            : const Color(0xFF0E132A).withOpacity(0.6),
        borderColor: isShadow
            ? Colors.transparent
            : Color(theme['accentColor']),
        isShadow: isShadow,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 24 : 20,
          isTablet ? 20 : 16,
          isTablet ? 24 : 20,
          isTablet ? 28 : 24,
        ),
        constraints: BoxConstraints(
          minHeight: isTablet ? 80 : 60,
          maxWidth: MediaQuery.of(context).size.width * (isTablet ? 0.9 : 0.95),
        ),
        child: isShadow
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 캐릭터 이름
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(theme['accentColor']).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(theme['accentColor']).withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          characterName,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // 레벨 표시
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Level ${widget.levelNumber}',
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 스토리 텍스트
                  Text(
                    storyText,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final bool isShadow;

  BubblePainter({
    required this.color,
    required this.borderColor,
    this.isShadow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isShadow ? 0 : 2;

    const radius = 16.0;

    // 말풍선 메인 부분 (둥근 사각형만, 꼬리 제거)
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ),
    );

    // 그림자가 아닐 때만 그라데이션 효과 적용
    if (!isShadow) {
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
      );

      final gradientPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        );

      canvas.drawPath(path, gradientPaint);
      canvas.drawPath(path, borderPaint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
