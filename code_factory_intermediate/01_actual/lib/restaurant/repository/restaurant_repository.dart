//RetroFit

//1. import 하기
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

//2. part 선언하기
part 'restaurant_repository.g.dart';

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
  @Headers({'accessToken':'true'})
  Future<CursorPagination<RestaurantModel>> paginate();



  @GET('/{id}')
  @Headers({'accessToken':'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
