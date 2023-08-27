import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipe.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_screen.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

class RecipePreview extends StatelessWidget {
  const RecipePreview({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return OutlinedCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipesScreen(initialRecipeId: recipe.id,))),
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: ThemeCustom.borderRadiusStandard,
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          Positioned.fromRelativeRect(
            rect: const RelativeRect.fromLTRB(0, 0, 0, 50),
            child: ClipRRect(
              borderRadius: ThemeCustom.borderRadiusStandard,
              child: Builder(builder: (context) {
                if (recipe.image != null) {
                  return Hero(tag: recipe.id, child: Image.memory(recipe.image!, fit: BoxFit.cover));
                } else {
                  return ShimmerEffect(enabled: true, child: Container(color: Colors.black, height: 200, width: double.infinity));
                }
              }),
            ),
          ),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: ThemeCustom.paddingInnerCard,
                    child: Text(
                      recipe.title,
                      style: ThemeCustom.textTheme(context).titleSmall,
                    ),
                  ))),
        ]),
      ),
    );
  }
}
