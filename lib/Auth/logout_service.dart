import 'package:flutter/material.dart';

import '../auth/auth_service.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    final authService = AuthService();

    await authService.signOut();

    if (!context.mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst,
    );
  }
}