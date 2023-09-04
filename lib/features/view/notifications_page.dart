import 'package:flutter/material.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/common/custom_textfield.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/view/login_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(
        title: 'Notifications',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        titleCenter: false,
        backIcon: IconConstants.hamburgerMenuIcon,
        onBackIconButtonpressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogInPage()),
          );
        },
      ),
     
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "inter",
                color: PaletteLightMode.textColor,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: CustomTextField(
                firstLine: "Lecture hall allocation",
                secondPartFirstline: "has been updated",
                thirdLine: "20 minutes ago",
                firstLineStyle: const TextStyle(fontSize: 13, color: PaletteLightMode.textColor),
                thirdLineStyle: const TextStyle(fontSize: 9, color: PaletteLightMode.secondaryTextColor),
                secondPartFirstLineStyle: const TextStyle(fontWeight: FontWeight.bold),
                controller: TextEditingController(),
                ontapBox: () {
                  // onTap function for the Box
                },
                ontapFrontIcon: () {
                  // onTap function for FrontIcon
                },
                ontapBackIcon: () {
                  // onTap function for backIcon
                },
                frontIcon: IconConstants.calendarIcon,
                frontIconScale: 50,
                backIconScale: 50,
                borderColor: Colors.transparent,
                borderWidth: 0,
                backgroundColor: PaletteLightMode.backgroundColor,
                boxwidth: 369.84,
                boxheight: 75,
                borderRadius: 10,
                padding: 16,
              ),
            ),
            const SizedBox(height: 20),
            // ... Add more notifications here
          ],
        ),
      ),
    );
  }
}
