// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/models/lecturer.dart';

class LecturerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  final CollectionReference _lecturersCollection =
      FirebaseFirestore.instance.collection('academicStaff');

  Future<List<Lecturer>> getLecturers(String filter) async {
  QuerySnapshot querySnapshot;

  if (filter == 'DS') {
    querySnapshot = await _lecturersCollection.where('category', isEqualTo: 'DS').get();
  } else if (filter == 'NS') {
    querySnapshot = await _lecturersCollection.where('category', isEqualTo: 'NS').get();
  } else if (filter == 'CSSE') {
    querySnapshot = await _lecturersCollection.where('category', isEqualTo: 'CSSE').get();
  } else if (filter == 'IS') {
    querySnapshot = await _lecturersCollection.where('category', isEqualTo: 'IS').get();
  } else {
    querySnapshot = await _lecturersCollection.get();
  }

  return querySnapshot.docs.map((doc) => Lecturer.fromSnapshot(doc)).toList();
}

}