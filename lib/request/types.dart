import '../model/base.dart';
typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);
typedef ErrorHandler<MType extends BaseModel> = MType? Function(dynamic err);