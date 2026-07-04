import 'package:cloud_firestore/cloud_firestore.dart';
import '../member.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMember(Member member) async {
    await _firestore.collection('members').add({
      "id": member.id,
      'name': member.name,
      'phone': member.phone,
      'age': member.age,
      'plan': member.plan,
      'fee': member.fee,
      'startDate': member.startDate,
      'endDate': member.endDate,
      'isActive': member.isActive,
    });
  }

  Future<void> updateMember(Member member) async {
    await _firestore
        .collection('members')
        .doc(member.id)
        .update({
      'name': member.name,
      'phone': member.phone,
      'age': member.age,
      'plan': member.plan,
      'fee': member.fee,
      'startDate': member.startDate,
      'endDate': member.endDate,
      'isActive': member.isActive,
    });
  }

  Stream<List<Member>> getMembers() {
    return _firestore.collection('members').snapshots().map((snapshot) {

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Member(
          id: doc.id,
          name: data['name'],
          phone: data['phone'],
          age: data['age'],
          plan: data['plan'],
          fee: data['fee'],
          startDate: (data['startDate'] as Timestamp).toDate(),
          endDate: (data['endDate'] as Timestamp).toDate(),
          isActive: data['isActive'],
        );
      }).toList();
    });
  }

  Future<void> deleteMember(String id) async {
    await _firestore
        .collection('members')
        .doc(id)
        .delete();
  }
}