import 'package:cloud_firestore/cloud_firestore.dart';


class Notifications {
  final String targetUid;
  final String message;
  final String title;
  final String type;
  final DateTime timeStamp;
  final String currentUserUid;

  const Notifications({
    required this.targetUid,
    required this.message,
    required this.title,
    required this.timeStamp,
    required this.type,
    required this.currentUserUid,
  });

  factory Notifications.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return Notifications(
      title: snapshotData['title'] as String,
      message: snapshotData['message'] as String,
      timeStamp: (snapshotData['timeStamp'] as Timestamp).toDate(),
      targetUid: snapshotData['targetUid'] as String,
      currentUserUid: snapshotData['currentuserUid'] as String,
      type: snapshotData['type'] as String,
    );
  }

 void setupNotificationsListener() {
  FirebaseFirestore.instance.collection('notifications')
      .where('targetUid', isEqualTo: currentUserUid) // Replace with user's UID
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((QuerySnapshot snapshot) {
   
  });
}
// Helper function to categorize notifications
String categorizeNotification(DateTime timestamp) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));

  if (timestamp.isAfter(today)) {
    return "Today";
  } else if (timestamp.isAfter(yesterday)) {
    return "Yesterday";
  } else {
    return "Previous";
  }
}

// Calculate relative time difference
String calculateRelativeTime(DateTime timestamp) {
  Duration difference = DateTime.now().difference(timestamp);
  
  if (difference.inSeconds < 60) {
    return "${difference.inSeconds} secs ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} mins ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else {
    return "${difference.inDays} days ago";
  }
}

}