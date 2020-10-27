import 'package:favorcate/core/services/meal_request.dart';
import 'package:favorcate/core/viewmodel/base_view_model.dart';

class HYMealViewModel extends BaseMealViewModel {
  HYMealViewModel() {
    HYMealRequest.getMealData().then((res) {
      meals = res;
    });
  }
}