import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SessionType { theory, practical, clinical }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory StatusBadgeWidget.sessionType(SessionType type) {
    switch (type) {
      case SessionType.theory:
        return StatusBadgeWidget(
          label: 'THEORY',
          backgroundColor: const Color(0xFFDBEAFE),
          textColor: const Color(0xFF1D4ED8),
        );
      case SessionType.practical:
        return StatusBadgeWidget(
          label: 'PRACTICAL',
          backgroundColor: const Color(0xFFDCFCE7),
          textColor: const Color(0xFF15803D),
        );
      case SessionType.clinical:
        return StatusBadgeWidget(
          label: 'CLINICAL',
          backgroundColor: const Color(0xFFFEF3C7),
          textColor: const Color(0xFFB45309),
        );
    }
  }

  factory StatusBadgeWidget.fromString(String type) {
    switch (type.toLowerCase()) {
      case 'practical':
        return StatusBadgeWidget.sessionType(SessionType.practical);
      case 'clinical':
        return StatusBadgeWidget.sessionType(SessionType.clinical);
      default:
        return StatusBadgeWidget.sessionType(SessionType.theory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
