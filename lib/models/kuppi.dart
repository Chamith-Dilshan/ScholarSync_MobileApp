import 'package:cloud_firestore/cloud_firestore.dart';

class KuppiSession {
  String id;
  DateTime date;
  String name;
  String conductor;
  String link;
  String imageUrl;

  KuppiSession({
    required this.id,
    required this.date,
    required this.name,
    required this.conductor,
    required this.link,
    required this.imageUrl,
  });

  factory KuppiSession.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return KuppiSession(
      id: snapshot.id,
      date: (snapshotData['date'] as Timestamp).toDate(),
      name: snapshotData['name'] as String,
      conductor: snapshotData['conductor'] as String,
      link: snapshotData['link'] as String,
      imageUrl: snapshotData['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'name': name,
        'conductor': conductor,
        'link': link,
        'imageUrl': imageUrl,
      };
}
