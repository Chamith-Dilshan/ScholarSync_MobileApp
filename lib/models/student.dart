import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String email;
  final String studentId;
  final String firstName;
  final String lastName;
  final String degreeProgram;
  final String batch;
  String? profileImageUrl;

  Student({
    required this.id,
    required this.email,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.degreeProgram,
    required this.batch,
    this.profileImageUrl =
        "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'studentId': studentId,
      'firstName': firstName,
      'lastName': lastName,
      'degreeProgram': degreeProgram,
      'batch': batch,
      'profileImageUrl': profileImageUrl ?? '',
    };
  }

  factory Student.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;
    return Student(
      id: snapshot.id,
      email: snapshotData['email'],
      studentId: snapshotData['studentId'],
      firstName: snapshotData['firstName'],
      lastName: snapshotData['lastName'],
      degreeProgram: snapshotData['degreeProgram'],
      batch: snapshotData['batch'],
      profileImageUrl: snapshotData['profileImageUrl'] ?? '',
    );
  }
}
