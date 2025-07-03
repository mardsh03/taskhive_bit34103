import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhive/providers/task_provider.dart';
// import 'package:taskhive/models/category.dart';

class CategoryFilter extends StatelessWidget {
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const CategoryFilter({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // All categories option
              _buildCategoryChip(
                context,
                null,
                'All',
                Colors.grey,
                Icons.list,
              ),
              const SizedBox(width: 8),
              // Category chips
              ...taskProvider.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCategoryChip(
                    context,
                    category.id,
                    category.name,
                    _parseColor(category.color),
                    _getCategoryIcon(category.icon),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    int? categoryId,
    String name,
    Color color,
    IconData icon,
  ) {
    final isSelected = selectedCategoryId == categoryId;
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : color,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
              backgroundColor: color.withValues(alpha: 0.1),
      selectedColor: color,
      checkmarkColor: Colors.white,
      onSelected: (_) => onCategorySelected(categoryId),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? color : color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'person':
        return Icons.person;
      case 'favorite':
        return Icons.favorite;
      case 'home':
        return Icons.home;
      case 'shopping_cart':
      case 'shopping':
        return Icons.shopping_cart;
      case 'health_and_safety':
      case 'health':
        return Icons.health_and_safety;
      case 'account_balance_wallet':
      case 'wallet':
      case 'finance':
        return Icons.account_balance_wallet;
      case 'star':
        return Icons.star;
      case 'book':
        return Icons.book;
      case 'music_note':
        return Icons.music_note;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'flight':
        return Icons.flight;
      case 'restaurant':
      case 'food':
        return Icons.restaurant;
      case 'directions_car':
      case 'car':
        return Icons.directions_car;
      case 'task':
        return Icons.task;
      default:
        return Icons.task;
    }
  }
} 