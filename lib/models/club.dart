import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String? id;
  final String? uid;
  final String? email;
  final String? name;
  final String? about;
  final String? inCharge;
  final String? president;
  final String? profileImageURL;
  final String? bannerImageURL;
  final String? image;

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
    this.image,
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
      image: snapshotData['image'],
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
        'image': image,
      };
}
