import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhive/services/notification_service.dart';
import 'package:taskhive/providers/task_provider.dart';
import 'package:taskhive/providers/theme_provider.dart';
import 'package:taskhive/screens/main_navigation_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  runApp(const TaskHiveApp());
}

class TaskHiveApp extends StatelessWidget {
  const TaskHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = TaskProvider();
            provider.loadTasks();
            provider.loadCategories();
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'TaskHive',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            home: const MainNavigationScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
