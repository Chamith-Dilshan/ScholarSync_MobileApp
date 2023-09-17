import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarsync/models/club.dart';

class ClubRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkIfUserIsClub(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .where('uid', isEqualTo: uid)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      // print("Error searching for club: $error");
      return false;
    }
  }

  Future<List<Club>> getAllClubs() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('clubs').get();

      return querySnapshot.docs.map((doc) => Club.fromSnapshot(doc)).toList();
    } catch (error) {
      // print("Error fetching clubs: $error");
      return [];
    }
  }

  Future<Club> getClubById(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('clubs')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Club.fromSnapshot(querySnapshot.docs.first);
      } else {
        return "" as Club;
      }
    } catch (error) {
      // print("Error fetching club: $error");
      return "" as Club;
    }
  }

  Future<void> updateClub(Club club) async {
    try {
      await _firestore.collection('clubs').doc(club.id).update(club.toJson());
    } catch (error) {
      // print("Error updating club: $error");
    }
  }

  Future<String> uploadImage(File imageFile, String storagePath) async {
    final storageRef = FirebaseStorage.instance.ref().child(storagePath);
    final uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() {});
    return await storageRef.getDownloadURL();
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> _updateClubEventImageUrls(Club club, String imageUrl) async {
    if (club.eventImageURLs == null) {
      club.eventImageURLs = [imageUrl];
    } else {
      club.eventImageURLs?.add(imageUrl);
    }

    await updateClub(club);
  }

  Future<void> uploadEventImage(String uid) async {
    Club club = await getClubById(uid);
    try {
      final eventImage = await pickImage();
      String imageName = eventImage!.path.split('/').last;
      final storagePath = 'clubs/${club.name}/events/$imageName';
      String eventImageURL = await uploadImage(eventImage, storagePath);
      await _updateClubEventImageUrls(club, eventImageURL);
    } catch (error) {
      // print("Error uploading image: $error");
    }
  }
}
