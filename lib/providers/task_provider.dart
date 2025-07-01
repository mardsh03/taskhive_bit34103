import 'package:flutter/foundation.dart' as foundation;
import 'package:taskhive/database/database_helper.dart';
import 'package:taskhive/models/task.dart';
import 'package:taskhive/models/category.dart';
import 'package:taskhive/services/notification_service.dart';
import 'package:taskhive/models/theme_store_item.dart';

class TaskProvider with foundation.ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  
  List<Task> _tasks = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final taskMaps = await _databaseHelper.getTasks();
      _tasks = taskMaps.map((map) => Task.fromMap(map)).toList();
    } catch (e) {
      foundation.debugPrint('Error loading tasks: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      final categoryMaps = await _databaseHelper.getCategories();
      _categories = categoryMaps.map((map) => Category.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error loading categories: $e');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final id = await _databaseHelper.insertTask(task.toMap());
      final newTask = task.copyWith(id: id);
      _tasks.insert(0, newTask);
      
      // Schedule notification if reminder time is set
      if (task.reminderTime != null) {
        await _notificationService.scheduleTaskReminder(
          id: id,
          title: 'Task Reminder',
          body: task.title,
          scheduledDate: task.reminderTime!,
        );
      }
      
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _databaseHelper.updateTask(task.toMap());
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        
        // Update notification if reminder time changed
        if (task.reminderTime != null) {
          await _notificationService.cancelNotification(task.id!);
          await _notificationService.scheduleTaskReminder(
            id: task.id!,
            title: 'Task Reminder',
            body: task.title,
            scheduledDate: task.reminderTime!,
          );
        }
        
        notifyListeners();
      }
    } catch (e) {
      foundation.debugPrint('Error updating task: $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _databaseHelper.deleteTask(taskId);
      await _notificationService.cancelNotification(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskCompletion(int taskId) async {
    try {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        status: !task.isCompleted ? 'completed' : 'pending',
      );
      await updateTask(updatedTask);
    } catch (e) {
      foundation.debugPrint('Error toggling task completion: $e');
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      final id = await _databaseHelper.insertCategory(category.toMap());
      final newCategory = category.copyWith(id: id);
      _categories.add(newCategory);
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error adding category: $e');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      await _databaseHelper.deleteCategory(categoryId);
      _categories.removeWhere((category) => category.id == categoryId);
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error deleting category: $e');
    }
  }

  List<Task> getTasksByCategory(int categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }

  Category? getCategoryById(int? categoryId) {
    if (categoryId == null) return null;
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  Future<List<ThemeStoreItem>> getThemeStoreItems() async {
    try {
      final items = await _databaseHelper.getThemeStoreItems();
      return items.map((map) => ThemeStoreItem.fromMap(map)).toList();
    } catch (e) {
      foundation.debugPrint('Error getting theme store items: $e');
      return [];
    }
  }

  Future<void> purchaseTheme(int themeId) async {
    try {
      await _databaseHelper.purchaseTheme(themeId);
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error purchasing theme: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      await _databaseHelper.clearAllData();
      // Reload data after clearing
      await loadTasks();
      await loadCategories();
      notifyListeners();
    } catch (e) {
      foundation.debugPrint('Error clearing data: $e');
    }
  }
} 