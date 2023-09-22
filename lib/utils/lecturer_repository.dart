// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/models/lecturer.dart';

class LecturerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _lecturersCollection =
      FirebaseFirestore.instance.collection('academicStaff');

  Future<List<Lecturer>> getLecturers(String category) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('academicStaff')
          .where('category', isEqualTo: category) // Add the filter here
          .get();

      return querySnapshot.docs
          .map((doc) => Lecturer.fromSnapshot(doc))
          .toList();
    } catch (error) {
      // Handle the error
      return [];
    }
  }
}
