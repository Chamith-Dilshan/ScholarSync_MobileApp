import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/button_icon.dart';
import '../../constants/icon_constants.dart';
import '../../theme/palette.dart';

class ImageFormField extends StatefulWidget {
  final Function(File) onImageSelected;
  final String? Function(File?) validator;
  final bool isEditing;
  final String? initialImageUrl;

  const ImageFormField({
    super.key,
    required this.onImageSelected,
    required this.validator,
    this.isEditing = false,
    this.initialImageUrl,
  });

  @override
  State<ImageFormField> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  File? _selectedImage;
  bool _isImageSelected = false;

  Future<void> imagePicker() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _isImageSelected = true;
      });

      widget.onImageSelected(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File?>(
      validator: (value) {
        return widget.validator.call(value);
      },
      builder: (state) {
        return GestureDetector(
          onTap: () async {
            await imagePicker();
          },
          child: Column(
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
                    : widget.isEditing
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.initialImageUrl!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
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
              if (!_isImageSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    state.errorText ?? '',
                    style: const TextStyle(
                      color: PaletteLightMode.errorColor,
                      fontSize: 12,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
