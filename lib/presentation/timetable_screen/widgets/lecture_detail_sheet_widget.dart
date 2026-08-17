import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../timetable_screen.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../theme/app_theme.dart';

class LectureDetailSheetWidget extends StatefulWidget {
  final TimetableEntry entry;

  const LectureDetailSheetWidget({super.key, required this.entry});

  @override
  State<LectureDetailSheetWidget> createState() =>
      _LectureDetailSheetWidgetState();
}

class _LectureDetailSheetWidgetState extends State<LectureDetailSheetWidget> {
  // TODO: Replace with Riverpod NotesNotifier — load/save notes using composite business key
  // Business Natural Key: programme_group + course_code + day_of_week + start_time
  final TextEditingController _notesController = TextEditingController();
  bool _isEditingNotes = false;
  int _selectedAlarm = 15; // minutes before class
  bool _alarmEnabled = true;

  final List<int> _alarmOptions = [5, 10, 15, 30, 60];

  @override
  void initState() {
    super.initState();
    // TODO: Load existing notes from Drift DB using composite key
    _notesController.text =
        'Review Chapter 4 — Cell Membrane Transport before this session.';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Color _accentColor() {
    switch (widget.entry.sessionType.toLowerCase()) {
      case 'practical':
        return AppTheme.practicalColor;
      case 'clinical':
        return AppTheme.clinicalColor;
      default:
        return AppTheme.theoryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;
    final accent = _accentColor();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              entry.sessionType == 'practical'
                                  ? Icons.science_rounded
                                  : entry.sessionType == 'clinical'
                                  ? Icons.local_hospital_rounded
                                  : Icons.menu_book_rounded,
                              color: accent,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      entry.courseCode,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    StatusBadgeWidget.fromString(
                                      entry.sessionType,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.courseTitle,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Info grid
                      _InfoGrid(entry: entry, accent: accent),
                      const SizedBox(height: 20),
                      // Programme groups
                      _SectionHeader(
                        icon: Icons.group_rounded,
                        label: 'Programme Groups',
                        accent: accent,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: entry.programmeGroups
                            .map(
                              (g) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: accent.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  g,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      // Alarm section
                      _SectionHeader(
                        icon: Icons.alarm_rounded,
                        label: 'Alarm',
                        accent: accent,
                        trailing: Switch(
                          value: _alarmEnabled,
                          onChanged: (v) {
                            setState(() => _alarmEnabled = v);
                            // TODO: Toggle alarm in AlarmSchedulerService using composite business key
                          },
                        ),
                      ),
                      if (_alarmEnabled) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Remind me before class:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _alarmOptions.map((mins) {
                            final isSelected = mins == _selectedAlarm;
                            return ChoiceChip(
                              label: Text('${mins}m'),
                              selected: isSelected,
                              onSelected: (v) {
                                if (v) {
                                  setState(() => _selectedAlarm = mins);
                                  // TODO: Reschedule alarm using AlarmSchedulerService
                                }
                              },
                              selectedColor: accent.withValues(alpha: 0.2),
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? accent
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected
                                      ? accent
                                      : theme.colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Notes section
                      Row(
                        children: [
                          _SectionHeader(
                            icon: Icons.edit_note_rounded,
                            label: 'Personal Notes',
                            accent: accent,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditingNotes = !_isEditingNotes;
                              });
                              if (!_isEditingNotes) {
                                // TODO: Save notes to Drift DB using composite business key:
                                // ${entry.programmeGroups.first}_${entry.courseCode}_${entry.dayOfWeek}_${entry.startTime}
                              }
                            },
                            child: Text(
                              _isEditingNotes ? 'Save' : 'Edit',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_isEditingNotes)
                        TextFormField(
                          controller: _notesController,
                          maxLines: 5,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add notes for this lecture...',
                            filled: true,
                            fillColor:
                                theme.colorScheme.surfaceContainerHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: accent, width: 1.5),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _notesController.text.isEmpty
                                ? 'No notes yet. Tap Edit to add your thoughts.'
                                : _notesController.text,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: _notesController.text.isEmpty
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                              height: 1.55,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final Widget? trailing;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.accent,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: accent),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final TimetableEntry entry;
  final Color accent;

  const _InfoGrid({required this.entry, required this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      _InfoItem(
        icon: Icons.access_time_rounded,
        label: 'Time',
        value: '${entry.startTime} – ${entry.endTime}',
      ),
      _InfoItem(
        icon: Icons.location_on_outlined,
        label: 'Room',
        value: '${entry.room}, ${entry.building}',
      ),
      _InfoItem(
        icon: Icons.person_rounded,
        label: 'Lecturer',
        value: entry.lecturerName,
      ),
      _InfoItem(
        icon: Icons.calendar_today_rounded,
        label: 'Day',
        value: entry.dayOfWeek,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Padding(
            padding: EdgeInsets.only(bottom: i < items.length - 1 ? 12 : 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 16, color: accent),
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  item.value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
