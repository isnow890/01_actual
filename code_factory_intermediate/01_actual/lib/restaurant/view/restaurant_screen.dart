import 'package:actual/common/dio/dio.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
        child: Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<CursorPagination<RestaurantModel>>(
            //riverPod 사용해서 한번에 처리.
              future:  ref.watch(restaurantRepositoryProvider).paginate(),
              builder:
                  (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
                //print(snapshot.data);
                // print(snapshot.error);
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.separated(
                  itemCount: snapshot.data!.data.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 16.0,
                  ),
                  itemBuilder: (context, index) {
                    //parsed
                    final pItem = snapshot.data!.data[index];

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
              })),
    ));
  }
}
