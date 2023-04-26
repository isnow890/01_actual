//RetroFit

//1. import 하기
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_rating_repository.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';

//2. part 선언하기
part 'restaurant_repository.g.dart';


final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  //똑같은 dio 인스턴스를 부르기 위하여
  final dio = ref.watch(dioProvider);
  final repository =
      RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
  return repository;
});

//RetroFit

//3.RestApi Annotation 적용하기
@RestApi()
abstract class RestaurantRepository {
  //4 생성자 넣기
  //http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  //baseUrl 이후의 url
  //http://$ip/restaurant
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams =
        const PaginationParams(after: '', count: null),
  });

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
