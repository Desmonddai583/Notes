import 'package:favorcate/core/model/meal_model.dart';
import 'package:favorcate/core/viewmodel/base_view_model.dart';
import 'package:flutter/material.dart';

import 'filter_view_model.dart';

class HYFavorViewModel extends BaseMealViewModel {
  void addMeal(HYMealModel meal) {
    originMeals.add(meal);
    notifyListeners();
  }

  void removeMeal(HYMealModel meal) {
    originMeals.remove(meal);
    notifyListeners();
  }

  void handleMeal(HYMealModel meal) {
    if (isFavor(meal)) {
      removeMeal(meal);
    } else {
      addMeal(meal);
    }
  }

  bool isFavor(HYMealModel meal) {
    return originMeals.contains(meal);
  }
}