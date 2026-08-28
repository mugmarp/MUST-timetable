import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import './widgets/day_tabs_widget.dart';
import './widgets/lecture_detail_sheet_widget.dart';
import './widgets/metric_cards_row_widget.dart';
import './widgets/next_up_card_widget.dart';
import './widgets/progress_bar_chart_widget.dart';
import './widgets/session_card_widget.dart';
import './widgets/timetable_header_widget.dart';

// TODO: Replace with Riverpod providers for production

class TimetableEntry {
  final String id;
  final String courseCode;
  final String courseTitle;
  final String category;
  final String sessionType;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final String building;
  final String lecturerName;
  final String lecturerAvatar;
  final List<String> programmeGroups;
  final String rating;
  final double ratingValue;
  final String lecturerSemanticLabel;

  const TimetableEntry({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.category,
    required this.sessionType,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.building,
    required this.lecturerName,
    required this.lecturerAvatar,
    required this.programmeGroups,
    required this.rating,
    required this.ratingValue,
    required this.lecturerSemanticLabel,
  });

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: map['id'] as String,
      courseCode: (map['courseCode'] ?? map['code'] ?? '') as String,
      courseTitle: (map['courseTitle'] ?? map['courseName'] ?? '') as String,
      category: (map['category'] ?? _deriveCategory(map['courseCode'] ?? map['code'] ?? '')) as String,
      sessionType: (map['sessionType'] ?? map['note'] ?? 'theory') as String,
      dayOfWeek: (map['dayOfWeek'] ?? map['day'] ?? '') as String,
      startTime: (map['startTime'] ?? '') as String,
      endTime: (map['endTime'] ?? '') as String,
      room: (map['room'] ?? map['venue'] ?? '') as String,
      building: (map['building'] ?? '') as String,
      lecturerName: (map['lecturerName'] ?? map['lecturer'] ?? '') as String,
      lecturerAvatar: (map['lecturerAvatar'] ?? '') as String,
      programmeGroups: List<String>.from(map['programmeGroups'] ?? map['cohorts'] ?? []),
      rating: (map['rating'] ?? '0.0') as String,
      ratingValue: (map['ratingValue'] as num?)?.toDouble() ?? 0.0,
      lecturerSemanticLabel: (map['lecturerSemanticLabel'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'courseCode': courseCode,
    'courseTitle': courseTitle,
    'category': category,
    'sessionType': sessionType,
    'dayOfWeek': dayOfWeek,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
    'building': building,
    'lecturerName': lecturerName,
    'lecturerAvatar': lecturerAvatar,
    'programmeGroups': programmeGroups,
    'rating': rating,
    'ratingValue': ratingValue,
    'lecturerSemanticLabel': lecturerSemanticLabel,
  };
}

String _deriveCategory(String code) {
  if (code.isEmpty) return 'General';
  final prefix = code.replaceAll(RegExp(r'\d'), '').toUpperCase();
  const categories = {
    'BIT': 'Information Technology', 'BCS': 'Computer Science',
    'BME': 'Biomedical Engineering', 'EEE': 'Electrical Engineering',
    'CIV': 'Civil Engineering', 'MIE': 'Mechanical Engineering',
    'PEM': 'Production Engineering', 'DLT': 'Dental Technology',
    'BBA': 'Business Administration', 'BAF': 'Accounting & Finance',
    'ECO': 'Economics', 'BSAF': 'Actuarial Science', 'BPSM': 'Project Management',
    'BSAL': 'Food Science & Technology', 'BSP': 'Physiotherapy',
    'BSPC': 'Speech & Hearing', 'BNS': 'Nursing Science',
    'BNC': 'Nursing (Clinical)', 'MLS': 'Medical Laboratory',
    'MLC': 'Medical Clinical', 'MBR': 'Medicine',
    'PHA': 'Pharmacy', 'PHS': 'Physiology',
    'BIO': 'Biology', 'CHM': 'Chemistry', 'PHY': 'Physics',
    'MAT': 'Mathematics', 'CSC': 'Computer Science',
    'BCH': 'Biochemistry', 'ANA': 'Anatomy', 'MIC': 'Microbiology',
    'PHM': 'Pharmacology', 'DVS': 'Development Studies',
    'COM': 'Communication', 'CMH': 'Community Health',
    'NSG': 'Nursing', 'GWH': 'Women\'s Health', 'FME': 'Family Medicine',
    'SWE': 'Software Engineering', 'BPCD': 'Planning & Development',
    'BGWH': 'Women\'s Health', 'STP': 'Student Projects',
    'MLS': 'Medical Laboratory', 'BIO': 'Biology',
    'SUR': 'Surgery', 'WEL': 'Welcoming',
    'PHX': 'Pharmacology & Therapeutics', 'BPS': 'Pharmaceutical Sciences',
    'BSE': 'Biomedical Engineering', 'CVE': 'Civil Engineering',
    'DCS': 'Computer Science', 'MCB': 'Microbiology',
    'OBG': 'Obstetrics & Gynaecology', 'PCH': 'Paediatrics',
    'SUG': 'Surgery',
  };
  final sortedKeys = categories.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
  for (final key in sortedKeys) {
    if (prefix.startsWith(key)) return categories[key]!;
  }
  return 'General';
}

// Mock data — Map-first pattern
// Placeholder: replaced by JSON asset loader below

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with TickerProviderStateMixin {
  late List<TimetableEntry> _allEntries;
  int _selectedDayIndex = 0;
  bool _isSyncing = false;
  final bool _isOnline = true;
  bool _isLoading = true;
  String? _selectedProgram; // null = show all

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _fullDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  late AnimationController _listAnimController;

  /// Load timetable data from bundled JSON asset
  Future<List<TimetableEntry>> _loadFromAsset() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/timetable_data.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final sessions = data['sessions'] as List;
      return sessions.map((s) => TimetableEntry.fromMap(s as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error loading timetable data: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _allEntries = [];
    _isLoading = true;

    // Load real data from JSON asset
    _loadFromAsset().then((entries) {
      if (mounted) {
        setState(() {
          _allEntries = entries;
          _isLoading = false;
          // Default to Monday (index 0) — user can switch via day tabs
          _selectedDayIndex = 0;
        });
      }
    });

    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listAnimController.forward();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  List<TimetableEntry> get _todayEntries {
    final day = _fullDays[_selectedDayIndex];
    var entries = _allEntries.where((e) => e.dayOfWeek == day).toList();
    if (_selectedProgram != null) {
      entries = entries.where((e) => e.programmeGroups.contains(_selectedProgram)).toList();
    }
    return entries..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  TimetableEntry? get _nextUpEntry {
    // Simulate "next up" as first entry of the selected day
    final today = _todayEntries;
    if (today.isEmpty) {
      // Fall back to Monday
      final monday = _allEntries.where((e) => e.dayOfWeek == 'Monday').toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      return monday.isNotEmpty ? monday.first : null;
    }
    return today.isNotEmpty ? today.first : null;
  }

  void _onDayChanged(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
    _listAnimController.reset();
    _listAnimController.forward();
  }

  Future<void> _onSync() async {
    setState(() => _isSyncing = true);
    final entries = await _loadFromAsset();
    if (mounted) {
      setState(() {
        _allEntries = entries;
        _isSyncing = false;
      });
      _listAnimController.reset();
      _listAnimController.forward();
    }
  }

  void _openLectureDetail(TimetableEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LectureDetailSheetWidget(entry: entry),
    );
  }

  // Monthly lesson mock data for chart
  final List<Map<String, dynamic>> _monthlyData = [
    {'month': 'May', 'lessons': 23, 'percentage': 70},
    {'month': 'Jun', 'lessons': 44, 'percentage': 100},
    {'month': 'Jul', 'lessons': 14, 'percentage': 50},
    {'month': 'Aug', 'lessons': 31, 'percentage': 85},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text('Loading timetable...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
            ],
          ),
        ),
      );
    }

