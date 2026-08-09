import 'package:cloud_firestore/cloud_firestore.dart';
import '../modal/gym.dart';

class GymService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveGym(Gym gym) async {

    await _firestore
        .collection("gyms")
        .doc(gym.id)
        .set(gym.toMap());

  }

  Future<Gym?> getGym(String uid) async {

    final doc = await _firestore
        .collection("gyms")
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return Gym.fromMap(
      doc.id,
      doc.data()!,
    );
  }

}