import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/task_provider.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;
  const EditCategoryScreen({super.key, required this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _nameController;
  late String _selectedColor;
  late String _selectedIcon;

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
  final List<Map<String, dynamic>> _colorOptions = [
    {'color': '#2196F3'},
    {'color': '#4CAF50'},
    {'color': '#FF9800'},
    {'color': '#E91E63'},
    {'color': '#9C27B0'},
    {'color': '#F44336'},
    {'color': '#00BCD4'},
    {'color': '#FFC107'},
    {'color': '#607D8B'},
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _selectedColor = widget.category.color;
    _selectedIcon = widget.category.icon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
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
            Text(
              'Choose Color',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose Icon',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: GridView.builder(
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
                            ? _parseColor(_selectedColor).withOpacity(0.2)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _parseColor(_selectedColor) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getIconData(iconOption['icon']),
                        color: isSelected ? _parseColor(_selectedColor) : theme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCategory,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      final updatedCategory = widget.category.copyWith(
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
      );
      await taskProvider.updateCategory(updatedCategory);
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