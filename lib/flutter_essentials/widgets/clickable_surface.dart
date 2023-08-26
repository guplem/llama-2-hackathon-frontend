import "package:flutter/material.dart";

class ClickableSurface extends StatelessWidget {
  const ClickableSurface({Key? key, required this.child, this.onTap}) : super(key: key);

  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? MaterialStateMouseCursor.clickable : SystemMouseCursors.forbidden,
        child: child,
      ),
    );
  }
}
