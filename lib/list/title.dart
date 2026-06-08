
part of 'blue_list.dart';

class _BlueListTitle<LType extends BaseModel> extends StatelessWidget{
  final Text title;
  final Widget? icon;
  final ListBloc<LType> listBloc;
  final bool hideMenu;
  final List<BlueListAction> actions;
  final bool haveSliverBuilder;
  final bool haveListBuilder;
  final bool haveDataTableBuilder;
  final bool hideTitle;
  final Widget divider;
  const _BlueListTitle({
    super.key,
    required this.listBloc,
    required this.actions,
    required this.haveSliverBuilder,
    required this.haveListBuilder,
    required this.haveDataTableBuilder,
    required this.hideTitle,
    required this.divider,
    required this.hideMenu,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if(hideTitle){
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Row(
            children: [
              if(icon!=null)
                icon!,
              Expanded(
                child: title,
              ),
              _searchBar(context),
              const SizedBox(width: 5,),
              if(!hideMenu)
                PopupMenuButton<dynamic>(
                  position: PopupMenuPosition.under,
                  onSelected: (value) {

                    if(value.runtimeType == ListViewType){
                      listBloc.add(ListSetViewTypeEvent(value));
                      return;
                    }
                    if(value == "resetFilter"){
                      listBloc.add(ListSetFilterResetEvent());
                      return;
                    }
                    for (var element in actions) {
                      if(element.value==value){
                        if(element.onSelect!=null) {
                          element.onSelect!();
                        }
                        break;
                      }
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      ...actions.map((e) => PopupMenuItem(
                          value: e.value,
                          child: ListTile(leading: e.icon,title: e.child,)),
                      ),
                      if(actions.isNotEmpty)
                        const PopupMenuDivider(),
                      if(haveDataTableBuilder)
                        const PopupMenuItem(
                          value: ListViewType.dataTable,
                          child: ListTile(
                            leading: Icon(Icons.list_alt),
                            title: Text("Data Table"),
                          ),
                        ),
                      if(haveListBuilder)
                        const PopupMenuItem(
                          value: ListViewType.listView,
                          child: ListTile(
                            leading: Icon(Icons.list_outlined),
                            title: Text("List View"),
                          ),
                        ),
                      if(haveSliverBuilder)
                        const PopupMenuItem(
                          value: ListViewType.sliverGrid,
                          child: ListTile(
                            leading: Icon(Icons.grid_4x4_outlined),
                            title: Text("Sliver"),
                          ),
                        ),

                    ];
                  },
                ),
            ],
          ),
        ),
        divider
      ],
    );
  }


  Widget _searchBar(BuildContext context){
    return SearchBar(
      constraints: const BoxConstraints(
          maxWidth: 150,
          minWidth: 150,
          maxHeight: 35,
          minHeight: 35
      ),
      controller: listBloc.searchController,
      autoFocus: false,
      trailing: [IconButton(
        icon: const Icon(Icons.search),
        tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
        onPressed: () {
          listBloc.add(const ListSearchValueEvent());
        },
      )],
      hintText: "Search",
      side: const WidgetStatePropertyAll<BorderSide>(BorderSide(width: 1)),
      backgroundColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
      overlayColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
      elevation: const MaterialStatePropertyAll<double>(0.0),
      onChanged: (String value) {

      },
      onSubmitted: (value) {
        listBloc.add(const ListSearchValueEvent());
      },
    );
  }
}