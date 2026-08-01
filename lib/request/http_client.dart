
import 'package:dio/dio.dart' hide Headers;
import 'types.dart';

class HttpClient{
  final String? baseUrl;
  final Dio dio;
  final Duration? connectTimeout;
  final List<Interceptor> interceptors;
  const HttpClient({
    required this.dio,
    this.baseUrl,
    this.connectTimeout,
    this.interceptors = const []
  });
  Future<Response<String>> request(String path,String method,{
    Map<String, dynamic>? bodyData,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
  }) async{
    dio.interceptors.addAll(interceptors);
    return dio.request<String>(
        "${baseUrl??""}$path",
        data: bodyData??formData,
        queryParameters: queryParameters,
        onSendProgress: uploadProgress,
        options: Options(
          method: method,
          responseType: ResponseType.plain,
          maxRedirects: 0,
          connectTimeout: connectTimeout
        )
    );
  }
}