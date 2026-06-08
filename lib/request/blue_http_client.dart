import 'dart:async';
import 'dart:typed_data';
import 'typed_http_client.dart';
import '../model/response.dart';
import '../model/base.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:mime/mime.dart';
import 'types.dart';
class BlueHttpClient extends TypedHttpClient{
  const BlueHttpClient({
    required super.dio,
    super.baseUrl,
    super.headers,
    super.timeout,
  });

  Future<ResponseModel<RType>?> blueReq<RType extends BaseModel>(String path, String method,{
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
    required ErrorHandler<ResponseModel<RType>> errorHandler
  }) async {
    return super.typedReq<ResponseModel<RType>>(path, method,
        queryParameters: queryParameters,
        bodyData: data,
        formData: formData,
        uploadProgress: uploadProgress,
        errorHandler: errorHandler
    );
  }

  Future<ResponseModel<RType>?> get<RType extends BaseModel>(String path,{
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
    required ErrorHandler<ResponseModel<RType>> errorHandler
  }) async {
    return super.typedReq<ResponseModel<RType>>(path, "GET",
      queryParameters: queryParameters,
      bodyData: data,
      formData: formData,
      uploadProgress: uploadProgress,
      errorHandler: errorHandler,
    );
  }


  Future<ResponseModel<RType>?> post<RType extends BaseModel>(String path,{
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
    required ErrorHandler<ResponseModel<RType>> errorHandler
  }) async {
    return super.typedReq<ResponseModel<RType>>(path, "POST",
        queryParameters: queryParameters,
        bodyData: data,
        formData: formData,
        uploadProgress: uploadProgress,
        errorHandler: errorHandler
    );
  }


  Future<ResponseModel<RType>?> put<RType extends BaseModel>(String path,{
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
    required ErrorHandler<ResponseModel<RType>> errorHandler
  }) async {
    return super.typedReq<ResponseModel<RType>>(path, "PUT",
      queryParameters: queryParameters,
      bodyData: data,
      formData: formData,
      uploadProgress: uploadProgress,
      errorHandler: errorHandler,
    );
  }

  Future<ResponseModel<RType>?> delete<RType extends BaseModel>(String path,{
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
    required ErrorHandler<ResponseModel<RType>> errorHandler
  }) async {
    return super.typedReq<ResponseModel<RType>>(path, "DELETE",
        queryParameters: queryParameters,
        bodyData: data,
        formData: formData,
        uploadProgress: uploadProgress,
        errorHandler: errorHandler
    );
  }



  Future<ResponseModel<RType>?> upload<RType extends BaseModel>(
      String path,
      String name,
      String fieldName,{
        required Uint8List fileByte,
        Map<String, dynamic>? queryParameters,
        OnUploadProgressCallback? uploadProgress,
        required ErrorHandler<ResponseModel<RType>> errorHandler
      }) async {
    FormData formData = FormData.fromMap({
      fieldName: MultipartFile.fromBytes(fileByte,
        filename: name,
        contentType: DioMediaType.parse(lookupMimeType(name)??"application/octet-stream"),
      )
    });
    return super.typedReq<ResponseModel<RType>>(path, "POST",
        queryParameters: queryParameters,
        formData: formData,
        uploadProgress: uploadProgress,
        errorHandler: errorHandler
    );
  }

}