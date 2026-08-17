import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../timetable_screen.dart';

class NextUpCardWidget extends StatefulWidget {
  final TimetableEntry entry;

  const NextUpCardWidget({super.key, required this.entry});

  @override
  State<NextUpCardWidget> createState() => _NextUpCardWidgetState();
}

class _NextUpCardWidgetState extends State<NextUpCardWidget> {
  // Simulated countdown — in production use real DateTime diff
  // TODO: Replace with real countdown from TimetableRepository + DateTime.now()
  final int _minutesLeft = 47;
  late final Stream<int> _countdown;

  @override
  void initState() {
    super.initState();
    // Simulate countdown decrement — never uses Future.delayed pattern
    _countdown = Stream.periodic(
      const Duration(seconds: 60),
      (i) => _minutesLeft - i - 1,
    ).take(_minutesLeft);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: "NEXT UP" label + countdown
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '⏰ NEXT UP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                StreamBuilder<int>(
                  stream: _countdown,
                  builder: (context, snapshot) {
                    final mins = snapshot.hasData
                        ? snapshot.data!
                        : _minutesLeft;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'in ${mins}m',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Course code + session type badge
            Row(
              children: [
                Text(
                  entry.courseCode,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                _WhiteBadge(label: entry.sessionType.toUpperCase()),
              ],
            ),
            const SizedBox(height: 6),
            // Course title
            Text(
              entry.courseTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // Bottom row: time + room + lecturer
            Row(
              children: [
                _InfoChip(
                  icon: Icons.access_time_rounded,
                  label: '${entry.startTime} – ${entry.endTime}',
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.location_on_outlined,
                  label: '${entry.room}, ${entry.building}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Lecturer avatar
                ClipOval(
                  child: Image.network(
                    entry.lecturerAvatar,
                    width: 26,
                    height: 26,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 26,
                      height: 26,
                      color: Colors.white.withValues(alpha: 0.3),
                      child: const Icon(
                        Icons.person,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    semanticLabel: entry.lecturerSemanticLabel,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  entry.lecturerName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const Spacer(),
                // Navigate arrow
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WhiteBadge extends StatelessWidget {
  final String label;
  const _WhiteBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
