import "dart:math";
import "package:animate_do/animate_do.dart";
import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

// Also known as Known as "Skeleton Loader" https://m3.material.io/styles/motion/transitions/transition-patterns#f7ff608a-087d-4a4e-9e83-f1af69184487
// But not much information exists about them: https://www.google.com/search?q=%22skeleton%22+site%3Am3.material.io
class ShimmerEffect extends StatelessWidget {
  final bool enabled;
  final Widget child;
  final Widget? shimmerWidget;
  final bool fill, fullyRounded;
  final bool animateTransitionToChild;
  final AlignmentGeometry? alignment;
  final Color? color;

  BorderRadius get shimmerRadius => fullyRounded ? ThemeCustom.borderRadiusFullyRounded : ThemeCustom.borderRadiusStandard;

  const ShimmerEffect({
    Key? key,
    required this.enabled,
    required this.child,
    this.fill = false,
    this.animateTransitionToChild = true,
    this.shimmerWidget,
    this.fullyRounded = false,
    this.alignment,
    this.color,
  }) : super(key: key);

  factory ShimmerEffect.lines({
    Key? key,
    required bool enabled,
    required int lines,
    Widget child = const SizedBox.shrink(),
    double linesHeight = ThemeCustom.spaceVertical * 1.5,
    bool animateTransitionToChild = true,
    bool randomWidth = true,
    bool fullyRoundedBorder = true,
    Alignment? shimmerAlignment = Alignment.topLeft,
    Color? color,
  }) {
    final random = Random();
    return ShimmerEffect(
      key: key,
      enabled: enabled,
      animateTransitionToChild: animateTransitionToChild,
      alignment: shimmerAlignment,
      shimmerWidget: Column(
        children: List.generate(lines * 2 + 1, (index) {
          if (index % 2 == 0) return Gap.vertical();
          return Row(
            children: [
              Flexible(
                  flex: randomWidth ? (1 + random.nextInt(10)) : 1,
                  child: ClipRRect(
                    borderRadius: fullyRoundedBorder ? ThemeCustom.borderRadiusFullyRounded : ThemeCustom.borderRadiusStandard,
                    child: Container(
                        decoration: BoxDecoration(borderRadius: fullyRoundedBorder ? ThemeCustom.borderRadiusFullyRounded : ThemeCustom.borderRadiusStandard, color: Colors.black),
                        height: linesHeight,
                        width: double.infinity),
                  )),
              Flexible(flex: randomWidth ? (2 + random.nextInt(9)) : 0, child: Container()),
            ],
          );
        }),
      ),
      color: color,
      child: child,
    );
  }

  factory ShimmerEffect.filledChild({
    Key? key,
    required bool enabled,
    bool animateTransitionToChild = true,
    Widget? widgetToShimmer,
    bool fullyRounded = false,
    Alignment? shimmerAlignment,
    Color? color,
  }) {
    return ShimmerEffect(
      enabled: enabled,
      animateTransitionToChild: animateTransitionToChild,
      alignment: shimmerAlignment,
      color: color,
      child: SizedBox.expand(child: widgetToShimmer ?? Container(color: Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = color ?? ThemeCustom.colorScheme(context).surfaceVariant;
    final Color highlightColor = baseColor.withOpacity(0.6);
    // Unassigned size is used for transition between colors: 1-baseColorSize-highlightColorSize
    const double baseColorSize = 0.8;
    const double highlightColorSize = 0.1;

    return FadeIn(
      duration: kThemeAnimationDuration,
      child: AnimatedSwitcher(
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: alignment ?? Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        duration: animateTransitionToChild ? kThemeAnimationDuration * 2 : Duration.zero,
        child: !enabled
            ? child
            : Shimmer(
                gradient: LinearGradient(
                  tileMode: TileMode.clamp,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [baseColor, baseColor, highlightColor, highlightColor, baseColor, baseColor],
                  stops: const <double>[0.0, baseColorSize / 2, 0.5 - highlightColorSize / 2, 0.5 + highlightColorSize / 2, 1 - baseColorSize / 2, 1.0],
                ),
                // baseColor: ThemeCustom.colorScheme(context).onSurface,
                // highlightColor: ThemeCustom.colorScheme(context).onSurface.withOpacity(0.35),
                // direction: ShimmerDirection.ltr,
                period: kThemeAnimationDuration * 10,
                child: Container(
                  child: shimmerWidget ??
                      ClipRRect(
                        borderRadius: shimmerRadius,
                        child: fill
                            ? Container(
                                decoration: BoxDecoration(borderRadius: shimmerRadius, color: Colors.black),
                                child: child,
                              )
                            : child,
                      ),
                ),
              ),
      ),
    );
  }
}
