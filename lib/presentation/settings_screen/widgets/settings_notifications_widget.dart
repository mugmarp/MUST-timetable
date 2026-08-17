import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import './settings_section_widget.dart';

class SettingsNotificationsWidget extends StatelessWidget {
  final bool alarmsEnabled;
  final int defaultReminderMinutes;
  final bool suppressDuringExams;
  final bool suppressDuringBreaks;
  final List<int> reminderOptions;
  final ValueChanged<bool> onAlarmsToggled;
  final ValueChanged<int> onReminderChanged;
  final ValueChanged<bool> onExamSuppressionToggled;
  final ValueChanged<bool> onBreakSuppressionToggled;

  const SettingsNotificationsWidget({
    super.key,
    required this.alarmsEnabled,
    required this.defaultReminderMinutes,
    required this.suppressDuringExams,
    required this.suppressDuringBreaks,
    required this.reminderOptions,
    required this.onAlarmsToggled,
    required this.onReminderChanged,
    required this.onExamSuppressionToggled,
    required this.onBreakSuppressionToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsSectionWidget(
      title: 'Notifications',
      icon: Icons.notifications_rounded,
      iconColor: AppTheme.clinicalColor,
      children: [
        SettingsRowWidget(
          icon: Icons.alarm_rounded,
          iconColor: AppTheme.clinicalColor,
          label: 'Class Alarms',
          subtitle: 'Get reminded before each lecture',
          control: Switch(
            value: alarmsEnabled,
            onChanged: (v) {
              onAlarmsToggled(v);
              // TODO: Trigger AlarmSchedulerService.toggleAll(v)
            },
          ),
        ),
        if (alarmsEnabled) ...[
          Divider(
            color: theme.colorScheme.outlineVariant,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.clinicalColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        Icons.timer_outlined,
                        size: 17,
                        color: AppTheme.clinicalColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Default reminder time',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: reminderOptions.map((mins) {
                    final isSelected = mins == defaultReminderMinutes;
                    return ChoiceChip(
                      label: Text('${mins}m before'),
                      selected: isSelected,
                      onSelected: (v) {
                        if (v) onReminderChanged(mins);
                      },
                      selectedColor: AppTheme.clinicalColor.withValues(
                        alpha: 0.15,
                      ),
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.clinicalColor
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.clinicalColor
                              : theme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
        Divider(
          color: theme.colorScheme.outlineVariant,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        SettingsRowWidget(
          icon: Icons.event_busy_rounded,
          iconColor: AppTheme.error,
          label: 'Suppress during exams',
          subtitle: 'Auto-silence alarms during exam weeks',
          control: Switch(
            value: suppressDuringExams,
            onChanged: onExamSuppressionToggled,
          ),
        ),
        Divider(
          color: theme.colorScheme.outlineVariant,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        SettingsRowWidget(
          icon: Icons.beach_access_rounded,
          iconColor: AppTheme.theoryColor,
          label: 'Suppress during breaks',
          subtitle: 'Silence all alarms on university holidays',
          control: Switch(
            value: suppressDuringBreaks,
            onChanged: onBreakSuppressionToggled,
          ),
        ),
      ],
    );
  }
}
