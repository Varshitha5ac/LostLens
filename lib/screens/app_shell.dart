
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'report_screen.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  // Opens Lost / Found reporting options.
  void showReportOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What happened?',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose what you want to report.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),

              // Lost item option.
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: AppColors.coral,
                    size: 25,
                  ),
                ),
                title: const Text(
                  'I Lost Something',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: const Text(
                  'Report an item you cannot find',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.muted,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportScreen(
                        initialType: 'Lost',
                      ),
                    ),
                  );
                },
              ),

              const Divider(
                color: AppColors.divider,
                indent: 55,
              ),

              // Found item option.
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.sage.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.evergreen,
                    size: 25,
                  ),
                ),
                title: const Text(
                  'I Found Something',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: const Text(
                  'Help someone recover their item',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.muted,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportScreen(
                        initialType: 'Found',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Individual bottom navigation item.
  Widget _navItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: 23,
                color: isSelected
                    ? AppColors.evergreen
                    : AppColors.muted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: isSelected
                      ? AppColors.evergreen
                      : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const ActivityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.paper,

      // Keeps screen state when switching tabs.
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      // Custom navigation with centre FAB space.
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _navItem(
              index: 0,
              label: 'Home',
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
            ),

            _navItem(
              index: 1,
              label: 'Explore',
              icon: Icons.explore_outlined,
              selectedIcon: Icons.explore_rounded,
            ),

            // Space for the centre floating button.
            const SizedBox(width: 52),

            _navItem(
              index: 2,
              label: 'Activity',
              icon: Icons.notifications_none_rounded,
              selectedIcon: Icons.notifications_rounded,
            ),

            _navItem(
              index: 3,
              label: 'Profile',
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
            ),
          ],
        ),
      ),

      // Central report button.
      floatingActionButton: FloatingActionButton(
        onPressed: showReportOptions,
        tooltip: 'Report an item',
        backgroundColor: AppColors.coral,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          size: 31,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}
