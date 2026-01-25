import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String role,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.now(),
    });
  }

  Future<String> getRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc['role'];
  }
}
