import 'package:actual/common/utils/data_utils.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';

//import 부분 추가
part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;

  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,

    @JsonKey(
      fromJson: DataUtils.pathToUrl,
    )
        required super.thumbUrl,

    required super.tags,

    // @JsonKey(
    //   fromJson: DataUtils.findEnum,
    // )
        required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  

  factory RestaurantDetailModel.fromJson(Map<String,dynamic> json)
  =>_$RestaurantDetailModelFromJson(json);
  
  // //From Json
  // factory RestaurantDetailModel.fromJson(Map<String,dynamic> json)
  // => _$RestaurantDetailModelFromJson(json);
  // //To Json
  // Map<String,dynamic> toJson()=>_$RestaurantDetailModelToJson(this);



}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;

  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel(
      {required this.id,
      required this.name,
      required this.imgUrl,
      required this.detail,
      required this.price});





  factory RestaurantProductModel.fromJson(Map<String,dynamic> json)
  =>_$RestaurantProductModelFromJson(json);




//
// factory RestaurantProductModel.fromJson({
//   required Map<String, dynamic> json,
// }) {
//   return RestaurantProductModel(
//     id: json['id'],
//     name: json['name'],
//     detail: json['detail'],
//     imgUrl: 'http://${ip}${json['imgUrl']}',
//     price: json['price'],
//   );
}
