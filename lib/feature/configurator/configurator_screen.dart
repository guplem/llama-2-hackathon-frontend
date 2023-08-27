import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

// ignore: depend_on_referenced_packages
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap.verticalNewSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeCustom.spaceHorizontal),
            child: Text("Preferences", style: ThemeCustom.textTheme(context).titleLarge),
          ),
          const Gap.vertical(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 5,
              child: Center(
                child: Wrap(
                  spacing: ThemeCustom.spaceHorizontal / 2,
                  runSpacing: ThemeCustom.spaceVertical / 2,
                  direction: Axis.horizontal,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeCustom.spaceHorizontal),
            child: Text("Appliances", style: ThemeCustom.textTheme(context).titleLarge),
          ),
          const Gap.vertical(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 2.5,
              child: Center(
                child: Wrap(
                  spacing: ThemeCustom.spaceHorizontal / 2,
                  runSpacing: ThemeCustom.spaceVertical / 2,
                  direction: Axis.horizontal,
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
          getProvider<RecipesProvider>(context, listen: true).recipes.isEmpty ? const Gap.vertical() : const Gap.verticalNewSection(),
        ],
      ),
    );
  }
}
