import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/models/projects.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProject(Project project) async {
    try {
      await _firestore.collection('projects').add(project.toJson());
    } catch (error) {
      // 
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toJson());
    } catch (error) {
      //
    }
  }

  Future<List<Project>> getProject() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('projects').get();

      return querySnapshot.docs
          .map((doc) => Project.fromSnapshot(doc))
          .toList();
    } catch (error) {
      // 
      return [];
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _firestore.collection('projects').doc(id).delete();
    } catch (error) {
      // 
    }
  }
}
