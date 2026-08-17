import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? branchIndex;

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Timetable',
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Notes',
      icon: Icons.note_outlined,
      selectedIcon: Icons.note_rounded,
      branchIndex: null, // stub tab
    ),
    _TabSpec(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      branchIndex: 1,
    ),
  ];

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub — silent ignore
    setState(() => _selectedVisualIndex = visualIndex);
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync visual index with shell's current branch
    final currentBranch = widget.navigationShell.currentIndex;
    final matchingVisual = _tabs.indexWhere(
      (t) => t.branchIndex == currentBranch,
    );
    if (matchingVisual != -1 && matchingVisual != _selectedVisualIndex) {
      setState(() => _selectedVisualIndex = matchingVisual);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationBar(
      selectedIndex: _selectedVisualIndex,
      onDestinationSelected: _onTabTap,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primaryContainer,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      destinations: List.generate(_tabs.length, (i) {
        final tab = _tabs[i];
        final isStub = tab.branchIndex == null;
        return NavigationDestination(
          icon: Opacity(opacity: isStub ? 0.4 : 1.0, child: Icon(tab.icon)),
          selectedIcon: Opacity(
            opacity: isStub ? 0.4 : 1.0,
            child: Icon(tab.selectedIcon),
          ),
          label: tab.label,
        );
      }),
    );
  }
}
