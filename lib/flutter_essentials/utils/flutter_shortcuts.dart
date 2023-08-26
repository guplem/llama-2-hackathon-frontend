import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

class FlutterShortcuts {

  static Future showInBottomSheet({required BuildContext context, required Widget child, bool isScrollControlled = true}) async {

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: ThemeCustom.colorScheme(context).background,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: ThemeCustom.borderRadiusStandard.topLeft, topRight: ThemeCustom.borderRadiusStandard.topRight),
      ),
      useSafeArea: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              // top: CustomTheme.borderRadiusStandardValue, // To avoid the content from "hiding" the border
              bottom: MediaQuery.of(context).viewInsets.bottom, // For the keyboard
            ),
            child: SafeArea(
              top: true,
              child: Column(
                children: [
                  Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))]),
                  child,
                  Gap.vertical(),
                ],
              ),
            ),
          ),
        );
      },
      // builder: (context) => SingleChildScrollView(
      //     child: child),
    );
  }

  // https://stackoverflow.com/a/45948243/7927429
  static void showSnackBar(BuildContext context, {required String text, Map<String, VoidCallback?>? action, Duration duration = const Duration(milliseconds: 4000), bool isError = false}) {
    final scaffold = ScaffoldMessenger.of(context);
    /*return*/ scaffold.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: isError ? ThemeCustom.colorScheme(context).errorContainer : ThemeCustom.colorScheme(context).inverseSurface,
        content: Text(text, style: TextStyle(color: isError ? ThemeCustom.colorScheme(context).onErrorContainer : ThemeCustom.colorScheme(context).onInverseSurface)),
        action: (action != null && action.isNotEmpty)
            ? SnackBarAction(
                textColor: ThemeCustom.colorScheme(context).inversePrimary,
                label: action.keys.first,
                onPressed: () {
                  action.values.first!();
                  scaffold.hideCurrentSnackBar;
                })
            : null,
      ),
    );
  }

  // static void showSimpleAlertDialog(BuildContext context, String message, {/*BorderRadius? borderRadius, */ String title = "", required Map<String, VoidCallback?> actions}) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: title == "" ? const SizedBox.shrink() : Text(title),
  //         content: Text(message),
  //         actions: [
  //           ...actions.entries.map((e) {
  //             return TextButton(
  //               child: Text(e.key),
  //               onPressed: () {
  //                 context.router.pop();
  //                 if (e.value != null) {
  //                   e.value!();
  //                 }
  //               },
  //             );
  //           })
  //         ],
  //         // shape: RoundedRectangleBorder(borderRadius: borderRadius ?? CustomTheme.borderRadius /*BorderRadius.circular(20)*/ ),
  //       );
  //     },
  //   );
  // }

  /// This will load the resource with the given loadFunction and then call the afterLoad with the result.
  static Future<T?> ensureResourceLoaded<T>({required T? resourceOriginal, required Function loadFunction, Function(T?)? onceLoaded}) async {
    T? resource = resourceOriginal;
    resource ??= await loadFunction();
    if (onceLoaded != null) await onceLoaded(resource);
    return resource;
  }

}
