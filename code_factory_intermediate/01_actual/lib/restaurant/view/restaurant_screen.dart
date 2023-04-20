import 'package:actual/common/dio/dio.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));
    //.data는 body 가져올 수 있음.
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                //print(snapshot.data);
                // print(snapshot.error);
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 16.0,
                  ),
                  itemBuilder: (context, index) {
                    //parsed
                    final item = snapshot.data![index];
                    final pItem = RestaurantModel.fromJson(item);

                    // final pItem = RestaurantModel(
                    //     id: item['id'],
                    //     name: item['name'],
                    //     thumbUrl: 'http://$ip/${item['thumbUrl']}',
                    //     tags: List<String>.from(item['tags']),
                    //     printRange: RestaurantPriceRange.values.firstWhere(
                    //         (element) => element.name == item['priceRange']),
                    //     ratings: item['ratings'],
                    //     ratingsCount: item['ratingsCount'],
                    //     deliveryTime: item['deliveryTime'],
                    //     deliveryFee: item['deliveryFee']);

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
