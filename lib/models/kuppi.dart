import 'package:cloud_firestore/cloud_firestore.dart';

class KuppiSession {
  final String id;
  final String date;
  final String name;
  final String conductor;
  final String link;

  KuppiSession({
    required this.id,
    required this.date,
    required this.name,
    required this.conductor,
    required this.link,
  });

  factory KuppiSession.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return KuppiSession(
      id: snapshot.id,
      date: snapshotData['date'] as String,
      name: snapshotData['name'] as String,
      conductor: snapshotData['conductor'] as String,
      link: snapshotData['link'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'name': name,
        'conductor': conductor,
        'link': link,
      };
}
