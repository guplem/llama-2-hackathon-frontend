import "dart:typed_data";
import "package:uuid/uuid.dart";

class Recipe {
  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.steps,
    this.image,
    required this.type,
    required this.favourite,
  });

  Uint8List? image;
  final String id;
  final String title;
  final String type;
  final Map<String, String> ingredients;
  final List<String> steps;
  final bool favourite;

  factory Recipe.fromJson(Map<String, dynamic> json, {String? type, bool? favourite}) {
    String foundType = json["type"] ?? type ?? "";
    bool foundFav = json["favourite"] ?? favourite ?? false;

    return Recipe(
      id: const Uuid().v4(),
      title: json["title"],
      // ingredients: List<String>.from(json["ingredients"].map((x) => x["name"])),
      ingredients: Map.fromEntries((json["ingredients"] as List).map((x) => MapEntry(x["name"], x["quantity"]))),
      steps: List<String>.from(json["steps"].map((x) => x)),
      type: foundType,
      favourite: foundFav,
    );
  }
}
