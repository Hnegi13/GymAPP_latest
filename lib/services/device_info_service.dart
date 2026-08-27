import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_session.dart';

class DeviceInfoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDeviceInfo() async {
    try {
      // Get the correct gym ID for normal or demo user.
      final gymId = AppSession.isDemoMode
          ? AppSession.currentGymId
          : FirebaseAuth.instance.currentUser?.uid;

      if (gymId == null) {
        return;
      }

      final deviceInfoPlugin = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();

      String manufacturer = '';
      String model = '';
      String osVersion = '';

      final androidInfo =
      await deviceInfoPlugin.androidInfo;

      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      osVersion = androidInfo.version.release;

      await _firestore
          .collection('gyms')
          .doc(gymId)
          .set(
        {
          'deviceInfo': {
            'manufacturer': manufacturer,
            'model': model,
            'osVersion': osVersion,
            'appVersion': packageInfo.version,
            'buildNumber': packageInfo.buildNumber,
          },
          'lastLogin': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      // Device information should never prevent
      // the user from using the app.
      print('Device info error: $e');
    }
  }
}