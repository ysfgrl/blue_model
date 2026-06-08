part of 'repository.dart';

mixin class DeleteByIdRepo {
  const DeleteByIdRepo();
  Future<ResponseModel<ResponseOk>?> deleteById(String id, {Map<String, dynamic>? params}) {
    throw UnimplementedError();
  }
}