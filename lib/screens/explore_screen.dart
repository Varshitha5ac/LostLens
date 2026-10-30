
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedType = 'All';
  String selectedCategory = 'All';
  String selectedSort = 'Newest';

  bool isGridView = true;

  final List<String> categories = [
    'All',
    'Electronics',
    'Wallets',
    'Bags',
    'Accessories',
    'Keys',
    'Books',
  ];

  // Sample listings for UI demonstration.
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Black Leather Wallet',
      'category': 'Wallets',
      'location': 'Central Library',
      'type': 'Lost',
      'date': '30 Oct 2026',
      'description':
          'A black leather wallet with multiple card slots.',
      'image':
          'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
    },
    {
      'name': 'Wireless Headphones',
      'category': 'Electronics',
      'location': 'College Cafeteria',
      'type': 'Found',
      'date': '29 Oct 2026',
      'description':
          'Black wireless headphones found near the cafeteria.',
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
    },
    {
      'name': 'Blue College Backpack',
      'category': 'Bags',
      'location': 'Block A',
      'type': 'Lost',
      'date': '30 Oct 2026',
      'description':
          'A blue backpack with books and stationery.',
      'image':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
    },
    {
      'name': 'Classic Wrist Watch',
      'category': 'Accessories',
      'location': 'Sports Ground',
      'type': 'Found',
      'date': '28 Oct 2026',
      'description':
          'A classic wrist watch found near the sports ground.',
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
    },
    {
      'name': 'Silver House Keys',
      'category': 'Keys',
      'location': 'Parking Area',
      'type': 'Found',
      'date': '27 Oct 2026',
      'description':
          'A small set of silver keys with a keychain.',
      'image':
          'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600',
    },
    {
      'name': 'Notebook Collection',
      'category': 'Books',
      'location': 'Lecture Hall',
      'type': 'Lost',
      'date': '26 Oct 2026',
      'description':
          'Three notebooks with handwritten study notes.',
      'image':
          'https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=600',
    },
  ];

  // Search, filter and sort listings.
  List<Map<String, dynamic>> get filteredItems {
    final query = searchController.text.toLowerCase().trim();

    final result = items.where((item) {
      final name = item['name'].toString().toLowerCase();
      final description =
          item['description'].toString().toLowerCase();
      final location =
          item['location'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          description.contains(query) ||
          location.contains(query);

      final matchesType =
          selectedType == 'All' || item['type'] == selectedType;

      final matchesCategory = selectedCategory == 'All' ||
          item['category'] == selectedCategory;

      return matchesSearch && matchesType && matchesCategory;
    }).toList();

    // Sort using actual dates instead of alphabetical comparison.
    final dateFormat = DateFormat('dd MMM yyyy');

    result.sort((a, b) {
      final dateA = dateFormat.parse(a['date'].toString());
      final dateB = dateFormat.parse(b['date'].toString());

      if (selectedSort == 'Newest') {
        return dateB.compareTo(dateA);
      }

      return dateA.compareTo(dateB);
    });

    return result;
  }

  void clearFilters() {
    setState(() {
      selectedType = 'All';
      selectedCategory = 'All';
      selectedSort = 'Newest';
      searchController.clear();
    });
  }

  // Sorting bottom sheet.
  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort listings',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to view reported items.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              RadioGroup<String>(
                groupValue: selectedSort,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedSort = value;
                  });

                  Navigator.pop(bottomSheetContext);
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Newest',
                      title: Text('Newest first'),
                      subtitle: Text('Recently reported items first'),
                      activeColor: AppColors.evergreen,
                    ),
                    RadioListTile<String>(
                      value: 'Oldest',
                      title: Text('Oldest first'),
                      subtitle: Text('Earlier reports first'),
                      activeColor: AppColors.evergreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Item details bottom sheet.
  void showItemDetails(Map<String, dynamic> item) {
    final isLost = item['type'] == 'Lost';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    item['image'].toString(),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 220,
                      width: double.infinity,
                      color: AppColors.paper,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                _statusBadge(isLost),

                const SizedBox(height: 12),

                Text(
                  item['name'].toString(),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  item['description'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),

                const SizedBox(height: 18),

                _detailRow(
                  Icons.category_outlined,
                  'Category',
                  item['category'].toString(),
                ),

                _detailRow(
                  Icons.location_on_outlined,
                  'Location',
                  item['location'].toString(),
                ),

                _detailRow(
                  Icons.calendar_today_outlined,
                  'Reported',
                  item['date'].toString(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Claim requests are UI demonstrations only.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.handshake_outlined),
                    label: const Text('Submit a Claim Request'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.evergreen,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Main Explore screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildHeader(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildSearch(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildTypeFilters(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildCategories(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
              sliver: SliverToBoxAdapter(
                child: _buildResultsHeader(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final extent = constraints.crossAxisExtent;

                  final crossAxisCount = extent >= 1000
                      ? 4
                      : extent >= 650
                          ? 3
                          : 2;

                  if (filteredItems.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _emptyState(),
                    );
                  }

                  if (!isGridView) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filteredItems[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildListCard(item),
                          );
                        },
                        childCount: filteredItems.length,
                      ),
                    );
                  }

                  final aspectRatio = extent >= 1000
                      ? 0.88
                      : extent >= 650
                          ? 0.78
                          : 0.68;

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildGridCard(filteredItems[index]);
                      },
                      childCount: filteredItems.length,
                    ),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 16,
                      childAspectRatio: aspectRatio,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page heading.
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DISCOVER YOUR COMMUNITY',
                style: TextStyle(
                  letterSpacing: 1.5,
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore Items',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  color: AppColors.evergreen,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Discover what people have lost or found.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            onPressed: clearFilters,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.evergreen,
            ),
            tooltip: 'Clear filters',
          ),
        ),
      ],
    );
  }

  // Search field and sort button.
  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.evergreen,
                ),
                hintText: 'Search items or locations...',
                border: InputBorder.none,
                filled: false,
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.evergreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: showSortOptions,
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColors.white,
            ),
            tooltip: 'Sort items',
          ),
        ),
      ],
    );
  }

  // Lost and Found filters.
  Widget _buildTypeFilters() {
    const types = ['All', 'Lost', 'Found'];

    return Row(
      children: types.map((type) {
        final isSelected = selectedType == type;

        return Padding(
          padding: const EdgeInsets.only(right: 9),
          child: ChoiceChip(
            label: Text(type == 'All' ? 'All Items' : type),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              setState(() {
                selectedType = type;
              });
            },
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.evergreen,
            side: BorderSide(
              color: isSelected
                  ? AppColors.evergreen
                  : AppColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelStyle: TextStyle(
              color: isSelected
                  ? AppColors.white
                  : AppColors.charcoal,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Horizontally scrollable category filters.
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 11),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = selectedCategory == category;

              return ChoiceChip(
                label: Text(category),
                selected: selected,
                showCheckmark: false,
                backgroundColor: AppColors.surface,
                selectedColor:
                    AppColors.sage.withValues(alpha: 0.4),
                onSelected: (_) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                side: BorderSide(
                  color: selected
                      ? AppColors.evergreen
                      : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 12,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Results count and layout controls.
  Widget _buildResultsHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${filteredItems.length} items found',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Sorted by $selectedSort',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Grid view',
          onPressed: () {
            setState(() {
              isGridView = true;
            });
          },
          icon: Icon(
            Icons.grid_view_rounded,
            color: isGridView
                ? AppColors.evergreen
                : AppColors.muted,
          ),
        ),
        IconButton(
          tooltip: 'List view',
          onPressed: () {
            setState(() {
              isGridView = false;
            });
          },
          icon: Icon(
            Icons.view_list_rounded,
            color: !isGridView
                ? AppColors.evergreen
                : AppColors.muted,
          ),
        ),
      ],
    );
  }

  // Empty search result state.
  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.sage,
          ),
          SizedBox(height: 12),
          Text(
            'No items found',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: AppColors.charcoal,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try changing your search or filters.',
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

  // Grid listing card.
  Widget _buildGridCard(Map<String, dynamic> item) {
    final isLost = item['type'] == 'Lost';

    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: () => showItemDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(13),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(item, double.infinity),
                  Positioned(
                    top: 9,
                    left: 9,
                    child: _statusBadge(isLost),
                  ),
                  Positioned(
                    bottom: 9,
                    right: 9,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLost
                            ? Icons.search
                            : Icons.check_circle_outline,
                        size: 15,
                        color: AppColors.evergreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Improved archive-style card information.
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['category'].toString().toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['name'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _locationText(item['location'].toString()),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item['date'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Horizontal listing card.
  Widget _buildListCard(Map<String, dynamic> item) {
    final isLost = item['type'] == 'Lost';

    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: () => showItemDetails(item),
      child: Container(
        height: 124,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                width: 96,
                height: double.infinity,
                child: _buildImage(item, 96),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statusBadge(isLost),
                  const SizedBox(height: 7),
                  Text(
                    item['name'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['category'].toString(),
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _locationText(item['location'].toString()),
                  const SizedBox(height: 4),
                  Text(
                    item['date'].toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }

  // Image with fallback and loading placeholder.
  Widget _buildImage(
    Map<String, dynamic> item,
    double width,
  ) {
    return Image.network(
      item['image'].toString(),
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          color: AppColors.paper,
          alignment: Alignment.center,
          child: const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.evergreen,
            ),
          ),
        );
      },
      errorBuilder: (_, _, _) => Container(
        color: AppColors.paper,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 38,
          color: AppColors.muted,
        ),
      ),
    );
  }

  // Lost / Found status tag.
  Widget _statusBadge(bool isLost) {
    final color = isLost ? AppColors.coral : AppColors.evergreen;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        isLost ? 'LOST' : 'FOUND',
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Location label.
  Widget _locationText(String location) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 13,
          color: AppColors.muted,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
