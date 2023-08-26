import "dart:async";
import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

// https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
// getProvider<X> vs. Consumer<X> https://stackoverflow.com/a/58774889/7927429
class ConfigurationProvider extends ChangeNotifier {

  ConfigurationProvider({List<String>? ingredients}) {
    _ingredients = ingredients ?? [];
    instance = this; // Singleton pattern
  }

  /// Recommended to use this when notifications about updates are not required instead of using getProvider<LoggedUserProvider>(context, listen: false). Reason: avoid over use of context
  static late final ConfigurationProvider instance; // Singleton pattern

  late final List<String> _ingredients;

  List<String> get ingredients => _ingredients;

  void addIngredient(String ingredient) {
    if (ingredient.isNullOrEmpty) return;
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(String ingredient) {
    _ingredients.remove(ingredient);
    notifyListeners();
  }
}
