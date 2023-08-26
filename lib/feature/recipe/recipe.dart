// Recipe class that contains ingredients and steps
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
        id: json["id"],
        name: json["name"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        steps: List<String>.from(json["steps"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "steps": List<dynamic>.from(steps.map((x) => x)),
      };
}