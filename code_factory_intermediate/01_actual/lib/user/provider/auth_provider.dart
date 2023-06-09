import 'package:actual/common/view/root_tab.dart';
import 'package:actual/order/view/order_done_screen.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:actual/user/view/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../restaurant/view/basket_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    //유저가 로딩중인지 에러가 나는지등등을 알 수 있음
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      //다른 값이 들어올때만 AuthProvider에서 알려줌.
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  //SplashScreen
  //앱을 처음 시작했을때
  //토큰이 존재하는지 확인하고
  //로그인 스크린으로 보내줄지
  //홈 스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(_, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';
    //유저 정보가 없는데
    //로그인중이면 그대로 로그인 페이지에 두고
    //만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    //UserModel
    //사용자 정보가 있는 상태면
    //로그인 중이거나 현재 위치가 SplashScreen이면
    //홈으로 이동
    if (user is UserModel) {
      return logginIn || state.location == '/splash'
          ?
          //null은 원래의 위치를 의미함.
          '/'
          : null;
    }

    //UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => RootTab(),
          routes: [
            //상세페이지를 위하여 등록함.
            GoRoute(
              //파라메터 입력
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (context, state) {
                //path의 :rid 값을 가져옴.
                return RestaurantDetailScreen(
                  id: state.pathParameters['rid']!,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (context, state) => BasketScreen(),
        ),
        GoRoute(
          path: '/order_done',
          name: OrderDoneScreen.routeName,
          builder: (context, state) => OrderDoneScreen(),
        ),
      ];

  //
  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }
}
