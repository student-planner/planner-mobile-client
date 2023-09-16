import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import 'core/bloc/bloc_global_observer.dart';
import 'core/constants/constants.dart';
import 'core/constants/routes_constants.dart';
import 'core/helpers/message_helper.dart';
import 'core/splash_screen.dart';
import 'src/configurations/module_configurator.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: '.env');

      ModuleConfigurator.init();

      await initializeDateFormatting('ru_RU', null);
      Bloc.observer = BlocGlobalObserver();
      Bloc.transformer = bloc_concurrency.sequential();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      final savedTheme = await AdaptiveTheme.getThemeMode();
      runApp(AppConfigurator(savedTheme: savedTheme));
    },
    (error, stackTrace) async {},
  );
}

/// Конфигурация приложения
class AppConfigurator extends StatelessWidget {
  const AppConfigurator({
    super.key,
    this.savedTheme,
  });

  final AdaptiveThemeMode? savedTheme;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('ru', 'RU'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      child: AdaptiveTheme(
        light: lightThemeData,
        dark: darkThemeData,
        initial: savedTheme ?? AdaptiveThemeMode.light,
        builder: (light, dark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: MessageHelper.rootScaffoldMessengerKey,
            title: 'Mobile app',
            navigatorKey: NavigationService.navigationKey,
            onGenerateRoute: AppRoutes.generateRoute,
            theme: light,
            darkTheme: dark,
            home: const AppRunner(),
          );
        },
      ),
    );
  }
}

/// Запуск приложения
class AppRunner extends StatefulWidget {
  const AppRunner({super.key});

  @override
  State<AppRunner> createState() => _AppRunnerState();
}

class _AppRunnerState extends State<AppRunner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: const SplashScreen(),
    );
  }
}
