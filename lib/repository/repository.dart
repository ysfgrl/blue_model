
import 'dart:typed_data';
import '../model/base.dart';
import '../model/response.dart';
import '../model/list_response.dart';
import '../model/list_request.dart';

part 'edit.dart';
part 'create.dart';
part 'get.dart';
part 'delete.dart';
part 'list.dart';
part 'set_field.dart';
part 'upload.dart';
part 'count.dart';
part 'url.dart';


typedef RepoGetByIdGetter<MType extends BaseModel> = GetByIdRepo<MType> Function();
typedef ListRepoGetter<MType extends BaseModel> = ListRepo<MType> Function();

typedef RepoEditGetter = EditRepo Function();
typedef RepoCreateGetter = CreateRepo Function();
typedef RepoDeleteGetter = DeleteByIdRepo Function();
typedef RepoSetFieldGetter = SetFieldRepo Function();
typedef UrlRepoGetter = UrlRepo Function();











