import 'package:flutter/material.dart';

import '../../main.dart';
import '../../src/goals/contracts/goal_detailed_dto/goal_detailed_dto.dart';
import '../../src/goals/contracts/goal_put_dto/goal_put_dto.dart';
import '../../src/goals/goals_page.dart';
import '../../src/goals/pages/details/goal_detailed_page.dart';
import '../../src/goals/pages/put/goal_put_next_page.dart';
import '../../src/welcome/login/contracts/ticket_dto/ticket_dto.dart';
import '../../src/welcome/login/login_page.dart';
import '../../src/welcome/login/screens/login_code_screen.dart';
import '../extension/formatted_message.dart';
import '../helpers/message_helper.dart';
import '../splash_screen.dart';

/// Коллекция роутов приложения
abstract class AppRoutes {
  static const String start = '/';
  static const String loading = '/loading';
  static const String login = '/login/email';
  static const String loginCode = '/login/code';
  static const String goals = '/goals';
  static const String goalsDetailed = '/goals/detailed';
  static const String goalsPut = '/goals/put';
  static const String goalsPutContinue = '/goals/put/continue';

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
          final ticketDto = settings.arguments as TicketDto;
          return MaterialPageRoute(
            builder: (_) => LoginCodeScreen(ticketDto: ticketDto),
          );
        case goals:
          return MaterialPageRoute(builder: (_) => const GoalsPage());
        case goalsDetailed:
          final goalDetailed = settings.arguments as GoalDetailedDto;
          return MaterialPageRoute(
            builder: (_) => GoalDetailedPage(goal: goalDetailed),
          );
        // case goalsPut:
        //   final goalDto = settings.arguments as GoalDto?;
        //   return MaterialPageRoute(
        //     builder: (_) => GoalPutPage(goalDto: goalDto),
        //   );
        case goalsPutContinue:
          final goalPutDto = settings.arguments as GoalPutDto;
          return MaterialPageRoute(
            builder: (_) => GoalPutNextPage(goalPutDto: goalPutDto),
          );
        default:
          return null;
      }
    } on Exception catch (e) {
      MessageHelper.showError(e.getMessage);
      return null;
    }
  }
}
