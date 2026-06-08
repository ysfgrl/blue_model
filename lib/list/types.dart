part of 'blue_list.dart';

typedef SliverGridBuilder<LType extends BaseModel> =
Widget Function(LType model, bool isSelected, int index);

typedef ListViewBuilder<LType extends BaseModel> =
Widget Function(LType model, bool isSelected, int index);

typedef DataTableBuilder<LType extends BaseModel> =
DataRow Function(LType model, bool isSelected);

typedef ListSelectedBuilder<LType extends BaseModel> =
Widget Function(BuildContext ctx, List<LType> selected);

typedef ListErrorBuilder =
Widget Function(ResponseError err);