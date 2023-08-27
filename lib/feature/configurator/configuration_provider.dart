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
    _activeIngredients = ingredients ?? [];
    instance = this; // Singleton pattern
  }

  bool loadingIngredients = false;

  /// Recommended to use this when notifications about updates are not required instead of using getProvider<LoggedUserProvider>(context, listen: false). Reason: avoid over use of context
  static late final ConfigurationProvider instance; // Singleton pattern

  List<String> get activeIngredients => _activeIngredients;
  late final List<String> _activeIngredients;

  List<String> get deactivatedIngredients => _deactivatedIngredients;
  late final List<String> _deactivatedIngredients;

  void addIngredient(String ingredient) {
    if (ingredient.isNullOrEmpty) return;
    _activeIngredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(String ingredient) {
    if (ingredient.isNullOrEmpty) return;
    _activeIngredients.remove(ingredient);
    _deactivatedIngredients.remove(ingredient);
    notifyListeners();
  }

  void deactivateIngredient(String ingredient) {
    if (ingredient.isNullOrEmpty) return;
    _activeIngredients.remove(ingredient);
    _deactivatedIngredients.add(ingredient);
    notifyListeners();
  }

  void activateIngredient(String ingredient) {
    if (ingredient.isNullOrEmpty) return;
    _activeIngredients.add(ingredient);
    _deactivatedIngredients.remove(ingredient);
    notifyListeners();
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
    _deactivatedIngredients.addAll(ingredients);
    notifyListeners();
  }
}
