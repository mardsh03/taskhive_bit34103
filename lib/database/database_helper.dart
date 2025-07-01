import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // For web, we'll use a dummy database since SQLite doesn't work well on web
      // This is just to maintain compatibility with the existing code
      return await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          // Create minimal tables for compatibility
          await db.execute('CREATE TABLE dummy (id INTEGER PRIMARY KEY)');
        },
      );
    }
    
    // For mobile/desktop platforms
    String path = join(await getDatabasesPath(), 'taskhive.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: _onOpen,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tasks table
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category_id INTEGER,
        priority TEXT DEFAULT 'medium',
        status TEXT DEFAULT 'pending',
        due_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        reminder_time TEXT,
        location TEXT,
        is_completed INTEGER DEFAULT 0
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT DEFAULT '#2196F3',
        icon TEXT DEFAULT 'task',
        created_at TEXT NOT NULL
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE user_preferences(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT,
        updated_at TEXT NOT NULL
      )
    ''');

    // Theme store table
    await db.execute('''
      CREATE TABLE theme_store(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL DEFAULT 0.0,
        image_url TEXT,
        is_purchased INTEGER DEFAULT 0,
        category TEXT DEFAULT 'productivity',
        created_at TEXT NOT NULL
      )
    ''');

    // Insert default categories
    await db.insert('categories', {
      'name': 'Work',
      'color': '#FF5722',
      'icon': 'work',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('categories', {
      'name': 'Study',
      'color': '#2196F3',
      'icon': 'school',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('categories', {
      'name': 'Personal',
      'color': '#4CAF50',
      'icon': 'person',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('categories', {
      'name': 'Health',
      'color': '#E91E63',
      'icon': 'favorite',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Insert default user preferences
    await db.insert('user_preferences', {
      'key': 'notifications_enabled',
      'value': 'true',
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('user_preferences', {
      'key': 'theme_mode',
      'value': 'system',
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Insert sample theme store items
    await db.insert('theme_store', {
      'name': 'Dark Mode Pro',
      'description': 'Premium dark theme for better eye comfort',
      'price': 2.99,
      'image_url': 'assets/images/dark_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Productivity Pack',
      'description': 'Advanced task templates and workflows',
      'price': 4.99,
      'image_url': 'assets/images/productivity_pack.png',
      'category': 'productivity',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Ocean Blue Premium',
      'description': 'Calming ocean-inspired theme with blue gradients',
      'price': 3.99,
      'image_url': 'assets/images/ocean_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Sunset Gold',
      'description': 'Warm golden theme with elegant typography',
      'price': 2.99,
      'image_url': 'assets/images/sunset_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Forest Green',
      'description': 'Nature-inspired theme with organic colors',
      'price': 2.99,
      'image_url': 'assets/images/forest_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Neon Cyber',
      'description': 'Futuristic theme with neon accents',
      'price': 3.99,
      'image_url': 'assets/images/cyber_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Minimalist White',
      'description': 'Clean, minimalist design with white space',
      'price': 1.99,
      'image_url': 'assets/images/minimalist_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Royal Purple',
      'description': 'Luxurious purple theme with gold accents',
      'price': 4.99,
      'image_url': 'assets/images/royal_theme.png',
      'category': 'theme',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Advanced Analytics',
      'description': 'Enhanced analytics and progress tracking',
      'price': 5.99,
      'image_url': 'assets/images/analytics_pack.png',
      'category': 'productivity',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Team Collaboration',
      'description': 'Share tasks and collaborate with team members',
      'price': 6.99,
      'image_url': 'assets/images/collaboration_pack.png',
      'category': 'productivity',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Custom Categories',
      'description': 'Create unlimited custom task categories',
      'price': 2.99,
      'image_url': 'assets/images/custom_categories.png',
      'category': 'productivity',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('theme_store', {
      'name': 'Priority Reminders',
      'description': 'Smart reminder system with priority levels',
      'price': 3.99,
      'image_url': 'assets/images/reminders_pack.png',
      'category': 'productivity',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _onOpen(Database db) async {
    // Ensure all theme store items are present
    await _ensureThemeStoreItems(db);
  }

  Future<void> _ensureThemeStoreItems(Database db) async {
    // Check if we have all the theme store items
    final existingItems = await db.query('theme_store');
    
    // Define all required items
    final requiredItems = [
      {
        'name': 'Dark Mode Pro',
        'description': 'Premium dark theme for better eye comfort',
        'price': 2.99,
        'image_url': 'assets/images/dark_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Productivity Pack',
        'description': 'Advanced task templates and workflows',
        'price': 4.99,
        'image_url': 'assets/images/productivity_pack.png',
        'category': 'productivity',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Ocean Blue Premium',
        'description': 'Calming ocean-inspired theme with blue gradients',
        'price': 3.99,
        'image_url': 'assets/images/ocean_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Sunset Gold',
        'description': 'Warm golden theme with elegant typography',
        'price': 2.99,
        'image_url': 'assets/images/sunset_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Forest Green',
        'description': 'Nature-inspired theme with organic colors',
        'price': 2.99,
        'image_url': 'assets/images/forest_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Neon Cyber',
        'description': 'Futuristic theme with neon accents',
        'price': 3.99,
        'image_url': 'assets/images/cyber_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Minimalist White',
        'description': 'Clean, minimalist design with white space',
        'price': 1.99,
        'image_url': 'assets/images/minimalist_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Royal Purple',
        'description': 'Luxurious purple theme with gold accents',
        'price': 4.99,
        'image_url': 'assets/images/royal_theme.png',
        'category': 'theme',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Advanced Analytics',
        'description': 'Enhanced analytics and progress tracking',
        'price': 5.99,
        'image_url': 'assets/images/analytics_pack.png',
        'category': 'productivity',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Team Collaboration',
        'description': 'Share tasks and collaborate with team members',
        'price': 6.99,
        'image_url': 'assets/images/collaboration_pack.png',
        'category': 'productivity',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Custom Categories',
        'description': 'Create unlimited custom task categories',
        'price': 2.99,
        'image_url': 'assets/images/custom_categories.png',
        'category': 'productivity',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Priority Reminders',
        'description': 'Smart reminder system with priority levels',
        'price': 3.99,
        'image_url': 'assets/images/reminders_pack.png',
        'category': 'productivity',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    // Insert missing items
    for (final item in requiredItems) {
      final existingItem = existingItems.where((existing) => existing['name'] == item['name']).toList();
      if (existingItem.isEmpty) {
        await db.insert('theme_store', item);
        print('Added missing theme store item: ${item['name']}');
      }
    }
  }

  // Task operations
  Future<int> insertTask(Map<String, dynamic> task) async {
    if (kIsWeb) {
      // For web, we'll return a dummy ID since we can't use SQLite
      print('Web platform: Task insertion not supported');
      return 1;
    }
    final db = await database;
    task['created_at'] = DateTime.now().toIso8601String();
    task['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    if (kIsWeb) {
      // For web, return empty list since we can't use SQLite
      print('Web platform: Task retrieval not supported');
      return [];
    }
    final db = await database;
    return await db.query('tasks', orderBy: 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> getTasksByCategory(int categoryId) async {
    if (kIsWeb) {
      // For web, return empty list since we can't use SQLite
      print('Web platform: Task retrieval by category not supported');
      return [];
    }
    final db = await database;
    return await db.query(
      'tasks',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    if (kIsWeb) {
      // For web, return success since we can't use SQLite
      print('Web platform: Task update not supported');
      return 1;
    }
    final db = await database;
    task['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  Future<int> deleteTask(int id) async {
    if (kIsWeb) {
      // For web, return success since we can't use SQLite
      print('Web platform: Task deletion not supported');
      return 1;
    }
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Category operations
  Future<List<Map<String, dynamic>>> getCategories() async {
    if (kIsWeb) {
      // For web, return default categories
      return [
        {
          'id': 1,
          'name': 'Work',
          'color': '#FF5722',
          'icon': 'work',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'name': 'Study',
          'color': '#2196F3',
          'icon': 'school',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 3,
          'name': 'Personal',
          'color': '#4CAF50',
          'icon': 'person',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 4,
          'name': 'Health',
          'color': '#E91E63',
          'icon': 'favorite',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];
    }
    final db = await database;
    return await db.query('categories', orderBy: 'name');
  }

  Future<int> insertCategory(Map<String, dynamic> category) async {
    if (kIsWeb) {
      // For web, return a dummy ID since we can't use SQLite
      print('Web platform: Category insertion not supported');
      return 1;
    }
    final db = await database;
    category['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('categories', category);
  }

  Future<int> deleteCategory(int categoryId) async {
    if (kIsWeb) {
      // For web, return success since we can't use SQLite
      print('Web platform: Category deletion not supported');
      return 1;
    }
    final db = await database;
    
    // First, update all tasks that use this category to have no category
    await db.update(
      'tasks',
      {'category_id': null},
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    
    // Then delete the category
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  // User preferences operations
  Future<String?> getUserPreference(String key) async {
    if (kIsWeb) {
      // For web, return default preferences
      switch (key) {
        case 'notifications_enabled':
          return 'true';
        case 'theme_mode':
          return 'system';
        default:
          return null;
      }
    }
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    return result.isNotEmpty ? result.first['value'] as String? : null;
  }

  Future<int> setUserPreference(String key, String value) async {
    if (kIsWeb) {
      // For web, return success since we can't use SQLite
      print('Web platform: User preference setting not supported');
      return 1;
    }
    final db = await database;
    return await db.insert(
      'user_preferences',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Theme store operations
  Future<List<Map<String, dynamic>>> getThemeStoreItems() async {
    if (kIsWeb) {
      // For web, return default theme store items
      return [
        {
          'id': 1,
          'name': 'Dark Mode Pro',
          'description': 'Premium dark theme for better eye comfort',
          'price': 2.99,
          'image_url': 'assets/images/dark_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'name': 'Productivity Pack',
          'description': 'Advanced task templates and workflows',
          'price': 4.99,
          'image_url': 'assets/images/productivity_pack.png',
          'category': 'productivity',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 3,
          'name': 'Ocean Blue Premium',
          'description': 'Calming ocean-inspired theme with blue gradients',
          'price': 3.99,
          'image_url': 'assets/images/ocean_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 4,
          'name': 'Sunset Gold',
          'description': 'Warm golden theme with elegant typography',
          'price': 2.99,
          'image_url': 'assets/images/sunset_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 5,
          'name': 'Forest Green',
          'description': 'Nature-inspired theme with organic colors',
          'price': 2.99,
          'image_url': 'assets/images/forest_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 6,
          'name': 'Neon Cyber',
          'description': 'Futuristic theme with neon accents',
          'price': 3.99,
          'image_url': 'assets/images/cyber_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 7,
          'name': 'Minimalist White',
          'description': 'Clean, minimalist design with white space',
          'price': 1.99,
          'image_url': 'assets/images/minimalist_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 8,
          'name': 'Royal Purple',
          'description': 'Luxurious purple theme with gold accents',
          'price': 4.99,
          'image_url': 'assets/images/royal_theme.png',
          'category': 'theme',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 9,
          'name': 'Advanced Analytics',
          'description': 'Enhanced analytics and progress tracking',
          'price': 5.99,
          'image_url': 'assets/images/analytics_pack.png',
          'category': 'productivity',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 10,
          'name': 'Team Collaboration',
          'description': 'Share tasks and collaborate with team members',
          'price': 6.99,
          'image_url': 'assets/images/collaboration_pack.png',
          'category': 'productivity',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 11,
          'name': 'Custom Categories',
          'description': 'Create unlimited custom task categories',
          'price': 2.99,
          'image_url': 'assets/images/custom_categories.png',
          'category': 'productivity',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 12,
          'name': 'Priority Reminders',
          'description': 'Smart reminder system with priority levels',
          'price': 3.99,
          'image_url': 'assets/images/reminders_pack.png',
          'category': 'productivity',
          'is_purchased': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
      ];
    }
    final db = await database;
    return await db.query('theme_store', orderBy: 'name');
  }

  Future<int> purchaseTheme(int themeId) async {
    if (kIsWeb) {
      // For web, return success since we can't use SQLite
      print('Web platform: Theme purchase not supported');
      return 1;
    }
    final db = await database;
    return await db.update(
      'theme_store',
      {'is_purchased': 1},
      where: 'id = ?',
      whereArgs: [themeId],
    );
  }

  Future<void> clearAllData() async {
    if (kIsWeb) {
      // For web, just print since we can't use SQLite
      print('Web platform: Data clearing not supported');
      return;
    }
    final db = await database;
    
    // Clear all tables
    await db.delete('tasks');
    await db.delete('categories');
    await db.delete('user_preferences');
    await db.update('theme_store', {'is_purchased': 0});
    
    // Re-insert default data
    await _onCreate(db, 1);
  }
} 