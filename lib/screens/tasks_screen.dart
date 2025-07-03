import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhive/providers/task_provider.dart';
import 'package:taskhive/models/task.dart';
import 'package:taskhive/widgets/task_card.dart';
import 'package:taskhive/widgets/category_filter.dart';
import 'package:taskhive/screens/add_task_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

class TasksScreen extends StatefulWidget {
  final int initialTab;
  final bool showAll;
  const TasksScreen({super.key, this.initialTab = 0, this.showAll = false});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedCategoryId;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskHive',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
        bottom: widget.showAll ? null : TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          CategoryFilter(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId;
              });
            },
          ),
          Expanded(
            child: widget.showAll
                ? _buildAllTasksList()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(false), // Pending tasks
                      _buildTaskList(true),  // Completed tasks
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );
          setState(() {}); // Refresh after adding
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }

  Widget _buildAllTasksList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Task> tasks = taskProvider.tasks;
        if (_selectedCategoryId != null) {
          tasks = tasks.where((task) => task.categoryId == _selectedCategoryId).toList();
        }
        if (tasks.isEmpty) {
          return Center(child: Text('No tasks found'));
        }
        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final category = taskProvider.getCategoryById(task.categoryId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskCard(
                    task: task,
                    category: category,
                    onTap: () => _editTask(task),
                    onToggle: () async {
                      taskProvider.toggleTaskCompletion(task.id!);
                      if (task.isCompleted == false) {
                        _confettiController.play();
                        await _audioPlayer.play(AssetSource('audio/success.mp3'));
                      }
                    },
                    onDelete: () => _deleteTask(task),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.amber],
                numberOfParticles: 30,
                maxBlastForce: 20,
                minBlastForce: 8,
                emissionFrequency: 0.05,
                gravity: 0.2,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskList(bool showCompleted) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Task> tasks = showCompleted 
            ? taskProvider.completedTasks 
            : taskProvider.pendingTasks;

        if (_selectedCategoryId != null) {
          tasks = tasks.where((task) => task.categoryId == _selectedCategoryId).toList();
        }

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showCompleted ? Icons.task_alt : Icons.task_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  showCompleted ? 'No completed tasks yet' : 'No pending tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  showCompleted 
                      ? 'Complete some tasks to see them here'
                      : 'Add a new task to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final category = taskProvider.getCategoryById(task.categoryId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskCard(
                    task: task,
                    category: category,
                    onTap: () => _editTask(task),
                    onToggle: () async {
                      taskProvider.toggleTaskCompletion(task.id!);
                      if (task.isCompleted == false) {
                        _confettiController.play();
                        await _audioPlayer.play(AssetSource('audio/success.mp3'));
                      }
                    },
                    onDelete: () => _deleteTask(task),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.amber],
                numberOfParticles: 30,
                maxBlastForce: 20,
                minBlastForce: 8,
                emissionFrequency: 0.05,
                gravity: 0.2,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );
    setState(() {}); // Refresh after returning
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 