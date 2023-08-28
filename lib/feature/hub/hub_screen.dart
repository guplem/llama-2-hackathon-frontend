import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configurator_screen.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipe_preview.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_screen.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:image_picker_android/image_picker_android.dart";

// ignore: depend_on_referenced_packages
import "package:image_picker_platform_interface/image_picker_platform_interface.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  final TextEditingController _ingredientTextController = TextEditingController();

  @override
  void dispose() {
    _ingredientTextController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: ScaffoldCustom(
        pageTitle: "DishForge",
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
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home_rounded),
              ),
              Tab(
                icon: Icon(Icons.kitchen_rounded),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.from(
                            getProvider<RecipesProvider>(context, listen: true).recipes.map(
                                  (recipe) => Padding(
                                    padding: ThemeCustom.paddingSquaredStandard.copyWith(right: 0),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height / 3,
                                      width: MediaQuery.of(context).size.width / 1.5,
                                      child: RecipePreview(recipe: recipe),
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      )),
                  const Gap.verticalNewSection(),
                  Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
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
                          // padding: ThemeCustom.paddingInnerCard.copyWith(top: ThemeCustom.paddingInnerCard.top / 1.9, bottom: ThemeCustom.paddingInnerCard.bottom / 1.9),
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
                        OutlinedCard(
                          // padding: ThemeCustom.paddingInnerCard.copyWith(top: ThemeCustom.paddingInnerCard.top / 1.9, bottom: ThemeCustom.paddingInnerCard.bottom / 1.9),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.fastfood_rounded),
                              const Gap.horizontal(),
                              DropdownButton<String>(
                                  underline: Container(),
                                  padding: EdgeInsets.zero,
                                  value: getProvider<ConfigurationProvider>(context, listen: true).type,
                                  onChanged: (String? value) {
                                    ConfigurationProvider.instance.updateType(value!);
                                  },
                                  items: const [
                                    DropdownMenuItem(value: "Any", child: Text("Any")),
                                    DropdownMenuItem(value: "Breakfast", child: Text("Breakfast")),
                                    DropdownMenuItem(value: "Lunch", child: Text("Lunch")),
                                    DropdownMenuItem(value: "Dinner", child: Text("Dinner")),
                                    DropdownMenuItem(value: "Snacks", child: Text("Snacks")),
                                    DropdownMenuItem(value: "Desserts", child: Text("Desserts")),
                                    DropdownMenuItem(value: "Beverages", child: Text("Beverages")),
                                    DropdownMenuItem(value: "Appetizers", child: Text("Appetizers")),
                                    DropdownMenuItem(value: "Side Dishes", child: Text("Side Dishes")),
                                  ]),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap.verticalNewSection(),
                  Text("Ingredients", style: ThemeCustom.textTheme(context).titleLarge),
                  if (getProvider<ConfigurationProvider>(context, listen: true).loadingIngredients) const LinearProgressIndicator(),
                  SizedBox(height: getProvider<ConfigurationProvider>(context, listen: true).loadingIngredients ? ThemeCustom.spaceVertical / 2 : ThemeCustom.spaceVertical),
                  Padding(
                    padding: ThemeCustom.paddingHorizontal,
                    child: Row(
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
                  ),
                  const Gap.vertical(),
                  Center(
                    child: Padding(
                      padding: ThemeCustom.paddingHorizontal,
                      child: Wrap(
                        spacing: ThemeCustom.spaceHorizontal / 2,
                        runSpacing: ThemeCustom.spaceVertical / 2,
                        alignment: WrapAlignment.center,
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
                  ),
                  const Gap.verticalNewSection(),
                  const Divider(),
                  const Gap.vertical(),
                  ElevatedButton.icon(onPressed: getProvider<RecipesProvider>(context, listen: true).loadingRecipe ? null : () {
                    RecipesProvider.getNew();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecipesScreen()));
                  }, label: const Text("Get new recipe"), icon: const Icon(Icons.auto_awesome)),
                  const Gap.verticalNewSection(),
                ],
              ),
            ),
            const ConfiguratorScreen(),
          ],
        ),
      ),
    );
  }
}
