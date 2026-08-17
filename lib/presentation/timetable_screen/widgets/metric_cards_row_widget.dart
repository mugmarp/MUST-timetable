import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetricCardsRowWidget extends StatelessWidget {
  final int lessonsToday;
  final int totalLessonsWeek;
  final int hoursThisWeek;

  const MetricCardsRowWidget({
    super.key,
    required this.lessonsToday,
    required this.totalLessonsWeek,
    required this.hoursThisWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.event_note_rounded,
            label: 'Lessons',
            value: '$lessonsToday',
            subtitle: 'today',
            backgroundColor: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.access_time_filled_rounded,
            label: 'Hours',
            value: '$hoursThisWeek',
            subtitle: 'this week',
            backgroundColor: const Color(0xFFFFF9C4),
            iconColor: const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label row (matches reference anatomy)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Large number
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              fontFeatures: [const FontFeature.tabularFigures()],
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle + arrow row
          Row(
            children: [
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const Spacer(),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.north_east_rounded,
                  size: 13,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
