import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scholarsync/common/button_icon.dart';
import 'package:scholarsync/common/search_bar.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/common/text_form_field.dart';
import 'package:scholarsync/constants/ui_constants.dart';
import 'package:scholarsync/features/widgets/kuppi_widget.dart';
import 'package:scholarsync/constants/image_constants.dart';
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
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _conductorController = TextEditingController();
  final _linkController = TextEditingController();

  // Future addKuppiSession() async {
  //   await FirebaseFirestore.instance.collection('kuppis').add({
  //     'date': _dateController.text.trim(),
  //     'name': _nameController.text.trim(),
  //     'conductor': _conductorController.text.trim(),
  //     'link': _linkController.text.trim(),
  //   });
  // }

  Future<void> createNewKuppiSession() async {
    KuppiSession kuppiSession = KuppiSession(
      id: '',
      name: _nameController.text.trim(),
      date: _dateController.text.trim(),
      conductor: _conductorController.text.trim(),
      link: _linkController.text.trim(),
    );

    await _kuppiRepository.createKuppiSession(kuppiSession);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _conductorController.dispose();
    _linkController.dispose();
    super.dispose();
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
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                children: const [
                  ImageWithTextWidget(
                    title: 'MICROPYTHON',
                    subtitle: 'by ATD Gamage',
                    date: '30th July, 2023',
                    imagePath: ImageConstants.kuppi1,
                  ),
                  SizedBox(height: 20),
                  ImageWithTextWidget(
                    title: 'Mathematics for Computing',
                    subtitle: 'by ATD Gamage',
                    date: '30th July, 2023',
                    imagePath: ImageConstants.kuppi1,
                  ),
                ],
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

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableFormDialog(
          title: 'Add New Kuppi Session',
          buttonLabel: 'Add',
          formFields: [
            const SizedBox(height: 5),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
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
                      )
                    ],
                  ),
                ),
                Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: PaletteLightMode.secondaryTextColor,
                      shape: BoxShape.circle,
                    ),
                    child: ButtonIcon(
                      icon: IconConstants.cameraIcon,
                      iconColor: PaletteLightMode.whiteColor,
                      size: 20,
                      onTap: () {},
                    )),
              ],
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
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
                return null;
              },
              onSaved: (value) {},
            ),
          ],
          onSubmit: (formData) async {
            await createNewKuppiSession();
          },
        );
      },
    );
  }
}
