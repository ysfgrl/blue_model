
part of 'blue_list.dart';

class _BlueListFooter<LType extends BaseModel> extends StatelessWidget{
  final ListBloc<LType> listBloc;
  final Widget divider;
  final bool hideFooter;
  const _BlueListFooter({
    super.key,
    required this.listBloc,
    required this.divider,
    required this.hideFooter
  });
  @override
  Widget build(BuildContext context) {
    if(listBloc.state.paginationType == ListPaginationType.infinity){
      return const SizedBox();
      // return SizedBox(
      //   height: 50,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       IconButton(onPressed: () {
      //         listBloc.add(const ListNextPageEvent());
      //       }, icon: const Icon(Icons.refresh))
      //     ],
      //   ),
      // );
    }
    if (hideFooter) {
      return const SizedBox();
    }
    return BlocBuilder<ListBloc<LType>, ListState<LType>>(
      bloc: listBloc,
      builder: (context, listState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            divider,
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: "Previous",
                    splashRadius: 20,
                    icon: const Icon(Icons.keyboard_arrow_left_rounded,),
                    onPressed:() => listBloc.add(const ListPreviousPageEvent()),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Size:"),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: DropdownButtonFormField<int>(
                              value: listState.pageSize,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(1),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                              ),
                              onChanged:(value) {
                                if(value!=null) {
                                  listBloc.add(ListSetPageSizeEvent(value));
                                }
                              },
                              items: [
                                ..._pageSizeValues.map((e) {
                                  return DropdownMenuItem(value: e, child: Text("$e"),);
                                },),
                                if(!_pageSizeValues.contains(listState.pageSize))
                                  DropdownMenuItem(value: listState.pageSize, child: Text("${listState.pageSize}"),)
                              ]
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text("${listState.page}/${listState.total}"),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: "Next",
                    splashRadius: 20,
                    icon: const Icon(Icons.keyboard_arrow_right_rounded,),
                    onPressed: () => listBloc.add(const ListNextPageEvent()),
                  )
                ],
              ),
            ),
          ],
        );
      },
      buildWhen: (previous, current) =>
          previous.pageSize != current.pageSize ||
          previous.page != current.page ||
          previous.total != current.total
    );
  }

}