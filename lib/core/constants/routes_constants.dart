import 'package:flutter/material.dart';

import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';

/// Коллекция роутов приложения
abstract class AppRoutes {
  static const String start = '/';
  static const String loading = '/loading';
  static const String login = '/login';
  static const String home = '/requests';
  static const String addRequest = '/requests/add';

  /// Сгенерировать роут
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        default:
          return null;
      }
    } on Exception catch (e) {
      MessageHelper.showError(e.getMessage);
      return null;
    }
  }
}
