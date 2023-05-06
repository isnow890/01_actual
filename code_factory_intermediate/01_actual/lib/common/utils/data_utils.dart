import 'dart:convert';

import '../../restaurant/model/restaurant_model.dart';
import '../const/data.dart';

class DataUtils{
  static String pathToUrl(String value) => 'http://$ip/${value}';

  static findEnum(String value) => RestaurantPriceRange.values
      .firstWhere((element) => element.name == value);

  static List<String> listPathsToUrls(List paths)=> paths.map((e) => pathToUrl(e)).toList();

  static String plainToBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(plain);
    return encoded;

  }

}