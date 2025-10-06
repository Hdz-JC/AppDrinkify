import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationController {
  static void navigateTo(BuildContext context, String route) {
    context.go(route);
  }
}
