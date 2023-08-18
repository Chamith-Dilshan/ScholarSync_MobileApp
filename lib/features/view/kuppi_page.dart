import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/common/button_icon.dart';
import 'package:scholarsync/common/search_bar.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/common/text_form_field.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/widgets/kuppi_widget.dart';
import 'package:scholarsync/common/reusable_form_dialog.dart';
import 'package:scholarsync/theme/palette.dart';
import 'package:scholarsync/utils/kuppi_repository.dart';
import '../../models/kuppi.dart';

final KuppiRepository _kuppiRepository = KuppiRepository();

class KuppiPage extends StatefulWidget {
  const KuppiPage({super.key});

  @override
  State<KuppiPage> createState() => _KuppiPageState();
}

class _KuppiPageState extends State<KuppiPage> {
  File? _selectedImage;
  bool _isImageSelected = false;
  String? downloadURL;

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _conductorController = TextEditingController();
  final _linkController = TextEditingController();

  Future<void> imagePicker(StateSetter setState) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _isImageSelected = true;
      });
    }
  }

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
      print(e);
    }
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
    return Scaffold(
        appBar: UIConstants.appBar(
          title: 'Kuppi Sessions',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          titleCenter: true,
          frontIcon: IconConstants.leftArrowIcon,
          backIcon: IconConstants.hamburgerMenuIcon,
          frontIconToolTip: 'Back to login page',
          onFrontIconButtonpressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const HomePage()),
            // );
          },
          onBackIconButtonpressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSearchBar(
              hint: 'Search for kuppi sessions...',
              onSearchSubmitted: (query) {},
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
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        KuppiSession session = snapshot.data![index];
                        return ImageWithTextWidget(
                          id: session.id,
                          title: session.name.toUpperCase(),
                          subtitle: 'by ${session.conductor}',
                          date: formatDate(session.date),
                          imageUrl: session.imageUrl,
                          onDelete: () {
                            setState(() {});
                          },
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
        ));
  }

  void _showFormDialog(BuildContext context) async {
    _resetFormFields();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableFormDialog(
          title: 'Add New Kuppi Session',
          buttonLabel: 'Add',
          formFields: [
            const SizedBox(height: 5),
            StatefulBuilder(
              builder: (context, setState) {
                return _buildImagePicker(setState);
              },
            ),
            const SizedBox(height: 15),
            ReusableTextField(
              controller: _nameController,
              labelText: 'Name',
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
              controller: _conductorController,
              labelText: 'Conducted by',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name of the conductor';
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
              await createNewKuppiSession();
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

  Widget _buildImagePicker(StateSetter setState) {
    return GestureDetector(
      onTap: () async {
        await imagePicker(setState);
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: PaletteLightMode.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: PaletteLightMode.shadowColor,
              offset: Offset(8, 8),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: _isImageSelected
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              )
            : Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: PaletteLightMode.secondaryTextColor,
                    shape: BoxShape.circle,
                  ),
                  child: const ButtonIcon(
                    icon: IconConstants.cameraIcon,
                    iconColor: PaletteLightMode.whiteColor,
                    size: 20,
                  ),
                ),
              ),
      ),
    );
  }
}
