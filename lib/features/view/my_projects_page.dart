import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/student_repository.dart';

import '../../common/project_box.dart';
import '../../common/reusable_form_dialog.dart';
import '../../common/search_bar.dart';
import '../../common/text_form_field.dart';
import '../../constants/ui_constants.dart';
import '../../models/project.dart';
import '../../utils/date_format.dart';
import '../widgets/drawer_menu.dart';
import 'home_page.dart';

void main() {
  runApp(const MyProjectsPage());
}

class MyProjectsPage extends StatefulWidget {
  const MyProjectsPage({super.key});

  @override
  State<MyProjectsPage> createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  final StudentRepository studentRepository = StudentRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _linkController = TextEditingController();

  Future<void> createNewProject() async {
    try {
      Project project = Project(
        name: _nameController.text,
        date: DateTime.parse(_dateController.text),
        link: _linkController.text,
      );

      await StudentRepository.createNewProject(project);
      setState(() {});
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomDrawerMenu(),
      appBar: UIConstants.appBar(
        title: 'My Projects',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            CustomSearchBar(
              hint: 'Search for projects...',
              onSearchSubmitted: (query) {},
              // Handle search query change
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: studentRepository.fetchProjectsForStudent(),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: PaletteLightMode.secondaryGreenColor,
                      ),
                    );
                  } else if (projectSnapshot.hasError) {
                    return Center(child: Text('Error${projectSnapshot.error}'));
                  } else if (projectSnapshot.data != null &&
                      projectSnapshot.data!.isNotEmpty) {
                    final List<Project>? projects = projectSnapshot.data;
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
                                    projectNumber: (index + 1).toString(),
                                    projectName: project.name,
                                    date: FormatDate.projectformatDate(
                                        project.date),
                                    githubLink: project.link,
                                  );
                                } else if (index == projects.length) {
                                  return _buildAddProjectBox();
                                } else {
                                  return Container();
                                }
                              },
                              childCount: projects!.length < 4
                                  ? projects.length + 1
                                  : 4,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return _buildAddProjectBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProjectBox() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: PaletteLightMode.shadowColor,
            offset: Offset(8, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center, // Center the add icon in the circle
        children: [
          // The small circle with green background
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: PaletteLightMode.secondaryGreenColor,
              shape: BoxShape.circle,
            ),
          ),
          // The add icon in the center of the circle
          IconButton(
            icon: SvgPicture.asset(
              IconConstants.addButtonIcon,
              // ignore: deprecated_member_use
              color: PaletteLightMode.whiteColor,
            ),
            tooltip: 'Increment',
            onPressed: () {
              _showFormDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFormDialog(BuildContext context, {Project? project}) async {
    bool isEditing = project != null;

    if (isEditing) {
      _nameController.text = project.name;
      _dateController.text =
          FormatDate.projectformatDate(DateTime.parse(project.date.toString()));
      _linkController.text = project.link;
    } else {
      _nameController.clear();
      _dateController.clear();
      _linkController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableFormDialog(
          title: isEditing ? 'Edit Project' : 'Add New Project',
          buttonLabel: isEditing ? 'Save' : 'Add',
          formFields: [
            const SizedBox(height: 15),
            ReusableTextField(
              controller: _nameController,
              labelText: 'Project Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            ReusableTextField(
              controller: _dateController,
              labelText: 'Date',
              isDateField: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            ReusableTextField(
              controller: _linkController,
              labelText: 'Github Link',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the GitHub link';
                }

                final Uri uri = Uri.parse(value);
                if (uri.scheme.isEmpty || uri.host.isEmpty) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
              onSaved: (value) {},
            ),
          ],
          onSubmit: (formData) async {
            await createNewProject();
          },
        );
      },
    );
  }
}
