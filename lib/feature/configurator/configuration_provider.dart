import "dart:convert";
import "dart:typed_data";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

import "package:receptes_rostisseries_delgado/api.dart";

// https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
// getProvider<X> vs. Consumer<X> https://stackoverflow.com/a/58774889/7927429
class ConfigurationProvider extends ChangeNotifier {
  ConfigurationProvider({List<String>? ingredients}) {
    instance = this;
    _ingredients = Map.fromEntries(ingredients?.map((ingredient) => MapEntry(ingredient, true)) ?? {});
  }

  static late final ConfigurationProvider instance;

//# region ingredients

  bool loadingIngredients = false;

  List<String> get activeIngredients => _ingredients.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList().cast<String>();

  Map<String, bool> get ingredients => Map<String, bool>.from(_ingredients);
  late final Map<String, bool> _ingredients;

  void updateIngredientStatus(String ingredient, bool isActive) {
    if (ingredient.isEmpty) return;
    _ingredients[ingredient] = isActive;
    notifyListeners();
  }

  void addIngredient(String ingredient) {
    if (ingredient.isEmpty) return;
    _ingredients[ingredient] = true;
    notifyListeners();
  }

  void removeIngredient(String ingredient) {
    if (ingredient.isEmpty) return;
    _ingredients.remove(ingredient);
    notifyListeners();
  }

  void deactivateIngredient(String ingredient) {
    updateIngredientStatus(ingredient, false);
  }

  void activateIngredient(String ingredient) {
    updateIngredientStatus(ingredient, true);
  }

  void addIngredientsFromImage(XFile image) async {
    Debug.logSuccessUpload("Requesting ingredients from image...");

    loadingIngredients = true;
    notifyListeners();

    Uint8List bytes = await image.readAsBytes();
    String base64 = base64Encode(bytes);

    Response response = await clarifai.post(
      "food-recognition/results",
      data: {
        "inputs": [
          {
            "data": {
              "image": {"base64": base64},
            }
          }
        ]
      },
    );

    List<dynamic> concepts = response.data["results"][0]["outputs"][0]["data"]["concepts"];
    concepts.removeWhere((concept) => concept["value"] < 0.7);
    List<String> ingredients = concepts.map((concept) => concept["name"]).toList().cast<String>();
    ingredients.removeWhere((ingredient) => ingredient.isNullOrEmpty);
    ingredients = ingredients.map((ingredient) => ingredient.trim().capitalizeFirstLetter()!).toList();

    Debug.logSuccessDownload("Ingredients in text format:\n$ingredients");

    loadingIngredients = false;
    _ingredients.addAll(Map.fromEntries(ingredients.map((ingredient) => MapEntry(ingredient, false))));
    notifyListeners();
  }

//# endregion ingredients

  //# region desires

  List<String> get activeDesires => desires.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList().cast<String>();
  Map<String, bool> get desires => _desires;
  final Map<String, bool> _desires = {
    "Vegetarian": false,
    "Vegan": false,
    "Low-calorie": false,
    "High-protein": false,
    "Gluten-free": false,
    "Dairy-free": false,
    "Nut-free": false,
    "Paleo": false,
    "Keto": false,
    "Heart-healthy": false,
    "Sugar-free": false,
    "High-fiber": false,
    "Low-carb": false,
    "Whole30": false,
    "Pescatarian": false,
    "Flexitarian": false,
    "Diabetic-friendly": false,
    "Kid-friendly": false,
    "Quick and easy": false,
    "Budget-friendly": false,
    "Allergen-friendly": false,
    "Raw": false,
    "Comfort food": false,
    "High-energy": false,
    "Low-sodium": false,
    "Anti-inflammatory": false,
    "Immune-boosting": false,
    "Gourmet": false,
    "One-pot meal": false,
    "Slow cooker/crockpot meal": false,
    "Batch cooking/meal prep": false,
    "Spicy/hot": false,
    "Mild": false,
    "Traditional": false,
    "Fusion": false,
    "Light and refreshing": false,
    "Hearty and filling": false,
    "Asian": false,
    "Mexican": false,
    "Italian": false,
    "Middle Eastern": false,
    "Indian": false,
    "Mediterranean": false,
    "Thai": false,
    "Chinese": false,
    "Japanese": false,
    "French": false,
    "African": false,
    "Caribbean": false,
  };

  void updateDesireStatus(String desire, bool isActive) {
    if (desire.isEmpty) return;
    _desires[desire] = isActive;
    notifyListeners();
  }

  void addDesire(String desire) {
    if (desire.isEmpty) return;
    _desires[desire] = true;
    notifyListeners();
  }

  void removeDesire(String desire) {
    if (desire.isEmpty) return;
    _desires.remove(desire);
    notifyListeners();
  }

  void deactivateDesire(String desire) {
    updateDesireStatus(desire, false);
  }

  void activateDesire(String desire) {
    updateDesireStatus(desire, true);
  }

  //# endregion desires
}
