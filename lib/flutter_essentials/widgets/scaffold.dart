import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/scheduler.dart";
import "package:flutter/services.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:receptes_rostisseries_delgado/theme_custom.dart";
import "package:visibility_detector/visibility_detector.dart";

//A wrap of the AppBar widget that exposes all parameters
class ScaffoldCustom extends StatefulWidget {
  final PreferredSizeWidget? appBar;

  /// Ignored if the app is running in debug mode
  final bool showAppBarInWeb, padding, showFloatingActionButton;
  final Widget? body, floatingActionButton;

  /// The scaffold will build a scrollable body if true.
  /// If not true it is advised to add additional padding/sized box at the bottom of the body in order to avoid the bottom (native) navigation bar.
  /// The amount of space will Deprecated, probably be: this: MediaQuery.of(context).viewPadding.bottom
  final bool showFloatingActionButtonIfNoScrollableContent, isInBottomSheet;
  final String pageTitle;
  final Widget Function(BuildContext context, ScrollController scrollController)? bodyBuilder;

  const ScaffoldCustom({
    required this.pageTitle,
    this.body,
    this.appBar,
    this.showAppBarInWeb = true,
    Key? key,
    this.isInBottomSheet = false,
    this.floatingActionButton,
    this.showFloatingActionButtonIfNoScrollableContent = true,
    this.padding = true,
    this.showFloatingActionButton = true,
  })  : bodyBuilder = null,
        assert(body != null),
        super(key: key);

  const ScaffoldCustom.scrollable({
    required this.pageTitle,
    this.appBar,
    this.showAppBarInWeb = true,
    Key? key,
    this.isInBottomSheet = false,
    this.floatingActionButton,
    this.showFloatingActionButtonIfNoScrollableContent = true,
    this.padding = true,
    this.showFloatingActionButton = true,
    required this.bodyBuilder,
  })  : body = null,
        assert(bodyBuilder != null),
        super(key: key);

  @override
  State<ScaffoldCustom> createState() => _ScaffoldCustomState();
}

class _ScaffoldCustomState extends State<ScaffoldCustom> {
  final _key = UniqueKey();
  late bool _showFloatingActionButton;
  Duration floatingActionButtonAnimationDuration = kThemeAnimationDuration;
  late ScrollController _scrollController;
  bool isScrollable = false;

  @override
  void initState() {
    _showFloatingActionButton = widget.showFloatingActionButtonIfNoScrollableContent && widget.floatingActionButton != null;
    _scrollController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        setState(() {
          _showFloatingActionButton = widget.floatingActionButton != null &&
              ((_scrollController.position.maxScrollExtent > 0) || (_scrollController.position.maxScrollExtent <= 0 && widget.showFloatingActionButtonIfNoScrollableContent));
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.0) {
          Debug.logUpdate('New visible screen: "${widget.pageTitle}". Setting application switcher description.', maxStackTraceRows: 0);
          SystemChrome.setApplicationSwitcherDescription(
            ApplicationSwitcherDescription(
              label: widget.pageTitle,
              primaryColor: ThemeCustom.colorScheme(context).primary.value,
            ),
          );
        }
      },
      child: Builder(builder: (context) {
        if (!widget.isInBottomSheet) {
          return Scaffold(
            // If issues with the "back button" are detected, maybe this is necessary:
            // https://github.com/Milad-Akarie/auto_route_library#autoleadingbutton-backbutton
            // https://stackoverflow.com/a/72134444/7927429
            appBar: (kIsWeb && !kDebugMode && !widget.showAppBarInWeb) ? null : widget.appBar,
            floatingActionButton: FloatingButtonVisibility(
              duration: floatingActionButtonAnimationDuration,
              visible: _showFloatingActionButton && widget.showFloatingActionButton,
              child: widget.floatingActionButton,
            ),
            body: NotificationListener<UserScrollNotification>(
                onNotification: (UserScrollNotification notification) {
                  if (notification.metrics.axis == Axis.vertical) {
                    if (notification.metrics.extentAfter > 0 || notification.metrics.extentBefore > 0) {
                      // There is content hidden that requires (vertical) scroll to be visible
                      final ScrollDirection direction = notification.direction;
                      setState(() {
                        if (direction == ScrollDirection.reverse) {
                          _showFloatingActionButton = false;
                        } else if (direction == ScrollDirection.forward) {
                          _showFloatingActionButton = true;
                        }
                      });
                    } else if (!_showFloatingActionButton || (_showFloatingActionButton && !widget.showFloatingActionButtonIfNoScrollableContent)) {
                      // The floating button is not visible but there is no need for hiding it, so show it
                      setState(() => _showFloatingActionButton = widget.showFloatingActionButtonIfNoScrollableContent);
                    }
                  }

                  return true;
                },
                child: getBody(context)),
          );
        } else {
          return getBody(context);
        }
      }),
    );
  }

  Widget getBody(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      bottom: false,
      minimum: widget.padding ? ThemeCustom.paddingSquaredStandard : EdgeInsets.zero,
      child: widget.body ?? widget.bodyBuilder!(context, _scrollController),
    );
  }
}
