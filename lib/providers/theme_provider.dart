import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme = 'default';
  final List<String> _availableThemes = [
    'default',
    'dark',
    'ocean',
    'sunset',
    'forest',
    'cyber',
    'minimalist',
    'royal',
    'analytics',
    'collaboration',
    'categories',
    'reminders',
  ];

  String get currentTheme => _currentTheme;
  List<String> get availableThemes => _availableThemes;
  ThemeData get theme => AppTheme.getTheme(_currentTheme);

  void setTheme(String themeName) {
    if (_availableThemes.contains(themeName)) {
      _currentTheme = themeName;
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    if (_currentTheme == 'dark') {
      setTheme('default');
    } else {
      setTheme('dark');
    }
  }

  bool get isDarkMode => _currentTheme == 'dark' || _currentTheme == 'cyber';

  String getThemeDisplayName(String themeName) {
    switch (themeName) {
      case 'default':
        return 'Classic Blue';
      case 'dark':
        return 'Dark Mode Pro';
      case 'ocean':
        return 'Ocean Blue Premium';
      case 'sunset':
        return 'Sunset Gold';
      case 'forest':
        return 'Forest Green';
      case 'cyber':
        return 'Neon Cyber';
      case 'minimalist':
        return 'Minimalist White';
      case 'royal':
        return 'Royal Purple';
      case 'analytics':
        return 'Advanced Analytics';
      case 'collaboration':
        return 'Team Collaboration';
      case 'categories':
        return 'Custom Categories';
      case 'reminders':
        return 'Priority Reminders';
      default:
        return themeName;
    }
  }

  String getThemeDescription(String themeName) {
    switch (themeName) {
      case 'default':
        return 'Clean and professional blue theme';
      case 'dark':
        return 'Premium dark theme for better eye comfort';
      case 'ocean':
        return 'Calming ocean-inspired colors';
      case 'sunset':
        return 'Warm and inviting golden tones';
      case 'forest':
        return 'Nature-inspired green palette';
      case 'cyber':
        return 'Futuristic neon aesthetics';
      case 'minimalist':
        return 'Clean and simple design';
      case 'royal':
        return 'Luxurious purple and gold';
      case 'analytics':
        return 'Enhanced analytics and progress tracking';
      case 'collaboration':
        return 'Share tasks and collaborate with team members';
      case 'categories':
        return 'Create unlimited custom task categories';
      case 'reminders':
        return 'Smart reminder system with priority levels';
      default:
        return 'Custom theme';
    }
  }

  IconData getThemeIcon(String themeName) {
    switch (themeName) {
      case 'default':
        return Icons.palette;
      case 'dark':
        return Icons.dark_mode;
      case 'ocean':
        return Icons.water;
      case 'sunset':
        return Icons.wb_sunny;
      case 'forest':
        return Icons.forest;
      case 'cyber':
        return Icons.terminal;
      case 'minimalist':
        return Icons.crop_square;
      case 'royal':
        return Icons.auto_awesome;
      case 'analytics':
        return Icons.analytics;
      case 'collaboration':
        return Icons.group;
      case 'categories':
        return Icons.category;
      case 'reminders':
        return Icons.notifications_active;
      default:
        return Icons.palette;
    }
  }
} 