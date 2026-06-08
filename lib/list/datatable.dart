
part of 'blue_list.dart';

class _BlueDatatableBuilder<LType extends BaseModel> extends StatelessWidget{
  final ListState<LType> listState;
  final DataTableBuilder<LType> dataTableBuilder;
  final Axis scrollDirection;
  final ScrollController scrollController;
  final SliverGridDelegate delegate;
  final List<DataColumn>? columns;
  const _BlueDatatableBuilder({
    super.key,
    required this.listState,
    required this.dataTableBuilder,
    required this.scrollDirection,
    required this.scrollController,
    required this.delegate,
    this.columns
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Row(
          children: [
            Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth
                ),
                child: DataTable(
                  columns: _getColumn(listState.list.first),
                  rows: [
                    ...listState.list.map((e) {
                      return dataTableBuilder(e, listState.selected.contains(e));
                    },),
                  ],
                ),
              ),
            ))
          ],
        ),
      );
    },);
  }

  List<DataColumn> _getColumn(LType first){
    var firstRow = dataTableBuilder!(first,false);
    if(columns != null && firstRow.cells.length == columns!.length) return columns!;
    if(columns != null && firstRow.cells.length < columns!.length){
      return columns!.sublist(0, firstRow.cells.length);
    }
    if(columns != null && firstRow.cells.length > columns!.length){
      final newColumn = [...columns!];
      for (int i = firstRow.cells.length-columns!.length; i < firstRow.cells.length; i++) {
        newColumn.add(DataColumn(label:Text("Column $i")));
      }
      return newColumn;
    }
    var colum = <DataColumn>[];
    for (int i = 0; i < firstRow.cells.length; i++) {
      colum.add(DataColumn(label:Text("Column $i")));
    }
    return colum;
  }
}