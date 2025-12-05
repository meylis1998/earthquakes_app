import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/design_tokens.dart';

/// Custom page route with slide-up and fade transition.
/// Used for detail screens and modals.
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppDurations.normal,
          reverseTransitionDuration: AppDurations.fast,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AppCurves.enter,
              reverseCurve: AppCurves.exit,
            ));

            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: AppCurves.enter,
              reverseCurve: AppCurves.exit,
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

/// Custom page route with fade transition only.
/// Used for same-level navigation.
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppDurations.fast,
          reverseTransitionDuration: AppDurations.fast,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: AppCurves.standard,
              ),
              child: child,
            );
          },
        );
}

/// Custom page route with shared axis (horizontal) transition.
/// Used for sibling navigation (tabs, etc.).
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final bool forward;

  SharedAxisPageRoute({
    required this.page,
    this.forward = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppDurations.normal,
          reverseTransitionDuration: AppDurations.normal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final direction = forward ? 1.0 : -1.0;

            final slideAnimation = Tween<Offset>(
              begin: Offset(0.3 * direction, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AppCurves.emphasized,
            ));

            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            );

            final scaleAnimation = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AppCurves.emphasized,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
        );
}

/// Custom transition page for GoRouter with hero support.
/// Enables hero animations between list and detail screens.
class HeroDetailPage<T> extends CustomTransitionPage<T> {
  HeroDetailPage({
    required super.child,
    super.name,
    super.arguments,
    super.key,
  }) : super(
          transitionDuration: AppDurations.normal,
          reverseTransitionDuration: AppDurations.fast,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AppCurves.enter,
              reverseCurve: AppCurves.exit,
            ));

            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: AppCurves.enter,
              reverseCurve: AppCurves.exit,
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

/// No transition page for instant navigation.
/// Named differently to avoid conflict with go_router's NoTransitionPage.
class InstantTransitionPage<T> extends CustomTransitionPage<T> {
  InstantTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.key,
  }) : super(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}

/// Extension for easier navigation with custom transitions.
extension NavigatorExtensions on NavigatorState {
  /// Push with slide-up transition.
  Future<T?> pushSlideUp<T>(Widget page) {
    return push(SlideUpPageRoute<T>(page: page));
  }

  /// Push with fade transition.
  Future<T?> pushFade<T>(Widget page) {
    return push(FadePageRoute<T>(page: page));
  }

  /// Push with shared axis transition.
  Future<T?> pushSharedAxis<T>(Widget page, {bool forward = true}) {
    return push(SharedAxisPageRoute<T>(page: page, forward: forward));
  }
}
