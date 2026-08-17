import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import './settings_section_widget.dart';

class SettingsAppearanceWidget extends StatelessWidget {
  final bool isDarkMode;
  final String selectedAccent;
  final List<Map<String, dynamic>> accentOptions;
  final ValueChanged<bool> onDarkModeToggled;
  final ValueChanged<String> onAccentChanged;

  const SettingsAppearanceWidget({
    super.key,
    required this.isDarkMode,
    required this.selectedAccent,
    required this.accentOptions,
    required this.onDarkModeToggled,
    required this.onAccentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsSectionWidget(
      title: 'Appearance',
      icon: Icons.palette_rounded,
      iconColor: AppTheme.secondary,
      children: [
        SettingsRowWidget(
          icon: isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          iconColor: AppTheme.secondary,
          label: 'Dark Mode',
          subtitle: isDarkMode ? 'Dark theme active' : 'Light theme active',
          control: Switch(
            value: isDarkMode,
            onChanged: (v) {
              onDarkModeToggled(v);
              // TODO: Persist to SharedPreferences and rebuild MaterialApp theme
            },
          ),
        ),
        Divider(
          color: theme.colorScheme.outlineVariant,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.color_lens_outlined,
                      size: 17,
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Accent Colour',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: accentOptions.map((opt) {
                  final name = opt['name'] as String;
                  final color = opt['color'] as Color;
                  final isSelected = name == selectedAccent;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => onAccentChanged(name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        width: isSelected ? 44 : 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(
                            isSelected ? 12 : 18,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 6),
              Text(
                selectedAccent,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
