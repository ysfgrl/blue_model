
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';


class FormBuilderSelect<DType extends BaseModel,FType> extends StatelessWidget{
  DType? initialValue;
  final String name;
  final Widget Function(DType, bool isSelected, int itemIndex) listItemBuilder;
  final Widget Function(DType?) childBuilder;
  final FType? Function(DType?) valueBuilder;
  final void Function(FType?)? onSaved;
  final void Function(FType?)? onChanged;
  final double width;
  final double height;
  final InputDecoration decoration;
  final ListBloc<DType> listBloc;
  final bool enabled;
  final GlobalKey<FormFieldState<FType>>? inputKey;
  FormBuilderSelect({
    super.key,
    this.inputKey,
    required this.listBloc,
    required this.listItemBuilder,
    required this.childBuilder,
    required this.valueBuilder,
    required this.name,
    this.enabled = true,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.width = double.infinity,
    this.height = 60,
    required this.decoration
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: height,
          maxWidth: width
      ),
      child: FormBuilderField<FType>(
          key: inputKey,
          builder: (field) => InputDecorator(
            decoration: decoration.copyWith(
                contentPadding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 10
                ),
                suffixIcon: enabled ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () async {
                      var res = await select(context);
                      if(res == null) return;
                      initialValue = res.firstOrNull;
                      field.didChange(valueBuilder(initialValue));
                    }, icon: const Icon(Icons.search_rounded)),
                    IconButton(onPressed: () async {
                      initialValue = null;
                      field.didChange(valueBuilder(initialValue));
                    }, icon: const Icon(Icons.close, color: Colors.red,))
                  ],
                ): null
            ),
            expands: true,
            child: childBuilder(initialValue),
          ),
          onChanged: onChanged,
          onSaved: onSaved,
          initialValue: valueBuilder(initialValue),
          name: name
      ),
    );
  }

  Future<List<DType>?> select(BuildContext context) async{
    if(initialValue == null){
      listBloc.add(const ListClearSelectedEvent());
    }else{
      listBloc.add(ListSetSelectedEvent<DType>([initialValue!]));
    }
    return await selectWidget.select(context);
  }

  BlueList<DType>? _selectWidget;
  BlueList<DType> get selectWidget => _selectWidget ??= BlueList<DType>(
    listBloc: listBloc,
    listViewBuilder: listItemBuilder ,
    selectedBuilder: (ctx,selected) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton(onPressed: () {
            listBloc.add(ListClearSelectedEvent());
          }, child: Text("Clear")),
          FilledButton(onPressed: () {
            Navigator.pop(ctx, listBloc.state.selected);
          }, child: Text("Select")),
          FilledButton(onPressed: () {
            Navigator.pop(ctx);
          }, child: Text("Close"))
        ],
      );
    },
  );

}