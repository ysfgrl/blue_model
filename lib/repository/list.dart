part of 'repository.dart';

mixin class ListRepo<MType extends BaseModel>{
  const ListRepo();
  Future<ResponseModel<ListResponse<MType>>?> list(ListRequest request) {
    throw UnimplementedError("Unimplemented list");
  }
}