import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressBarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;

  const ProgressBarChartWidget({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Progress',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Horizontal scrollable capsule bar chart
          SizedBox(
            height: 180,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: monthlyData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: _CapsuleBar(
                      month: data['month'] as String,
                      lessons: data['lessons'] as int,
                      percentage: (data['percentage'] as int) / 100.0,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapsuleBar extends StatelessWidget {
  final String month;
  final int lessons;
  final double percentage; // 0.0 to 1.0

  const _CapsuleBar({
    required this.month,
    required this.lessons,
    required this.percentage,
  });

  Color _barColor(double pct) {
    if (pct >= 0.9) return const Color(0xFF7C3AED); // purple — peak
    if (pct >= 0.6) return const Color(0xFF4F46E5); // indigo — good
    if (pct >= 0.4) return const Color(0xFF6EE7B7); // mint — moderate
    return const Color(0xFFD1D5DB); // grey — low
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const barHeight = 140.0;
    const barWidth = 52.0;
    final fillHeight = barHeight * percentage;
    final barColor = _barColor(percentage);
    // Badge position is at the top of the fill
    final badgeBottom = fillHeight - 14;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: barWidth,
          height: barHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background capsule (outline/hatched)
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(barWidth / 2),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                    width: 1.5,
                  ),
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              // Filled capsule
              Positioned(
                bottom: 0,
                child: Container(
                  width: barWidth,
                  height: fillHeight.clamp(16.0, barHeight),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(barWidth / 2),
                    color: barColor,
                  ),
                ),
              ),
              // Percentage badge at top of fill
              Positioned(
                bottom: badgeBottom.clamp(0.0, barHeight - 28),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(percentage * 100).round()}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Lessons count
        Text(
          '$lessons',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Text(
          'lessons',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        // Month label
        Text(
          month,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
