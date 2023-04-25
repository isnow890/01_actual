import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    //현재 위치가
    //최대 길이보다 조금 덜되는 위치까지 왔다면
    //새로운 데이터를 추가요청한다.

    //최대스크롤가능한 길이 마이너스 300 보다 현재 스크롤 위치가 크면
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
    print('run');
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final data = ref.watch(restaurantProvider); //계속 생성이 된 이후에 기억이 되므로.

    //완전 처음 로딩일때
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    //CursorPagination
    //CursorPaginationFetchingMore
    //CursorPaginationRefetching

    final cp = data as CursorPagination;

    return ListView.separated(
      controller: controller,
      itemCount: cp!.data.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 16.0,
      ),
      itemBuilder: (context, index) {
        //parsed
        final pItem = cp.data[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                id: pItem.id,
              ),
            ));
          },
          child: RestaurantCard.fromModel(
            model: pItem,
          ),
        );
      },
    );
  }
}
