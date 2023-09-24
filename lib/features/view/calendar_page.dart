import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/common/custom_elevated_button.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/widgets/drawer_menu.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/calendar_methods.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateFormat monthYearFormat = DateFormat('dd MMMM yyyy');
  EventController eventController = EventController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final calendarMethods = CalendarMethods();
  List<CalendarEventData> caleventdata = [];
  int selectedBoxIndex = -1;

  @override
  void initState() {
    super.initState();
    calendarMethods.fetchEventDataFromFirestore().then((data) {
      setState(() {
        caleventdata = data;
        eventController.addAll(caleventdata);
      });
    }).catchError((error) {
      print('Error fetching data from Firestore: $error');
    });
  }

  @override
  void dispose() {
    super.dispose();
    eventController.dispose();
  }

  void _showEventDialog(BuildContext context, List<CalendarEventData> events, String lectureTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                  text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Rate your lecture',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: PaletteLightMode.textColor,
                    ),
                  ),
                  const TextSpan(text: '\n'),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text:
                        'How would you rate today\'s "$lectureTitle" lecture?',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: PaletteLightMode.textColor,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  feedbackColorBox(Icons.sentiment_very_dissatisfied, 1),
                  const SizedBox(width: 2),
                  feedbackColorBox(Icons.sentiment_dissatisfied, 2),
                  const SizedBox(width: 2),
                  feedbackColorBox( Icons.sentiment_neutral, 3),
                  const SizedBox(width: 2),
                  feedbackColorBox(Icons.sentiment_satisfied, 4),
                  const SizedBox(width: 2),
                  feedbackColorBox(Icons.sentiment_very_satisfied, 5),
                ],
              ),
              const SizedBox(height: 16.0),
              CustomElevatedButton(
                label: 'Submit',
                onPressed: () {
                  if (selectedBoxIndex != -1) {
                    // Call a function to store the data in Firestore
                    _storeDataInFirestore(events, selectedBoxIndex);
                    Navigator.of(context).pop(); // Close the dialog
                  }
                  else{
                    //Close the dialog
                    Navigator.of(context).pop();  
                  }                 
                },
              ),
            ],
          ),
        );
      },
    );
  }

Widget feedbackColorBox(IconData icon, int index) {
  return IconButton(
    icon: Icon(
      icon,
      color: index == selectedBoxIndex ? PaletteLightMode.secondaryGreenColor :  PaletteLightMode.textColor,
    ),
    onPressed: () {
      setState(() {
        selectedBoxIndex = index; // Update the selectedBoxIndex when the button is pressed        
      });
    print('indexNumber is $index');
    },
  );
}

  void _storeDataInFirestore(
      List<CalendarEventData> events, int selectedBoxIndex) {
    // Extract event details
    String eventTitle =
        events[0].title; // Assuming you want the title of the first event
    String eventDescription = events[0]
        .description; // Assuming you want the description of the first event

    // Store the data in Firestore
    FirebaseFirestore.instance.collection('ratings').add({
      'selectedBoxIndex': selectedBoxIndex,
      'eventTitle': eventTitle,
      'eventDescription': eventDescription,
    }).then((_) {
      print('Data stored in Firestore successfully');
    }).catchError((error) {
      print('Error storing data in Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomDrawerMenu(),
      appBar: UIConstants.appBar(
          title: 'Calendar',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          titleCenter: false,
          backIcon: IconConstants.hamburgerMenuIcon,
          onBackIconButtonpressed: () {
            _scaffoldKey.currentState!.openEndDrawer(); // Open the end drawer
          }),
      body: DayView(
        controller: eventController,
        showVerticalLine: true,
        minDay: DateTime(2020),
        maxDay: DateTime(2030),
        heightPerMinute: 1,
        scrollPhysics: const BouncingScrollPhysics(),
        pageViewPhysics: const BouncingScrollPhysics(),
        headerStyle: const HeaderStyle(
            headerTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              color: PaletteLightMode.backgroundColor,
            )),
        dateStringBuilder: (date, {secondaryDate}) {
          return monthYearFormat.format(date);
        },
        onEventTap: (events, date) {
          _showEventDialog(context, events, events[0].title);
        },
      ),
    );
  }
}
