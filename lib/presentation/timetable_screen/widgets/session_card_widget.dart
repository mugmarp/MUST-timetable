import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../timetable_screen.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../theme/app_theme.dart';

class SessionCardWidget extends StatelessWidget {
  final TimetableEntry entry;
  final VoidCallback onTap;

  const SessionCardWidget({
    super.key,
    required this.entry,
    required this.onTap,
  });

  Color _cardBg(SessionType type) {
    switch (type) {
      case SessionType.theory:
        return const Color(0xFFEFF6FF);
      case SessionType.practical:
        return const Color(0xFFF0FDF4);
      case SessionType.clinical:
        return const Color(0xFFFFFBEB);
    }
  }

  Color _accentColor(SessionType type) {
    switch (type) {
      case SessionType.theory:
        return AppTheme.theoryColor;
      case SessionType.practical:
        return AppTheme.practicalColor;
      case SessionType.clinical:
        return AppTheme.clinicalColor;
    }
  }

  IconData _sessionIcon(SessionType type) {
    switch (type) {
      case SessionType.theory:
        return Icons.menu_book_rounded;
      case SessionType.practical:
        return Icons.science_rounded;
      case SessionType.clinical:
        return Icons.local_hospital_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = _parseType(entry.sessionType);
    final bg = _cardBg(type);
    final accent = _accentColor(type);
    final icon = _sessionIcon(type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: accent.withValues(alpha: 0.08),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: accent, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: icon box + rating
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 20, color: accent),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    entry.rating,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Category + session type badge
              Row(
                children: [
                  Text(
                    entry.category,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadgeWidget.fromString(entry.sessionType),
                ],
              ),
              const SizedBox(height: 4),
              // Course title
              Text(
                entry.courseTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Bottom row: time + room + avatar stack + arrow
              Row(
                children: [
                  // Time chip
                  _SmallChip(
                    icon: Icons.access_time_rounded,
                    label: '${entry.startTime}–${entry.endTime}',
                    color: accent,
                  ),
                  const SizedBox(width: 6),
                  _SmallChip(
                    icon: Icons.location_on_outlined,
                    label: entry.room,
                    color: accent,
                  ),
                  const Spacer(),
                  // Avatar stack + programme groups count
                  _AvatarStack(
                    count: entry.programmeGroups.length,
                    avatarUrl: entry.lecturerAvatar,
                    semanticLabel: entry.lecturerSemanticLabel,
                    accent: accent,
                  ),
                  const SizedBox(width: 8),
                  // Arrow circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static SessionType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'practical':
        return SessionType.practical;
      case 'clinical':
        return SessionType.clinical;
      default:
        return SessionType.theory;
    }
  }
}

class _SmallChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SmallChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final int count;
  final String avatarUrl;
  final String semanticLabel;
  final Color accent;

  const _AvatarStack({
    required this.count,
    required this.avatarUrl,
    required this.semanticLabel,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Single avatar
        ClipOval(
          child: Image.network(
            avatarUrl,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 24,
              height: 24,
              color: accent.withValues(alpha: 0.2),
              child: Icon(Icons.person, size: 12, color: accent),
            ),
            semanticLabel: semanticLabel,
          ),
        ),
        if (count > 1) ...[
          const SizedBox(width: 4),
          Text(
            '${count - 1}+',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ],
    );
  }
}
