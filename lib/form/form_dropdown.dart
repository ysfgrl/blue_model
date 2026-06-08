
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';


class FormBuilderDropDown<VType> extends FormBuilderDropdown<VType>{
  FormBuilderDropDown({
    super.key,
    required super.name,
    required super.items,
    super.validator,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    super.isExpanded = true,
    super.isDense = true,
    super.elevation = 8,
    super.iconSize = 24.0,
    super.style,
    super.disabledHint,
    super.icon,
    super.iconDisabledColor,
    super.iconEnabledColor,
    super.onTap,
    super.autofocus = false,
    super.dropdownColor,
    super.focusColor,
    super.itemHeight,
    super.selectedItemBuilder,
    super.menuMaxHeight,
    super.enableFeedback,
    super.borderRadius,
    super.alignment = AlignmentDirectional.centerStart,
  });

}