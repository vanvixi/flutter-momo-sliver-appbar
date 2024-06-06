import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_momo_ui/debounce.dart';

class CollapsingNotification extends Notification {
  final double transformValue;

  CollapsingNotification(this.transformValue);
}

class AppBarScrollHandler extends StatefulWidget {
  const AppBarScrollHandler({
    super.key,
    required this.minExtent,
    required this.maxExtent,
    required this.controller,
    required this.child,
  });

  final double minExtent;
  final double maxExtent;
  final ScrollController controller;
  final Widget child;

  @override
  State<AppBarScrollHandler> createState() => _AppBarScrollHandlerState();
}

class _AppBarScrollHandlerState extends State<AppBarScrollHandler> {
  double t = 0;
  ScrollDirection? scrollDirection;
  final Debounce debounce = Debounce(ms: 300);

  @override
  void dispose() {
    debounce.dispose();
    super.dispose();
  }

  void animateTo(double offset) {
    widget.controller.animateTo(offset, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void reverseDirectionHandler() {
    if (t >= 0.15) return animateTo(widget.maxExtent - widget.minExtent);

    animateTo(0);
  }

  void forwardDirectionHandler() {
    if (t <= 0.85) return animateTo(0);

    animateTo(widget.minExtent);
  }

  void scrollDirectionHandler() {
    if (scrollDirection == ScrollDirection.reverse) reverseDirectionHandler();

    if (scrollDirection == ScrollDirection.forward) forwardDirectionHandler();

    scrollDirection = null;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is CollapsingNotification) {
          t = notification.transformValue;
        }

        if (notification is ScrollUpdateNotification) {
          final scrollDelta = notification.scrollDelta;
          if (scrollDelta == null) return false;
          scrollDirection = scrollDelta > 0 ? ScrollDirection.reverse : ScrollDirection.forward;
        }

        if (notification is ScrollEndNotification) {
          if (t == 0 || t == 1 || scrollDirection == null) return false;

          debounce.run(scrollDirectionHandler);
        }

        return false;
      },
      child: widget.child,
    );
  }
}
