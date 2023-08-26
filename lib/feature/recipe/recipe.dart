// Recipe class that contains ingredients and steps
import "package:uuid/uuid.dart";

class Recipe {
  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
  });

  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> steps;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: const Uuid().v4(),
        name: json["title"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        steps: List<String>.from(json["steps"].map((x) => x)),
      );
}
