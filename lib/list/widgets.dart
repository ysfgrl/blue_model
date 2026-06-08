part of 'blue_list.dart';

const Widget listEmptyWidget = Center(
  child: Text("List Empty"),
);

const Widget listLoadingWidget = Center(
  child: CircularProgressIndicator(),
);

Widget listErrorBuilder(ResponseError err){
  return  LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // important
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child:  Center(
            child: Text("Error : ${err.toJson()}"),
          ),
        ),
      );
    },
  );
}