    if (isTablet) {
      return _buildTabletLayout(theme);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onSync,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: TimetableHeaderWidget(
                  isSyncing: _isSyncing,
                  isOnline: _isOnline,
                  onSyncTap: _onSync,
                  onSettingsTap: () => context.go(AppRoutes.settingsScreen),
                ),
              ),
              if (_nextUpEntry != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: NextUpCardWidget(entry: _nextUpEntry!),
                  ),
                ),
              SliverToBoxAdapter(
                child: DayTabsWidget(
                  days: _days,
                  selectedIndex: _selectedDayIndex,
                  onDaySelected: _onDayChanged,
                  entries: _allEntries,
                  fullDays: _fullDays,
                ),
              ),
              if (_todayEntries.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 56,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No classes on ${_fullDays[_selectedDayIndex]}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enjoy your free day!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = _todayEntries[index];
                      final delay = (index * 60).clamp(0, 400);
                      return AnimatedBuilder(
                        animation: _listAnimController,
                        builder: (context, child) {
                          final start = delay / 1000.0;
                          final t = ((_listAnimController.value - start) / 0.4)
                              .clamp(0.0, 1.0);
                          final curved = Curves.easeOutCubic.transform(t);
                          return Opacity(
                            opacity: curved,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - curved)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SessionCardWidget(
                            entry: entry,
                            onTap: () => _openLectureDetail(entry),
                          ),
                        ),
                      );
                    }, childCount: _todayEntries.length),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: MetricCardsRowWidget(
                    lessonsToday: _todayEntries.length,
                    totalLessonsWeek: _allEntries.length,
                    hoursThisWeek: (_allEntries.fold<double>(0, (sum, e) {
                      final start =
                          int.tryParse(e.startTime.split(':')[0]) ?? 0;
                      final end = int.tryParse(e.endTime.split(':')[0]) ?? 0;
                      return sum + (end - start);
                    })).round(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: ProgressBarChartWidget(monthlyData: _monthlyData),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Row(
          children: [
            // Left panel — schedule list
            SizedBox(
              width: 380,
              child: Column(
                children: [
                  TimetableHeaderWidget(
                    isSyncing: _isSyncing,
                    isOnline: _isOnline,
                    onSyncTap: _onSync,
                    onSettingsTap: () => context.go(AppRoutes.settingsScreen),
                  ),
                  DayTabsWidget(
                    days: _days,
                    selectedIndex: _selectedDayIndex,
                    onDaySelected: _onDayChanged,
                    entries: _allEntries,
                    fullDays: _fullDays,
                  ),
                  Expanded(
                    child: _todayEntries.isEmpty
                        ? Center(
                            child: Text(
                              'No classes today',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _todayEntries.length,
                            itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SessionCardWidget(
                                entry: _todayEntries[i],
                                onTap: () =>
                                    _openLectureDetail(_todayEntries[i]),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            // Divider
            VerticalDivider(width: 1, color: theme.colorScheme.outlineVariant),
            // Right panel — metrics + chart
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_nextUpEntry != null)
                      NextUpCardWidget(entry: _nextUpEntry!),
                    const SizedBox(height: 20),
                    MetricCardsRowWidget(
                      lessonsToday: _todayEntries.length,
                      totalLessonsWeek: _allEntries.length,
                      hoursThisWeek: (_allEntries.fold<double>(0, (sum, e) {
                        final start =
                            int.tryParse(e.startTime.split(':')[0]) ?? 0;
                        final end = int.tryParse(e.endTime.split(':')[0]) ?? 0;
                        return sum + (end - start);
                      })).round(),
                    ),
                    const SizedBox(height: 20),
                    ProgressBarChartWidget(monthlyData: _monthlyData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}