import 'dart:math';
import 'package:flutter/material.dart';

class ShootingStar {
  late Offset position;
  late double speed;
  late double size;
  late double opacity;
  final Random random = Random();

  ShootingStar(Random randomGen, Size canvasSize) {
    // 오른쪽 상단에서 시작
    position = Offset(
      canvasSize.width * 0.7 +
          randomGen.nextDouble() * canvasSize.width * 0.3, // 오른쪽 30% 영역에서 시작
      randomGen.nextDouble() * -canvasSize.height * 0.5, // 화면 밖 위에서 시작
    );
    speed = randomGen.nextDouble() * 2 + 1; // 1 ~ 3 사이의 속도
    size = randomGen.nextDouble() * 40 + 30; // 30 ~ 70 사이의 크기
    opacity = randomGen.nextDouble() * 0.5 + 0.5; // 0.5 ~ 1.0 사이의 투명도
  }

  void update(Size canvasSize) {
    // 오른쪽에서 왼쪽으로 꺾이면서 떨어지도록 수정
    position = Offset(
      position.dx - speed * 0.3, // x 좌표는 왼쪽으로 이동 (꺾이는 효과)
      position.dy + speed, // y 좌표는 아래로 이동
    );

    // 화면 밖으로 나가면 다시 초기화
    if (position.dy > canvasSize.height + size || position.dx < -size) {
      position = Offset(
        canvasSize.width * 0.7 +
            random.nextDouble() * canvasSize.width * 0.3, // 오른쪽 30% 영역에서 시작
        random.nextDouble() * -canvasSize.height * 0.8, // 화면 밖 위에서 더 랜덤하게 시작
      );
      speed = random.nextDouble() * 2 + 1;
      size = random.nextDouble() * 40 + 30;
      opacity = random.nextDouble() * 0.5 + 0.5;
    }
  }
}

class ShootingStarPainter extends CustomPainter {
  final List<ShootingStar> stars;

  ShootingStarPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      // 별똥별 이미지 그리기
      final Paint imagePaint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withOpacity(star.opacity.clamp(0.0, 1.0)),
          BlendMode.modulate,
        );

      // 이미지 크기 계산
      final double imageSize = star.size;
      final Rect imageRect = Rect.fromCenter(
        center: star.position,
        width: imageSize,
        height: imageSize,
      );

      // 별똥별 이미지 그리기 (이미지가 로드되지 않은 경우를 대비해 원으로 대체)
      final Paint fallbackPaint = Paint()
        ..color = Colors.white.withOpacity(star.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(star.position, imageSize / 2, fallbackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShootingStarPainter oldDelegate) {
    return true; // 계속 다시 그려야 하므로 항상 true
  }
}

class ShootingStarBackground extends StatefulWidget {
  final int numberOfStars;
  final Widget? child;

  const ShootingStarBackground({super.key, this.numberOfStars = 1, this.child});

  @override
  State<ShootingStarBackground> createState() => _ShootingStarBackgroundState();
}

class _ShootingStarBackgroundState extends State<ShootingStarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ShootingStar> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _stars = [];
    _controller =
        AnimationController(
            duration: const Duration(milliseconds: 500), // 더 빠른 애니메이션으로 자주 떨어지게
            vsync: this,
          )
          ..addListener(() {
            // 별똥별들의 위치를 업데이트하고 화면을 다시 그리도록 요청
            if (mounted) {
              setState(() {
                for (var star in _stars) {
                  star.update(MediaQuery.of(context).size);
                }
              });
            }
          })
          ..repeat(); // 무한 반복

    // 위젯이 빌드된 후 화면 크기를 가져와 별들을 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initStars(MediaQuery.of(context).size);
      }
    });
  }

  void _initStars(Size canvasSize) {
    if (mounted) {
      setState(() {
        _stars = List.generate(
          widget.numberOfStars,
          (index) => ShootingStar(_random, canvasSize),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 별똥별 이미지들
        ..._stars
            .map(
              (star) => Positioned(
                left: star.position.dx - star.size / 2,
                top: star.position.dy - star.size / 2,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: star.opacity.clamp(0.0, 1.0),
                      child: Image.asset(
                        'assets/images/shootingStar.png',
                        width: star.size,
                        height: star.size,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
        // 다른 UI 요소들
        if (widget.child != null) widget.child!,
      ],
    );
  }
}
