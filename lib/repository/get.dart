part of 'repository.dart';

mixin class GetByIdRepo<MType extends BaseModel> {
  const GetByIdRepo();
  Future<ResponseModel<MType>?> getById(String id, {Map<String, dynamic>? params}) {
    throw UnimplementedError();
  }
}