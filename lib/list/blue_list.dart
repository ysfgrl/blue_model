import 'package:blue_model/blue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'action.dart';
part 'types.dart';
part 'widgets.dart';
part 'loader.dart';
part 'title.dart';
part 'footer.dart';
part 'select.dart';
part 'listview.dart';
part 'sliver.dart';
part 'datatable.dart';
typedef BlueListGroupSelect<LType extends BaseModel> = dynamic Function(LType model);

class BlueListGroup{
  final Widget child;
  const BlueListGroup({
    required this.child
  });
}

var _pageSizeValues = [
  10,
  20,
  50,
  100
];
class BlueList<LType extends BaseModel> extends StatelessWidget{
  final SliverGridBuilder<LType>? sliverGridBuilder;
  final ListViewBuilder<LType>? listViewBuilder;
  final DataTableBuilder<LType>? dataTableBuilder;

  final ListSelectedBuilder<LType>? selectedBuilder;
  final Text title;
  final Widget? icon;
  final GlobalKey globalKey = GlobalKey();
  final ListBloc<LType> listBloc;
  final List<BlueListAction> actions;

  final Widget loadingWidget;
  final Widget emptyWidget;
  final ListErrorBuilder errorBuilder;

  final bool hideFooter;
  final bool hideTitle;
  final bool hideMenu;
  final double opacity;
  final Widget divider;
  final Color? color;
  final SliverGridDelegate delegate;
  final List<DataColumn>? columns;
  final Map<dynamic,Widget> groups;
  final Axis scrollDirection;
  final BlueListGroupSelect<LType>? groupKey;
  BlueList({super.key,
    required this.listBloc,
    this.listViewBuilder,
    this.dataTableBuilder,
    this.sliverGridBuilder,
    this.selectedBuilder,
    this.hideFooter = false,
    this.hideTitle = false,
    this.hideMenu = false,
    this.title = const Text("List"),
    this.scrollDirection = Axis.vertical,
    this.loadingWidget = listLoadingWidget,
    this.emptyWidget = listEmptyWidget,
    this.opacity = 1,
    this.groups = const {},
    this.errorBuilder = listErrorBuilder,
    this.actions = const [],
    this.divider = const Divider(),
    this.groupKey,
    this.color,
    this.delegate = const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        mainAxisExtent: 300
    ),
    this.columns,
    this.icon,
  });

  Future<List<LType>?> select(BuildContext c) async {
    return showDialog<List<LType>>(
      context: c,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Builder(
            builder: (context) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 600,
                  minWidth: 500,
                ),
                child: Card(child: this,),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          _BlueListTitle(
            listBloc: listBloc,
            actions: actions,
            haveSliverBuilder: sliverGridBuilder != null,
            haveListBuilder: listViewBuilder != null,
            haveDataTableBuilder: dataTableBuilder != null,
            hideTitle: hideTitle,
            divider: divider,
            icon: icon,
            title: title,
            hideMenu: hideMenu,
          ),
          Expanded(
              child: RefreshIndicator(child: BlocBuilder<ListBloc<LType>, ListState<LType>>(
                bloc: listBloc,
                builder: (context, listState) {
                  if(listState.listState == ListBlocDataState.init){
                    listBloc.add(const ListGetListEvent());
                  }
                  if(listState.listState == ListBlocDataState.error){
                    return errorBuilder(listState.message!);
                  }else if(listState.listState != ListBlocDataState.loaded &&
                      listState.paginationType == ListPaginationType.pagination){
                    return loadingWidget;
                  }else if(listState.list.isEmpty){
                    return emptyWidget;
                  }
                  if(dataTableBuilder != null && listState.viewType == ListViewType.dataTable){
                    return _BlueDatatableBuilder(
                        listState: listState,
                        dataTableBuilder: dataTableBuilder!,
                        scrollDirection: scrollDirection,
                        scrollController: listBloc.scroll,
                        delegate: delegate,
                        columns: columns,
                    );
                  }else if(listViewBuilder != null && listState.viewType == ListViewType.listView){
                    return _BlueListViewBuilder(
                        listState: listState,
                        listViewBuilder: listViewBuilder!,
                        groups: groups,
                        scrollDirection: scrollDirection,
                        scrollController: listBloc.scroll,
                        groupKey: groupKey,
                        loadMore: () {
                          listBloc.add(const ListNextPageEvent());
                        },
                    );
                  }else if(sliverGridBuilder!= null && listState.viewType == ListViewType.sliverGrid){
                    return _BlueSliverBuilder(
                        listState: listState,
                        sliverGridBuilder: sliverGridBuilder!,
                        groups: groups,
                        scrollDirection: scrollDirection,
                        scrollController: listBloc.scroll,
                        delegate: delegate,
                        groupKey: groupKey,
                    );
                  }else if(dataTableBuilder != null){
                    return _BlueDatatableBuilder(
                        listState: listState,
                        dataTableBuilder: dataTableBuilder!,
                        scrollDirection: scrollDirection,
                        scrollController: listBloc.scroll,
                        delegate: delegate,
                        columns: columns,
                    );
                  }else if(listViewBuilder != null){
                    return _BlueListViewBuilder(
                      listState: listState,
                      listViewBuilder: listViewBuilder!,
                      groups: groups,
                      scrollDirection: scrollDirection,
                      scrollController: listBloc.scroll,
                      groupKey: groupKey,
                      loadMore: () {
                        listBloc.add(const ListNextPageEvent());
                      },
                    );
                  }else if(sliverGridBuilder != null){
                    return _BlueSliverBuilder(
                      listState: listState,
                      sliverGridBuilder: sliverGridBuilder!,
                      groups: groups,
                      scrollDirection: scrollDirection,
                      scrollController: listBloc.scroll,
                      delegate: delegate,
                      groupKey: groupKey,
                    );
                  }
                  return const Center(child: Text("Not Found Builder"),);
                },
                buildWhen: (previous, current) => true,
              ), onRefresh: () async{
                listBloc.add(const ListRefreshPageEvent());
              },)
          ),
          _BlueListSelectLayer(
              listBloc: listBloc,
              selectedBuilder: selectedBuilder,
          ),
          _BlueListFooter(
              listBloc: listBloc,
              divider: divider,
              hideFooter: hideFooter
          )
        ],
      ),
    );
  }

}


