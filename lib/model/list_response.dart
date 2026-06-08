

import 'factory.dart';
import 'base.dart';

class ListResponse<T extends BaseModel> extends BaseModel {
  late int page;
  late int pageSize;
  late int total;
  late List<T> list;
  ListResponse();
  @override
  ListResponse.fromJson(Map<String, dynamic> data){
    page = data["page"] ?? 1;
    pageSize = data["pageSize"] ?? 50;
    total = data["total"] ?? 0;
    list = ModelFactory.modelListFactory(data["list"] ?? []);
  }

  ListResponse.fromList(List<T> newList){
    page =1;
    pageSize = newList.length;
    total = newList.length;
    list = newList;
  }

  @override
  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "total": total,
    "list": list.map((e) => e.toJson()).toList(),
  };
}
