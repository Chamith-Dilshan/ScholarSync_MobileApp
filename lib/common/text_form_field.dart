import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scholarsync/theme/palette.dart';

class ReusableTextField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool obscureText;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color cursorColor;
  final double borderRadius;
  final bool isDense;
  final bool isMultiline;
  final bool isDateField;

  final TextEditingController? controller;

  const ReusableTextField({
    Key? key,
    required this.labelText,
    this.initialValue = '',
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.borderColor = PaletteLightMode.secondaryTextColor,
    this.focusedBorderColor = PaletteLightMode.secondaryGreenColor,
    this.cursorColor = PaletteLightMode.secondaryGreenColor,
    this.borderRadius = 8.0,
    this.isDense = false,
    this.controller,
    this.isMultiline = false,
    this.isDateField = false,
  }) : super(key: key);

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool _hasError = false;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(
          height: _calculateHeight(),
          child: TextFormField(
            keyboardType: widget.isMultiline
                ? TextInputType.multiline
                : TextInputType.text,
            maxLines: widget.isMultiline ? 10 : 1,
            controller: widget.controller,
            initialValue:
                widget.controller != null ? null : widget.initialValue,
            validator: (value) {
              setState(() {
                _hasError = widget.validator?.call(value) != null;
              });
              return widget.validator?.call(value);
            },
            onSaved: widget.onSaved,
            obscureText: widget.obscureText,
            cursorColor: widget.cursorColor,
            style: const TextStyle(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.focusedBorderColor,
                ),
              ),
              isDense: widget.isDense,
              contentPadding: const EdgeInsets.all(8),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              errorMaxLines: null,
              suffixIcon: widget.isDateField // Add this condition
                  ? IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: widget.controller != null
                              ? widget.controller!.text.isNotEmpty
                                  ? DateTime.parse(widget.controller!.text)
                                  : DateTime.now()
                              : _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            if (widget.controller != null) {
                              widget.controller!.text = DateFormat('yyyy-MM-dd')
                                  .format(pickedDate)
                                  .toString();
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      iconSize: 18,
                    )
                  : null, // Set suffixIcon to null if isDateField is false
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  double _calculateHeight() {
    if (_hasError && widget.isMultiline) {
      return 150.0;
    } else if (_hasError && !widget.isMultiline) {
      return 50.0;
    } else if (!_hasError && widget.isMultiline) {
      return 100.0;
    } else {
      return 30.0;
    }
  }
}
