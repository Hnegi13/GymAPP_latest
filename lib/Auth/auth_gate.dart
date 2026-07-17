import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/dashboard_page.dart';
import '../services/gym_service.dart';
import 'login_page.dart';
import 'register_gym_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {

        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authSnapshot.hasData) {
          return LoginPage();
        }

        final uid = authSnapshot.data!.uid;

        return FutureBuilder(
          future: GymService().getGym(uid),

          builder: (context, gymSnapshot) {

            if (gymSnapshot.connectionState ==
                ConnectionState.waiting) {

              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (gymSnapshot.data == null) {
              return const RegisterGymPage();
            }

            return const DashboardPage();
          },
        );
      },
    );
  }
}