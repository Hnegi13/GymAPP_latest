import 'package:cloud_firestore/cloud_firestore.dart';
import '../modal/member.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _membersCollection {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection('gyms')
        .doc(uid)
        .collection('members');
  }


  Future<void> addMember(Member member) async {
    await _membersCollection.add({
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
    await _membersCollection
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

  Future<int> getMembersCount() async {
    final snapshot = await _membersCollection.get();
    return snapshot.docs.length;
  }

  Stream<List<Member>> getMembers() {
    return _membersCollection.snapshots().map((snapshot) {
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
    await _membersCollection
        .doc(id)
        .delete();
  }
  Future<int> getExpiringMembersCount() async {
    final snapshot = await _membersCollection.get();
    const int expiryWarningDays = 7;
    int count = 0;

    print("Today's Date: ${DateTime.now()}");

    for (var doc in snapshot.docs) {
      final data = doc.data();

      DateTime endDate = (data['endDate'] as Timestamp).toDate();

      int daysLeft = endDate.difference(DateTime.now()).inDays;

      // print("----------------------");
      // print("Member : ${data['name']}");
      // print("End Date : $endDate");
      // print("Days Left : $daysLeft");

      if (daysLeft >= 0 && daysLeft <= expiryWarningDays) {
        count++;
      }
    }

    print("Expiring Count = $count");

    return count;
  }

  Future<List<Member>> getExpiringMembers() async {
    final snapshot = await _membersCollection.get();

    List<Member> members = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      DateTime endDate =
      (data['endDate'] as Timestamp).toDate();

      int daysLeft =
          endDate.difference(DateTime.now()).inDays;

      if (daysLeft >= 0 && daysLeft <= 7) {
        members.add(
          Member(
            id: doc.id,

            name: data['name'],
            phone: data['phone'],
            age: data['age'],
            plan: data['plan'],
            fee: data['fee'],
            startDate: (data['startDate'] as Timestamp).toDate(),
            endDate: endDate,
            isActive: data['isActive'],
          ),
        );
      }
    }

    return members;
  }

  Future<List<Member>> getExpiredMembers() async {
    final snapshot = await _membersCollection.get();

    List<Member> members = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      DateTime endDate =
      (data['endDate'] as Timestamp).toDate();

      if (endDate.isBefore(DateTime.now())) {
        members.add(
          Member(
            id: doc.id,

            name: data['name'],
            phone: data['phone'],
            age: data['age'],
            plan: data['plan'],
            fee: data['fee'],
            startDate: (data['startDate'] as Timestamp).toDate(),
            endDate: endDate,
            isActive: data['isActive'],
          ),
        );
      }
    }

    return members;
  }

  Future<int> getExpiredMembersCount() async {
    final snapshot = await _membersCollection.get();

    int count = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();

      DateTime endDate =
      (data['endDate'] as Timestamp).toDate();

      if (endDate.isBefore(DateTime.now())) {
        count++;
      }
    }

    return count;
  }

  Future<List<Member>> getActiveMembers() async {

    final snapshot = await _membersCollection.get();

    List<Member> members = [];

    for (var doc in snapshot.docs) {

      final data = doc.data();

      DateTime endDate =
      (data['endDate'] as Timestamp).toDate();

      if (endDate.isAfter(DateTime.now())) {

        members.add(

          Member(
            id: doc.id,
            name: data['name'],
            phone: data['phone'],
            age: data['age'],
            plan: data['plan'],
            fee: data['fee'],
            startDate: (data['startDate'] as Timestamp).toDate(),
            endDate: endDate,
            isActive: data['isActive'],
          ),

        );

      }

    }

    return members;

  }

  Future<void> renewMembership({
    required String id,
    required DateTime newEndDate,
    required String plan,
    required String fee,
  }) async {
    await _membersCollection.doc(id).update({
      'plan': plan,
      'fee': fee,
      'endDate': newEndDate,
      'isActive': true,
    });
  }

  Future<Member?> getMemberById(String id) async {

    final doc = await _membersCollection
        .doc(id)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;

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
  }

  Stream<int> getMembersCountStream() {
    return _membersCollection.snapshots().map(
          (snapshot) => snapshot.docs.length,
    );
  }
  Stream<int> getExpiringMembersCountStream() {
    return _membersCollection.snapshots().map((snapshot) {
      int count = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();

        DateTime endDate =
        (data['endDate'] as Timestamp).toDate();

        int daysLeft =
            endDate.difference(DateTime.now()).inDays;

        if (daysLeft >= 0 && daysLeft <= 7) {
          count++;
        }
      }

      return count;
    });
  }

  Stream<int> getExpiredMembersCountStream() {
    return _membersCollection.snapshots().map((snapshot) {
      int count = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();

        DateTime endDate =
        (data['endDate'] as Timestamp).toDate();

        if (endDate.isBefore(DateTime.now())) {
          count++;
        }
      }

      return count;
    });
  }


}