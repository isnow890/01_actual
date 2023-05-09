// 1)요청을 보낼때
// 2)응답을 받을때
// 3)에러가 났을때

import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../user/provider/auth_provider.dart';
import '../const/data.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.ref, required this.storage});

  // 1)요청을 보낼때
  // 로그로 사용할 수도 있음.
  // 요청을 보내기 전의 상태임.
  //만약에 요청의 header에 accessToken : true라는 값이 있다면
  //실제 토큰을 가져와서 authorization : bearer 의 값을 변경함.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    print('시작');

    print(options.headers['accessToken']);
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }

  // 2)응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    // TODO: implement onResponse
    return super.onResponse(response, handler);
  }

// 3)에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    //401 에러가 났을때 (status code)
    //토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    //다시 새로운 토큰으로 요청.

    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //refreshToken 아예 없으면
    //당연히 에러를 던진다
    if (refreshToken == null) {
      //에러를 발생시킴
      handler.reject((err));
      return;
    }

    final isStatus401 = err.response?.statusCode == 401;
    //토큰을 refresh 하려다가 에러가 났다는 뜻임.
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        //토큰 변경하기
        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await storage.write(
            key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

        //요청 재전송 (토큰 새로 발급 후 다시 실행)
        final response = await dio.fetch(options);

        //요청이 성공했다는 상태를 반환함.
        return handler.resolve(response);
        // await storage.write(key: REFRESH_TOKEN_KEY, value: resp.data['refreshToken']);
      } on DioError catch (e) {
        //Circular dependency Error
        //A,B
        //A->B의 친구
        //B-A의 친구
        //A-B-A-B-A-B
        //상호 참조하므로 에러 발생 근데 난 발생 안함.
        //userMeProvider와 dio가 상호 참조하고 있음

        ref.read(authProvider.notifier).logout();
        handler.reject(e);
      }
    }

    //에러 없이 종료할 수 있다.
    // return handler.resolve(response);

    // TODO: implement onError
    return super.onError(err, handler);
  }
}
