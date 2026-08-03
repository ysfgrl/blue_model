
part of 'blue_list.dart';

class _BlueListViewBuilder<LType extends BaseModel> extends StatelessWidget{
  final ListState<LType> listState;
  final ListViewBuilder<LType> listViewBuilder;
  final Map<dynamic,Widget> groups;
  final Axis scrollDirection;
  final BlueListGroupSelect<LType>? groupKey;
  final ScrollController scrollController;
  final VoidCallback loadMore;
  const _BlueListViewBuilder({
    super.key,
    required this.listState,
    required this.listViewBuilder,
    required this.groups,
    required this.scrollDirection,
    required this.scrollController,
    required this.loadMore,
    this.groupKey,
  });
  @override
  Widget build(BuildContext context) {
    int index = 0;
    if(groups.isEmpty || groupKey ==null){
      return ListView(
        controller: scrollController,
        scrollDirection: scrollDirection,
        physics: const AlwaysScrollableScrollPhysics(),
        children:[
          ...listState.list.map((item) {
            return listViewBuilder(item, listState.selected.contains(item), index++);
          },),
          if(listState.paginationType == ListPaginationType.infinity)
          Center(
            child: IconButton(onPressed: loadMore, icon: Icon(Icons.refresh)),
          )
        ],
      );
    }

    Map<dynamic,List<Widget>> groupList = {};
    if(groups.isNotEmpty && groupKey != null){
      groups.forEach((key, group) {
        groupList[key] = [];
        groupList[key]!.add(group);
      },);
    }else{
      groupList[1] = [];
      groupList[1]!.add(SizedBox());
    }

    for (var item in listState.list) {
      var key = groupKey == null? 1 : groupKey!(item);
      groupList[key]?.add(listViewBuilder(item, listState.selected.contains(item), index));
      index++;
    }
    return ListView(
      controller: scrollController,
      scrollDirection: scrollDirection,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        ...groupList.values.expand((element) => element.length == 1 ?[]: element,),

      ],
    );
  }
}