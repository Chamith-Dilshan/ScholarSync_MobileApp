import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/common/search_bar.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/common/text_form_field.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/widgets/kuppi_widget.dart';
import 'package:scholarsync/common/reusable_form_dialog.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/kuppi_repository.dart';
import '../../models/kuppi.dart';
import '../widgets/image_form_field.dart';

class KuppiPage extends StatefulWidget {
  const KuppiPage({super.key});

  @override
  State<KuppiPage> createState() => _KuppiPageState();
}

class _KuppiPageState extends State<KuppiPage> {
  File? _selectedImage;
  bool _isImageSelected = false;
  String? downloadURL;
  String _searchQuery = '';

  final KuppiRepository _kuppiRepository = KuppiRepository();

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _conductorController = TextEditingController();
  final _linkController = TextEditingController();

  Future<void> createNewKuppiSession() async {
    try {
      await uploadImage();

      KuppiSession kuppiSession = KuppiSession(
        id: '',
        name: _nameController.text.trim(),
        date: DateTime.parse(_dateController.text.trim()),
        conductor: _conductorController.text.trim(),
        link: _linkController.text.trim(),
        imageUrl: downloadURL!,
      );

      await _kuppiRepository.createKuppiSession(kuppiSession);
      setState(() {});
    } catch (e) {
      // print(e);
    }
  }

  void _handleDelete(KuppiSession session) async {
    await _kuppiRepository.deleteKuppiSession(session.id);
    _deleteImage(session);
  }

  void _deleteImage(KuppiSession session) async {
    var imageRef = FirebaseStorage.instance.refFromURL(session.imageUrl);
    await imageRef.delete();
  }

  Future uploadImage() async {
    String imageName = _selectedImage!.path.split('/').last;
    Reference ref =
        FirebaseStorage.instance.ref().child('kuppi_images/$imageName');
    await ref.putFile(_selectedImage!);
    downloadURL = await ref.getDownloadURL();
  }

  String formatDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String month = DateFormat('MMMM').format(date);
    String year = DateFormat('y').format(date);

    String daySuffix = day.endsWith('1')
        ? 'st'
        : day.endsWith('2')
            ? 'nd'
            : day.endsWith('3')
                ? 'rd'
                : 'th';

    return '$day$daySuffix $month $year';
  }

  List<KuppiSession> _filterSessions(List<KuppiSession> sessions) {
    if (_searchQuery.isEmpty) {
      return sessions; // Return all sessions if search query is empty
    } else {
      final query = _searchQuery.toLowerCase();
      return sessions.where((session) {
        return session.name.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _conductorController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _resetFormFields() {
    setState(() {
      _nameController.clear();
      _dateController.clear();
      _conductorController.clear();
      _linkController.clear();
      _selectedImage = null;
      _isImageSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: UIConstants.appBar(
            title: 'Kuppi Sessions',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            titleCenter: true,
            frontIcon: IconConstants.leftArrowIcon,
            backIcon: IconConstants.hamburgerMenuIcon,
            frontIconToolTip: 'Back to login page',
            onFrontIconButtonpressed: () {},
            onBackIconButtonpressed: () {},
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSearchBar(
                hint: 'Search for kuppi sessions...',
                onSearchSubmitted: (query) {
                  setState(() {
                    _searchQuery = query.trim();
                  });
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 18),
              Expanded(
                child: FutureBuilder<List<KuppiSession>>(
                  future: _kuppiRepository.getKuppiSessions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: PaletteLightMode.secondaryGreenColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error fetching Kuppi sessions'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No Kuppi sessions available'),
                      );
                    } else {
                      final filteredSessions = _filterSessions(snapshot.data!);

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 20),
                        // itemCount: snapshot.data!.length,
                        itemCount: filteredSessions.length,
                        itemBuilder: (context, index) {
                          KuppiSession session = filteredSessions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: KuppiWidget(
                              id: session.id,
                              title: session.name,
                              subtitle: 'by ${session.conductor}',
                              date: formatDate(session.date),
                              imageUrl: session.imageUrl,
                              link: session.link,
                              onDelete: () {
                                Future.delayed(Duration.zero).then((value) {
                                  _handleDelete(session);
                                });
                                setState(() {});
                              },
                              onEdit: () {
                                Future.delayed(Duration.zero).then((value) {
                                  _showFormDialog(context, session: session);
                                });
                                setState(() {});
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: PaletteLightMode.secondaryGreenColor,
            tooltip: 'Increment',
            onPressed: () {
              _showFormDialog(context);
            },
            child: SvgPicture.asset(
              IconConstants.addButtonIcon,
              colorFilter: const ColorFilter.mode(
                PaletteLightMode.whiteColor,
                BlendMode.srcIn,
              ),
              width: 25,
              height: 25,
            ),
          )),
    );
  }

  void _showFormDialog(BuildContext context, {KuppiSession? session}) async {
    final parentContext = context;
    bool isEditing = session != null;

    if (isEditing) {
      _nameController.text = session.name;
      _dateController.text = DateFormat('yyyy-MM-dd').format(session.date);
      _conductorController.text = session.conductor;
      _linkController.text = session.link;
      downloadURL = session.imageUrl;
    } else {
      _resetFormFields();
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return ReusableFormDialog(
          title: isEditing ? 'Edit Kuppi Session' : 'Add New Kuppi Session',
          buttonLabel: isEditing ? 'Save' : 'Add',
          formFields: [
            ImageFormField(
              initialImageUrl: isEditing ? session.imageUrl : null,
              isEditing: isEditing,
              validator: (selectedImage) {
                if (_isImageSelected == false) {
                  return 'Please select an image';
                }
                return null;
              },
              onImageSelected: (selectedImage) {
                setState(() {
                  _selectedImage = selectedImage;
                  _isImageSelected = true;
                });
              },
            ),
            ReusableTextField(
              controller: _nameController,
              labelText: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                if (value.length > 30) {
                  return 'Name must not exceed 30 characters';
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
              controller: _conductorController,
              labelText: 'Conducted by',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the conductor';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            ReusableTextField(
              controller: _linkController,
              labelText: 'Link to join',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the link to join';
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
            if (_isImageSelected) {
              if (isEditing) {
                // Delete the old image
                _deleteImage(session);

                // Upload the new image and get the download URL
                await uploadImage();

                // Update the session properties
                session.name = _nameController.text.trim();
                session.date = DateTime.parse(_dateController.text.trim());
                session.conductor = _conductorController.text.trim();
                session.link = _linkController.text.trim();
                session.imageUrl = downloadURL!;

                // Update the session in the repository
                await _kuppiRepository.updateKuppiSession(session);

                setState(() {});
              } else {
                // Create a new session
                await createNewKuppiSession();
              }
            }
          },
          onPop: () {
            setState(() {
              _selectedImage = null;
            });
          },
        );
      },
    );
  }
}
