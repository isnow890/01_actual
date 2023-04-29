import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/utils/pagination_utils.dart';
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

    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantProvider.notifier));
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
      itemCount: cp!.data.length + 1,
      separatorBuilder: (context, index) => SizedBox(
        height: 16.0,
      ),
      itemBuilder: (context, index) {
        if (index == cp.data.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Center(
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터입니다.')),
          );
        }

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
