import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String studentName;
  final String degree;
  final String batch;

  Student({
    required this.id,
    required this.studentName,
    required this.degree,
    required this.batch,
  });

  factory Student.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return Student(
      id: snapshot.id,
      studentName: snapshotData['studentName'] as String,
      degree: snapshotData['degree'] as String,
      batch: snapshotData['batch'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'degree': degree,
      'batch': batch,
    };
  }
}
