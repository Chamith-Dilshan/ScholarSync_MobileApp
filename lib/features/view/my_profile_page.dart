import 'package:flutter/material.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/student_repository.dart';
import '../../common/project_box.dart';
import '../../constants/icon_constants.dart';
import '../../constants/ui_constants.dart';
import '../../models/project.dart';
import '../../models/student.dart';
import '../../utils/date_format.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/profile_info.dart';
import 'my_projects_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final StudentRepository studentService = StudentRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<Student?> _fetchUser() async {
    final userData = await studentService.fetchStudentData();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: const CustomDrawerMenu(),
        appBar: UIConstants.appBar(
          title: 'My Profile',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          titleCenter: false,
          backIcon: IconConstants.hamburgerMenuIcon,
          onBackIconButtonpressed: () {
            _scaffoldKey.currentState!.openEndDrawer(); // Open the end drawer
          },
        ),
        body: FutureBuilder(
            future: _fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: PaletteLightMode.secondaryGreenColor,
                ));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              } else {
                final student = snapshot.data!;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileInfo(
                        id: student.id,
                        profileImageUrl: student.profileImageUrl!,
                        firstName: student.firstName,
                        lastName: student.lastName,
                        degreeProgram: student.degreeProgram,
                        batch: student.batch,
                        studentId: student.studentId,
                      ),
                      const SizedBox(height: 15),
                      Row(
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
                              Route route = MaterialPageRoute(
                                  builder: (context) => const MyProjectsPage());
                              Navigator.push(context, route);
                            },
                            child: TextButton(
                              onPressed: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const MyProjectsPage());
                                Navigator.push(context, route);
                              },
                              child: const Text(
                                'view all',
                                style: TextStyle(
                                  color: PaletteLightMode.textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: FutureBuilder(
                          future: studentService.fetchProjectsForStudent(),
                          builder: (context, projectSnapshot) {
                            if (projectSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: PaletteLightMode.secondaryGreenColor,
                                ),
                              );
                            } else if (projectSnapshot.hasError) {
                              return Center(
                                  child: Text('Error${projectSnapshot.error}'));
                            } else if (projectSnapshot.data != null &&
                                projectSnapshot.data!.isNotEmpty) {
                              final List<Project>? projects =
                                  projectSnapshot.data;
                              return CustomScrollView(
                                physics: const BouncingScrollPhysics(),
                                slivers: [
                                  SliverPadding(
                                    padding: const EdgeInsets.all(0),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200.0,
                                        mainAxisSpacing: 20.0,
                                        crossAxisSpacing: 20.0,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          if (index < projects.length) {
                                            final project = projects[index];
                                            return ProjectBox(
                                              projectNumber:
                                                  (index + 1).toString(),
                                              projectName: project.name,
                                              date:
                                                  FormatDate.projectformatDate(
                                                      DateTime.parse(project
                                                          .date
                                                          .toString())),
                                              githubLink: project.link,
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                        childCount: projects!.length < 4
                                            ? projects.length
                                            : 4,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(child: Text('No projects'));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
