import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhive/models/category.dart';
import 'package:taskhive/providers/task_provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedColor = '#2196F3';
  String _selectedIcon = 'task';

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Blue', 'color': '#2196F3'},
    {'name': 'Green', 'color': '#4CAF50'},
    {'name': 'Red', 'color': '#F44336'},
    {'name': 'Orange', 'color': '#FF9800'},
    {'name': 'Purple', 'color': '#9C27B0'},
    {'name': 'Pink', 'color': '#E91E63'},
    {'name': 'Teal', 'color': '#009688'},
    {'name': 'Indigo', 'color': '#3F51B5'},
    {'name': 'Brown', 'color': '#795548'},
    {'name': 'Grey', 'color': '#607D8B'},
  ];

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'Task', 'icon': 'task'},
    {'name': 'Work', 'icon': 'work'},
    {'name': 'School', 'icon': 'school'},
    {'name': 'Person', 'icon': 'person'},
    {'name': 'Heart', 'icon': 'favorite'},
    {'name': 'Home', 'icon': 'home'},
    {'name': 'Shopping', 'icon': 'shopping_cart'},
    {'name': 'Health', 'icon': 'health_and_safety'},
    {'name': 'Wallet', 'icon': 'account_balance_wallet'},
    {'name': 'Star', 'icon': 'star'},
    {'name': 'Book', 'icon': 'book'},
    {'name': 'Music', 'icon': 'music_note'},
    {'name': 'Sports', 'icon': 'sports_soccer'},
    {'name': 'Travel', 'icon': 'flight'},
    {'name': 'Food', 'icon': 'restaurant'},
    {'name': 'Car', 'icon': 'directions_car'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Color Selection
            Text(
              'Choose Color',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((colorOption) {
                final isSelected = _selectedColor == colorOption['color'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorOption['color'];
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _parseColor(colorOption['color']),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Icon Selection
            Text(
              'Choose Icon',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _iconOptions.length,
              itemBuilder: (context, index) {
                final iconOption = _iconOptions[index];
                final isSelected = _selectedIcon == iconOption['icon'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = iconOption['icon'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? _parseColor(_selectedColor).withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? _parseColor(_selectedColor)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _getIconData(iconOption['icon']),
                      color: isSelected 
                          ? _parseColor(_selectedColor)
                          : Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      
      final category = Category(
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
        createdAt: DateTime.now(),
      );

      taskProvider.addCategory(category);
      Navigator.pop(context);
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIconData(String iconName) {
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
        return Icons.shopping_cart;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'account_balance_wallet':
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
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      default:
        return Icons.task;
    }
  }
} 