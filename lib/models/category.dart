class Category {
  final int? id;
  final String name;
  final String color;
  final String icon;
  final DateTime createdAt;

  Category({
    this.id,
    required this.name,
    this.color = '#2196F3',
    this.icon = 'task',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'] ?? '#2196F3',
      icon: map['icon'] ?? 'task',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Category copyWith({
    int? id,
    String? name,
    String? color,
    String? icon,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 