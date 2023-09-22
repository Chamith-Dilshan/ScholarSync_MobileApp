import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/project.dart';
import '../models/student.dart';

class StudentRepository {
  CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('students');

  Future<List<Student>> getStudents() async {
    try {
      QuerySnapshot querySnapshot = await studentCollection.get();
      List<Student> students =
          querySnapshot.docs.map((doc) => Student.fromSnapshot(doc)).toList();
      return students;
    } catch (e) {
      return [];
    }
  }

  Future<Student?> fetchStudentData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('students')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs[0].data();

          // Map the Firestore data to a Student object
          return Student(
            id: querySnapshot.docs[0].id,
            email: userData['email'],
            studentId: userData['studentId'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            degreeProgram: userData['degreeProgram'],
            batch: userData['batch'],
            profileImageUrl: userData['profileImageUrl'] ??
                'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
          );
        }
      }
    } catch (e) {
      // print('Error fetching user data: $e');
    }
    return null;
  }

  Future<List<Project>> fetchProjectsForStudent() async {
    try {
      Future<Student?> student = fetchStudentData();
      String studentId = (await student)!.id;

      final projectCollection = FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .collection('projects');

      final querySnapshot = await projectCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        final projects =
            querySnapshot.docs.map((doc) => Project.fromSnapshot(doc)).toList();

        return projects;
      } else {
        return [];
      }
    } catch (e) {
      // print('Error fetching projects: $e');
      rethrow;
    }
  }

  static Future<void> createNewProject(Project project) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('students')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final studentId = querySnapshot.docs[0].id;

          final projectCollection = FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .collection('projects');

          await projectCollection.add({
            'name': project.name,
            'date': project.date,
            'link': project.link,
          });
        }
      }
    } catch (e) {
      // Handle errors here
    }
  }

  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<String> uploadImage(File imageFile, String imagePath) async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child(imagePath);
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      final String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  static Future<String> uploadProfileImage(String studentId) async {
    try {
      final imageFile = await pickImage();
      return uploadImage(imageFile!, 'students/$studentId/profileImage');
    } catch (e) {
      print('Error uploading image: $e');
      return "";
    }
  }

  static Future<void> updateProfileImageURL(String id, String studentId) async {
    try {
      final studentDocRef =
          FirebaseFirestore.instance.collection('students').doc(id);

      // Get the existing student document data
      final studentSnapshot = await studentDocRef.get();
      final studentData = studentSnapshot.data();

      // Determine whether to create or update the profileImageUrl field
      if (studentData != null && studentData.containsKey('profileImageUrl')) {
        // Update the existing profileImageUrl field
        final profileImageUrl = await uploadProfileImage(studentId);
        await studentDocRef.update({'profileImageUrl': profileImageUrl});
      } else {
        // Create the profileImageUrl field
        final profileImageUrl = await uploadProfileImage(studentId);
        await studentDocRef
            .set({'profileImageUrl': profileImageUrl}, SetOptions(merge: true));
      }
    } catch (e) {
      // Handle errors here
      print('Error updating profile image URL: $e');
    }
  }
}
