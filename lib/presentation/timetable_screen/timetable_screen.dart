import 'package:flutter/material.dart';
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
      courseCode: map['courseCode'] as String,
      courseTitle: map['courseTitle'] as String,
      category: map['category'] as String,
      sessionType: map['sessionType'] as String,
      dayOfWeek: map['dayOfWeek'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      room: map['room'] as String,
      building: map['building'] as String,
      lecturerName: map['lecturerName'] as String,
      lecturerAvatar: map['lecturerAvatar'] as String,
      programmeGroups: List<String>.from(map['programmeGroups'] as List),
      rating: map['rating'] as String,
      ratingValue: (map['ratingValue'] as num).toDouble(),
      lecturerSemanticLabel: map['lecturerSemanticLabel'] as String,
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

// Mock data — Map-first pattern
final List<Map<String, dynamic>> _timetableEntryMaps = [
  {
    'id': 'te001',
    'courseCode': 'BSC 2101',
    'courseTitle': 'Biochemistry & Cell Biology',
    'category': 'Life Sciences',
    'sessionType': 'theory',
    'dayOfWeek': 'Monday',
    'startTime': '08:00',
    'endTime': '10:00',
    'room': 'LT 3',
    'building': 'Main Block',
    'lecturerName': 'Dr. Nakamya Ruth',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_19469930f-1763299082322.png',
    'programmeGroups': ['MBR 1', 'PHA I'],
    'rating': '4.2',
    'ratingValue': 4.2,
    'lecturerSemanticLabel':
        'Professional headshot of Ugandan woman in white lab coat smiling',
  },
  {
    'id': 'te002',
    'courseCode': 'PHY 2203',
    'courseTitle': 'Medical Physics & Instrumentation',
    'category': 'Physics',
    'sessionType': 'practical',
    'dayOfWeek': 'Monday',
    'startTime': '10:00',
    'endTime': '13:00',
    'room': 'Physics Lab 1',
    'building': 'Science Block',
    'lecturerName': 'Mr. Ochieng James',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_103ed5b0c-1763301455344.png',
    'programmeGroups': ['MBR 1'],
    'rating': '3.8',
    'ratingValue': 3.8,
    'lecturerSemanticLabel':
        'Professional headshot of East African man in blue shirt',
  },
  {
    'id': 'te003',
    'courseCode': 'ANA 2105',
    'courseTitle': 'Human Anatomy — Thorax & Abdomen',
    'category': 'Anatomy',
    'sessionType': 'clinical',
    'dayOfWeek': 'Monday',
    'startTime': '14:00',
    'endTime': '16:00',
    'room': 'Anatomy Hall',
    'building': 'Medical School',
    'lecturerName': 'Prof. Kigozi Bernard',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_11103a4a5-1763295121268.png',
    'programmeGroups': ['MBR 1', 'BSP I', 'PHA I'],
    'rating': '4.5',
    'ratingValue': 4.5,
    'lecturerSemanticLabel':
        'Professional photo of senior Ugandan professor in academic gown',
  },
  {
    'id': 'te004',
    'courseCode': 'BCH 2302',
    'courseTitle': 'Molecular Biology & Genetics',
    'category': 'Biochemistry',
    'sessionType': 'theory',
    'dayOfWeek': 'Tuesday',
    'startTime': '08:00',
    'endTime': '10:00',
    'room': 'LT 1',
    'building': 'Main Block',
    'lecturerName': 'Dr. Atuhaire Grace',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_19469930f-1763299082322.png',
    'programmeGroups': ['MBR 1', 'BSP I'],
    'rating': '4.0',
    'ratingValue': 4.0,
    'lecturerSemanticLabel':
        'Professional headshot of Ugandan woman scientist in laboratory',
  },
  {
    'id': 'te005',
    'courseCode': 'MIC 2201',
    'courseTitle': 'Medical Microbiology',
    'category': 'Microbiology',
    'sessionType': 'practical',
    'dayOfWeek': 'Tuesday',
    'startTime': '11:00',
    'endTime': '14:00',
    'room': 'Micro Lab 2',
    'building': 'Science Block',
    'lecturerName': 'Dr. Ssemanda Peter',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1fca98af4-1763300295478.png',
    'programmeGroups': ['MBR 1', 'PHA I'],
    'rating': '3.5',
    'ratingValue': 3.5,
    'lecturerSemanticLabel':
        'Professional headshot of Ugandan man in medical scrubs',
  },
  {
    'id': 'te006',
    'courseCode': 'PHM 2401',
    'courseTitle': 'Pharmacology I — Autonomic Drugs',
    'category': 'Pharmacology',
    'sessionType': 'theory',
    'dayOfWeek': 'Wednesday',
    'startTime': '09:00',
    'endTime': '11:00',
    'room': 'LT 2',
    'building': 'Main Block',
    'lecturerName': 'Dr. Nakamya Ruth',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_19469930f-1763299082322.png',
    'programmeGroups': ['MBR 1', 'PHA I'],
    'rating': '4.1',
    'ratingValue': 4.1,
    'lecturerSemanticLabel':
        'Professional headshot of Ugandan woman in white lab coat smiling',
  },
  {
    'id': 'te007',
    'courseCode': 'SUR 3101',
    'courseTitle': 'Surgical Techniques & Ward Rounds',
    'category': 'Surgery',
    'sessionType': 'clinical',
    'dayOfWeek': 'Wednesday',
    'startTime': '13:00',
    'endTime': '16:00',
    'room': 'Ward 5B',
    'building': 'MRRH Teaching Hospital',
    'lecturerName': 'Prof. Kigozi Bernard',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_11103a4a5-1763295121268.png',
    'programmeGroups': ['MBR 1'],
    'rating': '4.8',
    'ratingValue': 4.8,
    'lecturerSemanticLabel':
        'Professional photo of senior Ugandan professor in academic gown',
  },
  {
    'id': 'te008',
    'courseCode': 'COM 1101',
    'courseTitle': 'Communication Skills & Academic Writing',
    'category': 'General Studies',
    'sessionType': 'theory',
    'dayOfWeek': 'Thursday',
    'startTime': '08:00',
    'endTime': '10:00',
    'room': 'LT 4',
    'building': 'Humanities Block',
    'lecturerName': 'Ms. Birungi Sandra',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1bfdb009f-1772186054453.png',
    'programmeGroups': ['MBR 1', 'PHA I', 'BSP I'],
    'rating': '3.2',
    'ratingValue': 3.2,
    'lecturerSemanticLabel':
        'Professional headshot of young Ugandan woman teacher',
  },
  {
    'id': 'te009',
    'courseCode': 'PHY 2204',
    'courseTitle': 'Physiology — Cardiovascular System',
    'category': 'Physiology',
    'sessionType': 'theory',
    'dayOfWeek': 'Friday',
    'startTime': '08:00',
    'endTime': '10:00',
    'room': 'LT 1',
    'building': 'Main Block',
    'lecturerName': 'Dr. Tumusiime Alex',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_18b8a6be9-1769208310897.png',
    'programmeGroups': ['MBR 1'],
    'rating': '4.3',
    'ratingValue': 4.3,
    'lecturerSemanticLabel':
        'Professional headshot of Ugandan male doctor in white coat',
  },
  {
    'id': 'te010',
    'courseCode': 'ANA 2106',
    'courseTitle': 'Histology & Embryology',
    'category': 'Anatomy',
    'sessionType': 'practical',
    'dayOfWeek': 'Friday',
    'startTime': '11:00',
    'endTime': '13:00',
    'room': 'Histology Lab',
    'building': 'Medical School',
    'lecturerName': 'Dr. Atuhaire Grace',
    'lecturerAvatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_19469930f-1763299082322.png',
    'programmeGroups': ['MBR 1', 'BSP I'],
    'rating': '4.0',
    'ratingValue': 4.0,
    'lecturerSemanticLabel':
        'Professional headshot of Ugandan woman scientist in laboratory',
  },
];

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod TimetableNotifier for production
  late List<TimetableEntry> _allEntries;
  int _selectedDayIndex = 0;
  bool _isSyncing = false;
  final bool _isOnline = true;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _fullDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    _allEntries = _timetableEntryMaps.map(TimetableEntry.fromMap).toList();

    // Set current day based on timestamp (2026-08-15 = Saturday index 5)
    _selectedDayIndex = 5;

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
    return _allEntries.where((e) => e.dayOfWeek == day).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
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

  void _onSync() async {
    // TODO: Replace with actual sync via TimetableRepository.fetchRemoteSchedule()
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isSyncing = false);
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

    if (isTablet) {
      return _buildTabletLayout(theme);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _onSync(),
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