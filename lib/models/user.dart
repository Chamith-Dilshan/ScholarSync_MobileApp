import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepo{
  final String username;
  final String uid;
  final String email;

  const UserRepo({
    required this.username,
    required this.uid,
    required this.email,
  });

  Map<String,dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
  };

  static UserRepo fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return UserRepo(
      username: snapshot['username'], 
      uid: snapshot['uid'], 
      email: snapshot['email'], 
    );
  }
}

