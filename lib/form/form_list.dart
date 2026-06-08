
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';

typedef FormBuilderListItemBuilder<MType extends BaseModel> =
Widget  Function(MType item);

typedef FormBuilderValueBuilder<MType extends BaseModel, VType> =
VType  Function(MType item);

class FormBuilderList<MType extends BaseModel, VType> extends StatelessWidget{
  final GlobalKey<FormFieldState<List<MType>>> inputKey = GlobalKey();
  final List<MType> initialValue;
  final String name;
  final void Function(List<MType>?, List<VType>?)? onSaved;
  final void Function(List<MType>?, List<VType>?)? onChanged;
  final double width;
  final double height;
  final InputDecoration? decoration;
  final BlueList<MType>? selectList;
  final FormBuilderListItemBuilder<MType> itemBuilder;
  final FormBuilderValueBuilder<MType, VType> valueBuilder;
  final bool singleSelect;
  final FormFieldValidator<List<VType>>? validator;
  final AutovalidateMode autovalidateMode;
  FormBuilderList({
    super.key,
    required this.name,
    required this.itemBuilder,
    required this.valueBuilder,
    this.selectList,
    this.initialValue = const [],
    this.onSaved,
    this.onChanged,
    this.width = double.infinity,
    this.height = 60,
    this.decoration,
    this.singleSelect = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: singleSelect ? 52: height,
          maxWidth: width
      ),
      child: FormBuilderField<List<VType>>(
        builder: (field) => singleSelect ?
        _single(context, field):
        _multi(context, field),
        onChanged: (value) {
          if(onChanged!= null) onChanged!(initialValue,value);
        },
        onSaved: (value){
          if(onSaved!= null) onSaved!(initialValue,value);
        },
        initialValue: values,
        name: name,
        key: inputKey,
        onReset: () {

        },
        validator: validator,
        autovalidateMode: autovalidateMode,
      ),
    );
  }

  Widget _multi(BuildContext context, FormFieldState<List<VType>> field){
    return InputDecorator(
        decoration: _decoration,
        child: ListView(
          children: [
            Card(
              child: Center(
                child: FilledButton(onPressed: () async {
                  var selected = await selectList?.select(context);
                  if(selected != null && selected.isNotEmpty){
                    for (var value in selected) {
                      initialValue.add(value);
                      field.didChange(values);
                    }
                  }
                }, child: Icon(Icons.add)),
              ),
            ),
            ...initialValue.map((e) {
              return Row(
                children: [
                  Expanded(child: itemBuilder(e)),
                  IconButton(onPressed: () {
                    initialValue.remove(e);
                    field.didChange(values);
                  }, icon: Icon(Icons.close, color: Colors.red,))
                ],
              );
            },)
          ],
        )
    );
  }

  Widget _single(BuildContext context, FormFieldState<List<VType>> field){
    return InputDecorator(
        decoration: _decoration,
        child: Row(
          children: [
            Expanded(child: initialValue.isNotEmpty ?
            itemBuilder(initialValue[0]):
            Text("...."),
            ),
            IconButton(onPressed: () async {
              if(initialValue.isEmpty){
                var selected = await selectList?.select(context);
                if(selected != null && selected.isNotEmpty){
                  initialValue.clear();
                  initialValue.add(selected[0]);
                  field.didChange(values);
                }
              }else {
                initialValue.clear();
                field.didChange(values);
              }
            }, icon: initialValue.isEmpty ?
            Icon(Icons.add, color: Colors.green,)
                :Icon(Icons.close, color: Colors.red,)
            ),
          ],
        )
    );
  }

  List<VType> get values => initialValue.map((e) => valueBuilder(e),).toList();

  InputDecoration get _decoration => decoration?.copyWith(
      contentPadding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 10
      )
  ) ?? InputDecoration(
      labelText: "form.field.${name}",
      contentPadding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 10
      )
  );
}