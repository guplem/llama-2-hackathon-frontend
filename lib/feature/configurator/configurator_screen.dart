import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_screen.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

class ConfiguratorScreen extends StatefulWidget {
  const ConfiguratorScreen({super.key});

  @override
  State<ConfiguratorScreen> createState() => _ConfiguratorScreenState();
}

class _ConfiguratorScreenState extends State<ConfiguratorScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      pageTitle: "Configuration",
      showFloatingActionButton: getProvider<ConfigurationProvider>(context, listen: true).ingredients.isNotEmpty && !getProvider<RecipesProvider>(context, listen: true).loadingRecipe,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RecipesProvider.getNew();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecipesScreen()));
        },
        child: const Icon(Icons.auto_awesome),
      ),
      showFloatingActionButtonIfNoScrollableContent: true,
      appBar: AppBar(
        title: const Text("Configuration"),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecipesScreen())),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Gap.vertical(),
          // Text("Ingredients",
          //     style: ThemeCustom.textTheme(context).titleMedium),
          const Gap.verticalNewSection(),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Add ingredient",
            ),
            onSubmitted: (String value) {
              ConfigurationProvider.instance.addIngredient(value);
            },
          ),
          const Gap.vertical(),
          ...List.from(
            getProvider<ConfigurationProvider>(context, listen: true).ingredients.map(
                  (String ingredient) => ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 250));
                        ConfigurationProvider.instance.removeIngredient(ingredient);
                      },
                    ),
                    title: Text(ingredient),
                  ),
                ),
          ),
          getProvider<RecipesProvider>(context, listen: true).recipes.isEmpty ? const Gap.vertical() : const Gap.verticalNewSection(),
        ],
      ),
    );
  }
}
