import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

//에러났을때
class UserModelError extends UserModelBase {
  final String message;
  UserModelError({required this.message});
}
//로딩중
class UserModelLoading extends UserModelBase {}

//데이터 가져왔을때
@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imageUrl;

  UserModel({required this.id, required this.username, required this.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
