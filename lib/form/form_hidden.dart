
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';


class FormBuilderHidden<DType> extends StatelessWidget{

  final DType initialValue;
  final String name;
  const FormBuilderHidden({
    super.key,
    required this.initialValue,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<DType>(
        builder: (field) => const InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none
          ),
          child: SizedBox(),
        ),
        initialValue: initialValue,
        name: name
    );
  }

}