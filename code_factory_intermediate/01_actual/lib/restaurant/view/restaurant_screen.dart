import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/utils/pagination_utils.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);


  @override
  Widget build(
    BuildContext context,
  ) {
    return PaginationListView(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RestaurantDetailScreen(
                  id: model.id,
                ),
              ));
            },
            child: RestaurantCard.fromModel(
              model: model,
            ),
          );
        });
  }
}
