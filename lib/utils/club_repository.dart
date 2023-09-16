import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/models/club.dart';

class ClubRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesClubExist(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .where('uid', isEqualTo: uid)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      // print("Error searching for club: $error");
      return false;
    }
  }

  Future<List<Club>> getAllClubs() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('clubs').get();

      return querySnapshot.docs.map((doc) => Club.fromSnapshot(doc)).toList();
    } catch (error) {
      // print("Error fetching clubs: $error");
      return [];
    }
  }

  Future<Club> getClubById(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('clubs')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Club.fromSnapshot(querySnapshot.docs.first);
      } else {
        return "" as Club;
      }
    } catch (error) {
      // print("Error fetching club: $error");
      return "" as Club;
    }
  }

  Future<void> updateClub(Club club) async {
    try {
      await _firestore.collection('clubs').doc(club.id).update(club.toJson());
    } catch (error) {
      // print("Error updating club: $error");
    }
  }
}
