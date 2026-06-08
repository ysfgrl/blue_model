import 'dart:convert';
import 'package:dio/dio.dart' hide Headers;
class BlobRequest {
  final Dio _dio;
  BlobRequest({
    Dio? dio,
  }): _dio = dio ?? Dio() ;
  Future<String> getBlobStr(String url) async{
    var response = await _dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    if(response.data != null) {
      return utf8.decode(response.data!);
    }
    return "";
  }
}