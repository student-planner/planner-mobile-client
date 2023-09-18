import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../core/constants/routes_constants.dart';
import '../../../core/helpers/message_helper.dart';
import '../../../core/splash_screen.dart';
import 'bloc/login_bloc.dart';
import 'screens/login_email_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ILoginBloc, LoginState>(
      listener: (context, state) => state.mapOrNull(
        loading: (state) => const SplashScreen(),
        error: (state) => MessageHelper.showError(state.message),
        successRequestCode: (state) => navService.pushNamed(
          AppRoutes.loginCode,
          args: state.ticketDto,
        ),
        successVerifyCode: (state) => navService.pushNamedAndRemoveUntil(
          AppRoutes.goals,
        ),
      ),
      child: const LoginEmailScreen(),
    );
  }
}
