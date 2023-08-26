import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/repice_configuration.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.auto_awesome),
      ),
      showFloatingActionButtonIfNoScrollableContent: true,
      appBar: AppBar(
        title: const Text("Configuration"),
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
              Debug.logDev("Submitted: $value");
              RecipeConfigurationProvider.instance.addIngredient(value);
            },
          ),
          const Gap.vertical(),
          ...List.from(
            getProvider<RecipeConfigurationProvider>(context, listen: true)
                .ingredients
                .map(
                  (String ingredient) => ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 250));
                        RecipeConfigurationProvider.instance
                            .removeIngredient(ingredient);
                      },
                    ),
                    title: Text(ingredient),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
