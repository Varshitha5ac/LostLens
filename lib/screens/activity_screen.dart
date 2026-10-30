
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> activities = [
    {
      'title': 'Match found!',
      'description':
          'A black wallet reported near the Library may match your report.',
      'time': '10 minutes ago',
      'date': 'TODAY',
      'type': 'Updates',
      'status': 'New match',
      'icon': Icons.auto_awesome_rounded,
      'color': AppColors.highlight,
    },
    {
      'title': 'Report submitted',
      'description':
          'Your report for a missing Blue Water Bottle was submitted.',
      'time': '2 hours ago',
      'date': 'TODAY',
      'type': 'Reports',
      'status': 'Under review',
      'icon': Icons.assignment_outlined,
      'color': AppColors.coral,
    },
    {
      'title': 'Claim request received',
      'description':
          'Someone has submitted a claim for your Found item.',
      'time': 'Yesterday, 4:30 PM',
      'date': 'YESTERDAY',
      'type': 'Updates',
      'status': 'Pending',
      'icon': Icons.mark_email_unread_outlined,
      'color': AppColors.marigold,
    },
    {
      'title': 'Item returned',
      'description':
          'Your ID Card has been successfully marked as returned.',
      'time': 'Yesterday, 11:15 AM',
      'date': 'YESTERDAY',
      'type': 'Reports',
      'status': 'Completed',
      'icon': Icons.check_circle_outline_rounded,
      'color': AppColors.sage,
    },
  ];

  List<Map<String, dynamic>> get filteredActivities {
    if (selectedFilter == 'All') return activities;

    return activities
        .where((activity) => activity['type'] == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YOUR UPDATES',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Activity',
                        style: TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.evergreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Activity summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.evergreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR IMPACT SO FAR',
                      style: TextStyle(
                        color: AppColors.sage,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _summaryItem('04', 'Reports'),
                        ),
                        Container(
                          height: 38,
                          width: 1,
                          color: Colors.white24,
                        ),
                        Expanded(
                          child: _summaryItem('02', 'Updates'),
                        ),
                        Container(
                          height: 38,
                          width: 1,
                          color: Colors.white24,
                        ),
                        Expanded(
                          child: _summaryItem('01', 'Returned'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Every report brings a lost item closer to home.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Section title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent activity',
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${filteredActivities.length} updates',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Filters
              Row(
                children: ['All', 'Reports', 'Updates'].map((filter) {
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: AppColors.evergreen,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.evergreen
                            : AppColors.border,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.charcoal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // Activity list
              if (filteredActivities.isEmpty)
                _emptyState()
              else
                ...filteredActivities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final activity = entry.value;
                  final showDate = index == 0 ||
                      filteredActivities[index - 1]['date'] !=
                          activity['date'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDate) ...[
                        Text(
                          activity['date'],
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _activityCard(activity),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _activityCard(Map<String, dynamic> activity) {
    final Color activityColor = activity['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  color: activityColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: AppColors.evergreen,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: const TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      activity['description'] as String,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    activity['time'] as String,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: activityColor.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  activity['status'] as String,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 42,
            color: AppColors.sage,
          ),
          SizedBox(height: 12),
          Text(
            'Nothing to show yet',
            style: TextStyle(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your activity will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
