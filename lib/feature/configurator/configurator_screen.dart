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
      pageTitle: "Kitchen configurator",
      padding: false,
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
        title: const Text("Kitchen configurator"),
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
            const Gap.verticalNewSection(),
            Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  OutlinedCard(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(getProvider<ConfigurationProvider>(context, listen: true).people > 1 ? Icons.people_rounded : Icons.person_rounded),
                        IconButton(onPressed: () => ConfigurationProvider.instance.removePerson(), icon: const Icon(Icons.remove_rounded)),
                        Text(getProvider<ConfigurationProvider>(context, listen: true).people.toString()),
                        IconButton(onPressed: () => ConfigurationProvider.instance.addPerson(), icon: const Icon(Icons.add_rounded)),
                      ],
                    ),
                  ),
                  OutlinedCard(
                    padding: ThemeCustom.paddingInnerCard.copyWith(top: ThemeCustom.paddingInnerCard.top / 1.9, bottom: ThemeCustom.paddingInnerCard.bottom / 1.9),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.speed_rounded),
                        const Gap.horizontal(),
                        DropdownButton<int>(
                            underline: Container(),
                            padding: EdgeInsets.zero,
                            value: getProvider<ConfigurationProvider>(context, listen: true).difficulty,
                            onChanged: (int? value) {
                              ConfigurationProvider.instance.updateDifficulty(value!);
                            },
                            items: const [
                              DropdownMenuItem(value: 1, child: Text("Easy")),
                              DropdownMenuItem(value: 2, child: Text("Medium")),
                              DropdownMenuItem(value: 3, child: Text("Hard")),
                            ]),
                      ],
                    ),
                  ),
                  OutlinedCard(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_rounded),
                        IconButton(onPressed: () => ConfigurationProvider.instance.updateDuration(ConfigurationProvider.instance.duration - const Duration(minutes: 10)), icon: const Icon(Icons.remove_rounded)),
                        Text(getProvider<ConfigurationProvider>(context, listen: true).duration.inMinutes.toString()),
                        // IconButton(onPressed: () => ConfigurationProvider.instance.updateDuration(getProvider<ConfigurationProvider>(context, listen: false).duration + const Duration(minutes: 5)), icon: const Icon(Icons.add_rounded)),
                        IconButton(onPressed: () => ConfigurationProvider.instance.updateDuration(ConfigurationProvider.instance.duration + const Duration(minutes: 10)), icon: const Icon(Icons.add_rounded)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap.verticalNewSection(),
            Text("Preferences", style: ThemeCustom.textTheme(context).titleLarge),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 160,
                child: Center(
                  child: Wrap(
                    spacing: ThemeCustom.spaceHorizontal / 2,
                    runSpacing: ThemeCustom.spaceVertical / 2,
                    direction: Axis.vertical,
                    children: List.from(getProvider<ConfigurationProvider>(context, listen: true).desires.entries.map((desire) {
                      return Padding(
                        padding: const EdgeInsets.only(left: ThemeCustom.spaceHorizontal / 2),
                        child: FilterChip(
                            selected: desire.value,
                            label: Text(desire.key),
                            onSelected: (bool value) {
                              ConfigurationProvider.instance.updateDesireStatus(desire.key, value);
                            }),
                      );
                    })),
                  ),
                ),
              ),
            ),
            const Gap.verticalNewSection(),
            Text("Appliances", style: ThemeCustom.textTheme(context).titleLarge),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 160,
                child: Center(
                  child: Wrap(
                    spacing: ThemeCustom.spaceHorizontal / 2,
                    runSpacing: ThemeCustom.spaceVertical / 2,
                    direction: Axis.vertical,
                    children: List.from(getProvider<ConfigurationProvider>(context, listen: true).appliances.entries.map((desire) {
                      return Padding(
                        padding: const EdgeInsets.only(left: ThemeCustom.spaceHorizontal / 2),
                        child: FilterChip(
                            selected: desire.value,
                            label: Text(desire.key),
                            onSelected: (bool value) {
                              ConfigurationProvider.instance.updateApplianceStatus(desire.key, value);
                            }),
                      );
                    })),
                  ),
                ),
              ),
            ),
            const Gap.verticalNewSection(),
            Text("Ingredients", style: ThemeCustom.textTheme(context).titleLarge),
            if (getProvider<ConfigurationProvider>(context, listen: true).loadingIngredients) const LinearProgressIndicator(),
            SizedBox(height: getProvider<ConfigurationProvider>(context, listen: true).loadingIngredients ? ThemeCustom.spaceVertical / 2 : ThemeCustom.spaceVertical),
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
            Center(
              child: Wrap(
                spacing: ThemeCustom.spaceHorizontal / 2,
                runSpacing: ThemeCustom.spaceVertical / 2,
                children: List.from(
                  getProvider<ConfigurationProvider>(context, listen: true).ingredients.entries.map(
                    (ingredient) {
                      return GestureDetector(
                        onLongPress: () {
                          ConfigurationProvider.instance.removeIngredient(ingredient.key);
                        },
                        child: FilterChip(
                          selected: ingredient.value,
                          label: Text(ingredient.key),
                          onSelected: (bool value) {
                            ConfigurationProvider.instance.updateIngredientStatus(ingredient.key, value);
                          },
                        ),
                      );
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
