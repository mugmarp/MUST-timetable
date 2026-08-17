import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingBottomPanelWidget extends StatelessWidget {
  final VoidCallback onGetStarted;
  final bool isTablet;

  const OnboardingBottomPanelWidget({
    super.key,
    required this.onGetStarted,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28, 32, 28, isTablet ? 32 : 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: isTablet
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
        boxShadow: isTablet
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // App logo row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'MUSTimetable',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Headline
          Text(
            'Start Learning\nToday',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Text(
            'Never miss a lecture. View your MUST timetable, set class alarms, and take notes — all offline.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
          // CTA row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: onGetStarted,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A2E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Circular arrow button
              InkWell(
                onTap: onGetStarted,
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      width: 1.5,
                    ),
                    color: theme.colorScheme.secondaryContainer,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: theme.colorScheme.secondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Feature dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FeatureDot(
                icon: Icons.notifications_active_outlined,
                label: 'Alarms',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 20),
              _FeatureDot(
                icon: Icons.edit_note_rounded,
                label: 'Notes',
                color: const Color(0xFF16A34A),
              ),
              const SizedBox(width: 20),
              _FeatureDot(
                icon: Icons.wifi_off_rounded,
                label: 'Offline',
                color: const Color(0xFFD97706),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureDot extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureDot({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
