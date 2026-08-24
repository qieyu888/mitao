import 'package:flutter/material.dart';

import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import 'agreement_screen.dart';
import 'onboarding_screen.dart';
import '../main_shell.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => AuthGateState();
}

class AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _loggedIn = false;
  bool _onboardingDone = false;

  @override
  void initState() {
    super.initState();
    _checkState();
  }

  Future<void> _checkState() async {
    final storage = StorageService.instance;
    final loggedIn = await storage.isLoggedIn();
    final onboardingDone = await storage.isOnboardingDone();
    setState(() {
      _loggedIn = loggedIn;
      _onboardingDone = onboardingDone;
      _loading = false;
    });
  }

  Future<void> _completeOnboarding() async {
    await StorageService.instance.setOnboardingDone();
    setState(() => _onboardingDone = true);
  }

  void _onLoginSuccess() {
    setState(() => _loggedIn = true);
  }

  Future<void> logout() async {
    await StorageService.instance.logout();
    setState(() => _loggedIn = false);
  }

  Future<void> deleteAccount() async {
    await StorageService.instance.deleteAccount();
    setState(() {
      _loggedIn = false;
      _onboardingDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.cream50,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.peach500),
        ),
      );
    }

    if (!_loggedIn) {
      if (!_onboardingDone) {
        return OnboardingScreen(onComplete: _completeOnboarding);
      }
      return AgreementScreen(onLoginSuccess: _onLoginSuccess);
    }

    return MainShell(
      onLogout: logout,
      onDeleteAccount: deleteAccount,
    );
  }
}
