import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/api.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipe.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

// https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
// getProvider<X> vs. Consumer<X> https://stackoverflow.com/a/58774889/7927429
class RecipesProvider extends ChangeNotifier {
  RecipesProvider({List<Recipe>? recipes}) {
    _recipes = recipes ?? [];
    instance = this; // Singleton pattern
  }

  /// Recommended to use this when notifications about updates are not required instead of using getProvider<LoggedUserProvider>(context, listen: false). Reason: avoid over use of context
  static late final RecipesProvider instance; // Singleton pattern

  late final List<Recipe> _recipes;

  bool loadingRecipe = false;

  List<Recipe> get recipes => _recipes;

  static void getNew() async {
    Debug.logWarning(ConfigurationProvider.instance.ingredients.isEmpty, "A recipe cannot be generated without ingredients.");
    Debug.logWarning(RecipesProvider.instance.loadingRecipe, "A recipe is already being generated.");

    Debug.log("Requesting new recipe...");

    RecipesProvider.instance.loadingRecipe = true;
    RecipesProvider.instance.notifyListeners();

    String recipeText = await _getText();

    Map<String, dynamic>? recipeJSON;
    int maxTries = 3;
    for (int i = 1; i <= maxTries; i++) {
      try {
        recipeJSON = await _getJson(text: recipeText);
        break;
      } catch (e) {
        if (i == maxTries) {
          Debug.logError("Too many tries ($i) to get a proper JSON formatted recipe: $e");
        } else {
          Debug.logWarning(true, asAssertion: false, "Error while getting JSON formatted recipe. Try number $i. Will retry...\n$e");
        }
      }
    }

    if (recipeJSON != null) {
      Debug.logSuccess("Recipe received.");
      // TODO: save the recipe in the provider
    }

    RecipesProvider.instance.loadingRecipe = false;
    RecipesProvider.instance.notifyListeners();
  }

  static Future<String> _getText() async {
    Debug.logSuccessUpload("Requesting text recipe...");

    Response response = await clarifai.post(
      "receipt-generator/results",
      data: {
        "inputs": [
          {
            "data": {
              "text": {"raw": ConfigurationProvider.instance.ingredients.join(", ")}
            }
          }
        ]
      },
    );

    String recipeText = response.data["results"][0]["outputs"][1]["data"]["text"]["raw"];

    Debug.logSuccessDownload("Recipe in text format:\n$recipeText");
    return recipeText;
  }

  static Future<Map<String, dynamic>> _getJson({required String text}) async {
    Debug.logSuccessUpload("Requesting JSON recipe...");

    Response response = await clarifai.post(
      "receipt-generator/results",
      data: {
        "inputs": [
          {
            "data": {
              "text": {"raw": text}
            }
          }
        ]
      },
    );

    String recipeAsString = response.data["results"][0]["outputs"][1]["data"]["text"]["raw"];
    Map<String, dynamic> recipeJSON = Map<String, dynamic>.from(json.decode(recipeAsString));

    Debug.logSuccessDownload("Recipe in json format:\n${recipeJSON.toString()}");
    return recipeJSON;
  }
}
