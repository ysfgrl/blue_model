import 'base.dart';
import 'filter.dart';


class ListRequest extends BaseModel{
  late int page;
  late int pageSize;
  late Map<String, FilterModel> filters;
  late Map<String, dynamic>? sort;
  late Map<String, AggModel>? agg;
  ListRequest.first({int size = 10}){
    page = 1;
    pageSize = size;
    filters = {};
    sort = {};
  }
  ListRequest.create({
    required this.page,
    required this.pageSize,
    required this.filters,
    this.sort,
  });
  ListRequest();
  factory ListRequest.fromJson(Map<String, dynamic> json) {
    return ListRequest()
      ..page = (json['page'] as num).toInt()
      ..pageSize = (json['pageSize'] as num).toInt()
      ..filters = (json['filters'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, FilterModel.fromJson(value));
      },)
      ..sort = json['sort'] as Map<String, dynamic>?;
  }
  @override
  Map<String, dynamic> toJson() => {
    'page': page,
    'pageSize': pageSize,
    'filters': filters.map((key, value) {
      return MapEntry(key, value.toJson());
    },),
    'sort': sort,
  };

}
