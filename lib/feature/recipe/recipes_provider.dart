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
  
  List<Recipe> get recipes => List.from(_recipes);
  late final List<Recipe> _recipes;

  bool loadingRecipe = false;
  

  static void getNew() async {
    Debug.logWarning(ConfigurationProvider.instance.activeIngredients.isEmpty, "A recipe cannot be generated without ingredients.");
    Debug.logWarning(RecipesProvider.instance.loadingRecipe, "A recipe is already being generated.");

    Debug.log("Requesting new recipe...");

    RecipesProvider.instance.loadingRecipe = true;
    RecipesProvider.instance.notifyListeners();

    String type = ConfigurationProvider.instance.type;
    String recipeText = await _getText();

    Map<String, dynamic>? recipeJSON;
    int maxTries = 3;
    for (int i = 1; i <= maxTries; i++) {
      String text = recipeText;

      try {
        // switch (i) {
        //   case 1:
        //     text += "\nEnjoy!";
        //     break;
        //   case 2:
        //     text += "\nI hope you like te recipe!";
        //     break;
        //   case 3:
        //     text += "\nEnd of recipe.\nPlease, remember to close to Json.";
        //     break;
        // }

        recipeJSON = await _getJson(text: text, addFinalBracket: i == maxTries);
        break;
      } catch (e) {
        if (i == maxTries) {
          RecipesProvider.instance.loadingRecipe = false;
          RecipesProvider.instance.notifyListeners();
          Debug.logError("Too many tries ($i) to get a proper JSON formatted recipe: $e");
        } else {
          Debug.logWarning(true, asAssertion: false, "Error while getting JSON formatted recipe. Try number $i. Will retry...\n$e");
          Future.delayed(const Duration(seconds: 1));
        }
      }
    }

    if (recipeJSON != null) {
      Debug.logSuccess("Recipe received.");
      // Save the recipe in the provider
      Recipe recipe = Recipe.fromJson(recipeJSON, type: type);
      RecipesProvider.instance._recipes.add(recipe);
      _loadImage(recipe: recipe);
    }

    RecipesProvider.instance.loadingRecipe = false;
    RecipesProvider.instance.notifyListeners();
  }

  static Future<String> _getText() async {
    Debug.logSuccessUpload("Requesting text recipe...");


    String inputText =
        "Available ingredients:\n"
        "${ConfigurationProvider.instance.activeIngredients.join(", ")}\n"
        "Maximum duration:\n"
        "${ConfigurationProvider.instance.duration.inMinutes} minutes\n"
        "Food for: ${ConfigurationProvider.instance.people} people\n"
        "Difficulty: ${ConfigurationProvider.instance.difficultyAsText}\n"
        "Preferences: ${ConfigurationProvider.instance.activeDesires.join(", ")}\n"
        "Available appliances: ${ConfigurationProvider.instance.activeDesires.join(", ")}\n"
        "Food type: ${ConfigurationProvider.instance.type}\n";

    // "recipe-generator-large-13B/results",
    Response response = await clarifai.post(
      "recipe-generator-gpt-4/results",
      data: {
        "inputs": [
          {
            "data": {
              "text": {"raw": inputText}
            }
          }
        ]
      },
    );

    String recipeText = response.data["results"][0]["outputs"][1]["data"]["text"]["raw"];

    Debug.logSuccessDownload("Recipe in text format:\n$recipeText");
    return recipeText;
  }

  static Future<Map<String, dynamic>> _getJson({required String text, required bool addFinalBracket}) async {
    Debug.logSuccessUpload("Requesting JSON recipe...");

    // "json-large-13B/results",
    Response response = await clarifai.post(
      "json-formatter-gpt-4/results",
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

    String recipeAsString = response.data["results"][0]["outputs"][2]["data"]["text"]["raw"];
    late Map<String, dynamic> recipeJSON;

    try {
      recipeJSON = Map<String, dynamic>.from(json.decode(recipeAsString));
    } catch (e) {
      try {
        Debug.logDev('Adding extra bracket "}" to the end of the recipe to try to make it a valid JSON.');
        recipeJSON = Map<String, dynamic>.from(json.decode("$recipeAsString}"));
      } catch (e) {
        Debug.logDev('Adding extra bracket and closing list "}]" to the end of the recipe to try to make it a valid JSON.');
        recipeJSON = Map<String, dynamic>.from(json.decode("$recipeAsString]}"));
      }
    }

    Debug.logSuccessDownload("Recipe in json format:\n${recipeJSON.toString()}");
    return recipeJSON;
  }

  static void _loadImage({required Recipe recipe}) async {
    Debug.logSuccessUpload("Requesting image for recipe...");

    Response response = await clarifai.post(
      "image-generator/results",
      data: {
        "inputs": [
          {
            "data": {
              "text": {"raw": recipe.title}
            }
          }
        ]
      },
    );

    String img = response.data["results"][0]["outputs"][1]["data"]["image"]["base64"];
    recipe.image = base64Decode(img);

    Debug.logSuccessDownload("Recipe image loaded.");
    RecipesProvider.instance.notifyListeners();
  }
}
