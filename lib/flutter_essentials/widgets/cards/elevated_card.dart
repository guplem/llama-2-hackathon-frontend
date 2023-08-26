import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

// WaitingForUpdate: Once this issue is completed, delete this class. https://github.com/flutter/flutter/issues/119401
class ElevatedCard extends StatelessWidget {
  const ElevatedCard({Key? key, required this.child, this.onTap, this.padding}) : super(key: key);

  final Widget? child;
  final void Function()? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: padding,
      color: ThemeCustom.colorScheme(context).surface,
      textColor: ThemeCustom.colorScheme(context).onSurface,
      elevation: 1,
      child: child,
    );
  }
}
