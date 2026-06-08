
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';


class FormBuilderStatic<DType> extends StatelessWidget{

  final DType initialValue;
  final String name;
  final Widget child;
  final InputDecoration decoration;
  const FormBuilderStatic({
    super.key,
    required this.initialValue,
    required this.child,
    required this.name,
    required this.decoration
  });
  @override
  Widget build(BuildContext context) {
    return FormBuilderField<DType>(
        builder: (field) => InputDecorator(
          decoration: decoration.copyWith(
            contentPadding: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 10
            ),
          ),
          child: child,
        ),
        initialValue: initialValue,
        name: name
    );
  }

}