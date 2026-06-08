
import 'base.dart';
enum ErrorLevel {
  error,
  fatal,
  warn,
  info
}
class ResponseError extends BaseModel{
  late String? file;
  late String? function;
  late String? detail;
  late int? line;
  late String code;
  late ErrorLevel level;

  ResponseError();

  factory ResponseError.fromJson(Map<String, dynamic> json) {
   return ResponseError()
     ..file = json['file'] as String?
     ..function = json['function'] as String?
     ..detail = json['detail'] as String?
     ..line = json['line'] as int?
     ..code = json['code'] as String
     ..level = ErrorLevel.values.byName(json['level'] as String);
  }
  @override
  Map<String, dynamic> toJson() => {
    'file': file,
    'function': function,
    'detail': detail,
    'line': line,
    'code': code,
    'level': level
  };
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResponseError && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

}
