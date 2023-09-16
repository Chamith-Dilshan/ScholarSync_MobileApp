import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String? id;
  final String? uid;
  final String? email;
  final String? name;
  String? about;
  String? inCharge;
  String? president;
  String? profileImageURL;
  String? bannerImageURL;

  Club({
    this.id,
    this.uid,
    this.email,
    this.name,
    this.about,
    this.inCharge,
    this.president,
    this.profileImageURL,
    this.bannerImageURL,
  });

  factory Club.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return Club(
      id: snapshot.id,
      uid: snapshotData['uid'],
      email: snapshotData['email'],
      name: snapshotData['name'],
      about: snapshotData['about'],
      inCharge: snapshotData['inCharge'],
      president: snapshotData['president'],
      profileImageURL: snapshotData['profileImageURL'],
      bannerImageURL: snapshotData['bannerImageURL'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'email': email,
        'name': name,
        'about': about,
        'inCharge': inCharge,
        'president': president,
        'profileImageURL': profileImageURL,
        'bannerImageURL': bannerImageURL,
      };
}
