import 'package:actual/common/model/token_response.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../../common/model/login_response.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = AuthRepository(dio: dio, baseUrl: 'http://$ip/auth');
  return repository;
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

//http://wlkfjwe/auth
  AuthRepository({required this.baseUrl, required this.dio});

  Future<LoginResponse> login(
      {required String userName, required String password}) async {
    final String serialized = DataUtils.plainToBase64('$userName:$password');
    final resp = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {
          'authorization': 'Basic $serialized',
        },
      ),
    );

    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post('$baseUrl/token',
        options: Options(headers: {'refreshToken': 'true'}));

    return TokenResponse.fromJson(resp.data);
  }
}
