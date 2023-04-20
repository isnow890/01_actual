import 'package:json_annotation/json_annotation.dart';
import '../../restaurant/model/restaurant_model.dart';
part 'cursor_pagination_model.g.dart';

@JsonSerializable(
  //제네릭 사용 1
  genericArgumentFactories: true,
)
//제네릭 사용 2 T 선언
class CursorPagination <T>{
  final CursorPaginationMeta meta;
  //제네릭 사용 3 T 필요한 부분 선언
  final List<T> data;

  CursorPagination({required this.meta,  required this.data});
  //제네릭 사용 3 T 필요한 부분 선언
  factory CursorPagination.fromJson(Map<String,dynamic> json, T Function(Object? json) fromJsonT)
  =>_$CursorPaginationFromJson(json,fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({required this.count, required this.hasMore});

  factory CursorPaginationMeta.fromJson(Map<String,dynamic> json)
  =>_$CursorPaginationMetaFromJson(json);
}

