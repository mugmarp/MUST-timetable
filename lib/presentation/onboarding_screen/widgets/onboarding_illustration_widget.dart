import 'package:flutter/material.dart';

class OnboardingIllustrationWidget extends StatelessWidget {
  const OnboardingIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE8E4FF),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkle decorations
          Positioned(top: 30, right: 40, child: _SparkleIcon(size: 20)),
          Positioned(top: 60, left: 30, child: _SparkleIcon(size: 14)),
          Positioned(top: 20, left: 80, child: _SparkleIcon(size: 10)),
          Positioned(bottom: 40, right: 30, child: _SparkleIcon(size: 12)),
          // Main illustration — stacked books
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Book stack illustration using Flutter primitives
              _BooksIllustration(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparkleIcon extends StatelessWidget {
  final double size;
  const _SparkleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.help_outline,
      size: size,
      color: Colors.white.withValues(alpha: 0.8),
    );
  }
}

class _BooksIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Shadow
          Positioned(
            bottom: 0,
            child: Container(
              width: 180,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Bottom book (largest)
          Positioned(
            bottom: 8,
            child: _BookWidget(
              width: 160,
              height: 36,
              spineColor: const Color(0xFF3B82F6),
              coverColor: const Color(0xFF60A5FA),
              pageColor: Colors.white,
            ),
          ),
          // Middle book
          Positioned(
            bottom: 42,
            left: 20,
            child: _BookWidget(
              width: 140,
              height: 34,
              spineColor: const Color(0xFF2563EB),
              coverColor: const Color(0xFF3B82F6),
              pageColor: Colors.white,
            ),
          ),
          // Top book (tilted slightly)
          Positioned(
            bottom: 74,
            left: 14,
            child: Transform.rotate(
              angle: -0.04,
              child: _BookWidget(
                width: 148,
                height: 32,
                spineColor: const Color(0xFF1D4ED8),
                coverColor: const Color(0xFF2563EB),
                pageColor: const Color(0xFFF0F9FF),
              ),
            ),
          ),
          // Topmost small book
          Positioned(
            bottom: 104,
            left: 30,
            child: Transform.rotate(
              angle: 0.06,
              child: _BookWidget(
                width: 120,
                height: 28,
                spineColor: const Color(0xFF1E40AF),
                coverColor: const Color(0xFF1D4ED8),
                pageColor: Colors.white,
              ),
            ),
          ),
          // MUST logo/text on top book
          Positioned(
            bottom: 112,
            left: 44,
            child: Text(
              'MUST',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color spineColor;
  final Color coverColor;
  final Color pageColor;

  const _BookWidget({
    required this.width,
    required this.height,
    required this.spineColor,
    required this.coverColor,
    required this.pageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Spine
        Container(
          width: 14,
          height: height,
          decoration: BoxDecoration(
            color: spineColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              bottomLeft: Radius.circular(3),
            ),
          ),
        ),
        // Cover
        Container(width: width - 14 - 8, height: height, color: coverColor),
        // Pages
        Container(
          width: 8,
          height: height,
          decoration: BoxDecoration(
            color: pageColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(3),
              bottomRight: Radius.circular(3),
            ),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
