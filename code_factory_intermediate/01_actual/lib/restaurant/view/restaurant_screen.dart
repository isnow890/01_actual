import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';
import '../component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();
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
                print(snapshot.data);
                // print(snapshot.error);
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 16.0,
                  ),
                  itemBuilder: (context, index) {
                    //parsed
                    final item = snapshot.data![index];
                    final pItem = RestaurantModel(
                        id: item['id'],
                        name: item['name'],
                        thumbUrl: 'http://$ip/${item['thumbUrl']}',
                        tags: List<String>.from(item['tags']),
                        printRange: RestaurantPriceRange.values.firstWhere(
                            (element) => element.name == item['priceRange']),
                        ratings: item['ratings'],
                        ratingsCount: item['ratingsCount'],
                        deliveryTime: item['deliveryTime'],
                        deliveryFee: item['deliveryFee']);

                    return RestaurantCard(
                      image: Image.network(pItem.thumbUrl,
                          fit: BoxFit.cover),
                      // image: Image.asset(
                      //   'asset/img/food/ddeok_bok_gi.jpg'
                      //   //As small as possible while still covering the entire target box
                      //   ,
                      //   fit: BoxFit.cover,
                      // ),
                      name: pItem.name,
                      //List<String>.from으로 List<dynamic> 형태를 형변환 해줄 수 있음.
                      tags: pItem.tags,
                      ratingsCount: pItem.ratingsCount,
                      deliveryTime: pItem.deliveryTime,
                      deliveryFee: pItem.deliveryFee,
                      ratings: pItem.ratings,
                    );
                  },
                );
              })),
    ));
  }
}
