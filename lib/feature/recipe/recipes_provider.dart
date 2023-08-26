
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

    RecipesProvider.instance.loadingRecipe = false;
    RecipesProvider.instance.notifyListeners();

    dynamic recipe = response.data["results"][0]["outputs"][4]["data"]["text"]["raw"];
    Debug.logDev(response.data.toString());
    Debug.logSuccessDownload("Properly formatted response! $recipe");

    // TODO: save the recipe in the provider

    RecipesProvider.instance.notifyListeners();
  }
}