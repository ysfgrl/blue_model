import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';



import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';

class FormBuilderDropDownRepo<SType extends BaseModel, VType> extends StatelessWidget{
  final GlobalKey<FormFieldState<VType>>? inputKey;
  final VType? initialValue;
  final String name;
  final InputDecoration decoration;
  final void Function(VType?)? onSaved;
  final void Function(VType?)? onChanged;
  final DropdownMenuItem<VType> Function(SType) itemBuilder;
  final ListBloc<SType> listBloc;
  final FormFieldValidator<VType>? validator;
  final AutovalidateMode autovalidateMode;
  const FormBuilderDropDownRepo({
    super.key,
    required this.name,
    required this.itemBuilder,
    this.initialValue,
    this.inputKey,
    this.decoration = const InputDecoration(),
    this.onSaved,
    this.onChanged,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    required this.listBloc,
    GlobalKey<FormFieldState<VType>>? stateKey,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc<SType>, ListState<SType>>(
      bloc: listBloc,
      builder: (context, state) {
        if(state.listState == ListBlocDataState.init){
          listBloc.add(const ListGetListEvent());
        }
        if(state.listState != ListBlocDataState.loaded){
          return const LinearProgressIndicator();
        }
        var items = state.list.map((e) => itemBuilder(e),).toList();
        bool isExist = false;
        for(var i in items){
          if(i.value == initialValue){
            isExist = true;
            break;
          }
        }
        if(!isExist && initialValue !=null) {
          items.add(DropdownMenuItem<VType>(child: Text("...."), value: initialValue,));
        }
        items.add(DropdownMenuItem<VType>(child: Text("Select...")));

        return FormBuilderDropdown<VType>(
          key: inputKey,
          name: name,
          items: items,
          initialValue: initialValue,
          onSaved: onSaved,
          onChanged: onChanged,
          decoration: decoration,
          validator: validator,
          autovalidateMode: autovalidateMode,
        );
      },
    );
  }

}