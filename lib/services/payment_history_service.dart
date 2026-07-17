import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modal/payment.dart';

class PaymentHistoryService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> generateReceiptNumber() async {

    final counterRef = _firestore
        .collection("system")
        .doc("receipt_counter");

    return await _firestore.runTransaction((transaction) async {

      final snapshot = await transaction.get(counterRef);

      int lastNumber =
          snapshot.data()?["lastReceiptNumber"] ?? 0;

      lastNumber++;

      transaction.update(counterRef, {
        "lastReceiptNumber": lastNumber,
      });

      final year = DateTime.now().year;

      final receiptNumber =
          "GM-$year-${lastNumber.toString().padLeft(6, '0')}";

      return receiptNumber;
    });
  }


  Future<void> savePayment(Payment payment) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;


    await _firestore
        .collection("gyms")
        .doc(uid)
        .collection("payments")
        .add(payment.toMap());

  }

  Future<List<Payment>> getLastFivePayments() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await _firestore
        .collection("gyms")
        .doc(uid)
        .collection("payments")
        .orderBy("paymentDate", descending: true)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) {
      return Payment.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }

  //fetch all payment history
  Future<List<Payment>> getAllPayments() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await _firestore
        .collection("gyms")
        .doc(uid)
        .collection("payments")
        .orderBy("paymentDate", descending: true,)
        .get();

    return snapshot.docs.map((doc) {
      return Payment.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }

}