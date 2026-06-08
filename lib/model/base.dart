
import 'dart:math';

String generateObjectId() {
  final rand = Random();
  final bytes = List<int>.generate(12, (_) => rand.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

abstract class BaseModel{
  BaseModel();
  BaseModel.fromJson(Map<String, dynamic> data);
  Map<String, dynamic> toJson(){
    throw UnimplementedError();
  }
  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

}