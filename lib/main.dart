import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';

import 'core/bloc/bloc_global_observer.dart';
import 'core/constants/constants.dart';
import 'core/constants/routes_constants.dart';
import 'core/helpers/message_helper.dart';
import 'core/splash_screen.dart';
import 'core/helpers/module_configurator.dart';
import 'src/goals/tabs/goals/components/goals_data_provider.dart';
import 'src/welcome/auth/bloc/auth_bloc.dart';
import 'src/welcome/auth/bloc/auth_scope.dart';
import 'src/welcome/login/bloc/login_bloc.dart';
import 'theme/dark_theme.dart';

Future<void> main() async {
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider<IAuthBloc>(
            create: (context) => injector.get<IAuthBloc>(),
          ),
          BlocProvider<ILoginBloc>(
            create: (context) => injector.get<ILoginBloc>(),
          ),
          ChangeNotifierProvider(
            create: (_) => injector.get<GoalsDataProvider>(),
            lazy: true,
          ),
        ],
        child: AdaptiveTheme(
          light: darkThemeData,
          dark: darkThemeData,
          //initial: savedTheme ?? AdaptiveThemeMode.dark,
          initial: AdaptiveThemeMode.dark,
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
    AuthScope.start(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: BlocListener<IAuthBloc, AuthState>(
        bloc: AuthScope.of(context),
        listener: (context, state) => state.maybeMap(
          unauthenticated: (_) => navService.pushNamedAndRemoveUntil(
            AppRoutes.login,
          ),
          authenticated: (state) => navService.pushNamedAndRemoveUntil(
            AppRoutes.goals,
          ),
          orElse: () => const SplashScreen(),
        ),
        child: const SplashScreen(),
      ),
    );
  }
}
