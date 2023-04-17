import '../../restaurant/model/restaurant_model.dart';
import '../const/data.dart';

class DataUtils{
  static pathToUrl(String value) => 'http://$ip/${value}';

  static findEnum(String value) => RestaurantPriceRange.values
      .firstWhere((element) => element.name == value);

}