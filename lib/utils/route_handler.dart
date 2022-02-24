import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRoute<T> {
  SlidePageRoute(this.page, {this.begin, this.end}) : super();
  final Offset? begin;
  final Offset? end;
  final Widget page;

  // By keeping it false will also render the initiating screen
  // And above that initiating screen the entering screen will be visible
  // like dialog
  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black38;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin ?? const Offset(1, 0.2),
        end: end ?? Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return page;
  }

  @override
  String get barrierLabel => "SliderDialogRoute";
}
