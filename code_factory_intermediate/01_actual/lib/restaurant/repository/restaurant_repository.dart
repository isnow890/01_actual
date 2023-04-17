//RetroFit

//1. import 하기
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
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
  // @GET('/')
  // paginate();

  @GET('/{id}')
  @Headers({'authorization':'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNjgxNzMyNTk1LCJleHAiOjE2ODE3MzI4OTV9.wEg9IrxPuALvvy1QMGhJpUB1gHyOVlC9iEJZ_ZXpbvw'})
  //http://$ip/restaurant/:id/
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
