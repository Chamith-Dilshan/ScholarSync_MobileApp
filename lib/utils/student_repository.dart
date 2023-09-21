import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/models/students.dart';

class StudentDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update user profile data
  Future<void> updateProfileData(Student student) async {
    try {
      await _firestore.collection('').doc(student.id).set({
        'studentName': student.studentName,
        'degree': student.degree,
        'batch': student.batch,
      });
    } catch (error) {
      print(error.toString());
    }
  }

  // Retrieve user profile data
  Future<Map<String, dynamic>?> getProfileData(String userId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Retrieve user's projects
  Stream<QuerySnapshot> getUserProjects(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .snapshots();
  }
}
