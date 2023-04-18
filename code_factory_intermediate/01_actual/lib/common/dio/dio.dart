// 1)요청을 보낼때
// 2)응답을 받을때
// 3)에러가 났을때

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/data.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  // 1)요청을 보낼때
  // 로그로 사용할 수도 있음.
  // 요청을 보내기 전의 상태임.
  //만약에 요청의 header에 accessToken : true라는 값이 있다면
  //실제 토큰을 가져와서 authorization : bearer 의 값을 변경함.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');


    if (options.headers['accessToken'] == 'true') {
       print('시작');
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }


    if (options.headers['refreshToken'] == 'true') {
      print('시작');
      options.headers.remove('refreshToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }


    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }
}
