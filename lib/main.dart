import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:receptes_rostisseries_delgado/feature/hub/hub_screen.dart";
import "package:receptes_rostisseries_delgado/feature/recipe/recipes_provider.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";
import "package:receptes_rostisseries_delgado/feature/configurator/configuration_provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData themeData = ThemeCustom.defaultTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider(create: (context) => SomeOtherClass()),
        ChangeNotifierProvider(create: (context) => InternetConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => ConfigurationProvider(ingredients: ["Oil", "Salt", "Pepper", "Onion", "Garlic"])),
        ChangeNotifierProvider(
          create: (context) => RecipesProvider(
            recipes: [
              // Recipe(id: "1", name: "Recipe A", ingredients: ["Ing 1", "Ing 2", "Ing 3"], steps: ["Step 1", "Step 2", "Step 3"]),
              // Recipe(id: "2", name: "Recipe B", ingredients: ["Ing 1", "Ing 2", "Ing 3"], steps: ["Step 1", "Step 2", "Step 3"]),
              // Recipe(id: "3", name: "Recipe C", ingredients: ["Ing 1", "Ing 2", "Ing 3"], steps: ["Step 1", "Step 2", "Step 3"]),
            ],
          ),
        ),
      ],
      child: MaterialApp(
        // THEME
        theme: themeData,
        themeMode: themeData.brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
        // OTHER
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => "Receptes Rostisseries Delgado",
        // INITIAL ROUTE
        home: const HubScreen(),
      ),
    );
  }
}
