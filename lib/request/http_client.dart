
import 'package:dio/dio.dart' hide Headers;
import 'types.dart';

class HttpClient{
  final String? baseUrl;
  final Map<String, String>? headers;
  final Dio dio;
  final Duration? timeout;
  const HttpClient({
    required this.dio,
    this.headers,
    this.baseUrl,
    this.timeout
  });
  Future<Response<String>> request(String path,String method,{
    Map<String, dynamic>? bodyData,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    OnUploadProgressCallback? uploadProgress,
  }) async{
    final margeOptions = <String, dynamic>{};
    margeOptions.addAll(dio.options.headers);
    margeOptions.addAll(headers?? {});
    return dio.request<String>(
        "${baseUrl??""}$path",
        data: bodyData??formData,
        queryParameters: queryParameters,
        onSendProgress: uploadProgress,
        options: Options(
          method: method,
          headers: margeOptions,
          responseType: ResponseType.plain,
          maxRedirects: 0,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        )
    );
  }
}