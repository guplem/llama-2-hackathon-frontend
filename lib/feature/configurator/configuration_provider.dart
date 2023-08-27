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
  ConfigurationProvider({List<String>? activeIngredients, List<String>? inactiveIngredients}) {
    instance = this;
    Map<String, bool> active = Map.fromEntries(activeIngredients?.map((ingredient) => MapEntry(ingredient, true)) ?? {});
    Map<String, bool> inactive = Map.fromEntries(inactiveIngredients?.map((ingredient) => MapEntry(ingredient, false)) ?? {});
    _ingredients = {...active, ...inactive};
  }

  static late final ConfigurationProvider instance;

  //# region ingredients

  bool loadingIngredients = false;

  List<String> get activeIngredients => _ingredients.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList().cast<String>();

  List<String> get deactivatedIngredients => _ingredients.entries.where((entry) => entry.value == false).map((entry) => entry.key).toList().cast<String>();

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

  List<String> get deactivatedDesires => desires.entries.where((entry) => entry.value == false).map((entry) => entry.key).toList().cast<String>();

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

  //# region appliances

  List<String> get activeAppliances => appliances.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList().cast<String>();

  List<String> get deactivatedAppliances => appliances.entries.where((entry) => entry.value == false).map((entry) => entry.key).toList().cast<String>();

  Map<String, bool> get appliances => _appliances;
  final Map<String, bool> _appliances = {
    "Stove": true,
    "Oven": true,
    "Instant Pot": true,
    "Air fryer": false,
    "Blender": false,
    "Bread machine": false,
    "Coffee maker": false,
    "Convection oven": false,
    "Deep fryer": false,
    "Dutch oven": false,
    "Electric skillet": false,
    "Food processor": false,
    "Grill": false,
    "Juicer": false,
    "Microwave": false,
    "Pressure cooker": false,
    "Rice cooker": false,
    "Slow cooker": false,
    "Sous vide": false,
    "Toaster": false,
    "Waffle maker": false,
    "Kettle": false,
    "Mixer": false,
    "Handheld immersion blender": false,
    "Bread maker": false,
    "Panini press": false,
  };

  void updateApplianceStatus(String appliance, bool isActive) {
    if (appliance.isEmpty) return;
    _appliances[appliance] = isActive;
    notifyListeners();
  }

  void addAppliance(String appliance) {
    if (appliance.isEmpty) return;
    _appliances[appliance] = true;
    notifyListeners();
  }

  void removeAppliance(String appliance) {
    if (appliance.isEmpty) return;
    _appliances.remove(appliance);
    notifyListeners();
  }

  void deactivateAppliance(String appliance) {
    updateApplianceStatus(appliance, false);
  }

  void activateAppliance(String appliance) {
    updateApplianceStatus(appliance, true);
  }

  //# endregion appliances

  //# region people

  int get people => _people;
  int _people = 2;

  void updatePeople(int people) {
    if (people < 1) return;
    _people = people;
    notifyListeners();
  }

  void addPerson() {
    _people++;
    notifyListeners();
  }

  void removePerson() {
    if (_people > 1) _people--;
    notifyListeners();
  }

  //# endregion people

  //# region duration

  Duration get duration => _duration;
  Duration _duration = const Duration(minutes: 30);

  void updateDuration(Duration duration) {
    if (duration.inMinutes < 1) return;
    _duration = duration;
    notifyListeners();
  }

  // endregion duration

  //# region difficulty

  String get difficultyAsText {
    return _difficulty == 2
        ? "Easy"
        : _difficulty == 2
            ? "Medium"
            : "Hard";
  }

  int get difficulty => _difficulty;
  int _difficulty = 2;

  void updateDifficulty(int difficulty) {
    if (difficulty < 1 || difficulty > 3) return;
    _difficulty = difficulty;
    notifyListeners();
  }

  // endregion difficulty

  //# region type

  String get type => _type;
  String _type = "Any";

  void updateType(String type) {
    if (type.isEmpty) return;
    _type = type;
    notifyListeners();
  }

  // endregion type
}
