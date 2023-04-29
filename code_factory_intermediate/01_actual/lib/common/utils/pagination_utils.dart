import 'package:actual/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static void paginate(
      {required ScrollController controller,
      required PaginationProvider provider}) {
    //현재 위치가
    //최대 길이보다 조금 덜되는 위치까지 왔다면
    //새로운 데이터를 추가요청한다.

    //최대스크롤가능한 길이 마이너스 300 보다 현재 스크롤 위치가 크면
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}
