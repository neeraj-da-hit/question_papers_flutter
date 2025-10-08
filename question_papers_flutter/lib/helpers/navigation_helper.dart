import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationHelper {
  /// Decide route type based on platform
  static PageRoute<T> _buildPageRoute<T>(Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }

  /// Push a new page
  static Future<T?> push<T>(Widget page) {
    return navigatorKey.currentState!.push(_buildPageRoute(page));
  }

  /// Replace the current page
  static Future<T?> pushReplacement<T>(Widget page) {
    return navigatorKey.currentState!.pushReplacement(_buildPageRoute(page));
  }

  /// Push and remove all previous routes
  static Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      _buildPageRoute(page),
      (route) => false,
    );
  }

  /// Go back
  static void pop<T extends Object?>([T? result]) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    }
  }

  /// Show Cupertino-style Bottom Sheet (Modal Popup)
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool dismissible = true,
  }) {
    final context = navigatorKey.currentContext!;
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        barrierDismissible: dismissible,
        builder: (_) => SafeArea(child: CupertinoPopupSurface(child: child)),
      );
    } else {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        ),
      );
    }
  }

  /// Show Cupertino-style full-screen dialog
  static Future<T?> showFullScreenDialog<T>(Widget page) {
    if (Platform.isIOS) {
      return navigatorKey.currentState!.push(
        CupertinoPageRoute(builder: (_) => page, fullscreenDialog: true),
      );
    } else {
      return navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (_) => page, fullscreenDialog: true),
      );
    }
  }
}
