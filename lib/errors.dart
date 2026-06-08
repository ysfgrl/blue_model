import 'model/error.dart';

class LocalErrors {

  static ResponseError  get  idRequireErr => ResponseError()
    ..code = "local.id_require"
    ..file = null
    ..line = 0
    ..detail = "Id Required"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  repRequireErr => ResponseError()
    ..code = "local.repo_require"
    ..file = null
    ..line = 0
    ..detail = "Repo Required"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  modelNotLoadedErr => ResponseError()
    ..code = "local.id_require"
    ..file = null
    ..line = 0
    ..detail = "Id Required"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  modelDeleteSuccessMsg => ResponseError()
    ..code = "local.delete_success"
    ..file = null
    ..line = 0
    ..detail = "Delete Success"
    ..level = ErrorLevel.info
    ..function = "";

  static ResponseError  get  modelSaveSuccessMsg => ResponseError()
    ..code = "local.save_success"
    ..file = null
    ..line = 0
    ..detail = "Save Success"
    ..level = ErrorLevel.info
    ..function = "";

  static ResponseError  get formKeyNfErr => ResponseError()
    ..code = "local.formKeyNf"
    ..file = null
    ..line = 0
    ..detail = "Form Key Not Found"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  formValidateErr => ResponseError()
    ..code = "local.formValidateError"
    ..file = null
    ..line = 0
    ..detail = "Validate Error"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  fileUploadErr => ResponseError()
    ..code = "local.fileUploadError"
    ..file = null
    ..line = 0
    ..detail = "Upload Error"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  fieldNfErr => ResponseError()
    ..code = "local.fieldNf"
    ..file = null
    ..line = 0
    ..detail = "Field Not Found"
    ..level = ErrorLevel.error
    ..function = "";
  static ResponseError  get  nFResponseErr => ResponseError()
    ..code = "local.nFResponse"
    ..file = null
    ..line = 0
    ..detail = "Not Found Response"
    ..level = ErrorLevel.error
    ..function = "";
  static ResponseError  get  nFErrorErr => ResponseError()
    ..code = "local.nFError"
    ..file = null
    ..line = 0
    ..detail = "Not Found Error"
    ..level = ErrorLevel.error
    ..function = "";
  static ResponseError  get nFStatusErr => ResponseError()
    ..code = "local.nFStatus"
    ..file = null
    ..line = 0
    ..detail = "Not Found Response"
    ..level = ErrorLevel.error
    ..function = "";
  static ResponseError  get  loggedMsg => ResponseError()
    ..code = "local.logged"
    ..file = null
    ..line = 0
    ..detail = "logged"
    ..level = ErrorLevel.info
    ..function = "";
  static ResponseError  get  registeredMsg => ResponseError()
    ..code = "local.registered"
    ..file = null
    ..line = 0
    ..detail = "Registered"
    ..level = ErrorLevel.info
    ..function = "";
  static ResponseError  get  logoutMsg => ResponseError()
    ..code = "local.logout"
    ..file = null
    ..line = 0
    ..detail = "Logout"
    ..level = ErrorLevel.info
    ..function = "";
  static ResponseError  get  unexpectedErr => ResponseError()
    ..code = "local.unexpectedError"
    ..file = null
    ..line = 0
    ..detail = "Logout"
    ..level = ErrorLevel.error
    ..function = "";

  static ResponseError  get  modelDecodeErr => ResponseError()
    ..code = "local.modelDecodeErr"
    ..file = null
    ..line = 0
    ..detail = "Decode Error"
    ..level = ErrorLevel.error
    ..function = "";
  static ResponseError  get  errorDecodeErr => ResponseError()
    ..code = "local.errorDecodeErr"
    ..file = null
    ..line = 0
    ..detail = "Decode Error"
    ..level = ErrorLevel.error
    ..function = "";
}
