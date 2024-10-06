import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatefulWidget {
  final Widget? icon;
  final Widget? rightIcon;
  final bool isSwitchableMode;
  final bool? isEditable;
  final String? text;
  final Function(String)? onChanged;
  final String? Function(String?) validation;
  final String? placeholder;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final int? maxSymbols;
  final TextEditingController controller;
  const Input(
      {super.key,
      required this.controller,
      this.maxSymbols,
      required this.validation,
      this.icon,
      this.isSwitchableMode = false,
      this.isEditable,
      this.text,
      this.onChanged,
      this.rightIcon,
      this.obscureText = false,
      this.enableSuggestions = true,
      this.autocorrect = false,
      this.placeholder});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool? _isEditable;
  String? errorText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.text ?? '';
    _isEditable = widget.isEditable;
    _focusNode = FocusNode();
    widget.controller.addListener(() {
      setState(() {
        errorText = widget.validation(widget.controller.text);
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                validator: widget.validation,
                autovalidateMode: AutovalidateMode.always,
                maxLength: widget.maxSymbols,
                obscureText: widget.obscureText,
                enableSuggestions: widget.enableSuggestions,
                autocorrect: widget.autocorrect,
                onChanged: widget.onChanged,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                    errorStyle: const TextStyle(fontSize: 0),
                    counterText: '',
                    focusColor: const Color(0xFF868889),
                    icon: widget.icon,
                    suffixIcon: widget.rightIcon != null
                        ? SizedBox(
                            height: 24, width: 24, child: widget.rightIcon)
                        : null,
                    prefixIconColor: const Color(0xFF868889),
                    suffixIconColor: const Color(0xFF868889),
                    border: InputBorder.none,
                    hintText: widget.placeholder),
                controller: widget.controller,
                textAlignVertical: widget.rightIcon != null
                    ? TextAlignVertical.center
                    : TextAlignVertical.top,
                focusNode: _focusNode,
                enabled: _isEditable,
                cursorColor: const Color(0xFF000000),
                style: TextStyle(
                    fontSize: 14.fontSize,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                    fontFamily: 'Hind Siliguri'),
              ),
            ),
            widget.isSwitchableMode
                ? IconButton(
                    icon: const Icon(
                      Icons.edit_note,
                      color: Color(0xFF5B67CA),
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditable = true;
                        Future.delayed(const Duration(milliseconds: 50), () {
                          FocusScope.of(context).requestFocus(_focusNode);
                        });
                      });
                    })
                : Container()
          ],
        ),
        Column(
          children: [
            Container(
              height: 1,
              color: errorText == null ? const Color(0xFFE3E8F1) : dangerColor,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText ?? '',
                style: const TextStyle(color: dangerColor),
              ),
            )
          ],
        ),
      ],
    );
  }
}
