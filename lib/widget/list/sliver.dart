
part of 'blue_list.dart';

class _BlueSliverBuilder<LType extends BaseModel> extends StatelessWidget{
  final ListState<LType> listState;
  final SliverGridBuilder<LType> sliverGridBuilder;
  final Map<dynamic,Widget> groups;
  final Axis scrollDirection;
  final BlueListGroupSelect<LType>? groupKey;
  final ScrollController scrollController;
  final SliverGridDelegate delegate;
  const _BlueSliverBuilder({
    super.key,
    required this.listState,
    required this.sliverGridBuilder,
    required this.groups,
    required this.scrollDirection,
    required this.scrollController,
    required this.delegate,
    this.groupKey,
  });

  @override
  Widget build(BuildContext context) {
    int index = 0;
    if(groups.isEmpty || groupKey ==null){
      return CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverGrid(
            gridDelegate: delegate,
            delegate: SliverChildListDelegate(listState.list.map((e) {
              return sliverGridBuilder(e, listState.selected.contains(e), ++index);
            },).toList()),
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
      groupList[1]!.add(const SizedBox());
    }
    for (var item in listState.list) {
      var key = groupKey == null? 1 : groupKey!(item);
      groupList[key]?.add(sliverGridBuilder(item, listState.selected.contains(item), index++));
      index++;
    }
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        ...groupList.values.expand(
              (element) => element.length == 1 ?[]: [
            SliverToBoxAdapter(
              child: element.first,
            ),
            SliverGrid(
              gridDelegate: delegate,
              delegate: SliverChildListDelegate(element.sublist(1)),
            )
          ],
        ),
      ],
    );
  }
}