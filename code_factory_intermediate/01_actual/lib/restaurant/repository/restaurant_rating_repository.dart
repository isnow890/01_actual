
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';
import '../model/restaurant_model.dart';

part 'restaurant_rating_repository.g.dart';
// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams =
    const PaginationParams(after: '', count: null),
  });



}

