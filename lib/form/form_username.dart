import 'package:blue_model/blue_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormBuilderUsername extends StatefulWidget {
  final String name;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final Future<String> Function(String?)? apiValidation;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final InputDecoration decoration;

  const FormBuilderUsername({
    super.key,
    required this.name,
    required this.decoration,
    this.initialValue,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.apiValidation,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  State<FormBuilderUsername> createState() => _FormBuilderUsernameState();
}

class _FormBuilderUsernameState extends State<FormBuilderUsername> {
  final inputKey = GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>();

  bool isValid = false;
  bool isChecking = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilderText(
      key: inputKey,
      name: widget.name,
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      onChanged: (value) async {
        setState(() {
          isChecking = true;
          isValid = false;
        });

        if (widget.apiValidation != null) {
          final apiError = await widget.apiValidation!(value);
          setState(() {
            isValid = apiError.isEmpty;
            isChecking = false;
          });
          if(isValid){
            inputKey.currentState?.validate();
          }else{
            inputKey.currentState?.invalidate(apiError);
          }
        }
        widget.onChanged?.call(value);
      },
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      decoration: widget.apiValidation == null? widget.decoration:
      widget.decoration.copyWith(
        suffixIcon: isChecking
            ? const SizedBox(
          width: 18,
          height: 18,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        )
            : isValid
            ? const Icon(Icons.check_circle_outline, color: Colors.green)
            : const Icon(Icons.close, color: Colors.red),
      ),
    );
  }
}