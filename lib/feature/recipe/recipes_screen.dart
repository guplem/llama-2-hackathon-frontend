import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipe.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";
import "package:scroll_snap_list/scroll_snap_list.dart";

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  // ignore: unused_field
  late int _focusedIndex;

  double get recipeWidth => MediaQuery.of(context).size.width - ThemeCustom.spaceHorizontal * 2;

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      pageTitle: "Recipes",
      showFloatingActionButton: getProvider<ConfigurationProvider>(context, listen: true).ingredients.isNotEmpty && !getProvider<RecipesProvider>(context, listen: true).loadingRecipe,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RecipesProvider.getNew();
        },
        child: const Icon(Icons.auto_awesome),
      ),
      showFloatingActionButtonIfNoScrollableContent: true,
      appBar: AppBar(
        title: const Text("Recipes"),
      ),
      padding: false,
      // Package: https://pub.dev/packages/scroll_snap_list
      body: ScrollSnapList(
        scrollDirection: Axis.horizontal,
        itemSize: recipeWidth,
        onItemFocus: (int index) => setState(() => _focusedIndex = index),
        itemCount: getProvider<RecipesProvider>(context, listen: true).recipes.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: recipeWidth,
            child: Builder(builder: (context) {
              if (RecipesProvider.instance.recipes.length - 1 < index) {
                if (getProvider<RecipesProvider>(context, listen: true).loadingRecipe) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: ElevatedButton.icon(onPressed: () => RecipesProvider.getNew(), label: const Text("Get new recipe"), icon: const Icon(Icons.auto_awesome)),
                  );
                }
              }
              Recipe recipe = RecipesProvider.instance.recipes[index];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap.verticalNewSection(),
                    Text(recipe.name),
                    const Gap.vertical(),
                    ...recipe.ingredients.map((ingredient) => Text(ingredient)),
                    const Gap.vertical(),
                    ...recipe.steps.map((step) => Text(step)),
                    const Gap.vertical(),
                    // const Placeholder(
                    //   fallbackHeight: 1000,
                    // )
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
