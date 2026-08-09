import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import '../constants/storage_paths.dart';

class PaymentQrService {

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();


//Pick Image
  Future<File?> pickQrImage() async {

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  //Upload QR

  Future<String?> uploadPaymentQr() async {

    final File? file = await pickQrImage();

    if (file == null) {
      return null;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final extension = file.path.split('.').last;

    final ref = _storage.ref().child(
      StoragePaths.paymentQr(uid),
    );

    await ref.putFile(file);

    final downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }

  //  Save URL in Firestore

  Future<void> saveQrUrl(String url) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({

      "paymentQrUrl": url,

      "paymentQrUpdatedAt":
      FieldValue.serverTimestamp(),

    });
  }


}
