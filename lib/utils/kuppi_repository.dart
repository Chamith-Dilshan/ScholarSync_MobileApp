import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/models/kuppi.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KuppiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<KuppiSession>> getKuppiSessions() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('kuppiSessions').get();

      return querySnapshot.docs
          .map((doc) => KuppiSession.fromSnapshot(doc))
          .toList();
    } catch (error) {
      // print("Error fetching kuppi sessions: $error");
      return [];
    }
  }

  Future<void> createKuppiSession(KuppiSession kuppiSession) async {
    try {
      await _firestore.collection('kuppiSessions').add(kuppiSession.toJson());
    } catch (error) {
      // print("Error creating kuppi session: $error");
    }
  }

  Future<void> updateKuppiSession(KuppiSession kuppiSession) async {
    try {
      await _firestore
          .collection('kuppiSessions')
          .doc(kuppiSession.id)
          .update(kuppiSession.toJson());
    } catch (error) {
      // print("Error updating kuppi session: $error");
    }
  }

  Future<void> deleteKuppiSession(String id) async {
    try {
      await _firestore.collection('kuppiSessions').doc(id).delete();
    } catch (error) {
      // print("Error deleting kuppi session: $error");
    }
  }
}
