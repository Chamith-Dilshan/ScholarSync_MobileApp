import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarsync/models/user.dart';

class UserRepository {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Stream<UserRepo> userDataStream(String userId) {
    return usersCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserRepo.fromSnap(snapshot);
      } else {
        // You can return a default instance or throw an exception here if needed
        print('Snapshot does not exits: $userId');
        return const UserRepo(
          username: '',
          uid: '',
          email: '',
        );
      }
    });
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
