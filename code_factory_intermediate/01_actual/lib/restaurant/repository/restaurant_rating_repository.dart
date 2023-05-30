import 'package:actual/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';
import '../../common/repository/base_pagination_repository.dart';
import '../model/restaurant_model.dart';

part 'restaurant_rating_repository.g.dart';

//ResApi 호출할때
// http://ip/restaurant/:rid/rating
//와 같이 :rid의 값을 받기 위하여 family로 생성함.
final restaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);
  return RestaurantRatingRepository(dio,
      baseUrl: 'http://$ip/restaurant/$id/rating');
});

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams =
        const PaginationParams(after: '', count: null),
  });
}
