import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/order/view/order_screen.dart';
import 'package:flutter/material.dart';

import '../../product/view/product_screen.dart';
import '../../restaurant/view/restaurant_screen.dart';
import '../../user/view/profile_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);
  static String get routeName =>'home';

  @override
  State<RootTab> createState() => _RootTabState();
}

//controller 사용 위하여 with SingleTickerProviderStateMixin 선언
class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {



  //나중에 입력이 됨. 그러므로 late 사용
  late TabController controller;
  int index = 0;

  //initState에 TabController 등록
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //length -> children의 길이
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() => index = controller.index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        //선택되었을때
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        //선택했을때 크기를 고정하고 글자를 나오게 함.
        type: BottomNavigationBarType.fixed,
        //탭했을때
        onTap: (int value) {
          index = value;
          controller.animateTo(value);
          // setState(() {
          //   index = value;
          // });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: '프로필'),
        ],
      ),
      title: '코팩 딜리버리',
      //TabBar
      child: TabBarView(
          //좌우로 스와이핑 기능 막기.
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            RestaurantScreen(),
            ProductScreen(),
            OrderScreen(),
            ProfileScreen(),
          ]),
    );
  }
}
