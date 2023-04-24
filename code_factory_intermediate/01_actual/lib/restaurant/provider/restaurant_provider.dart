import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기.
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    // 화면에 있는 데이터를 다 지우고 로딩함.
    bool forceRefetch = false,
  }) async {
    // 5가지 가능성
    // [상태가]
    // 1) CursorPagination - 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
    // 3) CursorPaginationError - 에러가 있는 상태
    // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
    // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

    // 바로 반환하는 상황
    // 1) hasMore = false 일때 (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
    // 2) 로딩중 - fetchMore : true
    //     fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.
    //Pagination을 한번이라도 갖고 있는 상황일 경우에
    if (state is CursorPagination && !forceRefetch){
      final pState = state as CursorPagination;
      if (!pState.meta.hasMore){
        return;
      }
    }
    //현재 로딩중인지 확인하기 위하여
    final isLoading = state is CursorPaginationLoading;
    //데이터를 받아온 적은 있는데 새로고침을 하였을 때.
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;

    //2번 반환 상황
    if (fetchMore && (isLoading || isRefetching || isFetchingMore)){
      return;
    }



    // final resp = await repository.paginate();
    // state = resp;
  }
}
