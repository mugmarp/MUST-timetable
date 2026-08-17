import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import './widgets/settings_appearance_widget.dart';
import './widgets/settings_danger_zone_widget.dart';
import './widgets/settings_data_sync_widget.dart';
import './widgets/settings_notifications_widget.dart';
import './widgets/settings_profile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: Replace with Riverpod PreferencesNotifier for production

  // Profile state
  String _studentName = 'Tendo Nakato';
  String _programmeGroup = 'MBR 1';
  final List<String> _programmeOptions = [
    'MBR 1',
    'MBR 2',
    'PHA I',
    'PHA II',
    'BSP I',
    'BSP II',
    'BNS 1',
    'BNS 2',
  ];

  // Notification state
  bool _alarmsEnabled = true;
  int _defaultReminderMinutes = 15;
  bool _suppressDuringExams = true;
  bool _suppressDuringBreaks = true;
  final List<int> _reminderOptions = [5, 10, 15, 30, 60];

  // Appearance state
  bool _isDarkMode = false;
  String _selectedAccent = 'Indigo';
  final List<Map<String, dynamic>> _accentOptions = [
    {'name': 'Indigo', 'color': AppTheme.primary},
    {'name': 'Purple', 'color': AppTheme.secondary},
    {'name': 'Green', 'color': AppTheme.practicalColor},
    {'name': 'Amber', 'color': AppTheme.clinicalColor},
  ];

  // Sync state
  final String _lastSyncedAt = 'Sat 15 Aug 2026 at 12:47 EAT';
  bool _isSyncing = false;

  void _onSync() async {
    // TODO: Replace with TimetableRepository.fetchRemoteSchedule()
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isSyncing = false);
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear Cache?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This will remove locally cached timetable data. Your notes and alarms will be preserved.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: Clear Drift DB cache tables
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.warning),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetNotesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Reset All Notes?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.error,
          ),
        ),
        content: Text(
          'This will permanently delete ALL personal lecture notes. This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: Delete all notes from Drift DB notes table
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showClearAlarmsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear All Alarms?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.error,
          ),
        ),
        content: Text(
          'All scheduled class reminders will be cancelled. You can re-enable them from individual lectures.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: Cancel all alarms via AlarmSchedulerService
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Clear Alarms'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              scrolledUnderElevation: 1,
              pinned: true,
              leading: InkWell(
                onTap: () => context.go('/timetable-screen'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Settings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40 : 16,
                vertical: 8,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile section
                  SettingsProfileWidget(
                    studentName: _studentName,
                    programmeGroup: _programmeGroup,
                    programmeOptions: _programmeOptions,
                    onNameChanged: (v) => setState(() => _studentName = v),
                    onProgrammeChanged: (v) {
                      if (v != null) {
                        setState(() => _programmeGroup = v);
                        // TODO: Update programme filter in TimetableRepository
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Notifications section
                  SettingsNotificationsWidget(
                    alarmsEnabled: _alarmsEnabled,
                    defaultReminderMinutes: _defaultReminderMinutes,
                    suppressDuringExams: _suppressDuringExams,
                    suppressDuringBreaks: _suppressDuringBreaks,
                    reminderOptions: _reminderOptions,
                    onAlarmsToggled: (v) => setState(() => _alarmsEnabled = v),
                    onReminderChanged: (v) =>
                        setState(() => _defaultReminderMinutes = v),
                    onExamSuppressionToggled: (v) =>
                        setState(() => _suppressDuringExams = v),
                    onBreakSuppressionToggled: (v) =>
                        setState(() => _suppressDuringBreaks = v),
                  ),
                  const SizedBox(height: 16),
                  // Appearance section
                  SettingsAppearanceWidget(
                    isDarkMode: _isDarkMode,
                    selectedAccent: _selectedAccent,
                    accentOptions: _accentOptions,
                    onDarkModeToggled: (v) => setState(() => _isDarkMode = v),
                    onAccentChanged: (v) => setState(() => _selectedAccent = v),
                  ),
                  const SizedBox(height: 16),
                  // Data & Sync section
                  SettingsDataSyncWidget(
                    lastSyncedAt: _lastSyncedAt,
                    isSyncing: _isSyncing,
                    onSync: _onSync,
                    onClearCache: _showClearCacheDialog,
                  ),
                  const SizedBox(height: 16),
                  // Danger zone
                  SettingsDangerZoneWidget(
                    onResetNotes: _showResetNotesDialog,
                    onClearAlarms: _showClearAlarmsDialog,
                  ),
                  const SizedBox(height: 32),
                  // App version footer
                  Center(
                    child: Text(
                      'MUSTimetable v1.0.0 • MUST Mbarara',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
