import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/theme_store_item.dart';
import '../utils/theme.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  late TextEditingController _searchController;
  int _purchasingItemId = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchDialog() async {
    _searchController.text = _searchQuery;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Store'),
        content: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter keyword'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _searchController.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _searchQuery = result.trim();
      });
    }
  }

  void _showFilterDialog() async {
    final categories = ['all', 'theme', 'productivity'];
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Filter by Category'),
        children: categories.map((cat) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, cat),
          child: Text(cat[0].toUpperCase() + cat.substring(1)),
        )).toList(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Theme Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Premium Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.getGradientColors('royal'),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.getCardShadow('royal'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Premium Themes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Transform your TaskHive experience with premium themes and productivity packs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Category Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Themes'),
                Tab(text: 'Productivity'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Store Items
          Expanded(
            child: FutureBuilder<List<ThemeStoreItem>>(
              future: taskProvider.getThemeStoreItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load store items',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final items = snapshot.data ?? [];
                final filteredItems = _filterItemsByCategory(items)
                    .where((item) => _searchQuery.isEmpty || item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStoreGrid(filteredItems, theme),
                    _buildStoreGrid(
                      filteredItems.where((item) => item.category == 'theme').toList(),
                      theme,
                    ),
                    _buildStoreGrid(
                      filteredItems.where((item) => item.category == 'productivity').toList(),
                      theme,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ThemeStoreItem> _filterItemsByCategory(List<ThemeStoreItem> items) {
    if (_selectedCategory == 'all') return items;
    return items.where((item) => item.category == _selectedCategory).toList();
  }

  Widget _buildStoreGrid(List<ThemeStoreItem> items, ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildStoreItemCard(item, theme);
      },
    );
  }

  Widget _buildStoreItemCard(ThemeStoreItem item, ThemeData theme) {
    final isPurchased = item.isPurchased == 1 || item.isPurchased == true;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.getCardShadow(theme.brightness == Brightness.dark ? 'dark' : 'default'),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showItemDetails(item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Image/Preview
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: _getItemGradient(item.name),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Item Icon
                      Center(
                        child: Icon(
                          _getItemIcon(item.name),
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      // Purchase Badge
                      if (isPurchased)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'PURCHASED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Item Details
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with flexible height
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Price and Buy button at bottom
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RM${item.price.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isPurchased)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'BUY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getItemGradient(String itemName) {
    if (itemName.contains('Ocean')) return AppTheme.getGradientColors('ocean');
    if (itemName.contains('Sunset')) return AppTheme.getGradientColors('sunset');
    if (itemName.contains('Forest')) return AppTheme.getGradientColors('forest');
    if (itemName.contains('Cyber')) return AppTheme.getGradientColors('cyber');
    if (itemName.contains('Royal')) return AppTheme.getGradientColors('royal');
    if (itemName.contains('Dark')) return [Colors.grey.shade800, Colors.grey.shade900];
    if (itemName.contains('Minimalist')) return [Colors.grey.shade300, Colors.grey.shade400];
    if (itemName.contains('Analytics')) return [Colors.blue.shade600, Colors.blue.shade800];
    if (itemName.contains('Collaboration')) return [Colors.green.shade600, Colors.green.shade800];
    if (itemName.contains('Categories')) return [Colors.orange.shade600, Colors.orange.shade800];
    if (itemName.contains('Reminders')) return [Colors.purple.shade600, Colors.purple.shade800];
    return AppTheme.getGradientColors('default');
  }

  IconData _getItemIcon(String itemName) {
    if (itemName.contains('Ocean')) return Icons.water;
    if (itemName.contains('Sunset')) return Icons.wb_sunny;
    if (itemName.contains('Forest')) return Icons.forest;
    if (itemName.contains('Cyber')) return Icons.terminal;
    if (itemName.contains('Royal')) return Icons.auto_awesome;
    if (itemName.contains('Dark')) return Icons.dark_mode;
    if (itemName.contains('Minimalist')) return Icons.crop_square;
    if (itemName.contains('Analytics')) return Icons.analytics;
    if (itemName.contains('Collaboration')) return Icons.group;
    if (itemName.contains('Categories')) return Icons.category;
    if (itemName.contains('Reminders')) return Icons.notifications;
    if (itemName.contains('Productivity')) return Icons.work;
    return Icons.palette;
  }

  void _showItemDetails(ThemeStoreItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildItemDetailsSheet(item),
    );
  }

  Widget _buildItemDetailsSheet(ThemeStoreItem item) {
    final theme = Theme.of(context);
    final isPurchased = item.isPurchased == 1 || item.isPurchased == true;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Item Preview
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: _getItemGradient(item.name),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  _getItemIcon(item.name),
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Item Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isPurchased)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'PURCHASED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!isPurchased)
                        Text(
                          'RM${item.price.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Features List
                  if (item.category == 'productivity') ...[
                    Text(
                      'Features:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem('Enhanced functionality'),
                    _buildFeatureItem('Premium support'),
                    _buildFeatureItem('Regular updates'),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isPurchased || _purchasingItemId == item.id ? null : () => _purchaseItem(item),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _purchasingItemId == item.id
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(
                              isPurchased ? 'Already Purchased' : 'Purchase Now',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            feature,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _purchaseItem(ThemeStoreItem item) async {
    setState(() => _purchasingItemId = item.id!);
    try {
      await Provider.of<TaskProvider>(context, listen: false).purchaseTheme(item.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} purchased successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _purchasingItemId = -1);
    }
  }
} 