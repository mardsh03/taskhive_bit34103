class Task {
  final int? id;
  final String title;
  final String? description;
  final int? categoryId;
  final String priority;
  final String status;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminderTime;
  final String? location;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    this.categoryId,
    this.priority = 'medium',
    this.status = 'pending',
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.reminderTime,
    this.location,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'priority': priority,
      'status': status,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'reminder_time': reminderTime?.toIso8601String(),
      'location': location,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      categoryId: map['category_id'],
      priority: map['priority'] ?? 'medium',
      status: map['status'] ?? 'pending',
      dueDate: map['due_date'] != null 
          ? DateTime.parse(map['due_date']) 
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      reminderTime: map['reminder_time'] != null 
          ? DateTime.parse(map['reminder_time']) 
          : null,
      location: map['location'],
      isCompleted: map['is_completed'] == 1,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? categoryId,
    String? priority,
    String? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reminderTime,
    String? location,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderTime: reminderTime ?? this.reminderTime,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
} 