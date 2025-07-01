import 'package:flutter/material.dart';
import 'package:taskhive/screens/add_task_screen.dart';
import 'package:taskhive/screens/add_category_screen.dart';

class TaskFAB extends StatefulWidget {
  const TaskFAB({super.key});

  @override
  State<TaskFAB> createState() => _TaskFABState();
}

class _TaskFABState extends State<TaskFAB> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      _showAddOptions();
    });
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Add Task'),
              subtitle: const Text('Create a new task'),
              onTap: () {
                Navigator.pop(context);
                _addTask();
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Add Category'),
              subtitle: const Text('Create a new category'),
              onTap: () {
                Navigator.pop(context);
                _addCategory();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );
  }

  void _addCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCategoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _onPressed,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add, size: 24),
        label: const Text('Add'),
      ),
    );
  }
} 