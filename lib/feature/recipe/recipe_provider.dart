import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/api.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipe.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

// https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
// getProvider<X> vs. Consumer<X> https://stackoverflow.com/a/58774889/7927429
class RecipeProvider extends ChangeNotifier {
  RecipeProvider() {
    instance = this; // Singleton pattern
  }

  /// Recommended to use this when notifications about updates are not required instead of using getProvider<LoggedUserProvider>(context, listen: false). Reason: avoid over use of context
  static late final RecipeProvider instance; // Singleton pattern

  final List<Recipe> _recipes = [];

  bool loadingRecipe = false;
  List<Recipe> get recipes => _recipes;

  static void getNew() async {
    Debug.logWarning(ConfigurationProvider.instance.ingredients.isEmpty, "A recipe cannot be generated without ingredients.");
    Debug.logWarning(RecipeProvider.instance.loadingRecipe, "A recipe is already being generated.");

    RecipeProvider.instance.loadingRecipe = true;
    RecipeProvider.instance.notifyListeners();


    Response response = await clarifai.post(
      "llama-code/results",
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

    RecipeProvider.instance.loadingRecipe = false;


    dynamic jsonResponse = jsonDecode(response.data.toString()); /*.results[0].outputs[4].data.text.raw;*/
    Debug.logDev("jsonResponse:\n\n$jsonResponse");

    // TODO: save the recipe in the provider

    RecipeProvider.instance.notifyListeners();
  }
}
