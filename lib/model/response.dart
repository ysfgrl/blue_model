

import 'factory.dart';
import 'base.dart';
import 'error.dart';

class ResponseModel<T extends BaseModel> extends BaseModel{
  late int code;
  late T? content;
  late ResponseError? error;

  ResponseModel();

  ResponseModel.create(T? c){
    content = c;
    code = 200;
    error = null;
  }
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel<T>()
      ..code = (json['code'] as num).toInt()
      ..content = json['content'] == null? null
          : ModelFactory.modelFactory(json['content'] as Map<String, dynamic>?)
      ..error = json['error'] == null ? null
          : ResponseError.fromJson(json['error'] as Map<String, dynamic>);
  }

  @override
  Map<String, dynamic> toJson() =>{
    'code': code,
    'content': ModelFactory.modelToJson(content),
    'error': error?.toJson(),
  };

  factory ResponseModel.err(ResponseError err){
    return ResponseModel()
      ..code = 0
    ..content = null
    ..error = err;
  }

  static str(String value){
    return ResponseModel<ResponseStr>()
      ..content=(ResponseStr()..value=value)
      ..code = 200
      ..error=null;
  }
  static integer(int value){
    return ResponseModel<ResponseInt>()
      ..content=(ResponseInt()..value=value)
      ..code = 200
      ..error=null;
  }
  static ok(bool value){
    return ResponseModel<ResponseOk>()
      ..content=(ResponseOk()..isOk=value)
      ..code = 200
      ..error=null;
  }
}

class ResponseOk extends BaseModel{
  late bool isOk;
  ResponseOk();
  factory ResponseOk.fromJson(Map<String, dynamic> json) {
    return ResponseOk()..isOk = json['isOk'] as bool;
  }
  @override
  Map<String, dynamic> toJson() => {
    'isOk': isOk,
  };
}

class ResponseStr extends BaseModel{
  late String value;
  ResponseStr();
  @override
  factory ResponseStr.fromJson(Map<String, dynamic> json) {
    return ResponseStr()..value = json['value'] as String;
  }
  @override
  Map<String, dynamic> toJson() => {
    'value': value,
  };
}

class ResponseInt extends BaseModel{
  late int value;
  ResponseInt();
  @override
  factory ResponseInt.fromJson(Map<String, dynamic> json) {
    return ResponseInt()..value = (json['value'] as num).toInt();
  }
  @override
  Map<String, dynamic> toJson() => {
    'value': value,
  };
}

class ResponseDate extends BaseModel{
  late DateTime value;
  ResponseDate();
  @override
  factory ResponseDate.fromJson(Map<String, dynamic> json) {
    return ResponseDate()..value =DateTime.parse(json['value'] as String);
  }
  @override
  Map<String, dynamic> toJson() => {
    'value': value.toIso8601String(),
  };
}
