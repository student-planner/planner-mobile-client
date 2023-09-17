import 'package:flutter/material.dart';

import '../../main.dart';
import '../../src/goals/goals_page.dart';
import '../../src/welcome/login/login_page.dart';
import '../../src/welcome/login/screens/login_code_screen.dart';
import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';
import '../splash_screen.dart';

/// Коллекция роутов приложения
abstract class AppRoutes {
  static const String start = '/';
  static const String loading = '/loading';
  static const String goals = '/goals';
  static const String login = '/login/email';
  static const String loginCode = '/login/code';
  static const String register = '/register';

  /// Сгенерировать роут
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case start:
          return MaterialPageRoute(builder: (_) => const AppRunner());
        case loading:
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        case login:
          return MaterialPageRoute(builder: (_) => const LoginPage());
        case loginCode:
          final ticketId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => LoginCodeScreen(ticketId: ticketId),
          );
        case goals:
          return MaterialPageRoute(builder: (_) => const GoalsPage());
        default:
          return null;
      }
    } on Exception catch (e) {
      MessageHelper.showError(e.getMessage);
      return null;
    }
  }
}
