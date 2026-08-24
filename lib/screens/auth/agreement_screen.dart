import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../app_info.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../settings/policy_screen.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  bool _agreedPrivacy = false;
  bool _agreedTerms = false;

  bool get _canEnter => _agreedPrivacy && _agreedTerms;

  Future<void> _enter() async {
    if (!_canEnter) return;
    await StorageService.instance.login();
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.peach300, AppColors.peach500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: KawaiiShadow.md,
                ),
                child: const Center(
                  child: Text(
                    '蜜',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                AppInfo.shortName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.peach500,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                AppInfo.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mocha400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppInfo.slogan,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.mocha500,
                ),
              ),
              const Spacer(flex: 1),
              _AgreementCheckbox(
                value: _agreedPrivacy,
                onChanged: (v) => setState(() => _agreedPrivacy = v ?? false),
                label: '我已阅读并同意',
                linkText: '《隐私政策》',
                onLinkTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PolicyScreen(kind: PolicyKind.privacy),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _AgreementCheckbox(
                value: _agreedTerms,
                onChanged: (v) => setState(() => _agreedTerms = v ?? false),
                label: '我已阅读并同意',
                linkText: '《用户协议》',
                onLinkTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PolicyScreen(kind: PolicyKind.terms),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canEnter ? _enter : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.peach500,
                    disabledBackgroundColor: AppColors.peach300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '同意并进入',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '无需注册，同意协议即可使用',
                style: TextStyle(fontSize: 12, color: AppColors.mocha400),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  const _AgreementCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.linkText,
    required this.onLinkTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final String linkText;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.peach500,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: label,
              style: const TextStyle(fontSize: 14, color: AppColors.mocha700),
              children: [
                TextSpan(
                  text: linkText,
                  style: const TextStyle(
                    color: AppColors.peach500,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
