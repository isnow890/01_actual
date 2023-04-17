import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';

//import 부분 추가
part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap;
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;

  //변형할 값을 JsonKey Annotation 사용함.
  //이후에 다시 빌드 실행해야함.
  @JsonKey(
    fromJson:pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange printRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.printRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  //From Json
  factory RestaurantModel.fromJson(Map<String,dynamic> json)
  => _$RestaurantModelFromJson(json);

  //To Json
  Map<String,dynamic> toJson()=>_$RestaurantModelToJson(this);


  //From Json에서 변형해야할 Property를 위한 Static Method
  static pathToUrl(String value)=> 'http://$ip/${value}';


  //
  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip/${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     printRange: RestaurantPriceRange.values
  //         .firstWhere((element) => element.name == json['priceRange']),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //   );
  // }
}
