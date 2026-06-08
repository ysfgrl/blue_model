part of 'repository.dart';

mixin class EditRepo {
  const EditRepo();
  Future<ResponseModel<ResponseOk>?> edit(String id, Map<String, dynamic> model, {Map<String, dynamic>? params}) {
    throw UnimplementedError();
  }
}