import 'package:flutter/material.dart';
import 'package:scholarsync/theme/palette.dart';

import '../constants/icon_constants.dart';
import '../features/widgets/circular_icon_button.dart';

class CustomSearchBar extends StatefulWidget {
  final String hint;
  final Color? textColor;
  final Color? iconColor;
  final ValueChanged<String>? onSearchSubmitted;

  const CustomSearchBar({
    Key? key,
    required this.hint,
    this.textColor = PaletteLightMode.secondaryTextColor,
    this.iconColor = PaletteLightMode.secondaryTextColor,
    this.onSearchSubmitted,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late FocusNode _focusNode;
  final TextEditingController _textEditingController = TextEditingController();
  bool _showClearIcon = false;
  Color? _currentIconColor;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _currentIconColor = widget.iconColor;
    _focusNode.addListener(_onFocusChange);
    _textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _currentIconColor = _focusNode.hasFocus
          ? PaletteLightMode.secondaryGreenColor
          : widget.iconColor;
      _showClearIcon = _textEditingController.text.isNotEmpty;
    });
  }

  void _onTextChanged() {
    setState(() {
      _showClearIcon = _textEditingController.text.isNotEmpty;
    });
  }

  void _clearSearch() {
    _textEditingController.clear();
    if (widget.onSearchSubmitted != null) {
      widget.onSearchSubmitted!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(11, 24, 43, 0.08),
            offset: Offset(8, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _textEditingController,
        onSubmitted: widget.onSearchSubmitted,
        style: TextStyle(color: widget.textColor),
        cursorColor: PaletteLightMode.secondaryGreenColor,
        focusNode: _focusNode,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hint,
          hintStyle: TextStyle(color: widget.textColor),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: CircularIconButton(
              buttonSize: 45,
              iconAsset: IconConstants.searchIcon,
              iconColor: _currentIconColor!,
              buttonColor: PaletteLightMode.transparentColor,
              onPressed: _clearSearch,
            ),
          ),
          suffixIcon: _showClearIcon
              ? CircularIconButton(
                  buttonSize: 30,
                  iconAsset: IconConstants.closeIcon,
                  iconColor: _currentIconColor!,
                  buttonColor: PaletteLightMode.transparentColor,
                  onPressed: _clearSearch,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: PaletteLightMode.secondaryGreenColor, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
