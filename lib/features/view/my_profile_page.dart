import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/common/project_box.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/features/view/my_projects_page.dart';
import 'package:scholarsync/features/widgets/profile_info.dart';
import 'package:scholarsync/models/projects.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/project_repository.dart';
import 'package:scholarsync/utils/student_repository.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  final ProjectService _projectService = ProjectService();
  final StudentDataService _db = StudentDataService();
  late final String uid;

  final String _searchQuery = '';

  String formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    } else {
      // Handle the case where the user is not authenticated
      // You can add navigation logic here if needed
    }
  }

  List<Project> _filterProjects(List<Project> projects) {
    if (_searchQuery.isEmpty) {
      return projects;
    } else {
      final query = _searchQuery.toLowerCase();
      return projects.where((project) {
        return project.projectName.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _db.getProfileData(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error fetching user data: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          final student = snapshot.data;

          if (student != null) {
            return Scaffold(
              appBar: UIConstants.appBar(
                title: 'My Profile',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                titleCenter: false,
                backIcon: IconConstants.hamburgerMenuIcon,
                onBackIconButtonpressed: () {
                  // Handle back button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: ProfileInfo(
                      degree: student['degree'] ?? '',
                      batch: student['batch'] ?? '',
                      studentName: student['studentName'] ?? '',
                    ),
                  ),
                  const SizedBox(height: 11),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Projects',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to MyProjectsPage when "View All" is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyProjectsPage(), // Create an instance of MyProjectsPage
                              ),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: PaletteLightMode.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: FutureBuilder<List<Project>>(
                      future: _projectService.getProject(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: PaletteLightMode.secondaryGreenColor,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                'Error fetching projects: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No projects available'),
                          );
                        } else {
                          final filteredProjects =
                              _filterProjects(snapshot.data!);

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              bottom: 25,
                            ),
                            child: Scrollbar(
                              child: GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 18.0,
                                crossAxisSpacing: 25.0,
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                children: filteredProjects.map((project) {
                                  return ProjectBox(
                                    projectNumber: project.projectNumber,
                                    projectName: project.projectName,
                                    date: formatDate(project.date),
                                    githubLink: project.githubLink,
                                    onDelete: () {
                                      // Handle project deletion
                                    },
                                    id: project.id,
                                    onEdit: () {
                                      // Handle project edit
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Error: User data not available'),
              ),
            );
          }
        } else {
          // Handle the case where user data is not available
          return const Scaffold(
            body: Center(
              child: Text('User data not available'),
            ),
          );
        }
      },
    );
  }
}
