import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'auth_gate.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    final authService = AuthService();

    await authService.signOut();

    if (!context.mounted) return;

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AuthGate(),
      ),
          (route) => false,
    );
  }
}