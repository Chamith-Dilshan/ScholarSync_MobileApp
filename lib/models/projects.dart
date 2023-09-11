import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String projectNumber;
  late final String projectName;
  late final DateTime date;
  late final String githubLink;

  Project({
    required this.id,
    required this.projectNumber,
    required this.projectName,
    required this.date,
    required this.githubLink,
  });

  factory Project.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return Project(
      id: snapshot.id,
      date: (snapshotData['date'] as Timestamp).toDate(),
      projectNumber: snapshotData['projectNumber'] as String,
      projectName: snapshotData['projectName'] as String,
      githubLink: snapshotData['githublink'] as String,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectNumber': projectNumber,
      'projectName': projectName,
      'date': date,
      'githubLink': githubLink,
    };
  }

}