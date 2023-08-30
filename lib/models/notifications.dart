import 'package:cloud_firestore/cloud_firestore.dart';


class Notifications {
  final String targetUid;
  final String message;
  final String title;
  final String type;
  final DateTime timeStamp;

  const Notifications({
    required this.targetUid,
    required this.message,
    required this.title,
    required this.timeStamp,
    required this.type,
  });

  factory Notifications.fromSnapshot(DocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return Notifications(
      title: snapshotData['title'] as String,
      message: snapshotData['message'] as String,
      timeStamp: (snapshotData['timeStamp'] as Timestamp).toDate(),
      targetUid: snapshotData['targetUid'] as String,
      type: snapshotData['type'] as String,
    );
  }

  
  static Stream<Map<String, List<Notifications>>> setupSegmentedNotificationsStream(String currentUserUid) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('targetUid', isEqualTo: currentUserUid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs.map((doc) => Notifications.fromSnapshot(doc)).toList();

      Map<String, List<Notifications>> segmentedNotifications = {
        'today': [],
        'yesterday': [],
        'previous': [],
      };

      final now = DateTime.now();

      for (var notification in notifications) {
        if (now.difference(notification.timeStamp).inDays == 0) {
          segmentedNotifications['today']?.add(notification);
        } else if (now.difference(notification.timeStamp).inDays == 1) {
          segmentedNotifications['yesterday']?.add(notification);
        } else {
          segmentedNotifications['previous']?.add(notification);
        }
      }

      // Ensure each segment contains at most three notifications
      segmentedNotifications.forEach((key, value) {
        if (value.length > 3) {
          segmentedNotifications[key] = value.sublist(0, 3);
        }
      });

      return segmentedNotifications;
    });
  }
}
