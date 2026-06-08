import 'base.dart';


enum FilterCompareType {
  equal,
  ne,
  gt,
  gte,
  lt,
  lte,
  inList,
  contains,
  notContains,

  startsWith,
  endsWith,

  isNull,
  isNotNull,
}

enum FilterValueType{
  string,
  number,
  bool,
  datetime,
  objectId,
}


class FilterModel<VType> extends BaseModel{
  late FilterCompareType compare;
  late VType? value;
  late FilterValueType type;
  FilterModel();

  FilterModel.equal({required this.value, required this.type}){
    this.compare = FilterCompareType.equal;
  }
  FilterModel.notEqual({required this.value, required this.type}){
    this.compare = FilterCompareType.ne;
  }
  FilterModel.inList({required this.value, required this.type}){
    this.compare = FilterCompareType.inList;
  }
  FilterModel.contains({required this.value, required this.type}){
    this.compare = FilterCompareType.contains;
  }
  FilterModel.startWith({required this.value, required this.type}){
    this.compare = FilterCompareType.startsWith;
  }
  FilterModel.gte({required this.value, required this.type}){
    this.compare = FilterCompareType.gte;
  }
  FilterModel.lte({required this.value, required this.type}){
    this.compare = FilterCompareType.lte;
  }
  factory FilterModel.fromJson(Map<String, dynamic> json) {
    var type = FilterValueType.values.firstWhere(
          (e) => e.name == json["type"],
    );
    var compare = FilterCompareType.values.firstWhere(
          (e) => e.name == json["compare"],
    );
    dynamic value;
    switch (type) {
      case FilterValueType.string:
        value = json["value"] as String;
      case FilterValueType.number:
        value = (json["value"] as num).toInt();
      case FilterValueType.bool:
        value = json["value"] as bool;
      case FilterValueType.datetime:
        value = DateTime.parse(json["value"] as String);
      case FilterValueType.objectId:
        value = json["value"] as String;
    }
    return FilterModel()
      ..compare = compare
      ..type = type
      ..value = value;
  }
  @override
  Map<String, dynamic> toJson() => {
    "compare": compare.name,
    "type": type.name,
    "value": value is DateTime? (value as DateTime).toIso8601String(): value,
  };
}

class AggModel extends BaseModel{
  late String localField;
  late String remoteField;
  late String collection;
  AggModel();
  factory AggModel.fromJson(Map<String, dynamic> json) {
    return AggModel()
      ..localField = json['localField'] as String
      ..remoteField = json['remoteField'] as String
      ..collection = json['collection'] as String;
  }
  @override
  Map<String, dynamic> toJson() => {
    'localField': localField,
    'remoteField': remoteField,
    'collection': collection,
  };
}