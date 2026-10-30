
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;
  String searchQuery = '';

  final List<String> categories = [
    'All',
    'Electronics',
    'Wallets',
    'Bags',
    'Keys',
    'Accessories',
  ];

  final List<Map<String, dynamic>> items = [
    {
      'name': 'Black Leather Wallet',
      'category': 'Wallets',
      'location': 'Central Library',
      'type': 'Lost',
      'date': 'Today',
      'image': 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'name': 'Wireless Headphones',
      'category': 'Electronics',
      'location': 'Cafeteria',
      'type': 'Found',
      'date': 'Yesterday',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
      'icon': Icons.headphones_outlined,
    },
    {
      'name': 'Blue College Backpack',
      'category': 'Bags',
      'location': 'Block A',
      'type': 'Lost',
      'date': 'Today',
      'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      'icon': Icons.backpack_outlined,
    },
    {
      'name': 'Classic Wrist Watch',
      'category': 'Accessories',
      'location': 'Sports Ground',
      'type': 'Found',
      'date': 'Yesterday',
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
      'icon': Icons.watch_outlined,
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    return items.where((item) {
      final matchesSearch = item['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesCategory = selectedCategory == 0 ||
          item['category'] == categories[selectedCategory];

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void showReportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What would you like to report?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _reportOption(
                icon: Icons.search,
                title: 'I Lost Something',
                subtitle: 'Report a missing belonging',
                color: AppColors.accent,
              ),
              const SizedBox(height: 12),
              _reportOption(
                icon: Icons.volunteer_activism_outlined,
                title: 'I Found Something',
                subtitle: 'Help someone recover their item',
                color: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _reportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
  final type = title == 'I Lost Something' ? 'Lost' : 'Found';

  Navigator.pop(context);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ReportScreen(initialType: type),
    ),
  );
},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

final gridColumns = screenWidth >= 900
    ? 4
    : screenWidth >= 600
        ? 3
        : 2;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildHeader(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildReportActions(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildCategories(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              sliver: filteredItems.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            'No matching items found.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildItemCard(filteredItems[index]);
                        },
                        childCount: filteredItems.length,
                      ),
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumns ,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 18,
                        childAspectRatio: screenWidth >= 600 ? 0.78 : 0.67,
                      ),
                    ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverToBoxAdapter(
                child: _buildMatchingBanner(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: showReportOptions,
  backgroundColor: AppColors.accent,
  foregroundColor: AppColors.textPrimary,
  elevation: 2,
  child: const Icon(Icons.add, size: 28),
),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LOSTLENS  /  CAMPUS COMMUNITY',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Lost something?\nLet’s find it.',
                style: TextStyle(
                  fontSize: 27,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'A little help can bring things back.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon.')),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() => searchQuery = value);
        },
        decoration: const InputDecoration(
          hintText: 'Search wallets, bags, electronics...',
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primary,
          ),
          border: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildReportActions() {
    return Row(
      children: [
        Expanded(
          child: _reportAction(
            title: 'I Lost It',
            subtitle: 'Find my belonging',
            icon: Icons.search_rounded,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _reportAction(
            title: 'I Found It',
            subtitle: 'Help someone',
            icon: Icons.favorite_border_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _reportAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
  final type = title == 'I Lost It' ? 'Lost' : 'Found';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ReportScreen(initialType: type),
    ),
  );
},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.white, size: 25),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse categories',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final isSelected = selectedCategory == index;

              return ChoiceChip(
                label: Text(categories[index]),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => selectedCategory = index);
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                showCheckmark: false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recently reported',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedCategory = 0;
              searchQuery = '';
            });
          },
          child: const Text('Clear filters'),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final isLost = item['type'] == 'Lost';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isLost
                          ? AppColors.accent
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      item['type'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        item['location'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item['date'],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMART MATCHING',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your lost item might be here.',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Explore similar items reported by others.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.auto_awesome,
            size: 42,
            color: AppColors.highlight,
          ),
        ],
      ),
    );
  }
}
