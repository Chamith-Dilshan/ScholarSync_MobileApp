import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String name;
  final DateTime date;
  final String link;

  Project({
    required this.name,
    required this.date,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'link': link,
    };
  }

  factory Project.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;
    return Project(
      name: snapshotData['name'],
      date: (snapshotData['date'] as Timestamp).toDate(),
      link: snapshotData['link'],
    );
  }
}
