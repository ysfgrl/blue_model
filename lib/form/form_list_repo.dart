
import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';

typedef FormBuilderListRepoSelect<MType extends BaseModel> = Future<List<MType>?> Function(BuildContext context, List<MType> selected);
class FormBuilderListRepo<MType extends BaseModel, VType> extends StatelessWidget{
  final GlobalKey<FormFieldState<List<MType>>>? inputKey;
  final String name;
  final void Function(List<MType>?, List<VType>?)? onSaved;
  final void Function(List<MType>?, List<VType>?)? onChanged;
  final double width;
  final double height;
  final InputDecoration? decoration;
  final ListBloc<MType> listBloc;
  final FormBuilderListItemBuilder<MType> itemBuilder;
  final FormBuilderValueBuilder<MType, VType> valueBuilder;
  final FormFieldValidator<List<VType>>? validator;
  final AutovalidateMode autovalidateMode;
  final FormBuilderListRepoSelect<MType>? selectFunc;
  FormBuilderListRepo({
    super.key,
    required this.name,
    required this.itemBuilder,
    required this.valueBuilder,
    required this.listBloc,
    this.onSaved,
    this.inputKey,
    this.onChanged,
    this.width = double.infinity,
    this.height = 60,
    this.decoration,
    this.validator,
    this.selectFunc,
    this.autovalidateMode = AutovalidateMode.disabled,
  });
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: height,
          maxWidth: width
      ),
      child: FormBuilderField<List<VType>>(
        key: inputKey,
        builder: (field) => _field(context, (p0) {
          field.didChange(p0);
        },),
        onChanged: (value) {
          if(onChanged!= null) onChanged!(list,value);
        },
        onSaved: (value){
          if(onSaved!= null) onSaved!(list,value);
        },
        name: name,
        onReset: () {

        },
        validator: validator,
        autovalidateMode: autovalidateMode,
      ),
    );
  }

  Widget _field(BuildContext context, void Function(List<VType>) didChange){
    return BlocConsumer<ListBloc<MType>, ListState<MType>>(
      bloc: listBloc,
      builder: (context, state){
        if(state.listState == ListBlocDataState.init){
          listBloc.add(ListGetListEvent());
        }
        if(state.listState != ListBlocDataState.loaded){
          return InputDecorator(
            decoration: _decoration,
            child: const LinearProgressIndicator(),
          );
        }
        return InputDecorator(
            decoration: _decoration,
            child: ListView(
              children: [
                if(selectFunc != null)
                Card(
                  child: Center(
                    child: FilledButton(onPressed: () async {
                      var selected = await selectFunc!(context, listBloc.state.list.toList());
                      if(selected != null){
                        listBloc.add(ListSetListEvent<MType>(ListResponse.fromList(selected)));
                      }
                    }, child: Icon(Icons.add)),
                  ),
                ),
                ...list.map((e) {
                  return Row(
                    children: [
                      Expanded(child: itemBuilder(e)),
                      IconButton(onPressed: () {
                        listBloc.add(ListRemoveListEvent(e));
                      }, icon: Icon(Icons.close, color: Colors.red,))
                    ],
                  );
                },)
              ],
            )
        );
      },
      listener: (context, state) {
          didChange(values);
      },
    );
  }

  List<VType> get values => list.isEmpty ? [] : list.map((e) => valueBuilder(e),).toList();
  List<MType> get list =>  listBloc.state.list;
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