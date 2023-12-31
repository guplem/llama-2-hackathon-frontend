import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipe.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";
import "package:scroll_snap_list/scroll_snap_list.dart";

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key, this.initialRecipeId, this.startInLoadingScreen = true});

  final String? initialRecipeId;
  final bool startInLoadingScreen;

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
      pageTitle: "DishForge - Recipes",
      showFloatingActionButton: getProvider<ConfigurationProvider>(context, listen: true).activeIngredients.isNotEmpty && !getProvider<RecipesProvider>(context, listen: true).loadingRecipe,
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
        // initialIndex: widget.initialRecipeId == null ? null : RecipesProvider.instance.recipes.indexWhere((element) => element.id == widget.initialRecipeId) * recipeWidth,
        initialIndex: widget.startInLoadingScreen ? getProvider<RecipesProvider>(context, listen: true).recipes.length.toDouble() : widget.initialRecipeId == null ? null : RecipesProvider.instance.recipes.indexWhere((element) => element.id == widget.initialRecipeId).toDouble(),
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
                child: Padding(
                  padding: ThemeCustom.paddingInnerCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap.verticalNewSection(),
                      if (recipe.image != null) Hero(tag: recipe.id, child: ClipRRect(borderRadius: ThemeCustom.borderRadiusStandard, child: Image.memory(recipe.image!))),
                      if (recipe.image == null) Hero(tag: recipe.id, child: ShimmerEffect(enabled: true, child: Container(color: Colors.black, height: 200, width: double.infinity))),
                      const Gap.vertical(),
                      Text(recipe.title, style: ThemeCustom.textTheme(context).titleLarge),
                      const Gap.verticalNewSection(),
                      const Divider(),
                      Text("Ingredients:", style: ThemeCustom.textTheme(context).titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                      const Gap.vertical(),
                      // ...recipe.ingredients.map((ingredient) => Padding(
                      //   padding: ThemeCustom.paddingHorizontal,
                      //   child: Text("- ${ingredient.capitalizeFirstLetter() ?? ""}"),
                      // )),
                      ...recipe.ingredients.entries.map((MapEntry<String, String> ingredient) => Padding(
                        padding: ThemeCustom.paddingHorizontal,
                        child: Text("- ${ingredient.key.capitalizeFirstLetter() ?? ""} (${ingredient.value})"),
                      )),
                      const Gap.verticalNewSection(),
                      const Divider(),
                      Text("Steps:", style: ThemeCustom.textTheme(context).titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                      const Gap.vertical(),
                      ...recipe.steps.map((step) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: ThemeCustom.borderRadiusFullyRounded,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: ThemeCustom.colorScheme(context).inversePrimary,
                                      shape: BoxShape.circle
                                  ),
                                  child: Padding(
                                    padding: ThemeCustom.paddingSquaredStandard,
                                    child: Text("${recipe.steps.indexOf(step) + 1}", style: ThemeCustom.textTheme(context).titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              const Gap.horizontal(),
                              Expanded(child: OutlinedCard(child: Text(step))),
                            ],
                          )),
                      const Gap.vertical(),
                      // const Placeholder(
                      //   fallbackHeight: 1000,
                      // )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
