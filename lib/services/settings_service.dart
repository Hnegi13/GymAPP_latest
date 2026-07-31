import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> resetAllData() async {
    final gymId = FirebaseAuth.instance.currentUser!.uid;

    final batch = _firestore.batch();

    // Delete Members
    final members = await _firestore
        .collection('gyms')
        .doc(gymId)
        .collection('members')
        .get();

    for (final doc in members.docs) {
      batch.delete(doc.reference);
    }

    // Delete Attendance
    final attendance = await _firestore
        .collection('attendance')
        .where('gymId', isEqualTo: gymId)
        .get();

    for (final doc in attendance.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}