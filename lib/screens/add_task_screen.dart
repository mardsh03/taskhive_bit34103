import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhive/providers/task_provider.dart';
import 'package:taskhive/models/task.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _priority = 'medium';
  int? _selectedCategoryId;
  DateTime? _dueDate;
  DateTime? _reminderTime;
  late TextEditingController _locationController;
  LatLng? _pickedLatLng;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.task?.location ?? '');
    if (widget.task?.location != null && widget.task!.location!.contains(',')) {
      final parts = widget.task!.location!.split(',');
      if (parts.length == 2) {
        _pickedLatLng = LatLng(double.tryParse(parts[0]) ?? 0, double.tryParse(parts[1]) ?? 0);
      }
    }
    if (isEditing) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _priority = widget.task!.priority;
      _selectedCategoryId = widget.task!.categoryId;
      _dueDate = widget.task!.dueDate;
      _reminderTime = widget.task!.reminderTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteTask,
              tooltip: 'Delete Task',
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _saveTask,
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('No Category'),
                    ),
                    ...taskProvider.categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category.icon),
                              color: _parseColor(category.color),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Due Date'),
              subtitle: Text(
                _dueDate != null 
                    ? DateFormat('MMM dd, yyyy').format(_dueDate!)
                    : 'No due date set',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_dueDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _dueDate = null;
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDueDate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Reminder'),
              subtitle: Text(
                _reminderTime != null 
                    ? DateFormat('MMM dd, yyyy HH:mm').format(_reminderTime!)
                    : 'No reminder set',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_reminderTime != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _reminderTime = null;
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectReminderTime,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (Optional)',
                hintText: 'Enter task location or pick from map',
                prefixIcon: Icon(Icons.location_on),
                suffixIcon: Icon(Icons.map),
              ),
              readOnly: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPickerScreen(initialLocation: _pickedLatLng),
                  ),
                );
                if (result != null && result is LatLng) {
                  setState(() {
                    _pickedLatLng = result;
                    _locationController.text = '${result.latitude},${result.longitude}';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _selectReminderTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _reminderTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      
      final task = Task(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        categoryId: _selectedCategoryId,
        priority: _priority,
        status: widget.task?.status ?? 'pending',
        dueDate: _dueDate,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        reminderTime: _reminderTime,
        location: _locationController.text,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      if (isEditing) {
        taskProvider.updateTask(task);
      } else {
        taskProvider.addTask(task);
      }

      Navigator.pop(context);
    }
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final taskProvider = context.read<TaskProvider>();
                taskProvider.deleteTask(widget.task!.id!);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.health_and_safety;
      case 'finance':
        return Icons.account_balance_wallet;
      default:
        return Icons.task;
    }
  }
}

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  const MapPickerScreen({Key? key, this.initialLocation}) : super(key: key);

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation ?? const LatLng(3.139, 101.6869); // Default: Kuala Lumpur
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() { _isSearching = true; });
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final latLng = LatLng(loc.latitude, loc.longitude);
        setState(() {
          _pickedLocation = latLng;
        });
        _mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() { _isSearching = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search location',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),
                IconButton(
                  icon: _isSearching ? const CircularProgressIndicator() : const Icon(Icons.arrow_forward),
                  onPressed: _isSearching ? null : _searchLocation,
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pickedLocation!,
                zoom: 15,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: _onMapTap,
              markers: _pickedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('picked'),
                        position: _pickedLocation!,
                      ),
                    }
                  : {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_pickedLocation != null) {
            Navigator.pop(context, _pickedLocation);
          }
        },
        label: const Text('Select'),
        icon: const Icon(Icons.check),
      ),
    );
  }
} 