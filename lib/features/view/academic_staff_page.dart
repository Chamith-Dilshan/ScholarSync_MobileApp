import 'package:flutter/material.dart';
import 'package:scholarsync/common/sidebar.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/features/widgets/academic_staff_page_tab.dart';
import 'package:scholarsync/features/widgets/drawer_menu.dart';
import 'package:scholarsync/features/widgets/lecturer_info.dart';
import 'package:scholarsync/models/lecturer.dart';
import 'package:scholarsync/utils/lecturer_repository.dart';

class AcademicStaffPage extends StatefulWidget {
  const AcademicStaffPage({super.key});

  @override
  State<AcademicStaffPage> createState() => _AcademicStaffPageState();
}

class _AcademicStaffPageState extends State<AcademicStaffPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LecturerService _lecturerService = LecturerService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer:  const CustomDrawerMenu(),
      appBar: UIConstants.appBar(
        title: 'Academic Staff',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        titleCenter: true,
        frontIcon: IconConstants.leftArrowIcon,
        backIcon: IconConstants.hamburgerMenuIcon,
        onFrontIconButtonpressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        onBackIconButtonpressed: () {
          _scaffoldKey.currentState!.openEndDrawer(); // Open the end drawer
        },
      ),
      body: Column(
        children: [
          AcademicStaffPageTabs(tabController: _tabController),
          const SizedBox(height: 8.0),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Add FutureBuilder for the first tab (DS).
                FutureBuilder<List<Lecturer>>(
                  future: _lecturerService.getLecturers('DS'),
                  builder: (context, snapshot) {
                    return buildTabContent(snapshot);
                  },
                ),
                // Add FutureBuilder for the second tab (NS).
                FutureBuilder<List<Lecturer>>(
                  future: _lecturerService.getLecturers('NS'),
                  builder: (context, snapshot) {
                    return buildTabContent(snapshot);
                  },
                ),
                // Add FutureBuilder for the third tab (IS).
                FutureBuilder<List<Lecturer>>(
                  future: _lecturerService.getLecturers('IS'),
                  builder: (context, snapshot) {
                    return buildTabContent(snapshot);
                  },
                ),
                // Add FutureBuilder for the fourth tab (CSSE).
                FutureBuilder<List<Lecturer>>(
                  future: _lecturerService.getLecturers('CSSE'),
                  builder: (context, snapshot) {
                    return buildTabContent(snapshot);
                  },
                ),
              ],
            ), 
          ),
        ],
      ),
    );
  }

  // Helper method to build tab content.
  Widget buildTabContent(AsyncSnapshot<List<Lecturer>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text('No lecturers found.');
    } else {
      final lecturers = snapshot.data!;
      return ListView.builder(
        itemCount: lecturers.length,
        itemBuilder: (context, index) {
          final lecturer = lecturers[index];
          return LecturerInformation(
            id: lecturer.id,
            name: lecturer.name,
            email: lecturer.email,
            imageUrl: lecturer.imageUrl, 
          );
        },
      );
    }
  }
}