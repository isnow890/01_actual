import 'package:actual/common/const/data.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/auth_provider.dart';
import 'package:actual/user/repository/auth_repository.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/secure_storage/secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return UserMeStateNotifier(
      repository: repository, storage: storage, authRepository: authRepository);
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final UserMeRepository repository;
  final AuthRepository authRepository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier(
      {required this.storage,
      required this.repository,
      required this.authRepository})
      : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }
    final resp = await repository.getMe();
    state = resp;
  }

  //로그인 로직
  Future<UserModelBase> login(
      {required String username, required String password}) async {
    try {
      state = UserModelLoading();
      final resp =
          await authRepository.login(username: username, password: password);

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();
      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  //로그아웃 로직
  Future<void> logout() async{
    state=null;
    Future.wait([
    storage.delete(key: REFRESH_TOKEN_KEY),
    storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
