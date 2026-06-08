import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBuilderNumber extends StatelessWidget {
  static final RegExp _numeric = RegExp(r'^(0|[1-9][0-9]*)$');
  final TextEditingController? _controller;
  final GlobalKey<FormFieldState<int?>>? inputKey;
  final int? initialValue;
  final String name;
  final void Function(int?)? onSaved;
  final void Function(int?)? onChanged;
  final InputDecoration? decoration;
  final FormFieldValidator<int>? validator;
  final AutovalidateMode autovalidateMode;
  FormBuilderNumber({
    super.key,
    required this.name,
    this.initialValue = 0,
    this.onSaved,
    this.inputKey,
    this.onChanged,
    this.decoration,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    TextEditingController? controller,
  }): _controller = controller ?? TextEditingController(text: initialValue.toString());

  @override
  Widget build(BuildContext context) {
    return FormBuilderFieldDecoration<int>(
      name: name,
      key: inputKey,
      autovalidateMode: autovalidateMode,
      initialValue: initialValue,
      onSaved:  onSaved,
      onChanged: onChanged,
      validator: validator,
      builder: (FormFieldState<int> field) {
        return TextField(
          controller: _controller,
          decoration: decoration ?? InputDecoration(
            labelText: name,
          ),
          onChanged: (value) {
            if(_numeric.hasMatch(value)) {
              field.didChange(int.parse(value));
            }
          },
        );
      },
    );
  }
}
