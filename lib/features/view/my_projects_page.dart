// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/common/project_box.dart';
import 'package:scholarsync/common/reusable_form_dialog.dart';
import 'package:scholarsync/common/search_bar.dart';
import 'package:scholarsync/common/text_form_field.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/features/view/my_profile_page.dart';
import 'package:scholarsync/models/projects.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/project_repository.dart';

void main() {
  runApp(const MyProjectsPage());
}

class MyProjectsPage extends StatefulWidget {
  const MyProjectsPage({super.key});

  @override
  State<MyProjectsPage> createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  String _searchQuery = '';
  final ProjectService _projectService = ProjectService();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _githubLinkController = TextEditingController();

  String formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  Future<void> createNewProject() async {
    try {
      Project project = Project(
        id: '',
        projectName: _nameController.text.trim(),
        date: DateTime.parse(_dateController.text.trim()),
        githubLink: _githubLinkController.text.trim(),
        projectNumber: '',
      );
      await _projectService.createProject(project);
      setState(() {});
    } catch (e) {
      // Handle the error
    }
  }

  void _handleDelete(Project project) async {
    await _projectService.deleteProject(project.id);
    setState(() {});
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
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _githubLinkController.dispose();
    super.dispose();
  }

  void _resetFormFields() {
    setState(() {
      _nameController.clear();
      _dateController.clear();
      _githubLinkController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            MaterialPageRoute(builder: (context) => const MyProfilePage()),
          );
        },
        onBackIconButtonpressed: () {
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogInPage()),
          );*/
        },
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hint: 'Search for projects...',
            onSearchSubmitted: (query) {
              setState(() {
                _searchQuery = query.trim();
              });
              FocusScope.of(context).unfocus();
            },
          ),
          Expanded(
            child: FutureBuilder<List<Project>>(
              future: _projectService.getProject(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: PaletteLightMode.secondaryGreenColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching projects'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No projects available'),
                  );
                } else {
                  final filteredProjects = _filterProjects(snapshot.data!);
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 25.0,
                    ),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      Project project = filteredProjects[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 25,
                        ),
                        child: ProjectBox(
                          id: project.id,
                          projectNumber: project.projectNumber,
                          projectName: project.projectName,
                          date: formatDate(project.date),
                          githubLink: project.githubLink,
                          onDelete: () {
                            _handleDelete(project);
                          },
                          onEdit: () {
                            _showFormDialog(context, project: project);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          _buildAddProjectBox(),
        ],
      ),
    );
  }

  Widget _buildAddProjectBox() {
    return Container(
      decoration: BoxDecoration(
        color: PaletteLightMode.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: PaletteLightMode.shadowColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
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
              color: PaletteLightMode.whiteColor,
            ),
            tooltip: 'Add Project',
            onPressed: () {
              _showFormDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFormDialog(BuildContext context, {Project? project}) {
    final isEditing = project != null;

    if (isEditing) {
      _nameController.text = project.projectName;
      _dateController.text = DateFormat('yyyy-MM-dd').format(project.date);
      _githubLinkController.text = project.githubLink;
    } else {
      _resetFormFields();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableFormDialog(
          title: isEditing ? 'Edit Project' : 'Add New Project',
          buttonLabel: isEditing ? 'Save' : 'Add',
          formFields: [
            ReusableTextField(
              controller: _nameController,
              labelText: 'Project Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project name';
                }
                return null;
              },
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
            ),
            ReusableTextField(
              controller: _githubLinkController,
              labelText: 'GitHub Link',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the GitHub link';
                }
                // Add more validation for a valid GitHub link if needed.
                return null;
              },
            ),
          ],
          onSubmit: (formData) async {
            if (isEditing) {
              // Update the existing project
              project.projectName = _nameController.text.trim();
              project.date = DateTime.parse(_dateController.text.trim());
              project.githubLink = _githubLinkController.text.trim();
              await _projectService.updateProject(project);
            } else {
              // Create a new project
              await createNewProject();
            }
            setState(() {});
            Navigator.pop(context); // Close the dialog
          },
        );
      },
    );
  }
}
