part of 'repository.dart';

mixin class CountRepo{
  const CountRepo();
  Future<ResponseModel<ResponseInt>?> count(ListRequest request) {
    throw UnimplementedError("Unimplemented count");
  }
}