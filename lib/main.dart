
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LostLensApp());
}

class LostLensApp extends StatelessWidget {
  const LostLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LostLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
