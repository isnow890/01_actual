import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/pagination_params.dart';

class _PaginationInfo {
  final int fetchCount;

  // 추가로 데이터 더 가져오기.

  // true - 추가로 데이터 더 가져옴
  // false - 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading()
  // 화면에 있는 데이터를 다 지우고 로딩함.
  final bool forceRefetch;

  _PaginationInfo(
      {this.fetchCount = 20,
      this.fetchMore = false,
      this.forceRefetch = false});
}

//113355
//IBasePaginationRepository -> repository만 실질적으로 변경하면 되는데 제네릭을 사용하기 위해서 IBasePaginationRepository를 생성하고 해당 클래스를 상속하여
//제네릭 사용이 가능하게 만들었음.
//IModelWithId의 경우 (T) 리턴되는 타입인데 이것도 제네릭을 사용하기 위하여 공통되게 사용하는 Id 생성함.
//IModelWithId(U)는 T의 지나친 일반화를 줄여주는 역할을 함. 모델을 다 IModelWithID를 상속받게끔 해서.
class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    Duration(seconds: 5), initialValue: _PaginationInfo(),
    //값이 업데이트될때 throttle 사용여부
    checkEquality: false,
  );

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();

    //리스너 생성
    paginationThrottle.values.listen(
      (state) {
        _throttledPagination(state);
      },
    );
  }

  Future<void> paginate({
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
    paginationThrottle.setValue(_PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch));
  }

  _throttledPagination(_PaginationInfo info) async {
    final int fetchCount = info.fetchCount;

    // 추가로 데이터 더 가져오기.

    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움 ) 아래로 스크롤해서 조회할때
    final bool fetchMore = info.fetchMore;

    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    // 화면에 있는 데이터를 다 지우고 로딩함.
    final bool forceRefetch = info.forceRefetch;

    try {
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

      //강제로 조회한 것도 아니고 이미 데이터가 다 조회 된 상태일 경우
      if (state is CursorPagination<T> && !forceRefetch) {
        final pState = state as CursorPagination<T>;
        //더이상 조회될 데이터가 없으니까
        if (!pState.meta.hasMore) {
          return;
        }
      }

      //현재 로딩중인지 확인하기 위하여
      final isLoading = state is CursorPaginationLoading;

      //처음부터 데이터 조회 - 새로고침
      final isRefetching = state is CursorPaginationRefetching;

      //데이터를 받아온 적은 있는데 새로고침을 하였을 때.
      //리스트의 맨 아래로 내려서 추가데이터를 요청하는 중

      final isFetchingMore = state is CursorPaginationFetchingMore;

      //2번 반환 상황
      //이미 데이터가 조회중이므로 return함.
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = (state as CursorPagination<T>);
        state =
            //pState.meta pState.data-> 이미 조회된 상태에서 데이터를 더 붙일것이므로.

            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        //113355 다이나믹으로 유추중이므로 IModelWithId를 만들게 됨.
        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }

      //데이터를 처음부터 가져오는 상황
      else {
        //만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch (API 요청)을 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state =
              CursorPaginationRefetching<T>(meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;
        state = resp.copywith(
            //기존에 있던 데이터 + 새로운 데이터가 추가됨.
            data: [
              ...pState.data,
              ...resp.data,
            ]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터 못가져옴');
    }
  }
}
