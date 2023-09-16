import 'package:cloud_firestore/cloud_firestore.dart';

class Lecturer {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  Lecturer( {
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory Lecturer.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;
    
    return Lecturer(
      id: snapshot.id,
      name: snapshotData['name'] as String,
      email: snapshotData['email'] as String,
      imageUrl: snapshotData['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}