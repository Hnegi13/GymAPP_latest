import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MpinService {
  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  String _getMpinKey() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No authenticated user found");
    }

    return 'gym_manager_mpin_${user.uid}';
  }

  Future<void> saveMpin(String mpin) async {
    await _storage.write(
      key: _getMpinKey(),
      value: mpin,
    );
  }

  Future<String?> getMpin() async {
    return await _storage.read(
      key: _getMpinKey(),
    );
  }

  Future<bool> isMpinSet() async {
    final mpin = await getMpin();

    return mpin != null && mpin.isNotEmpty;
  }

  Future<bool> verifyMpin(String enteredMpin) async {
    final storedMpin = await getMpin();

    if (storedMpin == null) {
      return false;
    }

    return storedMpin == enteredMpin;
  }

  Future<void> deleteMpin() async {
    await _storage.delete(
      key: _getMpinKey(),
    );
  }

  Future<void> resetMpin() async {
    await _storage.delete(
      key: _getMpinKey(),
    );
  }

  Future<void> setMpinConfigured() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No authenticated user found");
    }

    await FirebaseFirestore.instance
        .collection('gyms')
        .doc(user.uid)
        .update({
      'mpinConfigured': true,
    });
  }


}