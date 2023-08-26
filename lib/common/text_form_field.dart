import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/theme/palette.dart';

import '../constants/icon_constants.dart';
import '../features/widgets/circular_icon_button.dart';

class ReusableTextField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool obscureText;
  final bool isDense;
  final bool isMultiline;
  final bool isDateField;
  final int lines;

  final TextEditingController? controller;

  const ReusableTextField({
    Key? key,
    required this.labelText,
    this.initialValue = '',
    this.lines = 10,
    this.validator,
    this.onSaved,
    this.controller,
    this.obscureText = false,
    this.isDense = false,
    this.isMultiline = false,
    this.isDateField = false,
  }) : super(key: key);

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(
              color: PaletteLightMode.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (widget.isDateField) {
                _showDatePicker();
              }
            },
            child: AbsorbPointer(
              absorbing: widget.isDateField,
              child: TextFormField(
                keyboardType: widget.isMultiline
                    ? TextInputType.multiline
                    : TextInputType.text,
                maxLines: widget.isMultiline ? widget.lines : 1,
                controller: widget.controller,
                initialValue:
                    widget.controller != null ? null : widget.initialValue,
                validator: (value) {
                  return widget.validator?.call(value);
                },
                onSaved: widget.onSaved,
                obscureText: widget.obscureText,
                cursorColor: PaletteLightMode.secondaryGreenColor,
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: PaletteLightMode.secondaryTextColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: PaletteLightMode.secondaryGreenColor,
                    ),
                  ),
                  isDense: widget.isDense,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  errorMaxLines: null,
                  suffixIcon: widget.isDateField
                      ? CircularIconButton(
                          buttonSize: 40,
                          iconAsset: IconConstants.calendarIcon,
                          iconColor: PaletteLightMode.secondaryTextColor,
                          buttonColor: PaletteLightMode.transparentColor,
                          onPressed: () {},
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.controller != null
          ? widget.controller!.text.isNotEmpty
              ? DateTime.parse(widget.controller!.text)
              : DateTime.now()
          : _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        if (widget.controller != null) {
          widget.controller!.text =
              DateFormat('yyyy-MM-dd').format(pickedDate).toString();
        }
      });
    }
  }
}
