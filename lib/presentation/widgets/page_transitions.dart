import 'package:flutter/material.dart';

Route<T> slideFadeRoute<T>(Widget page, {Duration duration = const Duration(milliseconds: 380), Offset begin = const Offset(0.08, 0)}) {
  return PageRouteBuilder<T>(
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
      final slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(curved);
      final fade = Tween<double>(begin: 0, end: 1).animate(curved);
      return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
    },
  );
}

