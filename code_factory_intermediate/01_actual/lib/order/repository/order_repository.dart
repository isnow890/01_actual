import 'package:actual/common/dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../model/order_model.dart';
import '../model/post_order_body.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return OrderRepository(dio, baseUrl: 'http://$ip/order');
  },
);

@RestApi()
//http://$ip/order/

abstract class OrderRepository {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @POST('/')
  @Headers(
    {'accessToken': 'true'},
  )
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}