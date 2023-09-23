import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholarsync/theme/palette.dart';

class CalendarMethods{

  Future<List<CalendarEventData>> fetchEventDataFromFirestore() async {
  List<CalendarEventData> eventDataList = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    for (var doc in querySnapshot.docs) {
      CalendarEventData eventData = CalendarEventData(
        date: doc['date'].toDate(),
        title: doc['title'],
        description: doc['description'],
        startTime: doc['startTime'].toDate(),
        endTime: doc['endTime'].toDate(),
        color: PaletteLightMode.primaryGreenColor,
      );

      eventDataList.add(eventData);
    }
  } catch (e) {
    // Handle any errors here
    print('Error fetching data from Firestore: $e');
  }

  return eventDataList;
}

}