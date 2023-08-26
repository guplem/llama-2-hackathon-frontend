import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

T getProvider<T>(BuildContext context, {required bool listen, bool suppressListenWarning = false}) {
  Debug.logWarning((!listen && !suppressListenWarning), "Trying to get a provider of type $T without listening to it going through the BuildContext. It is recommended to use the singleton pattern instead (instance of the provider).");

  try {
    // Provider.of<X> vs. Consumer<X> https://stackoverflow.com/a/58774889/7927429
    T obtainedProvider = Provider.of<T>(context, listen: listen);
    // if (obtainedProvider is! ChangeNotifier && listen) {
    //   Debug.logWarning("You are tying to listen a value from $T, a provider that is not a ChangeNotifier. This is not recommended. If you are sure you want to do this, use a ValueListenableBuilder.", maxStackTraceRows: 1, signature: "⚠️");
    // }
    return obtainedProvider;
  } catch (e) {
    Debug.logError("Error while trying to get a provider of type $T. ${listen ? "Are you sure you want to listen to this provider?" : ""}");
    rethrow;
  }
}
