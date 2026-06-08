
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';
import '../json_editor/blue_json_editor.dart';

final class FormBuilderJson extends StatelessWidget{
  final Map<String, dynamic> initialValue;
  final String name;
  final void Function(Map<String, dynamic>?)? onSaved;
  final void Function(Map<String, dynamic>?)? onChanged;
  final double width;
  final double height;
  final Text title;
  final List<FJSONAction> actions;
  final FJSONActionCallback? actionCallback;
  final FJSONMenuEventCallback? menuEvent;
  final FormFieldValidator<Map<String, dynamic>>? validator;
  final AutovalidateMode autovalidateMode;
  const FormBuilderJson({
    super.key,
    required this.name,
    this.onSaved,
    this.onChanged,
    required this.initialValue,
    this.width = double.infinity,
    this.height = 60,
    required this.title,
    this.actions = const [],
    this.actionCallback,
    this.menuEvent,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: height,
          maxWidth: width
      ),
      child: FormBuilderField<Map<String, dynamic>>(
        builder: (field) {
          return InputDecorator(
              decoration: const InputDecoration(
                  border: InputBorder.none
              ),
              child: FJSONEditor(
                jsonData: initialValue,
                title: title,
                isEditable: true,
                topActions: actions,
                actionCallback: actionCallback,
                menuEvent: menuEvent,
              ),

          );
        },
        onChanged: onChanged,
        onSaved: onSaved,
        initialValue: initialValue,
        name: name,
        validator: validator,
        autovalidateMode: autovalidateMode,
        onReset: () {

        },
      ),
    );
  }

}