import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../model/user_model.dart';

part 'user_me_repository.g.dart';


final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
final dio = ref.watch(dioProvider);
final repository = UserMeRepository(dio,baseUrl: 'http://$ip/user/me');
  return repository;
});

// http://$ip/user/me
@RestApi()
abstract class UserMeRepository {
factory UserMeRepository(Dio dio, {String baseUrl})= _UserMeRepository;
@GET('/')
  @Headers({'accessToken':'true'})
  Future<UserModel> getMe();


}