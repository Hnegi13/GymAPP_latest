import 'package:cloud_firestore/cloud_firestore.dart';
import '../member.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMember(Member member) async {
    await _firestore.collection('members').add({
      'name': member.name,
      'phone': member.phone,
      'age': member.age,
      'plan': member.plan,
      'fee': member.fee,
    });
  }

  Stream<List<Member>> getMembers() {
    return _firestore.collection('members').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Member(
          name: data['name'],
          phone: data['phone'],
          age: data['age'],
          plan: data['plan'],
          fee: data['fee'],
        );
      }).toList();
    });
  }
}