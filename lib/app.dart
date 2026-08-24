import 'package:flutter/material.dart';

import 'app_info.dart';
import 'screens/auth/auth_gate.dart';
import 'theme/app_theme.dart';

class BubblePopApp extends StatelessWidget {
  const BubblePopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.fullName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}
