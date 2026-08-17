import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SettingsDangerZoneWidget extends StatelessWidget {
  final VoidCallback onResetNotes;
  final VoidCallback onClearAlarms;

  const SettingsDangerZoneWidget({
    super.key,
    required this.onResetNotes,
    required this.onClearAlarms,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.error.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    size: 15,
                    color: AppTheme.error,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'DANGER ZONE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            color: AppTheme.error.withValues(alpha: 0.15),
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          // Reset notes
          _DangerRow(
            icon: Icons.delete_sweep_rounded,
            label: 'Reset All Notes',
            subtitle: 'Permanently delete all lecture notes',
            onTap: onResetNotes,
          ),
          Divider(
            color: AppTheme.error.withValues(alpha: 0.1),
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          // Clear alarms
          _DangerRow(
            icon: Icons.alarm_off_rounded,
            label: 'Clear All Alarms',
            subtitle: 'Cancel all scheduled class reminders',
            onTap: onClearAlarms,
          ),
        ],
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _DangerRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      splashColor: AppTheme.error.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 17, color: AppTheme.error),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.error,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppTheme.error.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
