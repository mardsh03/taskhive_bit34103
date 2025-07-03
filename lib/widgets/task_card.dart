import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskhive/models/task.dart';
import 'package:taskhive/models/category.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Category? category;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.category,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPriorityColor() {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor() {
    if (category != null) {
      try {
        return Color(int.parse(category!.color.replaceAll('#', '0xFF')));
      } catch (e) {
        return Colors.blue;
      }
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Checkbox
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => onToggle(),
                    activeColor: _getCategoryColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: task.isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : null,
                                color: task.isCompleted 
                                    ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                                    : null,
                              ),
                            ),
                          ),
                          // Priority indicator
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            decoration: task.isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Category chip
                          if (category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor().withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getCategoryColor().withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(category!.icon),
                                    size: 14,
                                    color: _getCategoryColor(),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    category!.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getCategoryColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 8),
                          // Due date
                          if (task.dueDate != null) ...[
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy').format(task.dueDate!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Reminder icon
                          if (task.reminderTime != null)
                            Icon(
                              Icons.notifications,
                              size: 16,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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