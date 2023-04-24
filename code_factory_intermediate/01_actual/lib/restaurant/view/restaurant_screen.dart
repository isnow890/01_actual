import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider); //계속 생성이 된 이후에 기억이 되므로.

    if (data.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.separated(
      itemCount: data!.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 16.0,
      ),
      itemBuilder: (context, index) {
        //parsed
        final pItem = data[index];

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
