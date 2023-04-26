import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../model/restaurant_model.dart';

//반환 RestaurantModel, 입력값 String
final restaurantDetailProvider =
Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);
  //데이터가 리스트에 없으므로.
  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
      (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);



class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required super.repository});


  void getDetail({
    required String id,
  }) async {
    //만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // state가 CursorPagination이 아닐때 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    //새로 요청한 데이터로 변경함.

    state = pState.copywith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList(),);

  }
}
