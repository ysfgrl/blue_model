part of 'blue_list.dart';

class BlueListLoader<LType extends BaseModel> extends StatelessWidget{
  final ListBloc<LType> listBloc;
  final Widget Function(BuildContext context) builder;
  const BlueListLoader({super.key,
    required this.listBloc,
    required this.builder,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc<LType>, ListState<LType>>(
      bloc: listBloc,
      builder: (context, state) {
        if(state.listState == ListBlocDataState.init){
          listBloc.add(const ListGetListEvent());
        }
        if(state.listState != ListBlocDataState.loaded){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return builder(context);
      },
      buildWhen: (previous, current) => true,
    );
  }

}
class BlueListsLoader extends StatelessWidget{
  final List<ListBloc> listBlocs;
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context) errorBuilder;
  final Widget? loadingWidget;
  const BlueListsLoader({super.key,
    required this.listBlocs,
    required this.builder,
    required this.errorBuilder,
    this.loadingWidget,
  });
  @override
  Widget build(BuildContext context) {
    if(listBlocs.isEmpty){
      return builder(context);
    }
    return BlocBuilder<ListBloc, ListState>(
      bloc: listBlocs.first,
      builder: (context, state) {
        if(state.listState == ListBlocDataState.init){
          listBlocs.first.add(const ListGetListEvent());
        }
        if(state.listState != ListBlocDataState.loaded){
          if(state.message!=null){
            return errorBuilder(context);
          }
          if(loadingWidget != null){
            return loadingWidget!;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return BlueListsLoader(
          listBlocs: listBlocs.sublist(1),
          builder: builder,
          errorBuilder: errorBuilder,
          loadingWidget: loadingWidget,
        );
      },
      buildWhen: (previous, current) => true,
    );
  }

}