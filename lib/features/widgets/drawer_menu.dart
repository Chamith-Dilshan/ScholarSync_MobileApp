import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/features/view/academic_staff_page.dart';
import 'package:scholarsync/features/view/calendar_page.dart';
import 'package:scholarsync/features/view/give_feedback.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/features/view/my_profile_page.dart';
import 'package:scholarsync/features/view/settings_page.dart';
import 'package:scholarsync/main.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawerMenu extends ConsumerStatefulWidget {
  const CustomDrawerMenu({super.key});

  @override
  ConsumerState<CustomDrawerMenu> createState() => _CustomDrawerMenuState();
}

class _CustomDrawerMenuState extends ConsumerState<CustomDrawerMenu> {
  // Function to launch the Play Store
void _launchPlayStore() async {
  final Uri playStoreUri = Uri.parse('https://play.google.com/store/games?device=phone');
  if (await canLaunchUrl(playStoreUri)) {
    await launchUrl(playStoreUri);
  } else {
    throw 'Could not launch $playStoreUri';
  }
}

  @override
  Widget build(BuildContext context) {
    return ref.watch(userStreamProvider).when(data: (userData) {
      return Drawer(
        backgroundColor: PaletteLightMode.whiteColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                  color: PaletteLightMode.whiteColor),
              accountName: Text(
                userData.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: PaletteLightMode.titleColor
                ),
              ),
              margin: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.20),
              accountEmail: Text(
                userData.email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture:
                  Image(image: NetworkImage(userData.imageUrl)),
              onDetailsPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MyProfilePage()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.homeIcon,
              title: 'Home',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.personIcon,
              title: 'My Profile',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.calendarIcon,
              title: 'Calendar',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const CalendarPage()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.settingOutlinedIcon,
              title: 'Settings',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.teacherIcon,
              title: 'Academic Staff',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const AcademicStaffPage()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.mailIcon,
              title: 'Give Feedback',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const FeedbackForm()));
              },
            ),
            ListTitleWidget(
              icon: IconConstants.likeOutlinedIcon,
              title: 'Rate Us',
              ontap: () {
                Navigator.pop(context);
                _launchPlayStore();
              },
            ),
            ListTitleWidget(
              icon: IconConstants.logoutIcon,
              title: 'Log Out',
              ontap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
          ],
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return const Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}

class ListTitleWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Function()? ontap;

  const ListTitleWidget({
    required this.icon,
    required this.title,
    required this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        colorFilter: const ColorFilter.mode(
          PaletteLightMode.textColor,
          BlendMode.srcIn,
        ),
        width: 23,
        height: 23,
      ),
      title: Text(title),
      onTap: ontap,
      focusColor: PaletteLightMode.secondaryGreenColor,
      
    );
  }
}
