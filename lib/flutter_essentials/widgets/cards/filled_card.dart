import "package:flutter/material.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";

// WaitingForUpdate: Once this issue is completed, delete this class. https://github.com/flutter/flutter/issues/119401
class FilledCard extends StatelessWidget {
  const FilledCard({Key? key, required this.child, this.onTap, this.padding}) : super(key: key);

  final Widget? child;
  final void Function()? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: padding,
      color: ThemeCustom.colorScheme(context).secondaryContainer, // Material3 Specs are with surfaceVariant, but secondaryContainer looks better IMO
      textColor: ThemeCustom.colorScheme(context).onSecondaryContainer, // Material3 Specs are with onSurfaceVariant, but looks better IMO
      elevation: 0,
      child: child,
    );
  }
}
