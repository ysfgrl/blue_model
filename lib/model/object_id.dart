import '../unique/process_unique.dart';
import 'dart:math' as math;
import 'dart:typed_data';

import 'base.dart';



const _maxCounterValue = 0xffffff;
const _counterMask = _maxCounterValue + 1;
var _counter = math.Random().nextInt(_counterMask);
int _getCounter(){
  return _counter = (_counter + 1) % _counterMask;
}

class ObjectId extends BaseModel{
  late String val;
  ObjectId();
  factory ObjectId.nil() {
    return ObjectId()
      ..val = "0"*24;
  }

  factory ObjectId.gen() {
    final millisecondsSinceEpoch =DateTime.now().millisecondsSinceEpoch;
    final processUnique = ProcessUnique().getValue();
    final secondsSinceEpoch = millisecondsSinceEpoch ~/ 1000;
    final Uint8List bytes = Uint8List(12);
    final counter = _getCounter();
    // 4-byte timestamp
    bytes
      ..[3] = secondsSinceEpoch & 0xff
      ..[2] = (secondsSinceEpoch >> 8) & 0xff
      ..[1] = (secondsSinceEpoch >> 16) & 0xff
      ..[0] = (secondsSinceEpoch >> 24) & 0xff;

    // 5-byte process unique
    bytes
      ..[4] = processUnique[0]
      ..[5] = processUnique[1]
      ..[6] = processUnique[2]
      ..[7] = processUnique[3]
      ..[8] = processUnique[4];

    // 3-byte counter
    bytes
      ..[11] = counter & 0xff
      ..[10] = (counter >> 8) & 0xff
      ..[9] = (counter >> 16) & 0xff;
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return ObjectId()
      ..val = buffer.toString();
  }

  factory ObjectId.from(String val) {
    return ObjectId()
      ..val = val;
  }

  bool get isNil => val == "0"*24;

  factory ObjectId.fromJson(Map<String, dynamic> json) {
    return ObjectId()
      ..val = json['\$oid'] as String;
  }
  @override
  Map<String, dynamic> toJson() => {
    "\$oid": val,
  };
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ObjectId && other.val == val;
  }

  @override
  int get hashCode => val.hashCode;

}