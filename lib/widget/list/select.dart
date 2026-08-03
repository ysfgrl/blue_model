

part of 'blue_list.dart';

class _BlueListSelectLayer<LType extends BaseModel> extends StatelessWidget {
  final ListBloc<LType> listBloc;
  final ListSelectedBuilder<LType>? selectedBuilder;
  const _BlueListSelectLayer({
    super.key,
    required this.listBloc,
    this.selectedBuilder,
  });
  @override
  Widget build(BuildContext context) {
    if(selectedBuilder == null){
      return const SizedBox();
    }
    return BlocBuilder<ListBloc<LType>, ListState<LType>>(
        bloc: listBloc,
      builder: (context, state) {
        if(state.selected.isEmpty){
          return const SizedBox();
        }
        return selectedBuilder!(context, state.selected);
      },
      buildWhen: (previous, current) => previous.selected != current.selected,
    );
  }
}