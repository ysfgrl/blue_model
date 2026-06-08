part of 'repository.dart';

mixin class UploadRepo{
  const UploadRepo();
  Future<ResponseModel<ResponseStr>?> upload({
    required String name,
    required String fieldName,
    required Uint8List file,
    required void Function(int sentBytes, int totalBytes) uploadProgress,
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError("Unimplemented upload");
  }
}