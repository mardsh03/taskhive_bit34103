class ThemeStoreItem {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isPurchased;
  final String category;
  final DateTime createdAt;

  ThemeStoreItem({
    this.id,
    required this.name,
    required this.description,
    this.price = 0.0,
    this.imageUrl,
    this.isPurchased = false,
    this.category = 'productivity',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'is_purchased': isPurchased ? 1 : 0,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ThemeStoreItem.fromMap(Map<String, dynamic> map) {
    return ThemeStoreItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['image_url'],
      isPurchased: map['is_purchased'] == 1,
      category: map['category'] ?? 'productivity',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  ThemeStoreItem copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isPurchased,
    String? category,
    DateTime? createdAt,
  }) {
    return ThemeStoreItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isPurchased: isPurchased ?? this.isPurchased,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 