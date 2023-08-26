import "dart:typed_data";

import "package:dio/dio.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/utils/debug.dart";
import "package:uuid/uuid.dart";

import "../../api.dart";

class Recipe {
  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.steps,
    this.image,
  });

  Uint8List? image;
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: const Uuid().v4(),
        title: json["title"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x["name"])),
        steps: List<String>.from(json["steps"].map((x) => x)),
      );
}
