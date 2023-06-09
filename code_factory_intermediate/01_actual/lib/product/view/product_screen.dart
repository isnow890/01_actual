import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/product/provider/product_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../restaurant/model/restaurant_detail_model.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(RestaurantDetailScreen.routeName, pathParameters: {
                  'rid' : model.restaurant.id,
                });
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) =>
                //         RestaurantDetailScreen(id: model.restaurant.id)));
              },
              child: ProductCard.fromProductModel(model: model));
        });

    return Center(
      child: Text('음식'),
    );
  }
}
