import 'package:favorcate/core/model/meal_model.dart';

import 'http_request.dart';

class HYMealRequest {
  static Future<List<HYMealModel>> getMealData() async {
    // 1.发送网络请求
    final url = "/meal";
    final result = await HttpRequest.request(url);

    // 2.json转modal
    final mealArray = result["meal"];
    List<HYMealModel> meals = [];
    for (var json in mealArray) {
      meals.add(HYMealModel.fromJson(json));
    }
    return meals;
  }
}