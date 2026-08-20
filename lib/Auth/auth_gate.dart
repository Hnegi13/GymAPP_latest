import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/MPIN/create_mpin_page.dart';
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

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('gyms')
              .doc(uid)
              .get(),
          builder: (context, gymSnapshot) {
            if (gymSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Gym document does not exist
            if (!gymSnapshot.hasData ||
                !gymSnapshot.data!.exists) {
              return const RegisterGymPage();
            }

            final gymData = gymSnapshot.data!.data();

            // MPIN disabled
            if (!AppConstants.enableMpin) {
              _updateLastLogin(uid);
              return const HomePage();
            }

            // MPIN already verified during this session
            if (_verifiedUid == uid) {
              return const HomePage();
            }

            // Check MPIN configuration from the same
            // Firestore document we already fetched.
            final mpinConfigured =
                gymData?['mpinConfigured'] == true;

            // MPIN has never been configured
            if (!mpinConfigured) {
              _updateLastLogin(uid);
              return const HomePage();
            }

            // MPIN is configured in Firebase.
            // Now check whether the actual MPIN exists locally.
            return FutureBuilder<bool>(
              future: MpinService().isMpinSet(),
              builder: (context, localMpinSnapshot) {
                if (localMpinSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // MPIN was configured previously,
                // but local storage was cleared.
                if (localMpinSnapshot.data != true) {
                  return CreateMpinPage(
                    onMpinCreated: () {
                      setState(() {
                        _verifiedUid = uid;
                      });

                      _updateLastLogin(uid);
                    },
                  );
                }

                // MPIN exists locally and must be verified.
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