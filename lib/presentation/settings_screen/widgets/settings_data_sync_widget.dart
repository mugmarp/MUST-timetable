import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import './settings_section_widget.dart';

class SettingsDataSyncWidget extends StatelessWidget {
  final String lastSyncedAt;
  final bool isSyncing;
  final VoidCallback onSync;
  final VoidCallback onClearCache;

  const SettingsDataSyncWidget({
    super.key,
    required this.lastSyncedAt,
    required this.isSyncing,
    required this.onSync,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsSectionWidget(
      title: 'Data & Sync',
      icon: Icons.sync_rounded,
      iconColor: AppTheme.theoryColor,
      children: [
        SettingsRowWidget(
          icon: Icons.cloud_sync_rounded,
          iconColor: AppTheme.theoryColor,
          label: 'Sync Timetable',
          subtitle: 'Last synced: $lastSyncedAt',
          control: isSyncing
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.theoryColor,
                  ),
                )
              : InkWell(
                  onTap: onSync,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.theoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sync Now',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.theoryColor,
                      ),
                    ),
                  ),
                ),
        ),
        Divider(
          color: theme.colorScheme.outlineVariant,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        SettingsRowWidget(
          icon: Icons.storage_rounded,
          iconColor: AppTheme.warning,
          label: 'Clear Cache',
          subtitle: 'Remove cached timetable data',
          control: InkWell(
            onTap: onClearCache,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Clear',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warning,
                ),
              ),
            ),
          ),
        ),
        Divider(
          color: theme.colorScheme.outlineVariant,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        SettingsRowWidget(
          icon: Icons.info_outline_rounded,
          iconColor: theme.colorScheme.onSurfaceVariant,
          label: 'Timetable Version',
          subtitle: 'Final v3 — Semester 2, 2025/2026',
          control: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.practicalColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'FINAL',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.practicalColor,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
