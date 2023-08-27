import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_screen.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:image_picker_android/image_picker_android.dart";

// ignore: depend_on_referenced_packages
import "package:image_picker_platform_interface/image_picker_platform_interface.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

class ConfiguratorScreen extends StatefulWidget {
  const ConfiguratorScreen({super.key});

  @override
  State<ConfiguratorScreen> createState() => _ConfiguratorScreenState();
}

class _ConfiguratorScreenState extends State<ConfiguratorScreen> {
  final TextEditingController _ingredientTextController = TextEditingController();

  @override
  void dispose() {
    _ingredientTextController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      pageTitle: "Configuration",
      showFloatingActionButton: getProvider<ConfigurationProvider>(context, listen: true).activeIngredients.isNotEmpty && !getProvider<RecipesProvider>(context, listen: true).loadingRecipe,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (getProvider<ConfigurationProvider>(context, listen: true).loadingIngredients) const LinearProgressIndicator(),
            const Gap.verticalNewSection(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientTextController,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Add ingredient",
                    ),
                    onSubmitted: (String value) {
                      ConfigurationProvider.instance.addIngredient(value);
                      _ingredientTextController.clear();
                    },
                  ),
                ),
                const Gap.horizontal(),
                IconButton(
                    onPressed: getProvider<ConfigurationProvider>(context, listen: true).loadingIngredients
                        ? null
                        : () async {
                            final ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
                            if (imagePickerImplementation is ImagePickerAndroid) {
                              imagePickerImplementation.useAndroidPhotoPicker = true;
                            }
                            XFile? image = await imagePickerImplementation.getImageFromSource(source: ImageSource.camera, options: const ImagePickerOptions(imageQuality: 1));
                            if (image == null) return;
                            ConfigurationProvider.instance.addIngredientsFromImage(image);
                          },
                    icon: const Icon(Icons.camera_alt_rounded)),
              ],
            ),
            const Gap.vertical(),
            Wrap(
              spacing: ThemeCustom.spaceHorizontal,
              runSpacing: ThemeCustom.spaceVertical,
              children: List.from(
                getProvider<ConfigurationProvider>(context, listen: true).ingredients.entries.map(
                      (ingredient) => FilterChip(
                        selected: ingredient.value,
                        label: Text(ingredient.key),
                        onSelected: (bool value) {
                          ConfigurationProvider.instance.updateIngredientStatus(ingredient.key, value);
                        },
                      ),
                    ),
              ),
            ),
            getProvider<RecipesProvider>(context, listen: true).recipes.isEmpty ? const Gap.vertical() : const Gap.verticalNewSection(),
          ],
        ),
      ),
    );
  }
}
