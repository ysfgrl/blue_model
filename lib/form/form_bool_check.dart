
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class FormBuilderBoolCheck extends StatelessWidget{
  final bool initialValue;
  final String name;
  final void Function(bool?)? onSaved;
  final void Function(bool?)? onChanged;
  final Text title;
  final FormFieldValidator<bool>? validator;
  final AutovalidateMode autovalidateMode;
  final InputDecoration? decoration;
  const FormBuilderBoolCheck({
    super.key,
    required this.name,
    this.initialValue = false,
    required this.title,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.decoration,
    this.autovalidateMode = AutovalidateMode.disabled,
  });
  @override
  Widget build(BuildContext context) {
    return FormBuilderFieldDecoration<bool>(
      name: name,
      initialValue: initialValue,
      onSaved:  onSaved,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<bool?> field) {
        return InputDecorator(
          decoration: decoration ?? const InputDecoration(
              border: InputBorder.none
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                onChanged: field.didChange,
                value: field.value ?? false,
              ),
              Expanded(child: title,)
            ],
          ),
        );
      },
    );
  }
}