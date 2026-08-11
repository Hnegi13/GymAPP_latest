import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/MPIN/enter_mpin_page.dart';
import '../Screens/home/home_page.dart';

import '../services/gym_service.dart';
import '../services/mpin_service.dart';
import '../utils/app_constants.dart';
import 'login_page.dart';
import 'register_gym_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _verifiedUid;

  Future<void> _onMpinVerified() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      _verifiedUid = user.uid;
    });

    await _updateLastLogin(user.uid);
  }

  Future<void> _updateLastLogin(String uid) async {
    await FirebaseFirestore.instance
        .collection('gyms')
        .doc(uid)
        .update({
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authSnapshot.hasData) {
          _verifiedUid = null;
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

            // MPIN disabled
            if (!AppConstants.enableMpin) {
              _updateLastLogin(uid);
              return const HomePage();
            }

            // MPIN already verified during this session
            if (_verifiedUid == uid) {
              return const HomePage();
            }

            return FutureBuilder<bool>(
              future: MpinService().isMpinSet(),
              builder: (context, mpinSnapshot) {
                if (mpinSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // No MPIN configured
                if (mpinSnapshot.data != true) {
                  _updateLastLogin(uid);
                  return const HomePage();
                }

                // MPIN configured but not verified
                return EnterMpinPage(
                  onVerified: _onMpinVerified,
                );
              },
            );
          },
        );
      },
    );
  }
}