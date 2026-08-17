import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import './settings_section_widget.dart';

class SettingsProfileWidget extends StatefulWidget {
  final String studentName;
  final String programmeGroup;
  final List<String> programmeOptions;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String?> onProgrammeChanged;

  const SettingsProfileWidget({
    super.key,
    required this.studentName,
    required this.programmeGroup,
    required this.programmeOptions,
    required this.onNameChanged,
    required this.onProgrammeChanged,
  });

  @override
  State<SettingsProfileWidget> createState() => _SettingsProfileWidgetState();
}

class _SettingsProfileWidgetState extends State<SettingsProfileWidget> {
  late TextEditingController _nameController;
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsSectionWidget(
      title: 'Profile',
      icon: Icons.person_rounded,
      iconColor: AppTheme.primary,
      children: [
        // Avatar + name row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.pexels.com/photos/3777943/pexels-photo-3777943.jpeg?auto=compress&cs=tinysrgb&w=100',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person_rounded,
                          size: 28,
                          color: theme.colorScheme.primary,
                        ),
                        semanticLabel:
                            'Profile photo of MUST student in casual attire',
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_editingName)
                      TextFormField(
                        controller: _nameController,
                        autofocus: true,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (v) {
                          widget.onNameChanged(v);
                          setState(() => _editingName = false);
                        },
                      )
                    else
                      Text(
                        widget.studentName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    const SizedBox(height: 3),
                    Text(
                      'Student • ${widget.programmeGroup}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (_editingName) {
                    widget.onNameChanged(_nameController.text);
                  }
                  setState(() => _editingName = !_editingName);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _editingName ? 'Save' : 'Edit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Divider(
          color: theme.colorScheme.outlineVariant,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        // Programme group selector
        SettingsRowWidget(
          icon: Icons.school_rounded,
          iconColor: AppTheme.primary,
          label: 'Programme Group',
          subtitle: 'Used to filter your timetable',
          control: DropdownButton<String>(
            value: widget.programmeGroup,
            underline: const SizedBox.shrink(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.primary,
              size: 18,
            ),
            borderRadius: BorderRadius.circular(12),
            items: widget.programmeOptions
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: widget.onProgrammeChanged,
          ),
        ),
      ],
    );
  }
}
